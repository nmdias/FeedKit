//
//  XMLKeyedEncodingContainer.swift
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

class XMLKeyedEncodingContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
  /// The encoder used for encoding XML elements.
  let encoder: XMLEncoder
  /// The current XML element being encoded.
  let element: XMLElement
  /// The coding path of the current encoding process.
  var codingPath: [any CodingKey] { encoder.codingPath }

  /// Initializes an encoding container for an XML element.
  /// - Parameters:
  ///   - element: The XML element to encode.
  ///   - encoder: The XML encoder used for encoding.
  init(element: XMLElement, encoder: XMLEncoder) {
    self.element = element
    self.encoder = encoder
  }

  // MARK: -

  func encodeNil(forKey key: Key) throws {
    fatalError()
  }

  func encode(_ value: Bool, forKey key: Key) throws {
    element.children.append(.init(name: key.stringValue, text: value.description))
  }

  func encode(_ value: String, forKey key: Key) throws {
    element.children.append(.init(name: key.stringValue, text: value))
  }

  func encode<T: LosslessStringConvertible>(_ value: T, for key: Key) {
    element.children.append(.init(name: key.stringValue, text: "\(value)"))
  }

  // MARK: - Int

  func encode(_ value: Int, forKey key: Key) throws { encode(value, for: key) }
  func encode(_ value: Int8, forKey key: Key) throws { encode(value, for: key) }
  func encode(_ value: Int16, forKey key: Key) throws { encode(value, for: key) }
  func encode(_ value: Int32, forKey key: Key) throws { encode(value, for: key) }
  func encode(_ value: Int64, forKey key: Key) throws { encode(value, for: key) }

  // MARK: - Unsigned Int

  func encode(_ value: UInt, forKey key: Key) throws { encode(value, for: key) }
  func encode(_ value: UInt8, forKey key: Key) throws { encode(value, for: key) }
  func encode(_ value: UInt16, forKey key: Key) throws { encode(value, for: key) }
  func encode(_ value: UInt32, forKey key: Key) throws { encode(value, for: key) }
  func encode(_ value: UInt64, forKey key: Key) throws { encode(value, for: key) }

  // MARK: - Floating point

  func encode(_ value: Float, forKey key: Key) throws { encode(value, for: key) }
  func encode(_ value: Double, forKey key: Key) throws { encode(value, for: key) }

  // MARK: - Type

  func encode<T>(_ value: T, forKey key: Key) throws where T: Encodable {
    encoder.codingPath.append(key)
    defer { self.encoder.codingPath.removeLast() }
    let childElement = try encoder.encode(value)
    if element !== childElement {
      element.children.append(childElement)
    }
  }

  // MARK: -

  func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
    fatalError()
  }

  func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
    fatalError()
  }

  func superEncoder() -> Encoder {
    fatalError()
  }

  func superEncoder(forKey key: Key) -> Encoder {
    fatalError()
  }
}
