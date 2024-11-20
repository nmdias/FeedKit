//
//  XMLUnkeyedDecodingContainer.swift
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

class XMLUnkeyedDecodingContainer: UnkeyedDecodingContainer {
  /// The XML decoder used for decoding the current element.
  var decoder: XMLDecoder
  /// The XML elements being decoded.
  var elements: [XMLElement]
  /// The current XML element being decoded.
  var element: XMLElement { elements[currentIndex] }
  /// The coding path of the current decoding process.
  var codingPath: [CodingKey] { decoder.codingPath }
  /// The number of elements in the container, or `nil` if unknown.
  var count: Int? { elements.count }
  /// A Boolean value indicating whether the container has reached the end.
  var isAtEnd: Bool { currentIndex >= count ?? 0 }
  /// The current index in the container's elements.
  var currentIndex: Int = 0

  /// Initializes the container for decoding an unkeyed XML element.
  /// - Parameters:
  ///   - decoder: The XML decoder used for decoding.
  ///   - element: The XML element representing the unkeyed container.
  init(decoder: XMLDecoder, element: XMLElement) {
    self.decoder = decoder
    if let parent = element.parent {
      decoder.stack.pop()
      decoder.stack.push(parent)
      elements = parent.children?.filter {
        $0.name == decoder.codingPath.last!.stringValue
      } ?? []
    } else {
      elements = []
    }
  }

  // MARK: - Decode

  func decodeNil() throws -> Bool {
    fatalError()
  }

  func decode(_ type: Bool.Type) throws -> Bool {
    fatalError()
  }

  func decode(_ type: String.Type) throws -> String { try decoder.decode(element, as: type) }

  // MARK: - Floating point

  func decode(_ type: Float.Type) throws -> Float { try decoder.decode(element, as: type) }
  func decode(_ type: Double.Type) throws -> Double { try decoder.decode(element, as: type) }

  // MARK: - Int

  func decode(_ type: Int.Type) throws -> Int { try decoder.decode(element, as: type) }
  func decode(_ type: Int8.Type) throws -> Int8 { try decoder.decode(element, as: type) }
  func decode(_ type: Int16.Type) throws -> Int16 { try decoder.decode(element, as: type) }
  func decode(_ type: Int32.Type) throws -> Int32 { try decoder.decode(element, as: type) }
  func decode(_ type: Int64.Type) throws -> Int64 { try decoder.decode(element, as: type) }

  // MARK: - Int

  func decode(_ type: UInt.Type) throws -> UInt { try decoder.decode(element, as: type) }
  func decode(_ type: UInt8.Type) throws -> UInt8 { try decoder.decode(element, as: type) }
  func decode(_ type: UInt16.Type) throws -> UInt16 { try decoder.decode(element, as: type) }
  func decode(_ type: UInt32.Type) throws -> UInt32 { try decoder.decode(element, as: type) }
  func decode(_ type: UInt64.Type) throws -> UInt64 { try decoder.decode(element, as: type) }

  // MARK: - Type

  func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
    // Ensure we have not reached the end of the children array
    guard !isAtEnd else {
      throw DecodingError.valueNotFound(T.self, .init(
        codingPath: codingPath,
        debugDescription: "Unkeyed container is at end."
      ))
    }

    // Get the current child element for decoding
    let element = elements[currentIndex]
    let value = try decoder.decode(element: element, as: type)
    // Advance the index for the next decode call
    currentIndex += 1
    return value
  }

  // MARK: -

  func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
    fatalError()
  }

  func nestedUnkeyedContainer() throws -> any UnkeyedDecodingContainer {
    fatalError()
  }

  func superDecoder() throws -> any Decoder {
    fatalError()
  }
}
