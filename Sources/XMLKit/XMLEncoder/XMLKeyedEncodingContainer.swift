//
// XMLKeyedEncodingContainer.swift
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

class XMLKeyedEncodingContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
  // MARK: Lifecycle

  /// Initializes an encoding container for an XML node.
  /// - Parameters:
  ///   - node: The XML node to encode.
  ///   - encoder: The XML encoder used for encoding.
  init(node: XMLNode, encoder: _XMLEncoder) {
    self.node = node
    self.encoder = encoder
  }

  // MARK: Internal

  /// The encoder used for encoding XML nodes.
  let encoder: _XMLEncoder
  /// The current XML node being encoded.
  let node: XMLNode

  /// The coding path of the current encoding process.
  var codingPath: [any CodingKey] {
    encoder.codingPath
  }

  func box(_ value: some LosslessStringConvertible, for key: Key) {
    if key.stringValue == "@text" {
      node.text = "\(value)"
      return
    }
    node.addChild(.init(name: key.stringValue, text: "\(value)"))
  }

  // MARK: -

  func encodeNil(forKey _: Key) throws {
    fatalError()
  }

  func encode(_ value: Bool, forKey key: Key) throws {
    box(value, for: key)
  }

  func encode(_ value: String, forKey key: Key) throws {
    box(value, for: key)
  }

  // MARK: - Int

  func encode(_ value: Int, forKey key: Key) throws {
    box(value, for: key)
  }

  func encode(_ value: Int8, forKey key: Key) throws {
    box(value, for: key)
  }

  func encode(_ value: Int16, forKey key: Key) throws {
    box(value, for: key)
  }

  func encode(_ value: Int32, forKey key: Key) throws {
    box(value, for: key)
  }

  func encode(_ value: Int64, forKey key: Key) throws {
    box(value, for: key)
  }

  // MARK: - Unsigned Int

  func encode(_ value: UInt, forKey key: Key) throws {
    box(value, for: key)
  }

  func encode(_ value: UInt8, forKey key: Key) throws {
    box(value, for: key)
  }

  func encode(_ value: UInt16, forKey key: Key) throws {
    box(value, for: key)
  }

  func encode(_ value: UInt32, forKey key: Key) throws {
    box(value, for: key)
  }

  func encode(_ value: UInt64, forKey key: Key) throws {
    box(value, for: key)
  }

  // MARK: - Floating point

  func encode(_ value: Float, forKey key: Key) throws {
    box(value, for: key)
  }

  func encode(_ value: Double, forKey key: Key) throws {
    box(value, for: key)
  }

  // MARK: - Type

  func encode(_ value: some Encodable, forKey key: Key) throws {
    encoder.codingPath.append(key)

    defer { self.encoder.codingPath.removeLast() }
    let child = try encoder.box(value)
    if node !== child {
      if value is XMLNamespaceCodable {
        let prefix = child.name
        let namespaceChildren = child.children

        namespaceChildren?.forEach { namespaceChild in
          namespaceChild.prefix = prefix
          node.addChild(namespaceChild)
        }

      } else {
        node.addChild(child)
      }
    }
  }

  // MARK: -

  func nestedContainer<NestedKey: CodingKey>(keyedBy _: NestedKey.Type, forKey _: Key) -> KeyedEncodingContainer<NestedKey> {
    fatalError()
  }

  func nestedUnkeyedContainer(forKey _: Key) -> UnkeyedEncodingContainer {
    fatalError()
  }

  func superEncoder() -> Encoder {
    fatalError()
  }

  func superEncoder(forKey _: Key) -> Encoder {
    fatalError()
  }
}
