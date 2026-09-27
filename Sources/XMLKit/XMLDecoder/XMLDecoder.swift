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

public class XMLDecoder {
  // MARK: Lifecycle

  /// Creates a new instance of `XMLDecoder`.
  public init() {}

  // MARK: Public

  /// The strategy for decoding `Date` values from XML nodes.
  public var dateDecodingStrategy: XMLDateDecodingStrategy = .deferredToDate

  public func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
    let reader: XMLReader = .init(data: data)
    let result = try reader.read().get()

    guard let rootNode = result.root else {
      throw XMLError.unexpected(reason: "Unexpected parsing result. Root is nil.")
    }

    return try decode(type, from: rootNode)
  }

  // MARK: Internal

  /// Decodes a top-level value of the given type from the given XML element.
  ///
  /// A key such as `dc` holds a type conforming to `XMLNamespaceCodable`, which
  /// has no element of its own — it is represented only by the
  /// namespace-prefixed elements of its members — so the key has to be reported
  /// as present whenever the namespace is. The key alone cannot reveal that:
  /// `<source:markdown>` carries the prefix `source`, yet it is not the RSS
  /// `<source>` element. What each key holds is read from the type decoded at it
  /// and recorded in `XMLNamespaceKeyKnowledge`, which outlives the document, so
  /// that the question is settled by the first document of a model rather than
  /// by every one.
  ///
  /// Decoding a document may take more than one pass, and never has a side effect
  /// on the nodes, so repeating it is safe.
  ///
  /// - parameter type: The type of the value to decode.
  /// - parameter node: The XML element to decode from.
  /// - returns: A value of the requested type.
  /// - throws: `DecodingError.dataCorrupted` if values requested from the payload
  ///   are corrupted, or if the given data is not valid XML.
  /// - throws: An error if any value throws an error during decoding.
  func decode<T: Decodable>(_: T.Type, from node: XMLNode) throws -> T {
    // A key such as `dc` is carried by the namespace of its members rather than
    // by an element of its own, so whether it is present depends on the type the
    // key holds, which nothing knows until a value has been decoded at it. The
    // pass below takes such a key to be present and so decodes it, which is what
    // reads the type; a key that turns out to hold an ordinary element has no
    // element to be decoded from, so the pass fails there — and it fails having
    // recorded the type, which is the answer the next pass needs.
    //
    // Each round resolves at least one key, and an application has finitely many
    // of them, so the document is decoded again only a handful of times, once per
    // process: the records outlive the document that produced them. A pass that
    // fails without resolving anything failed for a reason of its own, and its
    // error is the document's.
    let knowledge: XMLNamespaceKeyKnowledge = .shared
    for _ in 0 ..< 16 {
      let recorded: Int = knowledge.recorded
      let decoder: _XMLDecoder = .init(node: node, codingPath: [])
      decoder.dateDecodingStrategy = dateDecodingStrategy

      do {
        return try T(from: decoder)
      } catch {
        // Only a pass that assumed a key was present can have failed because of
        // something that another pass can answer, and only knowledge recorded
        // since this one began can have changed that answer.
        guard decoder.assumedKeyPresent, knowledge.recorded != recorded else {
          throw error
        }
      }
    }

    // Unreachable while the keys of a model are finite, which they are; decoding
    // once more reports the document's error rather than a bound's.
    let decoder: _XMLDecoder = .init(node: node, codingPath: [])
    decoder.dateDecodingStrategy = dateDecodingStrategy
    return try T(from: decoder)
  }
}

/// A decoder for XML data that uses a stack-based parsing approach.
class _XMLDecoder: Decoder {
  // MARK: Lifecycle

  /// Initializes the decoder with a root element and optional coding path.
  /// - Parameters:
  ///   - node: The root XML element to start decoding from.
  ///   - codingPath: The initial coding path, defaulting to an empty array.
  init(
    node: XMLNode,
    codingPath: [CodingKey] = []
  ) {
    stack = XMLStack()
    stack.push(node)
    self.codingPath = codingPath
    userInfo = [:]
  }

  // MARK: Internal

  /// The stack used for managing XML elements during decoding.
  var stack: XMLStack
  /// The path of coding keys used to locate a value in the decoding process.
  var codingPath: [any CodingKey]
  /// User-defined contextual information for the decoding process.
  var userInfo: [CodingUserInfoKey: Any]
  /// The strategy for decoding `Date` values from XML nodes.
  var dateDecodingStrategy: XMLDateDecodingStrategy = .deferredToDate
  /// Whether this pass took a key to be present without knowing what it holds.
  ///
  /// Such a pass may fail on that key when it turns out to hold an ordinary
  /// element, which has no element to be decoded from; the document is decoded
  /// again with the answer. See `XMLDecoder.decode(_:from:)`.
  var assumedKeyPresent: Bool = false

  /// Returns a keyed decoding container for the current XML element.
  /// - Parameter type: The type of the coding key.
  /// - Returns: A keyed decoding container for the specified key type.
  /// - Throws: An error if the container cannot be created.
  func container<Key: CodingKey>(keyedBy _: Key.Type) throws -> KeyedDecodingContainer<Key> {
    KeyedDecodingContainer(XMLKeyedDecodingContainer<Key>(
      decoder: self,
      node: stack.top()!
    ))
  }

  /// Returns an unkeyed decoding container for the current XML element.
  /// - Returns: An unkeyed decoding container.
  /// - Throws: An error if the container cannot be created.
  func unkeyedContainer() throws -> any UnkeyedDecodingContainer {
    XMLUnkeyedDecodingContainer(
      decoder: self,
      node: stack.top()!
    )
  }

  /// Returns a single-value decoding container for the current XML element.
  /// - Returns: A single-value decoding container.
  /// - Throws: An error if the container cannot be created.
  func singleValueContainer() throws -> any SingleValueDecodingContainer {
    XMLSingleValueDecodingContainer(
      decoder: self,
      node: stack.top()!
    )
  }

  // MARK: -

  /// Decodes an `XMLNode` into a `Decodable` type.
  /// - Parameters:
  ///   - element: The XML element to decode.
  ///   - type: The type to decode the element as.
  /// - Returns: A decoded value of the specified type.
  /// - Throws: An error if decoding fails.
  func decode<T: Decodable>(node: XMLNode, as type: T.Type) throws -> T {
    switch T.self {
    case is Date.Type:
      return try decode(node: node, as: Date.self) as! T

    default:
      stack.push(node)
      defer { stack.pop() }
      return try type.init(from: self)
    }
  }

  /// Decodes a `Date` value from the given XML node using the current strategy.
  /// - Parameters:
  ///   - node: The XML node containing the date value.
  ///   - type: The expected type, which must be `Date`.
  /// - Returns: A decoded `Date` instance.
  /// - Throws: A `DecodingError` if the date cannot be decoded.
  func decode(node: XMLNode, as _: Date.Type) throws -> Date {
    switch dateDecodingStrategy {
    case .deferredToDate:
      return try Date(from: self)
    case let .formatter(formatter):
      stack.push(node)
      defer { stack.pop() }
      guard
        let stringDate = node.text,
        let date = formatter.date(from: stringDate)
      else {
        throw DecodingError.dataCorrupted(.init(
          codingPath: codingPath,
          debugDescription: "Unable to decode date with formatter: \(formatter)"
        ))
      }
      return date
    }
  }

  /// Decodes an `XMLNode` into a `LosslessStringConvertible` type.
  /// - Parameters:
  ///   - element: The XML element to decode.
  ///   - type: The type to decode the element as.
  /// - Returns: A decoded value of the specified type.
  /// - Throws: An error if the text is nil or conversion fails.
  func decode<T: LosslessStringConvertible>(_ node: XMLNode, as type: T.Type) throws -> T {
    guard let text = node.text, let value = T(text) else {
      throw DecodingError.valueNotFound(type, .init(
        codingPath: codingPath,
        debugDescription: "Expected text but found nil"
      ))
    }
    return value
  }
}
