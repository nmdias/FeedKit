//
//  XMLEncoder.swift
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

struct XMLEncoder: Encoder {
  var codingPath: [any CodingKey]

  var userInfo: [CodingUserInfoKey: Any]

  func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {
    fatalError()
  }

  func unkeyedContainer() -> any UnkeyedEncodingContainer {
    fatalError()
  }

  func singleValueContainer() -> any SingleValueEncodingContainer {
    fatalError()
  }
}

extension XMLEncoder {
  struct _KeyedEncodingContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
    var codingPath: [any CodingKey]

    // MARK: - Encode

    func encodeNil(forKey key: Key) throws {
    }

    func encode(_ value: Bool, forKey key: Key) throws {
      fatalError()
    }

    func encode(_ value: String, forKey key: Key) throws {
      fatalError()
    }

    // MARK: - Encode Int

    func encode(_ value: Int, forKey key: Key) throws {
      fatalError()
    }

    func encode(_ value: Int8, forKey key: Key) throws {
      fatalError()
    }

    func encode(_ value: Int16, forKey key: Key) throws {
      fatalError()
    }

    func encode(_ value: Int32, forKey key: Key) throws {
      fatalError()
    }

    func encode(_ value: Int64, forKey key: Key) throws {
      fatalError()
    }

    // MARK: - Encode Unsigned Int

    func encode(_ value: UInt, forKey key: Key) throws {
      fatalError()
    }

    func encode(_ value: UInt8, forKey key: Key) throws {
      fatalError()
    }

    func encode(_ value: UInt16, forKey key: Key) throws {
      fatalError()
    }

    func encode(_ value: UInt32, forKey key: Key) throws {
      fatalError()
    }

    func encode(_ value: UInt64, forKey key: Key) throws {
      fatalError()
    }

    // MARK: - Encode Floating point

    func encode(_ value: Float, forKey key: Key) throws {
      fatalError()
    }

    func encode(_ value: Double, forKey key: Key) throws {
      fatalError()
    }

    // MARK: - Encode Type

    func encode<T>(_ value: T, forKey key: Key) throws where T: Encodable {
      fatalError()
    }

    // MARK: -

    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
      fatalError()
    }

    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
      fatalError()
    }

    func superEncoder() -> Encoder {
      fatalError()
    }

    func superEncoder(forKey key: Key) -> Encoder {
      fatalError()
    }
  }
}

// MARK: - _UnkeyedEncodingContainer

extension XMLEncoder {
  struct _UnkeyedEncodingContainer: UnkeyedEncodingContainer {
    var codingPath: [CodingKey]

    var count: Int

    // MARK: - Encode

    func encodeNil() throws {
      fatalError()
    }

    func encode(_ value: Bool) throws {
      fatalError()
    }

    func encode(_ value: String) throws {
      fatalError()
    }

    // MARK: - Encode Int

    func encode(_ value: Int) throws {
      fatalError()
    }

    func encode(_ value: Int8) throws {
      fatalError()
    }

    func encode(_ value: Int16) throws {
      fatalError()
    }

    func encode(_ value: Int32) throws {
      fatalError()
    }

    func encode(_ value: Int64) throws {
      fatalError()
    }

    // MARK: - Encode Unsigned Int

    func encode(_ value: UInt) throws {
      fatalError()
    }

    func encode(_ value: UInt8) throws {
      fatalError()
    }

    func encode(_ value: UInt16) throws {
      fatalError()
    }

    func encode(_ value: UInt32) throws {
      fatalError()
    }

    func encode(_ value: UInt64) throws {
      fatalError()
    }

    // MARK: - Encode Floating point

    func encode(_ value: Float) throws {
      fatalError()
    }

    func encode(_ value: Double) throws {
      fatalError()
    }

    // MARK: - Encode Type

    func encode<T>(_ value: T) throws where T: Encodable {
      fatalError()
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
}

// MARK: - _SingleValueEncodingContainer

extension XMLEncoder {
  struct _SingleValueEncodingContainer: SingleValueEncodingContainer {
    var codingPath: [any CodingKey]

    // MARK: - Encode

    func encodeNil() throws {
      fatalError()
    }

    func encode(_ value: Bool) throws {
      fatalError()
    }

    func encode(_ value: String) throws {
      fatalError()
    }

    // MARK: - Encode Int

    func encode(_ value: Int) throws {
      fatalError()
    }

    func encode(_ value: Int8) throws {
      fatalError()
    }

    func encode(_ value: Int16) throws {
      fatalError()
    }

    func encode(_ value: Int32) throws {
      fatalError()
    }

    func encode(_ value: Int64) throws {
      fatalError()
    }

    // MARK: - Encode Unsigned Int

    func encode(_ value: UInt) throws {
      fatalError()
    }

    func encode(_ value: UInt8) throws {
      fatalError()
    }

    func encode(_ value: UInt16) throws {
      fatalError()
    }

    func encode(_ value: UInt32) throws {
      fatalError()
    }

    func encode(_ value: UInt64) throws {
      fatalError()
    }

    // MARK: - Encode Floating point

    func encode(_ value: Float) throws {
      fatalError()
    }

    func encode(_ value: Double) throws {
      fatalError()
    }

    // MARK: - Encode Type

    mutating func encode<T>(_ value: T) throws where T: Encodable {
      fatalError()
    }
  }
}
