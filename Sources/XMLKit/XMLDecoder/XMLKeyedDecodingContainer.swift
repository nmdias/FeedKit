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

class XMLKeyedDecodingContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
  // MARK: Lifecycle

  /// Initializes a keyed decoding container for an XML element.
  /// - Parameters:
  ///   - decoder: The XML decoder used for decoding.
  ///   - element: The XML element to decode.
  init(decoder: _XMLDecoder, node: XMLNode) {
    self.decoder = decoder
    self.node = node
    knowledge = XMLNamespaceKeyKnowledge.shared.snapshot(for: Key.self)
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
  var codingPath: [CodingKey] {
    decoder.codingPath
  }

  func contains(_ key: Key) -> Bool {
    // The name is asked for several times below, and a coding key need not store
    // it as a string.
    let name: String = key.stringValue

    if name == "@text", node.text?.isEmpty == false {
      return true
    }
    if child(for: key) != nil {
      return true
    }
    // A key can also be held by the namespace of its members rather than by an
    // element of its own, as `meta` is held by `<meta:title>`. Whether it is meant
    // that way is a property of the type the key holds, which is what has been
    // recorded for this coding-key type. Nothing may have decoded a value at the
    // key yet, in which case it is taken to be present: the pass that goes on to
    // decode it reads the type, and records it; if the key turns out to hold an
    // ordinary element, there is no element to decode it from and the pass fails,
    // to be run again with the answer.
    let holdsNamespaceContainer: Bool? = knowledge.holdsNamespaceContainer(name)
    guard holdsNamespaceContainer != false else {
      return false
    }
    guard node.hasNamespace(for: name) else {
      return false
    }
    if holdsNamespaceContainer == nil {
      decoder.assumedKeyPresent = true
    }
    return true
  }

  // MARK: -

  func decodeNil(forKey key: Key) throws -> Bool {
    if key.stringValue == "@text" {
      return node.text?.isEmpty == true
    }

    if key.stringValue == "@attributes" {
      return node.children?.isEmpty == true
    }

    if let child = child(for: key), child.text == nil, child.children?.isEmpty ?? true {
      return true
    }

    // If the element has some content (either text or children), it's not 'nil'
    return false
  }

  // MARK: - Decode

  func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
    try decodeScalar(type, forKey: key)
  }

  func decode(_ type: String.Type, forKey key: Key) throws -> String {
    if key.stringValue == "@text" {
      return node.text ?? ""
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
    decoder.codingPath.append(key)
    defer { self.decoder.codingPath.removeLast() }

    if type is XMLNamespaceCodable.Type {
      record(type, forKey: key)
      return try decoder.decode(node: node, as: T.self)
    }

    guard let child = child(for: key) else {
      // Recorded before the throw: a key that holds an ordinary element has no
      // element to be decoded from, and knowing that is what keeps the next pass
      // from failing here.
      record(type, forKey: key)
      throw DecodingError.dataCorruptedError(
        forKey: key, in: self,
        debugDescription: "Failed to decode \(type) value from key: \(key.stringValue)"
      )
    }

    return try decoder.decode(node: child, as: T.self)
  }

  // MARK: -

  func nestedContainer<NestedKey: CodingKey>(keyedBy _: NestedKey.Type, forKey _: Key) throws -> KeyedDecodingContainer<NestedKey> {
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

  // MARK: Private

  /// The keys of this container's coding-key type, as known when it was created;
  /// see `XMLNamespaceKeyKnowledge`.
  private let knowledge: XMLNamespaceKeyKnowledge.Snapshot

  /// The child the container last looked up, and the name it was looked up by.
  ///
  /// A key is asked about more than once: `contains(_:)` first, then
  /// `decodeNil(forKey:)` and `decode(_:forKey:)` as the value is read, or the
  /// same three steps as `decodeIfPresent` takes them. The element's children do
  /// not change while it is decoded, so the walk over them is done once per key
  /// rather than once per question.
  private var lookedUpName: String?
  private var lookedUpChild: XMLNode?

  /// The child of the element that the key names, preferring one that carries
  /// text, or `nil` when the element does not name it.
  ///
  /// - Parameter key: The key.
  /// - Returns: The child, or `nil`.
  private func child(for key: Key) -> XMLNode? {
    let name: String = key.stringValue
    if lookedUpName == name {
      return lookedUpChild
    }
    let child: XMLNode? = node.child(for: name)
    lookedUpName = name
    lookedUpChild = child
    return child
  }

  /// Decodes a value that is carried as the text of the child the key names.
  ///
  /// - Parameters:
  ///   - type: The type to decode the text as.
  ///   - key: The key.
  /// - Returns: The decoded value.
  /// - Throws: `DecodingError.dataCorrupted` when the element does not name the
  ///   key, or the child has no text, or the text is not a value of that type.
  private func decodeScalar<T: LosslessStringConvertible>(_ type: T.Type, forKey key: Key) throws -> T {
    guard let child = child(for: key), let text = child.text, let value = T(text) else {
      throw DecodingError.dataCorrupted(.init(
        codingPath: codingPath,
        debugDescription: "Failed to decode \(type) value from key: \(key.stringValue)"
      ))
    }
    return value
  }

  /// Records what the key holds, the first time a value is decoded at it.
  ///
  /// Only a key the element does not name has to be recorded: `contains(_:)`
  /// answers for a key the element names from the child, whatever the key holds.
  ///
  /// - Parameters:
  ///   - type: The type decoded at the key.
  ///   - key: The key.
  private func record(_ type: (some Decodable).Type, forKey key: Key) {
    guard child(for: key) == nil, knowledge.holdsNamespaceContainer(key.stringValue) == nil else {
      return
    }
    XMLNamespaceKeyKnowledge.shared.record(
      for: Key.self,
      key: key.stringValue,
      isNamespaceContainer: type is XMLNamespaceCodable.Type
    )
  }
}
