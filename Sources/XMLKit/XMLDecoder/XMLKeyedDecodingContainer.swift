//
// XMLKeyedDecodingContainer.swift
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

/// A keyed decoding container over one element, or over an element's attributes.
///
/// The keys are XMLKit's: a child element's name, `@text` for the element's own
/// text, `@attributes` for its attributes, and a namespace prefix for a property
/// whose type conforms to `XMLNamespaceCodable`.
struct XMLKeyedDecodingContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
  // MARK: Lifecycle

  /// Initializes a keyed decoding container.
  /// - Parameters:
  ///   - decoder: The decoder the container reads through.
  ///   - node: The element, or element attributes, the container reads from.
  init(decoder: _XMLDecoder, node: XMLDecodingNode) {
    self.decoder = decoder
    self.node = node
  }

  // MARK: Internal

  /// The XML decoder used for decoding the current element.
  let decoder: _XMLDecoder
  /// The node being decoded.
  let node: XMLDecodingNode

  /// The coding path of the current decoding process.
  var codingPath: [any CodingKey] {
    decoder.codingPath
  }

  /// The keys this node offers.
  ///
  /// A namespace container's key is deliberately absent: whether a prefix names a
  /// namespace container depends on the type being decoded, which a container
  /// cannot know.
  var allKeys: [Key] {
    switch node {
    case let .attributes(element):
      return element.xmlKitAttributes.compactMap { Key(stringValue: $0.name) }

    case let .element(element):
      var names = element.childElements.map(\.qualifiedName)
      if element.xmlKitText(cache: decoder.cache)?.isEmpty == false {
        names.append(XMLKeyConvention.textKey)
      }
      if element.xmlKitHasAttributes {
        names.append(XMLKeyConvention.attributesKey)
      }
      return names.compactMap { Key(stringValue: $0) }

    case .sequence:
      return []
    }
  }

  func contains(_ key: Key) -> Bool {
    switch node {
    case let .attributes(element):
      return element.xmlKitAttribute(named: key.stringValue) != nil

    case let .element(element):
      if key.stringValue == XMLKeyConvention.textKey {
        return element.xmlKitText(cache: decoder.cache)?.isEmpty == false
      }
      if key.stringValue == XMLKeyConvention.attributesKey {
        return element.xmlKitHasAttributes
      }
      if element.xmlKitHasChild(named: key.stringValue) {
        return true
      }
      // During discovery a namespace prefix is accepted for any key, which gives
      // the decoder the chance to observe that a key such as `dc` holds a value.
      // The authoritative pass only accepts it for keys observed to be namespace
      // containers, so an element such as `<source:markdown>` is never mistaken
      // for the RSS `<source>` element just because they share the prefix
      // `source`.
      if decoder.isDiscoveringNamespaceContainers {
        return element.xmlKitHasNamespace(for: key.stringValue)
      }
      return decoder.namespaceContainerKeys.keys.contains(key.stringValue)
        && element.xmlKitHasNamespace(for: key.stringValue)

    case .sequence:
      return false
    }
  }

  // MARK: -

  func decodeNil(forKey key: Key) throws -> Bool {
    switch node {
    case let .attributes(element):
      return element.xmlKitAttribute(named: key.stringValue) == nil

    case let .element(element):
      if key.stringValue == XMLKeyConvention.textKey {
        return element.xmlKitText(cache: decoder.cache)?.isEmpty != false
      }
      if key.stringValue == XMLKeyConvention.attributesKey {
        return !element.xmlKitHasAttributes
      }
      if let child = element.xmlKitChild(named: key.stringValue, cache: decoder.cache) {
        // An element with attributes is not empty: `<enclosure url="…"/>` is a
        // value, not an absence, even though it has no text and no children.
        return child.xmlKitText(cache: decoder.cache) == nil
          && child.children.isEmpty
          && !child.xmlKitHasAttributes
      }
      // If the element has some content (either text or children), it's not 'nil'
      return false

    case .sequence:
      return true
    }
  }

  // MARK: - Decode

  func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
    try decodeScalar(type, forKey: key)
  }

  func decode(_ type: String.Type, forKey key: Key) throws -> String {
    // The element's own text is addressed by `@text`, and an element with no text
    // decodes as the empty string rather than failing, because that is what an
    // empty element has always meant here.
    if key.stringValue == XMLKeyConvention.textKey, case let .element(element) = node {
      return element.xmlKitText(cache: decoder.cache) ?? ""
    }
    return try decodeScalar(type, forKey: key)
  }

  // MARK: - Int

  func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
    try decodeScalar(type, forKey: key)
  }

  func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
    try decodeScalar(type, forKey: key)
  }

  func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
    try decodeScalar(type, forKey: key)
  }

  func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
    try decodeScalar(type, forKey: key)
  }

  func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
    try decodeScalar(type, forKey: key)
  }

  // MARK: - Unsigned Int

  func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
    try decodeScalar(type, forKey: key)
  }

  func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
    try decodeScalar(type, forKey: key)
  }

  func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
    try decodeScalar(type, forKey: key)
  }

  func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
    try decodeScalar(type, forKey: key)
  }

  func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
    try decodeScalar(type, forKey: key)
  }

  // MARK: - Floating point

  func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
    try decodeScalar(type, forKey: key)
  }

  func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
    try decodeScalar(type, forKey: key)
  }

  // MARK: - Type

  func decode<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
    switch node {
    case let .attributes(element):
      guard element.xmlKitAttribute(named: key.stringValue) != nil else {
        throw DecodingError.dataCorruptedError(
          forKey: key, in: self,
          debugDescription: "Failed to decode \(type) value from key: \(key.stringValue)"
        )
      }
      // Attributes are flat: every key of a nested type names another attribute
      // of the same element.
      return try decoder.makeChild(node: .attributes(element), key: key).decodeValue(T.self)

    case let .element(element):
      if key.stringValue == XMLKeyConvention.attributesKey {
        return try decoder.makeChild(node: .attributes(element), key: key).decodeValue(T.self)
      }

      if key.stringValue == XMLKeyConvention.textKey {
        return try decoder.makeChild(node: .element(element), key: key).decodeValue(T.self)
      }

      if type is XMLNamespaceCodable.Type {
        // A namespace container has no element of its own: its members are the
        // namespace-prefixed elements of the element being decoded.
        decoder.namespaceContainerKeys.keys.insert(key.stringValue)
        return try decoder.makeChild(node: .element(element), key: key).decodeValue(T.self)
      }

      if T.self is any XMLRepeatedValueDecodable.Type {
        // A list is every sibling with this name, in document order.
        let matches = element.xmlKitChildren(named: key.stringValue)
        guard !matches.isEmpty else {
          throw DecodingError.dataCorruptedError(
            forKey: key, in: self,
            debugDescription: "Failed to decode \(type) value from key: \(key.stringValue)"
          )
        }
        return try decoder.makeChild(node: .sequence(matches), key: key).decodeValue(T.self)
      }

      guard let child = element.xmlKitChild(named: key.stringValue, cache: decoder.cache) else {
        throw DecodingError.dataCorruptedError(
          forKey: key, in: self,
          debugDescription: "Failed to decode \(type) value from key: \(key.stringValue)"
        )
      }

      return try decoder.makeChild(node: .element(child), key: key).decodeValue(T.self)

    case .sequence:
      throw DecodingError.dataCorruptedError(
        forKey: key, in: self,
        debugDescription: "Failed to decode \(type) value from key: \(key.stringValue)"
      )
    }
  }

  // MARK: -

  func decodeIfPresent<T: Decodable>(_: T.Type, forKey key: Key) throws -> T? {
    guard contains(key) else {
      return nil
    }
    guard try !decodeNil(forKey: key) else {
      return nil
    }
    return try decode(T.self, forKey: key)
  }

  func nestedContainer<NestedKey: CodingKey>(
    keyedBy type: NestedKey.Type,
    forKey key: Key
  ) throws -> KeyedDecodingContainer<NestedKey> {
    try requiredChild(forKey: key).container(keyedBy: type)
  }

  func nestedUnkeyedContainer(forKey key: Key) throws -> any UnkeyedDecodingContainer {
    try requiredChild(forKey: key).unkeyedContainer()
  }

  func superDecoder() throws -> any Decoder {
    decoder
  }

  func superDecoder(forKey key: Key) throws -> any Decoder {
    try requiredChild(forKey: key)
  }

  // MARK: Private

  /// A decoder positioned at the value bound to `key`.
  private func requiredChild(forKey key: Key) throws -> _XMLDecoder {
    switch node {
    case let .attributes(element):
      guard element.xmlKitAttribute(named: key.stringValue) != nil else {
        throw DecodingError.keyNotFound(key, .init(
          codingPath: codingPath,
          debugDescription: "No attribute named \(key.stringValue)."
        ))
      }
      return decoder.makeChild(node: .attributes(element), key: key)

    case let .element(element):
      if key.stringValue == XMLKeyConvention.attributesKey {
        return decoder.makeChild(node: .attributes(element), key: key)
      }
      if key.stringValue == XMLKeyConvention.textKey {
        return decoder.makeChild(node: .element(element), key: key)
      }
      let matches = element.xmlKitChildren(named: key.stringValue)
      guard let child = element.xmlKitChild(named: key.stringValue, cache: decoder.cache) else {
        throw DecodingError.keyNotFound(key, .init(
          codingPath: codingPath,
          debugDescription: "No element named \(key.stringValue)."
        ))
      }
      return matches.count > 1
        ? decoder.makeChild(node: .sequence(matches), key: key)
        : decoder.makeChild(node: .element(child), key: key)

    case .sequence:
      throw DecodingError.keyNotFound(key, .init(
        codingPath: codingPath,
        debugDescription: "No element named \(key.stringValue)."
      ))
    }
  }

  /// Decodes a scalar from the text bound to `key`.
  private func decodeScalar<T: LosslessStringConvertible>(_ type: T.Type, forKey key: Key) throws -> T {
    let value: String? = switch node {
    case let .attributes(element):
      element.xmlKitAttribute(named: key.stringValue)

    case let .element(element):
      if key.stringValue == XMLKeyConvention.textKey {
        element.xmlKitText(cache: decoder.cache)
      } else {
        element.xmlKitChild(named: key.stringValue, cache: decoder.cache)?
          .xmlKitText(cache: decoder.cache)
      }

    case .sequence:
      nil
    }

    guard let value else {
      throw DecodingError.dataCorrupted(.init(
        codingPath: codingPath,
        debugDescription: "Failed to decode \(type) value from key: \(key.stringValue)"
      ))
    }
    guard let decoded = T(value) else {
      throw DecodingError.dataCorrupted(.init(
        codingPath: codingPath,
        debugDescription: "\(value.debugDescription) is not a valid \(type) for key: \(key.stringValue)"
      ))
    }
    return decoded
  }
}

// MARK: - Key conventions

/// The coding keys XMLKit gives to the two channels that are not child elements.
///
/// The names are reserved by construction: `@` cannot begin an XML name, so
/// neither can collide with an element.
enum XMLKeyConvention {
  /// The key that addresses an element's own text.
  static let textKey = "@text"
  /// The key that addresses an element's attributes.
  static let attributesKey = "@attributes"
}
