//
//  XMLEncoder.swift
//
//  Copyright (c) 2016 - 2024 Nuno Dias
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

/// A custom encoder for encoding XML data using a stack-based approach.
class XMLEncoder: Encoder {
  /// The stack used for managing XML elements during encoding.
  var stack: XMLStack = .init()
  /// The current XML element being encoded, or `nil` if no element exists.
  var element: XMLElement? { stack.top() }
  /// The current key in the encoding path.
  var currentKey: String { return codingPath.last!.stringValue }
  /// The path of coding keys used to locate a value in the encoding process.
  var codingPath: [any CodingKey] = []
  /// User-defined contextual information for the encoding process.
  var userInfo: [CodingUserInfoKey: Any] = [:]

  /// Initializes an XML encoder with an optional coding path.
  /// - Parameters:
  ///   - codingPath: The initial coding path, defaulting to an empty array.
  init(codingPath: [CodingKey] = []) {
    stack = XMLStack()
    self.codingPath = codingPath
    userInfo = [:]
  }

  /// Encodes a value to an XML element.
  /// - Parameter value: The value to encode.
  /// - Returns: The encoded XML element.
  /// - Throws: An error if encoding fails.
  func encode<T: Codable>(value: T) throws -> XMLElement {
    let key = XMLCodingKey(stringValue: "\(type(of: value))".lowercased(), intValue: nil)
    let encoder = XMLEncoder(codingPath: [key])
    try value.encode(to: encoder)
    return encoder.element!
  }

  /// Returns a keyed encoding container for encoding XML elements.
  /// - Parameter type: The type of the coding key.
  /// - Returns: A keyed encoding container.
  func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {
    let element = XMLElement(name: currentKey)
    stack.push(element)
    return KeyedEncodingContainer(XMLKeyedEncodingContainer(element: element, encoder: self))
  }

  /// Returns an unkeyed encoding container for encoding XML elements.
  /// - Returns: An unkeyed encoding container.
  func unkeyedContainer() -> any UnkeyedEncodingContainer {
    stack.push(element!)
    return XMLUnkeyedEncodingContainer(element: stack.top()!, encoder: self)
  }

  /// Returns a single-value encoding container for encoding a single XML element.
  /// - Returns: A single-value encoding container.
  func singleValueContainer() -> any SingleValueEncodingContainer {
    XMLSingleValueEncodingContainer(encoder: self, element: stack.top()!, codingPath: codingPath)
  }

  /// Encodes a value and returns the corresponding XML element.
  /// - Parameter value: The value to encode.
  /// - Returns: The encoded XML element.
  /// - Throws: An error if encoding fails.
  func encode(_ value: Encodable) throws -> XMLElement {
    switch value {
    case is Date:
      return try encode(value as! Date)
    default:
      try value.encode(to: self)
      return stack.pop()!
    }
  }
}
