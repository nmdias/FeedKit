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
import XMLKitCore

/// An encoder that writes Swift values as XML documents.
///
/// The conventions mirror ``XMLDecoder``: a property is a child element, `@text`
/// is the element's own text, `@attributes` is its attribute bag, and a value
/// whose type conforms to `XMLNamespaceCodable` contributes its members directly
/// to the enclosing element.
public class XMLEncoder {
  // MARK: Lifecycle

  /// Creates a new instance of `XMLEncoder`.
  public init() {}

  // MARK: Public

  /// The strategy for encoding `Date` values into XML nodes.
  public var dateEncodingStrategy: XMLDateEncodingStrategy = .deferredToDate

  /// Encodes a value as an XML document.
  ///
  /// The document element is named after the value's type, lowercased, which is
  /// the name that has always been produced here; callers that need a specific
  /// name set it on the returned document with ``XMLDocument/setRootName(name:)``.
  ///
  /// - Parameter value: The value to encode.
  /// - Returns: The encoded document.
  /// - Throws: An error if encoding fails.
  public func encode(value: some Codable) throws -> XMLKit.XMLDocument {
    let rootName = "\(type(of: value))".lowercased()
    let root = XMLKitCore.XMLElement(name: rootName)
    let encoder: _XMLEncoder = .init(
      element: root,
      codingPath: [XMLCodingKey(stringValue: rootName, intValue: nil)],
      dateEncodingStrategy: dateEncodingStrategy
    )
    try value.encode(to: encoder)
    return XMLDocument(root: root)
  }
}

/// An encoder positioned at one element of the document being built.
///
/// Each nested value is encoded by its own instance, so a container knows which
/// element it writes into and which key named it — the latter being the name
/// every repeated sibling takes.
final class _XMLEncoder: Encoder {
  // MARK: Lifecycle

  /// Initializes an encoder positioned at an element.
  /// - Parameters:
  ///   - element: The element values are written into.
  ///   - codingPath: The path that reached this element.
  ///   - dateEncodingStrategy: The strategy for encoding `Date` values.
  init(
    element: XMLKitCore.XMLElement,
    codingPath: [any CodingKey] = [],
    dateEncodingStrategy: XMLDateEncodingStrategy = .deferredToDate
  ) {
    self.element = element
    self.codingPath = codingPath
    self.dateEncodingStrategy = dateEncodingStrategy
  }

  // MARK: Internal

  /// The element this encoder writes into.
  let element: XMLKitCore.XMLElement
  /// The path of coding keys used to reach this element.
  let codingPath: [any CodingKey]
  /// User-defined contextual information for the encoding process.
  let userInfo: [CodingUserInfoKey: Any] = [:]
  /// The strategy for encoding `Date` values into XML nodes.
  let dateEncodingStrategy: XMLDateEncodingStrategy

  /// The key that named the element currently being encoded.
  var currentKey: String {
    codingPath.last?.stringValue ?? element.qualifiedName
  }

  /// Returns a keyed encoding container for the current element.
  func container<Key: CodingKey>(keyedBy _: Key.Type) -> KeyedEncodingContainer<Key> {
    KeyedEncodingContainer(XMLKeyedEncodingContainer<Key>(encoder: self, element: element))
  }

  /// Returns an unkeyed encoding container for the current element.
  func unkeyedContainer() -> any UnkeyedEncodingContainer {
    XMLUnkeyedEncodingContainer(encoder: self, element: element)
  }

  /// Returns a single-value encoding container for the current element.
  func singleValueContainer() -> any SingleValueEncodingContainer {
    XMLSingleValueEncodingContainer(encoder: self, element: element)
  }

  // MARK: Encoding

  /// Encodes `value` into `element`.
  ///
  /// - Parameters:
  ///   - value: The value to encode.
  ///   - element: The element the value describes.
  ///   - codingPath: The path that reached the element.
  func encodeValue(_ value: some Encodable, into element: XMLKitCore.XMLElement, codingPath: [any CodingKey]) throws {
    if let date = value as? Date {
      element.text = string(from: date)
      return
    }
    let encoder: _XMLEncoder = .init(
      element: element,
      codingPath: codingPath,
      dateEncodingStrategy: dateEncodingStrategy
    )
    try value.encode(to: encoder)
  }

  /// The text of a `Date` under the configured strategy.
  func string(from date: Date) -> String {
    switch dateEncodingStrategy {
    case .deferredToDate:
      // `Date`'s own representation is a number of seconds since the reference
      // date; the previous implementation crashed here, which no caller could
      // have relied on.
      "\(date.timeIntervalSinceReferenceDate)"
    case let .formatter(formatter):
      formatter.string(from: date)
    }
  }
}

// MARK: - Repeated values

/// A type that is written as repeated sibling elements.
///
/// `Array` and `Set` conform, which is what lets a keyed encoding container give
/// every item the name of the property rather than inventing a wrapper element.
protocol XMLRepeatedValueEncodable {
  /// Appends one element per item to `element`.
  func xmlEncodeRepeated(
    into element: XMLKitCore.XMLElement,
    named name: String,
    encoder: _XMLEncoder,
    codingPath: [any CodingKey]
  ) throws
}

extension Array: XMLRepeatedValueEncodable where Element: Encodable {
  func xmlEncodeRepeated(
    into element: XMLKitCore.XMLElement,
    named name: String,
    encoder: _XMLEncoder,
    codingPath: [any CodingKey]
  ) throws {
    for item in self {
      let child = XMLKitCore.XMLElement(name: name)
      try encoder.encodeValue(item, into: child, codingPath: codingPath)
      element.appendChild(child)
    }
  }
}

extension Set: XMLRepeatedValueEncodable where Element: Encodable {
  func xmlEncodeRepeated(
    into element: XMLKitCore.XMLElement,
    named name: String,
    encoder: _XMLEncoder,
    codingPath: [any CodingKey]
  ) throws {
    for item in self {
      let child = XMLKitCore.XMLElement(name: name)
      try encoder.encodeValue(item, into: child, codingPath: codingPath)
      element.appendChild(child)
    }
  }
}
