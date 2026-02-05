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

  /// Decodes a top-level value of the given type from the given XML representation.
  ///
  /// - parameter type: The type of the value to decode.
  /// - parameter data: The XML element to decode from.
  /// - returns: A value of the requested type.
  /// - throws: `DecodingError.dataCorrupted` if values requested from the payload
  ///   are corrupted, or if the given data is not valid XML.
  /// - throws: An error if any value throws an error during decoding.
  func decode<T: Decodable>(_: T.Type, from node: XMLNode) throws -> T {
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
  ///   - element: The root XML element to start decoding from.
  ///   - codingPath: The initial coding path, defaulting to an empty array.
  init(node: XMLNode, codingPath: [CodingKey] = []) {
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

  /// Decodes an `XMLNode` into a `LosslessStringConvertible` type.
  ///
  /// - Parameters:
  ///   - element: The `XMLNode` to decode.
  ///   - type: The type to decode the element as. Must conform to
  ///     `LosslessStringConvertible`.
  ///   - key: The `CodingKey` identifying the element to decode.
  /// - Returns: A decoded value of the specified type.
  /// - Throws: A `DecodingError.dataCorrupted` error if the element's text is
  ///   missing or cannot be converted to the specified type.
  func decode<T: LosslessStringConvertible>(_ node: XMLNode, as type: T.Type, for key: some CodingKey) throws -> T {
    guard
      let child = node.child(for: key.stringValue),
      let text = child.text,
      let value = T(text)
    else {
      throw DecodingError.dataCorrupted(.init(
        codingPath: codingPath,
        debugDescription: "Failed to decode \(type) value from key: \(key.stringValue)"
      ))
    }
    return value
  }
}
