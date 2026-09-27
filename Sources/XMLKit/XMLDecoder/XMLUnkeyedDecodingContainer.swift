//
// XMLUnkeyedDecodingContainer.swift
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

/// An unkeyed decoding container over a group of sibling elements.
///
/// XML has no array literal: a list is an element repeated at the same level, so
/// the container is a view over the elements that carry the same name.
struct XMLUnkeyedDecodingContainer: UnkeyedDecodingContainer {
  // MARK: Lifecycle

  /// Initializes the container for decoding a group of sibling elements.
  /// - Parameters:
  ///   - decoder: The XML decoder used for decoding.
  ///   - elements: The elements being decoded, in document order.
  init(decoder: _XMLDecoder, elements: [XMLKitCore.XMLElement]) {
    self.decoder = decoder
    self.elements = elements
  }

  // MARK: Internal

  /// The XML decoder used for decoding the current node.
  let decoder: _XMLDecoder
  /// The elements being decoded.
  let elements: [XMLKitCore.XMLElement]

  /// The current index in the container's elements.
  var currentIndex: Int = 0

  /// The coding path of the current decoding process.
  var codingPath: [any CodingKey] {
    decoder.codingPath
  }

  /// The number of elements in the container, or `nil` if unknown.
  var count: Int? {
    elements.count
  }

  /// A Boolean value indicating whether the container has reached the end.
  var isAtEnd: Bool {
    currentIndex >= elements.count
  }

  // MARK: - Decode

  mutating func decodeNil() throws -> Bool {
    let element = try advance()
    return element.xmlKitText(cache: decoder.cache) == nil
      && element.children.isEmpty
      && !element.xmlKitHasAttributes
  }

  mutating func decode(_ type: Bool.Type) throws -> Bool {
    try decodeScalar(type)
  }

  mutating func decode(_ type: String.Type) throws -> String {
    try decodeScalar(type)
  }

  // MARK: - Floating point

  mutating func decode(_ type: Float.Type) throws -> Float {
    try decodeScalar(type)
  }

  mutating func decode(_ type: Double.Type) throws -> Double {
    try decodeScalar(type)
  }

  // MARK: - Int

  mutating func decode(_ type: Int.Type) throws -> Int {
    try decodeScalar(type)
  }

  mutating func decode(_ type: Int8.Type) throws -> Int8 {
    try decodeScalar(type)
  }

  mutating func decode(_ type: Int16.Type) throws -> Int16 {
    try decodeScalar(type)
  }

  mutating func decode(_ type: Int32.Type) throws -> Int32 {
    try decodeScalar(type)
  }

  mutating func decode(_ type: Int64.Type) throws -> Int64 {
    try decodeScalar(type)
  }

  // MARK: - Unsigned Int

  mutating func decode(_ type: UInt.Type) throws -> UInt {
    try decodeScalar(type)
  }

  mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
    try decodeScalar(type)
  }

  mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
    try decodeScalar(type)
  }

  mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
    try decodeScalar(type)
  }

  mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
    try decodeScalar(type)
  }

  // MARK: - Type

  mutating func decode<T: Decodable>(_: T.Type) throws -> T {
    let child = try advanceDecoder()
    return try child.decodeValue(T.self)
  }

  mutating func decodeIfPresent<T: Decodable>(_ type: T.Type) throws -> T? {
    guard !isAtEnd else {
      return nil
    }
    return try decode(type)
  }

  // MARK: -

  mutating func nestedContainer<NestedKey: CodingKey>(
    keyedBy type: NestedKey.Type
  ) throws -> KeyedDecodingContainer<NestedKey> {
    try advanceDecoder().container(keyedBy: type)
  }

  mutating func nestedUnkeyedContainer() throws -> any UnkeyedDecodingContainer {
    try advanceDecoder().unkeyedContainer()
  }

  mutating func superDecoder() throws -> any Decoder {
    try advanceDecoder()
  }

  // MARK: Private

  /// The element at the current position, without advancing.
  private func current() throws -> XMLKitCore.XMLElement {
    guard !isAtEnd else {
      throw DecodingError.valueNotFound(XMLKitCore.XMLElement.self, .init(
        codingPath: codingPath,
        debugDescription: "Unkeyed container is at end."
      ))
    }
    return elements[currentIndex]
  }

  /// Advances to the next element and returns it.
  @discardableResult
  private mutating func advance() throws -> XMLKitCore.XMLElement {
    let element = try current()
    currentIndex += 1
    return element
  }

  /// Advances to the next element and returns a decoder positioned at it.
  private mutating func advanceDecoder() throws -> _XMLDecoder {
    let element = try current()
    let child = decoder.makeChild(node: .element(element), index: currentIndex)
    currentIndex += 1
    return child
  }

  /// Decodes a scalar from the element at the current position.
  private mutating func decodeScalar<T: LosslessStringConvertible>(_ type: T.Type) throws -> T {
    let element = try advance()
    return try decoder.decodeScalar(type, from: .element(element))
  }
}
