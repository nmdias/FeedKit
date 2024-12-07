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
  let encoder: _XMLEncoder
  /// The XML node being encoded.
  let node: XMLNode
  /// The coding path of the current encoding process.
  var codingPath: [CodingKey] { encoder.codingPath }
  /// The number of children (encoded values) in the current node.
  var count: Int = 0

  /// Initializes a value encoding container for an XML node.
  /// - Parameters:
  ///   - node: The XML node to encode values to.
  ///   - encoder: The XML encoder used for encoding.
  init(node: XMLNode, encoder: _XMLEncoder) {
    self.node = node
    self.encoder = encoder
  }

  /// Encodes a value and appends it as a child of the current node.
  /// - Parameter value: The value to encode, which must conform to
  ///   `LosslessStringConvertible`.
  func box<T: LosslessStringConvertible>(_ value: T) -> XMLNode {
    .init(name: encoder.currentKey, text: "\(value)")
  }

  // MARK: -

  func encodeNil() throws { }

  func encode(_ value: Bool) throws { node.children?.append(box(value)); count += 1 }
  func encode(_ value: String) throws { node.children?.append(box(value)); count += 1 }

  // MARK: - Int

  func encode(_ value: Int) throws { node.children?.append(box(value)); count += 1 }
  func encode(_ value: Int8) throws { node.children?.append(box(value)); count += 1 }
  func encode(_ value: Int16) throws { node.children?.append(box(value)); count += 1 }
  func encode(_ value: Int32) throws { node.children?.append(box(value)); count += 1 }
  func encode(_ value: Int64) throws { node.children?.append(box(value)); count += 1 }

  // MARK: - Unsigned Int

  func encode(_ value: UInt) throws { node.children?.append(box(value)); count += 1 }
  func encode(_ value: UInt8) throws { node.children?.append(box(value)); count += 1 }
  func encode(_ value: UInt16) throws { node.children?.append(box(value)); count += 1 }
  func encode(_ value: UInt32) throws { node.children?.append(box(value)); count += 1 }
  func encode(_ value: UInt64) throws { node.children?.append(box(value)); count += 1 }

  // MARK: - Floating point

  func encode(_ value: Float) throws { node.children?.append(box(value)); count += 1 }
  func encode(_ value: Double) throws { node.children?.append(box(value)); count += 1 }

  // MARK: - Type

  func encode<T>(_ value: T) throws where T: Encodable {
    encoder.codingPath.append(XMLCodingKey(stringValue: encoder.currentKey, intValue: count))
    defer { self.encoder.codingPath.removeLast() }
    
    let child = try encoder.box(value)
    if node !== child {
      node.children.append(child)
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
