//
// XMLSingleValueEncodingContainer.swift
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

/// A container for a value with no key: the text of the element being encoded.
struct XMLSingleValueEncodingContainer: SingleValueEncodingContainer {
  // MARK: Lifecycle

  /// Initializes a single value encoding container.
  /// - Parameters:
  ///   - encoder: The encoder used for encoding.
  ///   - element: The element the value describes.
  init(encoder: _XMLEncoder, element: XMLKitCore.XMLElement) {
    self.encoder = encoder
    self.element = element
  }

  // MARK: Internal

  /// The encoder used for encoding.
  let encoder: _XMLEncoder
  /// The element being encoded.
  let element: XMLKitCore.XMLElement

  /// The coding path of the current encoding process.
  var codingPath: [any CodingKey] {
    encoder.codingPath
  }

  // MARK: -

  func encodeNil() throws {
    // A `nil` value produces no text; see
    // ``XMLKeyedEncodingContainer/encodeNil(forKey:)``.
  }

  func encode(_ value: Bool) throws {
    box("\(value)")
  }

  func encode(_ value: String) throws {
    box(value)
  }

  // MARK: - Int

  func encode(_ value: Int) throws {
    box("\(value)")
  }

  func encode(_ value: Int8) throws {
    box("\(value)")
  }

  func encode(_ value: Int16) throws {
    box("\(value)")
  }

  func encode(_ value: Int32) throws {
    box("\(value)")
  }

  func encode(_ value: Int64) throws {
    box("\(value)")
  }

  // MARK: - Unsigned Int

  func encode(_ value: UInt) throws {
    box("\(value)")
  }

  func encode(_ value: UInt8) throws {
    box("\(value)")
  }

  func encode(_ value: UInt16) throws {
    box("\(value)")
  }

  func encode(_ value: UInt32) throws {
    box("\(value)")
  }

  func encode(_ value: UInt64) throws {
    box("\(value)")
  }

  // MARK: - Floating point

  func encode(_ value: Float) throws {
    box("\(value)")
  }

  func encode(_ value: Double) throws {
    box("\(value)")
  }

  // MARK: - Type

  func encode(_ value: some Encodable) throws {
    if let date = value as? Date {
      box(encoder.string(from: date))
      return
    }
    try encoder.encodeValue(value, into: element, codingPath: codingPath)
  }

  // MARK: Private

  /// Writes the value as the element's text.
  private func box(_ text: String) {
    element.text = text
  }
}
