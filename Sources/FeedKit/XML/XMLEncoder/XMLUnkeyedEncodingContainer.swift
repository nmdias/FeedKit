//
//  XMLUnkeyedEncodingContainer.swift
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

class XMLUnkeyedEncodingContainer: UnkeyedEncodingContainer {
  /// The XML encoder used for encoding values.
  let encoder: XMLEncoder
  /// The XML element being encoded.
  let element: XMLElement
  /// The coding path of the current encoding process.
  var codingPath: [CodingKey] { encoder.codingPath }
  /// The number of children (encoded values) in the current element.
  var count: Int = 0

  /// Initializes a value encoding container for an XML element.
  /// - Parameters:
  ///   - element: The XML element to encode values to.
  ///   - encoder: The XML encoder used for encoding.
  init(element: XMLElement, encoder: XMLEncoder) {
    self.element = element
    self.encoder = encoder
  }

  /// Encodes a value and appends it as a child of the current element.
  /// - Parameter value: The value to encode, which must conform to
  ///   `LosslessStringConvertible`.
  func encodeValue<T: LosslessStringConvertible>(_ value: T) {
    element.children.append(.init(type: .element, name: encoder.currentKey, text: "\(value)"))
    count += 1
  }

  // MARK: -

  func encodeNil() throws { }

  func encode(_ value: Bool) throws { encodeValue(value) }
  func encode(_ value: String) throws { encodeValue(value) }

  // MARK: - Int

  func encode(_ value: Int) throws { encodeValue(value) }
  func encode(_ value: Int8) throws { encodeValue(value) }
  func encode(_ value: Int16) throws { encodeValue(value) }
  func encode(_ value: Int32) throws { encodeValue(value) }
  func encode(_ value: Int64) throws { encodeValue(value) }

  // MARK: - Unsigned Int

  func encode(_ value: UInt) throws { encodeValue(value) }
  func encode(_ value: UInt8) throws { encodeValue(value) }
  func encode(_ value: UInt16) throws { encodeValue(value) }
  func encode(_ value: UInt32) throws { encodeValue(value) }
  func encode(_ value: UInt64) throws { encodeValue(value) }

  // MARK: - Floating point

  func encode(_ value: Float) throws { encodeValue(value) }
  func encode(_ value: Double) throws { encodeValue(value) }

  // MARK: - Type

  func encode<T>(_ value: T) throws where T: Encodable {
    encoder.codingPath.append(XMLCodingKey(stringValue: encoder.currentKey, intValue: count))
    defer { self.encoder.codingPath.removeLast() }
    let child = try encoder.encode(value)
    if element !== child {
      element.children.append(child)
    }
    count += 1
  }

  // MARK: -

  func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
    fatalError()
  }

  func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
    fatalError()
  }

  func superEncoder() -> Encoder {
    fatalError()
  }
}
