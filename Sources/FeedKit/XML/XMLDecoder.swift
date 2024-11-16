//
//  XMLDecoder.swift
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

struct XMLDecoder: Decoder {
  var elements: [XMLElement]

  var codingPath: [any CodingKey]

  var userInfo: [CodingUserInfoKey: Any] = [:]

  init(
    elements: [XMLElement],
    codingPath: [CodingKey] = []) {
    self.elements = elements
    self.codingPath = codingPath
  }

  init(
    element: XMLElement,
    codingPath: [CodingKey] = []) {
    self.init(
      elements: [element],
      codingPath: codingPath
    )
  }

  func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
    guard let element = elements.first, elements.count == 1 else {
      throw DecodingError.dataCorrupted(.init(
        codingPath: codingPath,
        debugDescription: "Unexpected number elements for keyed container with type \(type)"
      ))
    }

    return KeyedDecodingContainer(_KeyedDecodingContainer<Key>(
      decoder: self,
      element: element))
  }

  func unkeyedContainer() throws -> any UnkeyedDecodingContainer {
    _UnkeyedDecodingContainer(
      decoder: self,
      elements: elements
    )
  }

  func singleValueContainer() throws -> any SingleValueDecodingContainer {
    guard let element = elements.first, elements.count == 1 else {
      throw DecodingError.dataCorrupted(.init(
        codingPath: codingPath,
        debugDescription: "Unexpected number elements for single value container"
      ))
    }

    return _SingleValueDecodingContainer(
      decoder: self,
      element: element,
      codingPath: codingPath
    )
  }
}

// MARK: - _KeyedDecodingContainer

extension XMLDecoder {
  struct _KeyedDecodingContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
    var decoder: XMLDecoder

    var element: XMLElement

    var codingPath: [CodingKey] {
      decoder.codingPath
    }

    var allKeys: [Key] {
      element.children?.compactMap {
        Key(stringValue: $0.name)
      } ?? []
    }

    init(decoder: XMLDecoder, element: XMLElement) {
      self.decoder = decoder
      self.element = element
    }

    func contains(_ key: Key) -> Bool {
      allKeys.contains {
        $0.stringValue == key.stringValue
      }
    }

    // MARK: - Decode

    func decodeNil(forKey key: Key) throws -> Bool {
      // Get the child element matching the given key
      guard let child = element.children?.first(where: { $0.name == key.stringValue }) else {
        return true
      }

      // Avoids initializing keys if all nested keys are nil.
      //
      // Note: It's unclear if,
      //
      // 1. Initialization is needed when an element exists in the tree with no text
      //    and its children also have no text, as attributes handling is not
      //    yet implemented.
      //
      // 2. Initialization is needed when an element's text exists, but is empty.
      //    For now, we also avoid any unnecessary initialization here.
      if
        (child.text == nil) &&
        (child.text?.isEmpty ?? true) &&
        (child.children?.isEmpty ?? true) {
        return true
      }

      // If the element has some content (either text or children), it's not 'nil'
      return false
    }

    // MARK: - Decode

    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
      fatalError()
    }

    func decode(_ type: String.Type, forKey key: Key) throws -> String {
      guard
        let child = element.children?.first(where: { $0.name == key.stringValue }),
        let text = child.text else {
        throw DecodingError.keyNotFound(key, .init(
          codingPath: codingPath,
          debugDescription: "No value found for key \(key.stringValue)"
        ))
      }
      return text
    }

    // MARK: - Int

    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
      fatalError()
    }

    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
      fatalError()
    }

    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
      fatalError()
    }

    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
      fatalError()
    }

    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
      fatalError()
    }

    // MARK: - Unsigned Int

    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
      fatalError()
    }

    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
      fatalError()
    }

    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
      fatalError()
    }

    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
      fatalError()
    }

    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
      fatalError()
    }

    // MARK: - Floating point

    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
      fatalError()
    }

    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
      fatalError()
    }

    // MARK: - Decode Type

    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T: Decodable {
      // Filter child elements matching the key's name
      guard let children = element.children?.filter({ $0.name == key.stringValue }) else {
        // Throw error if no matching key is found
        throw DecodingError.keyNotFound(key, .init(
          codingPath: codingPath,
          debugDescription: "No value found for key \(key.stringValue)"
        ))
      }

      // If multiple matching elements exist, decode them as a collection
      if children.count > 1 {
        return try T(from: XMLDecoder(
          elements: children,
          codingPath: codingPath + [key])
        )
      }

      // Get the single matching child or throw if not found
      guard let child = children.first(where: { $0.name == key.stringValue }) else {
        throw DecodingError.keyNotFound(key, .init(
          codingPath: codingPath,
          debugDescription: "No value found for key \(key.stringValue)"
        ))
      }

      // Decode from the single matching element
      return try T(from: XMLDecoder(
        element: child,
        codingPath: codingPath + [key])
      )
    }

    // MARK: -

    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
      fatalError()
    }

    func nestedUnkeyedContainer(forKey key: Key) throws -> any UnkeyedDecodingContainer {
      fatalError()
    }

    func superDecoder() throws -> any Decoder {
      fatalError()
    }

    func superDecoder(forKey key: Key) throws -> any Decoder {
      fatalError()
    }
  }
}

// MARK: - _UnkeyedDecodingContainer

extension XMLDecoder {
  struct _Key: CodingKey {
    var stringValue: String
    var intValue: Int?

    init(index: Int) {
      stringValue = "Index \(index)"
      intValue = index
    }

    init?(stringValue: String) { return nil }
    init?(intValue: Int) {
      stringValue = "Index \(intValue)"
      self.intValue = intValue
    }
  }

  struct _UnkeyedDecodingContainer: UnkeyedDecodingContainer {
    var decoder: XMLDecoder

    var elements: [XMLElement]

    var codingPath: [CodingKey] { decoder.codingPath }

    var count: Int? { elements.count }

    var isAtEnd: Bool { currentIndex >= count ?? 0 }

    var currentIndex: Int = 0

    init(decoder: XMLDecoder, elements: [XMLElement]) {
      self.decoder = decoder
      self.elements = elements
    }

    // MARK: - Decode

    func decodeNil() throws -> Bool {
      fatalError()
    }

    func decode(_ type: Bool.Type) throws -> Bool {
      fatalError()
    }

    func decode(_ type: String.Type) throws -> String {
      fatalError()
    }

    // MARK: - Floating point

    func decode(_ type: Double.Type) throws -> Double {
      fatalError()
    }

    func decode(_ type: Float.Type) throws -> Float {
      fatalError()
    }

    // MARK: - Int

    func decode(_ type: Int.Type) throws -> Int {
      fatalError()
    }

    func decode(_ type: Int8.Type) throws -> Int8 {
      fatalError()
    }

    func decode(_ type: Int16.Type) throws -> Int16 {
      fatalError()
    }

    func decode(_ type: Int32.Type) throws -> Int32 {
      fatalError()
    }

    func decode(_ type: Int64.Type) throws -> Int64 {
      fatalError()
    }

    // MARK: - Unsigned Int

    func decode(_ type: UInt.Type) throws -> UInt {
      fatalError()
    }

    func decode(_ type: UInt8.Type) throws -> UInt8 {
      fatalError()
    }

    func decode(_ type: UInt16.Type) throws -> UInt16 {
      fatalError()
    }

    func decode(_ type: UInt32.Type) throws -> UInt32 {
      fatalError()
    }

    func decode(_ type: UInt64.Type) throws -> UInt64 {
      fatalError()
    }

    // MARK: - Decode Type

    mutating func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
      // Ensure we have not reached the end of the children array
      guard !isAtEnd else {
        throw DecodingError.valueNotFound(T.self, .init(
          codingPath: codingPath,
          debugDescription: "Unkeyed container is at end."
        ))
      }

      // Get the current child element for decoding
      let element = elements[currentIndex]

      // Advance the index for the next decode call
      currentIndex += 1

      return try T(from: XMLDecoder(
        element: element,
        codingPath: codingPath + [_Key(index: currentIndex - 1)]
      ))
    }

    // MARK: -

    mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
      fatalError()
    }

    mutating func nestedUnkeyedContainer() throws -> any UnkeyedDecodingContainer {
      fatalError()
    }

    mutating func superDecoder() throws -> any Decoder {
      fatalError()
    }
  }
}

// MAKR: - _SingleValueDecodingContainer

extension XMLDecoder {
  struct _SingleValueDecodingContainer: SingleValueDecodingContainer {
    var decoder: XMLDecoder

    var element: XMLElement

    var codingPath: [any CodingKey]

    init(
      decoder: XMLDecoder,
      element: XMLElement,
      codingPath: [any CodingKey]) {
      self.decoder = decoder
      self.element = element
      self.codingPath = codingPath
    }

    // MARK: - Decode

    func decodeNil() -> Bool {
      fatalError()
    }

    func decode(_ type: Bool.Type) throws -> Bool {
      fatalError()
    }

    // MARK: - Floating point

    func decode(_ type: Float.Type) throws -> Float {
      fatalError()
    }

    func decode(_ type: Double.Type) throws -> Double {
      fatalError()
    }

    // MARK: - Int

    func decode(_ type: Int.Type) throws -> Int {
      fatalError()
    }

    func decode(_ type: Int8.Type) throws -> Int8 {
      fatalError()
    }

    func decode(_ type: Int16.Type) throws -> Int16 {
      fatalError()
    }

    func decode(_ type: Int32.Type) throws -> Int32 {
      fatalError()
    }

    func decode(_ type: Int64.Type) throws -> Int64 {
      fatalError()
    }

    // MARK: - Unsigned Int

    func decode(_ type: UInt.Type) throws -> UInt {
      fatalError()
    }

    func decode(_ type: UInt8.Type) throws -> UInt8 {
      fatalError()
    }

    func decode(_ type: UInt16.Type) throws -> UInt16 {
      fatalError()
    }

    func decode(_ type: UInt32.Type) throws -> UInt32 {
      fatalError()
    }

    func decode(_ type: UInt64.Type) throws -> UInt64 {
      fatalError()
    }

    // MARK: - Decode Type

    func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
      fatalError()
    }
  }
}
