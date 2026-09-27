//
// XMLDecoder.swift
//
// Copyright (c) 2016 - 2026 Nuno Dias
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import XMLKitCore

/// A decoder that reads Swift values from XML documents.
///
/// Decoding is driven by the engine's parser and document model, and mapped onto
/// the key conventions XMLKit has always published:
///
/// - A property is a child element (`<title>…</title>` for `title`).
/// - An element's text is reached with the key `@text`.
/// - An element's attributes are reached with the key `@attributes`, whose keys
///   are the attribute names.
/// - A property whose type conforms to `XMLNamespaceCodable` is a group of
///   namespace-prefixed elements, addressed by the namespace prefix.
public class XMLDecoder {
  // MARK: Lifecycle

  /// Creates a new instance of `XMLDecoder`.
  public init() {}

  // MARK: Public

  /// The strategy for decoding `Date` values from XML nodes.
  public var dateDecodingStrategy: XMLDateDecodingStrategy = .deferredToDate

  /// Decodes a value of the given type from XML data.
  /// - Parameters:
  ///   - type: The type of the value to decode.
  ///   - data: The XML data to decode from.
  /// - Returns: A value of the requested type.
  /// - Throws: `XMLError` when the data is not well-formed XML, or a
  ///   `DecodingError` when it is well-formed but does not match the type.
  public func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
    let element: XMLKitCore.XMLElement
    do {
      element = try XMLDecoderInput.rootElement(from: data)
    } catch let error as XMLError {
      throw error
    } catch {
      // A document that cannot be parsed at all has always been reported as an
      // `XMLError`, and callers match on it.
      throw XMLError.unexpected(reason: "\(error)")
    }

    return try decode(type, from: element)
  }

  // MARK: Internal

  /// Decodes a top-level value of the given type from a parsed element.
  ///
  /// Decoding runs twice. The first pass records which keys are namespace
  /// containers, that is, keys whose type conforms to `XMLNamespaceCodable`.
  /// Those types have no element of their own — they are represented only by the
  /// namespace-prefixed elements of their members — so a key such as `dc` has to
  /// be reported as present whenever the namespace is. The key alone cannot
  /// reveal that: `<source:markdown>` carries the prefix `source`, yet it is not
  /// the RSS `<source>` element. Knowing the namespace containers up front lets
  /// the second pass, the one whose result is returned, accept a namespace
  /// prefix only where it is genuinely meant as one. Neither pass performs any
  /// side effect on the nodes, so running twice is safe.
  ///
  /// The discovery pass discards its result, so any error it raises is ignored;
  /// the authoritative pass is the one that reports errors to the caller.
  ///
  /// - Parameters:
  ///   - type: The type of the value to decode.
  ///   - element: The element to decode the value from.
  /// - Returns: A value of the requested type.
  /// - Throws: A `DecodingError` if the element does not match the type.
  func decode<T: Decodable>(_: T.Type, from element: XMLKitCore.XMLElement) throws -> T {
    let discovery: _XMLDecoder = .init(
      node: .element(element),
      codingPath: [],
      isDiscoveringNamespaceContainers: true
    )
    discovery.dateDecodingStrategy = dateDecodingStrategy
    _ = try? T(from: discovery)

    let decoder: _XMLDecoder = .init(
      node: .element(element),
      codingPath: [],
      cache: discovery.cache,
      namespaceContainerKeys: discovery.namespaceContainerKeys
    )
    decoder.dateDecodingStrategy = dateDecodingStrategy
    return try T(from: decoder)
  }
}

// MARK: - Node

/// Where a decoder is currently reading from.
enum XMLDecodingNode {
  /// A single element.
  case element(XMLKitCore.XMLElement)
  /// The attributes of an element, addressed as the `@attributes` child.
  case attributes(XMLKitCore.XMLElement)
  /// Repeated sibling elements, which is how XML spells a list.
  case sequence([XMLKitCore.XMLElement])
}

// MARK: - Engine

/// A decoder positioned at one node of a document.
///
/// Each nested value is decoded by its own instance, created by
/// ``makeChild(node:key:)`` with the node to read and the coding key that reached
/// it, so a failure reports the path that led to it.
final class _XMLDecoder: Decoder {
  // MARK: Lifecycle

  /// Initializes the decoder at a node.
  /// - Parameters:
  ///   - node: The node to read values from.
  ///   - codingPath: The initial coding path, defaulting to an empty array.
  ///   - cache: State shared by every container of this decode.
  ///   - namespaceContainerKeys: Key names already known to hold a namespace
  ///     container, used by the authoritative of the two decoding passes.
  ///   - isDiscoveringNamespaceContainers: Whether this decoder is the discovery
  ///     pass, which reports a namespace as present for any key that addresses
  ///     it so that namespace container keys can be observed.
  init(
    node: XMLDecodingNode,
    codingPath: [any CodingKey] = [],
    cache: XMLDecodeCache = .init(),
    namespaceContainerKeys: XMLNamespaceContainerKeys = .init(),
    isDiscoveringNamespaceContainers: Bool = false
  ) {
    self.node = node
    self.codingPath = codingPath
    self.cache = cache
    self.namespaceContainerKeys = namespaceContainerKeys
    self.isDiscoveringNamespaceContainers = isDiscoveringNamespaceContainers
  }

  // MARK: Internal

  /// The node this decoder reads from.
  let node: XMLDecodingNode
  /// The path of coding keys used to locate a value in the decoding process.
  let codingPath: [any CodingKey]
  /// State shared by every container of this decode.
  let cache: XMLDecodeCache
  /// User-defined contextual information for the decoding process.
  let userInfo: [CodingUserInfoKey: Any] = [:]
  /// Key names already resolved as namespace container keys, meaning the type
  /// decoded at that key conforms to `XMLNamespaceCodable`.
  ///
  /// A reference type because a container nested any depth below the root adds
  /// the keys it discovers, and the pass that follows has to see all of them.
  let namespaceContainerKeys: XMLNamespaceContainerKeys
  /// Whether this decoder belongs to the discovery pass.
  let isDiscoveringNamespaceContainers: Bool
  /// The strategy for decoding `Date` values from XML nodes.
  var dateDecodingStrategy: XMLDateDecodingStrategy = .deferredToDate

  /// A decoder positioned at `node`, with `key` appended to the coding path.
  func makeChild(node: XMLDecodingNode, key: (any CodingKey)? = nil) -> _XMLDecoder {
    var path = codingPath
    if let key {
      path.append(key)
    }
    let child: _XMLDecoder = .init(
      node: node,
      codingPath: path,
      cache: cache,
      namespaceContainerKeys: namespaceContainerKeys,
      isDiscoveringNamespaceContainers: isDiscoveringNamespaceContainers
    )
    child.dateDecodingStrategy = dateDecodingStrategy
    return child
  }

  /// A decoder positioned at the element at `index` of a repeated group.
  func makeChild(node: XMLDecodingNode, index: Int) -> _XMLDecoder {
    makeChild(node: node, key: XMLCodingKey(stringValue: "[\(index)]", intValue: index))
  }

  // MARK: Decoder

  func container<Key: CodingKey>(keyedBy _: Key.Type) throws -> KeyedDecodingContainer<Key> {
    switch node {
    case .attributes,
         .element:
      return KeyedDecodingContainer(XMLKeyedDecodingContainer<Key>(decoder: self, node: node))
    case let .sequence(elements):
      guard elements.count == 1, let only = elements.first else {
        throw DecodingError.typeMismatch([String: Any].self, .init(
          codingPath: codingPath,
          debugDescription: "A keyed container needs exactly one element, but found \(elements.count)."
        ))
      }
      return KeyedDecodingContainer(XMLKeyedDecodingContainer<Key>(decoder: self, node: .element(only)))
    }
  }

  func unkeyedContainer() throws -> any UnkeyedDecodingContainer {
    switch node {
    case let .sequence(elements):
      XMLUnkeyedDecodingContainer(decoder: self, elements: elements)
    case let .element(element):
      // An element used as a container is the group of its child elements.
      XMLUnkeyedDecodingContainer(decoder: self, elements: element.childElements)
    case .attributes:
      XMLUnkeyedDecodingContainer(decoder: self, elements: [])
    }
  }

  func singleValueContainer() throws -> any SingleValueDecodingContainer {
    XMLSingleValueDecodingContainer(decoder: self, node: node)
  }

  // MARK: Decoding

  /// Decodes `type` from the node this decoder is positioned at.
  func decodeValue<T: Decodable>(_ type: T.Type) throws -> T {
    if type == Date.self {
      // The discovery pass records which keys are namespace containers and
      // discards the value it decodes. A date is the most expensive value in the
      // tree — the permissive formatter walks up to eight ICU patterns per value
      // — so that pass does not decode one. Its traversal is otherwise
      // identical, so it records the same keys.
      if isDiscoveringNamespaceContainers {
        return Date(timeIntervalSinceReferenceDate: 0) as! T
      }
      return try decodeDate() as! T
    }

    return try T(from: self)
  }

  /// The text of a node, as XMLKit reports it.
  func text(of node: XMLDecodingNode) -> String? {
    switch node {
    case let .element(element):
      element.xmlKitText(cache: cache)
    case .attributes:
      nil
    case let .sequence(elements):
      elements.first?.xmlKitText(cache: cache)
    }
  }

  /// Decodes a `LosslessStringConvertible` value from a node's text.
  ///
  /// - Parameters:
  ///   - type: The type to decode.
  ///   - node: The node holding the text.
  /// - Returns: The decoded value.
  /// - Throws: `DecodingError.valueNotFound` when the node has no text, and
  ///   `DecodingError.dataCorrupted` when the text is not a valid value.
  func decodeScalar<T: LosslessStringConvertible>(_ type: T.Type, from node: XMLDecodingNode) throws -> T {
    guard let text = text(of: node) else {
      throw DecodingError.valueNotFound(type, .init(
        codingPath: codingPath,
        debugDescription: "Expected text but found nil"
      ))
    }
    guard let value = T(text) else {
      throw DecodingError.dataCorrupted(.init(
        codingPath: codingPath,
        debugDescription: "\(text.debugDescription) is not a valid \(type)."
      ))
    }
    return value
  }

  // MARK: Private

  /// Decodes a `Date` from the current node using the configured strategy.
  private func decodeDate() throws -> Date {
    switch dateDecodingStrategy {
    case .deferredToDate:
      return try Date(from: self)
    case let .formatter(formatter):
      guard let stringDate = text(of: node), let date = formatter.date(from: stringDate) else {
        throw DecodingError.dataCorrupted(.init(
          codingPath: codingPath,
          debugDescription: "Unable to decode date with formatter: \(formatter)"
        ))
      }
      return date
    }
  }
}

// MARK: - Namespace containers

/// The set of coding keys discovered to hold a namespace container.
///
/// Shared by every decoder of one pass; see ``_XMLDecoder/namespaceContainerKeys``.
final class XMLNamespaceContainerKeys {
  /// The key names, as coding key string values.
  var keys: Set<String> = []
}

// MARK: - Repeated values

/// A type that is built from repeated sibling elements.
///
/// `Array` and `Set` conform, and the marker is what lets a keyed container tell
/// "decode the one element this key names" apart from "decode every sibling this
/// key names", which XML gives no other way to distinguish.
protocol XMLRepeatedValueDecodable {}

extension Array: XMLRepeatedValueDecodable where Element: Decodable {}
extension Set: XMLRepeatedValueDecodable where Element: Decodable {}
