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
  var codingPath: [any CodingKey]

  var userInfo: [CodingUserInfoKey: Any]

  func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
    fatalError()
  }

  func unkeyedContainer() throws -> any UnkeyedDecodingContainer {
    fatalError()
  }

  func singleValueContainer() throws -> any SingleValueDecodingContainer {
    fatalError()
  }
}

// MARK: - _KeyedDecodingContainer

extension XMLDecoder {
  struct _KeyedDecodingContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
    var codingPath: [any CodingKey]

    var allKeys: [Key]

    func contains(_ key: Key) -> Bool {
      fatalError()
    }

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

    // MARK: - Decode

    func decodeNil(forKey key: Key) throws -> Bool {
      fatalError()
    }

    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T: Decodable {
      fatalError()
    }

    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
      fatalError()
    }

    func decode(_ type: String.Type, forKey key: Key) throws -> String {
      fatalError()
    }

    // MARK: - Floating point

    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
      fatalError()
    }

    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
      fatalError()
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
  }
}

// MARK: - _UnkeyedDecodingContainer

extension XMLDecoder {
  struct _UnkeyedDecodingContainer: UnkeyedDecodingContainer {
    var codingPath: [any CodingKey]

    var count: Int?

    var isAtEnd: Bool

    var currentIndex: Int

    mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
      fatalError()
    }

    mutating func nestedUnkeyedContainer() throws -> any UnkeyedDecodingContainer {
      fatalError()
    }

    mutating func superDecoder() throws -> any Decoder {
      fatalError()
    }

    // MARK: - Decode

    func decodeNil() throws -> Bool {
      fatalError()
    }

    func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
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
  }
}

// MAKR: - _SingleValueDecodingContainer

extension XMLDecoder {
  struct _SingleValueDecodingContainer: SingleValueDecodingContainer {
    var codingPath: [any CodingKey]

    // MARK: - Decode

    func decodeNil() -> Bool {
      fatalError()
    }

    func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
      fatalError()
    }

    func decode(_ type: Bool.Type) throws -> Bool {
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
  }
}
