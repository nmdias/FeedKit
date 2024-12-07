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
  /// The encoder used for encoding XML nodes.
  let encoder: _XMLEncoder
  /// The current XML node being encoded.
  let node: XMLNode
  /// The coding path of the current encoding process.
  var codingPath: [any CodingKey] { encoder.codingPath }

  /// Initializes an encoding container for an XML node.
  /// - Parameters:
  ///   - node: The XML node to encode.
  ///   - encoder: The XML encoder used for encoding.
  init(node: XMLNode, encoder: _XMLEncoder) {
    self.node = node
    self.encoder = encoder
  }

  func box<T: LosslessStringConvertible>(_ value: T, for key: Key) {
    if key.stringValue == "@text" {
      node.text = "\(value)"
      return
    }
    node.children.append(.init(name: key.stringValue, text: "\(value)"))
  }

  // MARK: -

  func encodeNil(forKey key: Key) throws {
    fatalError()
  }

  func encode(_ value: Bool, forKey key: Key) throws { box(value, for: key) }
  func encode(_ value: String, forKey key: Key) throws { box(value, for: key) }

  // MARK: - Int

  func encode(_ value: Int, forKey key: Key) throws { box(value, for: key) }
  func encode(_ value: Int8, forKey key: Key) throws { box(value, for: key) }
  func encode(_ value: Int16, forKey key: Key) throws { box(value, for: key) }
  func encode(_ value: Int32, forKey key: Key) throws { box(value, for: key) }
  func encode(_ value: Int64, forKey key: Key) throws { box(value, for: key) }

  // MARK: - Unsigned Int

  func encode(_ value: UInt, forKey key: Key) throws { box(value, for: key) }
  func encode(_ value: UInt8, forKey key: Key) throws { box(value, for: key) }
  func encode(_ value: UInt16, forKey key: Key) throws { box(value, for: key) }
  func encode(_ value: UInt32, forKey key: Key) throws { box(value, for: key) }
  func encode(_ value: UInt64, forKey key: Key) throws { box(value, for: key) }

  // MARK: - Floating point

  func encode(_ value: Float, forKey key: Key) throws { box(value, for: key) }
  func encode(_ value: Double, forKey key: Key) throws { box(value, for: key) }

  // MARK: - Type

  func encode<T>(_ value: T, forKey key: Key) throws where T: Encodable {
    encoder.codingPath.append(key)

    defer { self.encoder.codingPath.removeLast() }
    let child = try encoder.box(value)
    if node !== child {
      node.children.append(child)
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
