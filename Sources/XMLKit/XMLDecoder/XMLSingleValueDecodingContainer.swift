//
// XMLSingleValueDecodingContainer.swift
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

/// A container for a value that has no key: an element's text, or an attribute.
struct XMLSingleValueDecodingContainer: SingleValueDecodingContainer {
  // MARK: Lifecycle

  /// Initializes a single value decoding container.
  /// - Parameters:
  ///   - decoder: The XML decoder used for decoding.
  ///   - node: The node holding the value.
  init(decoder: _XMLDecoder, node: XMLDecodingNode) {
    self.decoder = decoder
    self.node = node
  }

  // MARK: Internal

  /// The XML decoder used for decoding the current element.
  let decoder: _XMLDecoder
  /// The node holding the value.
  let node: XMLDecodingNode

  /// The coding path of the current decoding process.
  var codingPath: [any CodingKey] {
    decoder.codingPath
  }

  // MARK: -

  func decodeNil() -> Bool {
    switch node {
    case let .element(element):
      element.xmlKitText(cache: decoder.cache) == nil
        && element.children.isEmpty
        && !element.xmlKitHasAttributes

    case .attributes:
      true

    case let .sequence(elements):
      elements.isEmpty
    }
  }

  func decode(_ type: Bool.Type) throws -> Bool {
    try decoder.decodeScalar(type, from: node)
  }

  func decode(_ type: String.Type) throws -> String {
    try decoder.decodeScalar(type, from: node)
  }

  // MARK: - Floating point

  func decode(_ type: Float.Type) throws -> Float {
    try decoder.decodeScalar(type, from: node)
  }

  func decode(_ type: Double.Type) throws -> Double {
    try decoder.decodeScalar(type, from: node)
  }

  // MARK: - Int

  func decode(_ type: Int.Type) throws -> Int {
    try decoder.decodeScalar(type, from: node)
  }

  func decode(_ type: Int8.Type) throws -> Int8 {
    try decoder.decodeScalar(type, from: node)
  }

  func decode(_ type: Int16.Type) throws -> Int16 {
    try decoder.decodeScalar(type, from: node)
  }

  func decode(_ type: Int32.Type) throws -> Int32 {
    try decoder.decodeScalar(type, from: node)
  }

  func decode(_ type: Int64.Type) throws -> Int64 {
    try decoder.decodeScalar(type, from: node)
  }

  // MARK: - Unsigned Int

  func decode(_ type: UInt.Type) throws -> UInt {
    try decoder.decodeScalar(type, from: node)
  }

  func decode(_ type: UInt8.Type) throws -> UInt8 {
    try decoder.decodeScalar(type, from: node)
  }

  func decode(_ type: UInt16.Type) throws -> UInt16 {
    try decoder.decodeScalar(type, from: node)
  }

  func decode(_ type: UInt32.Type) throws -> UInt32 {
    try decoder.decodeScalar(type, from: node)
  }

  func decode(_ type: UInt64.Type) throws -> UInt64 {
    try decoder.decodeScalar(type, from: node)
  }

  // MARK: - Type

  func decode<T: Decodable>(_: T.Type) throws -> T {
    try decoder.decodeValue(T.self)
  }
}
