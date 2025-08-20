//
// XMLKeyedDecodingContainer.swift
//
// Copyright (c) 2016 - 2025 Nuno Dias
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

class XMLKeyedDecodingContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
  // MARK: Lifecycle

  /// Initializes a keyed decoding container for an XML element.
  /// - Parameters:
  ///   - decoder: The XML decoder used for decoding.
  ///   - element: The XML element to decode.
  init(decoder: _XMLDecoder, node: XMLNode) {
    self.decoder = decoder
    self.node = node
  }

  // MARK: Internal

  /// The XML decoder used for decoding the current element.
  var decoder: _XMLDecoder
  /// The current XML element being decoded.
  var node: XMLNode
  /// This property is expected to contain all keys present in the current
  /// XML element. However, it is not yet utilized.
  var allKeys: [Key] = []

  /// The coding path of the current decoding process.
  var codingPath: [CodingKey] { decoder.codingPath }

  func contains(_ key: Key) -> Bool {
    if key.stringValue == "@text", node.text?.isEmpty == false {
      return true
    }
    return node.hasChild(for: key.stringValue)
  }

  // MARK: -

  func decodeNil(forKey key: Key) throws -> Bool {
    if key.stringValue == "@text" {
      return node.text?.isEmpty == true
    }

    if key.stringValue == "@attributes" {
      return node.children?.isEmpty == true
    }

    if let child = node.child(for: key.stringValue), child.text == nil, child.children?.isEmpty ?? true {
      return true
    }

    // If the element has some content (either text or children), it's not 'nil'
    return false
  }

  // MARK: - Decode

  func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool { try decoder.decode(node, as: type, for: key) }
  func decode(_ type: String.Type, forKey key: Key) throws -> String {
    if key.stringValue == "@text" {
      return node.text ?? ""
    }

    return try decoder.decode(node, as: type, for: key)
  }

  // MARK: - Int

  func decode(_ type: Int.Type, forKey key: Key) throws -> Int { try decoder.decode(node, as: type, for: key) }
  func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 { try decoder.decode(node, as: type, for: key) }
  func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 { try decoder.decode(node, as: type, for: key) }
  func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 { try decoder.decode(node, as: type, for: key) }
  func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 { try decoder.decode(node, as: type, for: key) }

  // MARK: - Unsigned Int

  func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt { try decoder.decode(node, as: type, for: key) }
  func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 { try decoder.decode(node, as: type, for: key) }
  func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 { try decoder.decode(node, as: type, for: key) }
  func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 { try decoder.decode(node, as: type, for: key) }
  func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 { try decoder.decode(node, as: type, for: key) }

  // MARK: - Floating point

  func decode(_ type: Float.Type, forKey key: Key) throws -> Float { try decoder.decode(node, as: type, for: key) }
  func decode(_ type: Double.Type, forKey key: Key) throws -> Double { try decoder.decode(node, as: type, for: key) }

  // MARK: - DecodeIfPresent

  func decodeIfPresent(_ type: Bool.Type, forKey key: Key) throws -> Bool? {
    guard contains(key) else { return nil }
    do {
      guard !(try decodeNil(forKey: key)) else { return nil }
      return try decode(type, forKey: key)
    } catch {
      return nil
    }
  }

  func decodeIfPresent(_ type: String.Type, forKey key: Key) throws -> String? {
    guard contains(key) else { return nil }
    do {
      guard !(try decodeNil(forKey: key)) else { return nil }
      return try decode(type, forKey: key)
    } catch {
      return nil
    }
  }

  // MARK: - DecodeIfPresent Int

  func decodeIfPresent(_ type: Int.Type, forKey key: Key) throws -> Int? {
    guard contains(key) else { return nil }
    do {
      guard !(try decodeNil(forKey: key)) else { return nil }
      return try decode(type, forKey: key)
    } catch {
      return nil
    }
  }

  func decodeIfPresent(_ type: Int8.Type, forKey key: Key) throws -> Int8? {
    guard contains(key) else { return nil }
    do {
      guard !(try decodeNil(forKey: key)) else { return nil }
      return try decode(type, forKey: key)
    } catch {
      return nil
    }
  }

  func decodeIfPresent(_ type: Int16.Type, forKey key: Key) throws -> Int16? {
    guard contains(key) else { return nil }
    do {
      guard !(try decodeNil(forKey: key)) else { return nil }
      return try decode(type, forKey: key)
    } catch {
      return nil
    }
  }

  func decodeIfPresent(_ type: Int32.Type, forKey key: Key) throws -> Int32? {
    guard contains(key) else { return nil }
    do {
      guard !(try decodeNil(forKey: key)) else { return nil }
      return try decode(type, forKey: key)
    } catch {
      return nil
    }
  }

  func decodeIfPresent(_ type: Int64.Type, forKey key: Key) throws -> Int64? {
    guard contains(key) else { return nil }
    do {
      guard !(try decodeNil(forKey: key)) else { return nil }
      return try decode(type, forKey: key)
    } catch {
      return nil
    }
  }

  // MARK: - DecodeIfPresent Unsigned Int

  func decodeIfPresent(_ type: UInt.Type, forKey key: Key) throws -> UInt? {
    guard contains(key) else { return nil }
    do {
      guard !(try decodeNil(forKey: key)) else { return nil }
      return try decode(type, forKey: key)
    } catch {
      return nil
    }
  }

  func decodeIfPresent(_ type: UInt8.Type, forKey key: Key) throws -> UInt8? {
    guard contains(key) else { return nil }
    do {
      guard !(try decodeNil(forKey: key)) else { return nil }
      return try decode(type, forKey: key)
    } catch {
      return nil
    }
  }

  func decodeIfPresent(_ type: UInt16.Type, forKey key: Key) throws -> UInt16? {
    guard contains(key) else { return nil }
    do {
      guard !(try decodeNil(forKey: key)) else { return nil }
      return try decode(type, forKey: key)
    } catch {
      return nil
    }
  }

  func decodeIfPresent(_ type: UInt32.Type, forKey key: Key) throws -> UInt32? {
    guard contains(key) else { return nil }
    do {
      guard !(try decodeNil(forKey: key)) else { return nil }
      return try decode(type, forKey: key)
    } catch {
      return nil
    }
  }

  func decodeIfPresent(_ type: UInt64.Type, forKey key: Key) throws -> UInt64? {
    guard contains(key) else { return nil }
    do {
      guard !(try decodeNil(forKey: key)) else { return nil }
      return try decode(type, forKey: key)
    } catch {
      return nil
    }
  }

  // MARK: - DecodeIfPresent Floating point

  func decodeIfPresent(_ type: Float.Type, forKey key: Key) throws -> Float? {
    guard contains(key) else { return nil }
    do {
      guard !(try decodeNil(forKey: key)) else { return nil }
      return try decode(type, forKey: key)
    } catch {
      return nil
    }
  }

  func decodeIfPresent(_ type: Double.Type, forKey key: Key) throws -> Double? {
    guard contains(key) else { return nil }
    do {
      guard !(try decodeNil(forKey: key)) else { return nil }
      return try decode(type, forKey: key)
    } catch {
      return nil
    }
  }

  // MARK: - DecodeIfPresent Type

  func decodeIfPresent<T>(_ type: T.Type, forKey key: Key) throws -> T? where T: Decodable {
    guard contains(key) else { return nil }
    do {
      guard !(try decodeNil(forKey: key)) else { return nil }
      return try decode(type, forKey: key)
    } catch {
      return nil
    }
  }

  // MARK: - Type

  func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T: Decodable {
    decoder.codingPath.append(key)
    defer { self.decoder.codingPath.removeLast() }

    if type is XMLNamespaceCodable.Type {
      return try decoder.decode(node: node, as: T.self)
    }

    guard let child = node.child(for: key.stringValue) else {
      throw DecodingError.dataCorruptedError(
        forKey: key, in: self,
        debugDescription: "Failed to decode \(type) value from key: \(key.stringValue)"
      )
    }

    return try decoder.decode(node: child, as: T.self)
  }

  // MARK: -

  func nestedContainer<NestedKey>(keyedBy _: NestedKey.Type, forKey _: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
    fatalError()
  }

  func nestedUnkeyedContainer(forKey _: Key) throws -> any UnkeyedDecodingContainer {
    fatalError()
  }

  func superDecoder() throws -> any Decoder {
    fatalError()
  }

  func superDecoder(forKey _: Key) throws -> any Decoder {
    fatalError()
  }
}
