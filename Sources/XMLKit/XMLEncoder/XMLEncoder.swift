//
// XMLEncoder.swift
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

public class XMLEncoder {
  // MARK: Lifecycle

  /// Creates a new instance of `XMLEncoder`.
  public init() {}

  // MARK: Public

  /// The strategy for encoding `Date` values into XML nodes.
  public var dateEncodingStrategy: XMLDateEncodingStrategy = .deferredToDate

  /// Encodes a value to an XML node.
  /// - Parameter value: The value to encode.
  /// - Returns: The encoded XML node.
  /// - Throws: An error if encoding fails.
  public func encode(value: some Codable) throws -> XMLKit.XMLDocument {
    let key: XMLCodingKey = .init(stringValue: "\(type(of: value))".lowercased(), intValue: nil)
    let encoder: _XMLEncoder = .init(codingPath: [key])
    encoder.dateEncodingStrategy = dateEncodingStrategy
    try value.encode(to: encoder)
    let rootNode = encoder.node!
    return XMLKit.XMLDocument(root: rootNode)
  }
}

/// A custom encoder for encoding XML data using a stack-based approach.
class _XMLEncoder: Encoder {
  // MARK: Lifecycle

  /// Initializes an XML encoder with an optional coding path.
  /// - Parameters:
  ///   - codingPath: The initial coding path, defaulting to an empty array.
  init(codingPath: [CodingKey] = []) {
    stack = XMLStack()
    self.codingPath = codingPath
    userInfo = [:]
  }

  // MARK: Internal

  /// The stack used for managing XML nodes during encoding.
  var stack: XMLStack = .init()
  /// The path of coding keys used to locate a value in the encoding process.
  var codingPath: [any CodingKey] = []
  /// User-defined contextual information for the encoding process.
  var userInfo: [CodingUserInfoKey: Any] = [:]
  /// The strategy for encoding `Date` values into XML nodes.
  var dateEncodingStrategy: XMLDateEncodingStrategy = .deferredToDate

  /// The current XML node being encoded, or `nil` if no node exists.
  var node: XMLNode? {
    stack.top()
  }

  /// The current key in the encoding path.
  var currentKey: String {
    codingPath.last!.stringValue
  }

  /// Returns a keyed encoding container for encoding XML nodes.
  /// - Parameter type: The type of the coding key.
  /// - Returns: A keyed encoding container.
  func container<Key: CodingKey>(keyedBy _: Key.Type) -> KeyedEncodingContainer<Key> {
    let node: XMLNode = .init(name: currentKey)
    stack.push(node)
    return KeyedEncodingContainer(XMLKeyedEncodingContainer(node: node, encoder: self))
  }

  /// Returns an unkeyed encoding container for encoding XML nodes.
  /// - Returns: An unkeyed encoding container.
  func unkeyedContainer() -> any UnkeyedEncodingContainer {
    stack.push(node!)
    return XMLUnkeyedEncodingContainer(node: node!, encoder: self)
  }

  /// Returns a single-value encoding container for encoding a single XML node.
  /// - Returns: A single-value encoding container.
  func singleValueContainer() -> any SingleValueEncodingContainer {
    XMLSingleValueEncodingContainer(encoder: self, node: node!, codingPath: codingPath)
  }

  func box(_ date: Date) throws -> XMLNode {
    switch dateEncodingStrategy {
    case .deferredToDate:
      fatalError()
    case let .formatter(formatter):
      .init(
        name: currentKey,
        text: formatter.string(from: date)
      )
    }
  }

  /// Encodes a value and returns the corresponding XML node.
  /// - Parameter value: The value to encode.
  /// - Returns: The encoded XML node.
  /// - Throws: An error if encoding fails.
  func box(_ value: Encodable) throws -> XMLNode {
    switch value {
    case is Date:
      return try box(value as! Date)
    default:
      try value.encode(to: self)
      return stack.pop()!
    }
  }
}
