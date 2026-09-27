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
import XMLKitCore

/// A keyed encoding container over one element.
///
/// Every key of a value that is not `@text` becomes a child element named by the
/// key, which is what makes XML out of a keyed `Codable` type without any
/// annotation beyond the two sigils.
struct XMLKeyedEncodingContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
  // MARK: Lifecycle

  /// Initializes a keyed encoding container.
  /// - Parameters:
  ///   - encoder: The encoder the container writes through.
  ///   - element: The element the container writes into.
  init(encoder: _XMLEncoder, element: XMLKitCore.XMLElement) {
    self.encoder = encoder
    self.element = element
  }

  // MARK: Internal

  /// The encoder used for encoding XML nodes.
  let encoder: _XMLEncoder
  /// The element being encoded.
  let element: XMLKitCore.XMLElement

  /// The coding path of the current encoding process.
  var codingPath: [any CodingKey] {
    encoder.codingPath
  }

  // MARK: -

  func encodeNil(forKey _: Key) throws {
    // A `nil` property produces no element. The previous implementation trapped
    // here, so no document was ever written this way.
  }

  func encode(_ value: Bool, forKey key: Key) throws {
    box("\(value)", for: key)
  }

  func encode(_ value: String, forKey key: Key) throws {
    box(value, for: key)
  }

  // MARK: - Int

  func encode(_ value: Int, forKey key: Key) throws {
    box("\(value)", for: key)
  }

  func encode(_ value: Int8, forKey key: Key) throws {
    box("\(value)", for: key)
  }

  func encode(_ value: Int16, forKey key: Key) throws {
    box("\(value)", for: key)
  }

  func encode(_ value: Int32, forKey key: Key) throws {
    box("\(value)", for: key)
  }

  func encode(_ value: Int64, forKey key: Key) throws {
    box("\(value)", for: key)
  }

  // MARK: - Unsigned Int

  func encode(_ value: UInt, forKey key: Key) throws {
    box("\(value)", for: key)
  }

  func encode(_ value: UInt8, forKey key: Key) throws {
    box("\(value)", for: key)
  }

  func encode(_ value: UInt16, forKey key: Key) throws {
    box("\(value)", for: key)
  }

  func encode(_ value: UInt32, forKey key: Key) throws {
    box("\(value)", for: key)
  }

  func encode(_ value: UInt64, forKey key: Key) throws {
    box("\(value)", for: key)
  }

  // MARK: - Floating point

  func encode(_ value: Float, forKey key: Key) throws {
    box("\(value)", for: key)
  }

  func encode(_ value: Double, forKey key: Key) throws {
    box("\(value)", for: key)
  }

  // MARK: - Type

  func encode(_ value: some Encodable, forKey key: Key) throws {
    if let date = value as? Date {
      box(encoder.string(from: date), for: key)
      return
    }

    let path = codingPath + [key]

    if key.stringValue == XMLKeyConvention.attributesKey {
      // An element's attributes are one bag, not a child element: encode the bag
      // into a scratch element and lift each of its children into an attribute of
      // this one, which is what makes the output well-formed XML.
      let container = XMLKitCore.XMLElement(name: key.stringValue)
      try encoder.encodeValue(value, into: container, codingPath: path)
      for attribute in container.childElements {
        element.setAttribute(attribute.qualifiedName, value: attribute.text)
      }
      return
    }

    if let repeated = value as? any XMLRepeatedValueEncodable {
      // A list is the element repeated once per item; no wrapper element is
      // invented, because a wrapper would change what the document says.
      try repeated.xmlEncodeRepeated(
        into: element,
        named: key.stringValue,
        encoder: encoder,
        codingPath: path
      )
      return
    }

    if value is XMLNamespaceCodable {
      // A namespace container has no element of its own: its members are keyed by
      // qualified name, and belong directly to the element being encoded.
      let container = XMLKitCore.XMLElement(name: key.stringValue)
      try encoder.encodeValue(value, into: container, codingPath: path)
      for child in container.children {
        element.appendChild(child)
      }
      return
    }

    let child = XMLKitCore.XMLElement(name: key.stringValue)
    try encoder.encodeValue(value, into: child, codingPath: path)
    element.appendChild(child)
  }

  // MARK: -

  func nestedContainer<NestedKey: CodingKey>(
    keyedBy _: NestedKey.Type,
    forKey key: Key
  ) -> KeyedEncodingContainer<NestedKey> {
    let child = XMLKitCore.XMLElement(name: key.stringValue)
    element.appendChild(child)
    return KeyedEncodingContainer(XMLKeyedEncodingContainer<NestedKey>(encoder: encoder, element: child))
  }

  func nestedUnkeyedContainer(forKey key: Key) -> any UnkeyedEncodingContainer {
    let child = XMLKitCore.XMLElement(name: key.stringValue)
    element.appendChild(child)
    return XMLUnkeyedEncodingContainer(
      encoder: _XMLEncoder(
        element: child,
        codingPath: codingPath + [key],
        dateEncodingStrategy: encoder.dateEncodingStrategy
      ),
      element: child
    )
  }

  func superEncoder() -> Encoder {
    encoder
  }

  func superEncoder(forKey key: Key) -> Encoder {
    _XMLEncoder(
      element: element,
      codingPath: codingPath + [key],
      dateEncodingStrategy: encoder.dateEncodingStrategy
    )
  }

  // MARK: Private

  /// Writes a scalar as the element's own text, or as a child element.
  private func box(_ text: String, for key: Key) {
    if key.stringValue == XMLKeyConvention.textKey {
      element.text = text
      return
    }
    element.appendChild(XMLKitCore.XMLElement(name: key.stringValue, text: text))
  }
}
