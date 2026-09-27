//
// XMLUnkeyedEncodingContainer.swift
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

/// An unkeyed encoding container that appends one sibling element per value.
struct XMLUnkeyedEncodingContainer: UnkeyedEncodingContainer {
  // MARK: Lifecycle

  /// Initializes the container.
  /// - Parameters:
  ///   - encoder: The encoder the container writes through.
  ///   - element: The element the items are appended to.
  init(encoder: _XMLEncoder, element: XMLKitCore.XMLElement) {
    self.encoder = encoder
    self.element = element
  }

  // MARK: Internal

  /// The encoder used for encoding values.
  let encoder: _XMLEncoder
  /// The element being encoded.
  let element: XMLKitCore.XMLElement

  /// The number of values encoded so far.
  var count: Int = 0

  /// The coding path of the current encoding process.
  var codingPath: [any CodingKey] {
    encoder.codingPath
  }

  // MARK: -

  mutating func encodeNil() throws {
    // A `nil` item produces no element; see
    // ``XMLKeyedEncodingContainer/encodeNil(forKey:)``.
  }

  mutating func encode(_ value: Bool) throws {
    box("\(value)")
  }

  mutating func encode(_ value: String) throws {
    box(value)
  }

  // MARK: - Int

  mutating func encode(_ value: Int) throws {
    box("\(value)")
  }

  mutating func encode(_ value: Int8) throws {
    box("\(value)")
  }

  mutating func encode(_ value: Int16) throws {
    box("\(value)")
  }

  mutating func encode(_ value: Int32) throws {
    box("\(value)")
  }

  mutating func encode(_ value: Int64) throws {
    box("\(value)")
  }

  // MARK: - Unsigned Int

  mutating func encode(_ value: UInt) throws {
    box("\(value)")
  }

  mutating func encode(_ value: UInt8) throws {
    box("\(value)")
  }

  mutating func encode(_ value: UInt16) throws {
    box("\(value)")
  }

  mutating func encode(_ value: UInt32) throws {
    box("\(value)")
  }

  mutating func encode(_ value: UInt64) throws {
    box("\(value)")
  }

  // MARK: - Floating point

  mutating func encode(_ value: Float) throws {
    box("\(value)")
  }

  mutating func encode(_ value: Double) throws {
    box("\(value)")
  }

  // MARK: - Type

  mutating func encode(_ value: some Encodable) throws {
    if let date = value as? Date {
      box(encoder.string(from: date))
      return
    }

    let path = codingPath + [XMLCodingKey(stringValue: currentKey, intValue: count)]

    if let repeated = value as? any XMLRepeatedValueEncodable {
      // A nested list has no name of its own in XML; its items join this one.
      try repeated.xmlEncodeRepeated(
        into: element,
        named: currentKey,
        encoder: encoder,
        codingPath: path
      )
      count += 1
      return
    }

    let child = XMLKitCore.XMLElement(name: currentKey)
    try encoder.encodeValue(value, into: child, codingPath: path)
    element.appendChild(child)
    count += 1
  }

  // MARK: -

  mutating func nestedContainer<NestedKey: CodingKey>(keyedBy _: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> {
    let child = XMLKitCore.XMLElement(name: currentKey)
    element.appendChild(child)
    count += 1
    return KeyedEncodingContainer(XMLKeyedEncodingContainer<NestedKey>(encoder: encoder, element: child))
  }

  mutating func nestedUnkeyedContainer() -> any UnkeyedEncodingContainer {
    let child = XMLKitCore.XMLElement(name: currentKey)
    element.appendChild(child)
    count += 1
    return XMLUnkeyedEncodingContainer(
      encoder: _XMLEncoder(
        element: child,
        codingPath: codingPath,
        dateEncodingStrategy: encoder.dateEncodingStrategy
      ),
      element: child
    )
  }

  mutating func superEncoder() -> Encoder {
    let child = XMLKitCore.XMLElement(name: currentKey)
    element.appendChild(child)
    count += 1
    return _XMLEncoder(
      element: child,
      codingPath: codingPath,
      dateEncodingStrategy: encoder.dateEncodingStrategy
    )
  }

  // MARK: Private

  /// The name every item takes: the key that named the list.
  private var currentKey: String {
    encoder.codingPath.last?.stringValue ?? element.qualifiedName
  }

  /// Appends a scalar item.
  private mutating func box(_ text: String) {
    element.appendChild(XMLKitCore.XMLElement(name: currentKey, text: text))
    count += 1
  }
}
