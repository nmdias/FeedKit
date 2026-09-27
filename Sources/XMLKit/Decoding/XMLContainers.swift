//
// XMLContainers.swift
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

// MARK: - Engine text access

extension _XMLDecoderEngine {
  /// The elements of the node this engine is positioned at, as a sequence.
  ///
  /// Used by the dispatch path for third-party repeated-element conformances,
  /// and by the dictionary path.
  func repeatedElementsForCurrentNode() throws -> [XMLElement] {
    switch node {
    case let .sequence(elements): return elements
    case let .element(element): return [element]
    case .attribute,
         .text:
      throw XMLDecoderError.typeMismatch(
        expected: "an element",
        actual: node.describingName,
        path: codingPath.map(\.stringValue),
        debugDescription: nil
      )
    }
  }

  /// `true` when `element` carries an explicit XML-Schema nil marker.
  ///
  /// Recognised regardless of ``XMLNilStrategy``, because decoding is about
  /// accepting what documents say, not about the caller's writing preference.
  /// Both the standard `true` spelling and `1` are accepted, since both occur.
  func isExplicitlyNil(_ element: XMLElement) -> Bool {
    guard let value = attributes(of: element)["xsi:nil"] ?? attributes(of: element)["nil"] else {
      return false
    }
    let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    return trimmed == "true" || trimmed == "1"
  }

  /// Determines whether `element` is a redundant *wrapper* around a list
  /// rather than a list item.
  ///
  /// The rule is deliberately narrow, because guessing wrong in either
  /// direction silently changes a document's meaning. All of these must hold:
  ///
  /// 1. The element has at least two element children — one child cannot
  ///    establish a pattern, and `[]` and `[one]` are not distinguishable from
  ///    a single object anyway.
  /// 2. *Every* child is an element, so the element has no direct text. If it
  ///    had text, descending would drop it.
  /// 3. *Every* child has the same qualified name as the wrapper, which is the
  ///    signature of `<book><book/><book/></book>`.
  /// 4. The wrapper has no attributes and no namespace declarations, so
  ///    descending cannot discard metadata that belonged to it.
  ///
  /// A genuine list item fails (3) whenever it has any child elements, because
  /// its children are its fields, not more of itself. The difficult case — a
  /// list item with no children at all — is left alone by (1), and
  /// ``XMLRepeatedElementStrategy/automatic`` documents that a single-item list
  /// is read as repeated siblings, which is the more common spelling.
  func isRepeatedElementWrapper(_ element: XMLElement, keyName _: String) -> Bool {
    guard configuration.repeatedElementStrategy == .automatic else {
      return false
    }
    guard element.attributes.isEmpty, element.namespaceDeclarations.isEmpty else {
      return false
    }
    guard element.children.count >= 2 else {
      return false
    }

    for child in element.children {
      guard case let .element(nested) = child else {
        return false
      }
      guard nested.qualifiedName == element.qualifiedName else {
        return false
      }
    }
    return true
  }

  /// The element's text as raw UTF-8 bytes, applying ``XMLDecoder/textTrimming``.
  ///
  /// ## Why bytes rather than a `String`
  ///
  /// Numeric parsing happens directly on these bytes. Producing a `String` first
  /// would allocate once per number and then re-scan it, which on a
  /// number-heavy document is the single largest avoidable cost in decoding.
  ///
  /// The returned slice is a view into the document for every case except when
  /// text fragments must be joined, so the common path allocates nothing.
  func scalarBytes() throws -> ArraySlice<UInt8> {
    switch node {
    case let .text(bytes):
      // An element's character data is trimmed according to
      // ``XMLDecoder/textTrimming``, because `<age>\n  42\n</age>` must
      // decode as `42`.
      return try applyTrimming(to: ArraySlice(bytes))

    case let .attribute(bytes):
      // An attribute value is *not* trimmed. `textTrimming` describes how to
      // read an element's character data; an attribute's value is already
      // exact, and trimming it would silently change it — `<T a="  x  "/>`
      // means the four-space-surrounded string, and `<T a="&#13;"/>` means a
      // carriage return, not the empty string.
      //
      // Verified against libxml2: `xmllint --xpath 'string(/T/@a)'` on the
      // document above prints a literal CR.
      return ArraySlice(bytes)

    case let .element(element):
      return try textBytes(of: element)

    case let .sequence(elements):
      // An empty sequence decodes as empty text rather than failing, so an
      // optional scalar sees "absent" instead of an error.
      //
      // XML lets an element repeat, and the repetitions need not be alike:
      // `<link rel="self" href="…"/>` may sit beside
      // `<link>https://example.com/</link>`. A scalar wants the one that
      // carries a value, so a sibling with text wins over one without.
      guard !elements.isEmpty else {
        return ArraySlice([UInt8]())
      }
      let candidate = elements.first { !text(of: $0).isEmpty } ?? elements[0]
      return try textBytes(of: candidate)
    }
  }

  /// The text of `element`, trimmed, as UTF-8 bytes.
  func textBytes(of element: XMLElement) throws -> ArraySlice<UInt8> {
    // Materialise the text once, through the document bytes when possible.
    let raw = try rawTextBytes(of: element)
    return try applyTrimming(to: raw)
  }

  /// The element's text without trimming.
  func rawTextBytes(of element: XMLElement) throws -> ArraySlice<UInt8> {
    guard let position = element.documentPosition else {
      return ArraySlice(Array(element.text.utf8))
    }

    // Fast path: a single text token that needs no unescaping is a verbatim
    // slice of the document — no allocation at all. A CDATA payload is
    // verbatim by definition, so it takes the same path.
    if let slice = document.verbatimTextSlice(ofElementAt: position) {
      return slice
    }
    return ArraySlice(Array(element.text.utf8))
  }

  /// Applies the configured trimming to a byte slice.
  func applyTrimming(to bytes: ArraySlice<UInt8>) throws -> ArraySlice<UInt8> {
    var start = bytes.startIndex
    var end = bytes.endIndex

    switch configuration.textTrimming {
    case .none:
      return bytes[start ..< end]

    case .whitespace:
      while start < end, bytes[start] == xmlSpace || bytes[start] == xmlTab {
        start += 1
      }
      while end > start, bytes[end - 1] == xmlSpace || bytes[end - 1] == xmlTab {
        end -= 1
      }

    case .whitespaceAndNewlines:
      while start < end, xmlIsXMLWhitespace(bytes[start]) {
        start += 1
      }
      while end > start, xmlIsXMLWhitespace(bytes[end - 1]) {
        end -= 1
      }
    }
    return bytes[start ..< end]
  }

  /// The element's full text as a `String`, trimmed.
  func scalarText() throws -> String {
    try String(decoding: scalarBytes(), as: UTF8.self)
  }

  /// Trims a `String` according to the configured strategy.
  func trimmedBytes(of text: String) -> ArraySlice<UInt8> {
    let bytes: ArraySlice = .init(Array(text.utf8))
    return (try? applyTrimming(to: bytes)) ?? bytes
  }
}

// MARK: - Verbatim text fast path

extension XMLTokenizedDocument {
  /// Returns the element's character data as a verbatim document slice when that
  /// is possible, or `nil` when it must be materialised.
  ///
  /// The condition is strict on purpose: exactly one text or CDATA token, no
  /// entity references, and no line-ending normalisation needed. Anything else
  /// must go through the unescaper, because handing out the raw bytes would
  /// silently skip a transform XML requires.
  ///
  /// A CDATA payload is verbatim by definition — that is what CDATA means — so it
  /// takes the fast path. An earlier version excluded it, which made `#cdata`
  /// decode as the empty string while `#text` worked, an inconsistency that only
  /// showed up when a type used both an attribute and a CDATA property.
  func verbatimTextSlice(ofElementAt index: Int) -> ArraySlice<UInt8>? {
    let token = tokens[index]
    let contentEnd = token.match >= 0 ? Int(token.match) : index + 1
    var position = index + 1

    var found: XMLToken?
    var foundIsCDATA = false

    while position < contentEnd {
      let child = tokens[position]
      switch child.kind {
      case .cdata,
           .text:
        // A second payload token means markup sits between the two, so
        // their concatenation is not contiguous in the document and the
        // bytes cannot be handed out as one slice.
        if found != nil {
          return nil
        }
        found = child
        foundIsCDATA = child.kind == .cdata
        position += 1

      case .comment:
        // A comment does not contribute to character data, so it does not
        // interrupt it; skip it.
        position += 1

      case .processingInstruction,
           .startTag:
        return nil

      case .documentType,
           .endTag,
           .xmlDeclaration:
        position += 1
      }
    }

    guard let text = found else {
      return nil
    }
    if foundIsCDATA {
      return bytes[text.contentStart ..< text.contentEnd]
    }
    guard text.firstSpecial < 0 else {
      return nil
    }
    return bytes[text.start ..< text.end]
  }
}

// MARK: - Keyed container

/// A keyed decoding container over a single XML element.
///
/// ## Why this is implemented from scratch
///
/// `KeyedDecodingContainer`'s own `decode<T>` handles `Array`, `Dictionary` and
/// optional shapes through an internal boxing path that always expects a *nested
/// container*. XML spells a list as repeated siblings and an absent value as an
/// absent element, so that machinery cannot express what XML means.
///
/// On Swift 6.4 the standard library routes generic `decode<T>(_:forKey:)` and
/// `decodeIfPresent<T>(_:forKey:)` through the
/// `KeyedDecodingContainerProtocol` requirement — verified in
/// `Documentation/probes/array-dispatch-probe.swift` — so implementing these
/// methods is sufficient to take the decision over. The primitive overloads call
/// the concrete methods below directly.
struct _XMLKeyedDecodingContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
  // MARK: Internal

  let engine: _XMLDecoderEngine
  let element: XMLElement

  var codingPath: [any CodingKey] {
    engine.codingPath
  }

  // MARK: Key enumeration

  /// The names present on the element, as coding keys.
  ///
  /// Includes ``XMLKeyConvention/textKey`` when the element has character data,
  /// so that a type asking for `allKeys` sees it, and includes attribute keys
  /// with the ``XMLKeyConvention/attributeSigil`` prefix so that a generated
  /// `CodingKeys` enum using that convention matches.
  var allKeys: [Key] {
    var seen: Set<String> = []
    var keys: [Key] = []

    func append(_ name: String) {
      guard !seen.contains(name), let key = Key(stringValue: name) else {
        return
      }
      seen.insert(name)
      keys.append(key)
    }

    for child in engine.elementChildren(of: element) {
      append(child.qualifiedName)
    }
    for attribute in engine.attributes(of: element) {
      append(XMLKeyConvention.attributeSigil + attribute.key)
    }
    // Text is only a key when there is text, so `allKeys` does not claim a
    // value that is not there.
    let text = engine.text(of: element)
    if !text.isEmpty {
      append(XMLKeyConvention.textKey)
    }
    return keys
  }

  func contains(_ key: Key) -> Bool {
    // `#cdata` is checked alongside `#text` because both name the same
    // channel: an element has one run of character data, and whether the
    // document spelled it as escaped text or as a CDATA section makes no
    // difference to its value. `decode` already treats them as one key, and
    // `contains` disagreeing with `decode` made `@XMLCData` properties fail
    // with "no value found for key" on documents that plainly had the value.
    if isMarkupKey(key) {
      return !element.children.isEmpty
    }
    if isTextKey(key) {
      return !engine.text(of: element).isEmpty
    }
    if let attributeName = attributeName(for: key) {
      return engine.attributes(of: element)[attributeName] != nil
    }
    return !engine.children(of: element, matching: key).isEmpty
  }

  // MARK: Nil

  func decodeNil(forKey key: Key) throws -> Bool {
    if isMarkupKey(key) {
      return element.children.isEmpty
    }
    if isTextKey(key) {
      return engine.text(of: element).isEmpty
    }
    if let attributeName = attributeName(for: key) {
      guard let value = engine.attributes(of: element)[attributeName] else {
        return true
      }
      // An empty attribute is not automatically nil, because "" is a
      // legitimate value; only absence is nil. `xsi:nil` is handled below.
      return value.isEmpty && engine.attributes(of: element)["xsi:nil"] == "true"
    }

    let matches = engine.children(of: element, matching: key)
    guard !matches.isEmpty else {
      return true
    }
    if matches.contains(where: { engine.isExplicitlyNil($0) }) {
      return true
    }
    // A single empty element is nil; several elements are an array, which is
    // never nil.
    if matches.count == 1, matches[0].children.isEmpty, matches[0].attributes.isEmpty {
      return true
    }
    return false
  }

  // MARK: Scalar overloads

  //
  // These are called directly by the standard library's typed `decode`
  // methods, which are `@inlinable` and dispatch to the concrete container.
  // Each forwards to the same code path as the generic method so that all
  // scalar handling — trimming, nil, repeated elements — stays in one place.

  func decode(_: Bool.Type, forKey key: Key) throws -> Bool {
    try requireScalar(Bool.self, key)
  }

  func decode(_: String.Type, forKey key: Key) throws -> String {
    try requireScalar(String.self, key)
  }

  func decode(_: Double.Type, forKey key: Key) throws -> Double {
    try requireScalar(Double.self, key)
  }

  func decode(_: Float.Type, forKey key: Key) throws -> Float {
    try requireScalar(Float.self, key)
  }

  func decode(_: Int.Type, forKey key: Key) throws -> Int {
    try requireScalar(Int.self, key)
  }

  func decode(_: Int8.Type, forKey key: Key) throws -> Int8 {
    try requireScalar(Int8.self, key)
  }

  func decode(_: Int16.Type, forKey key: Key) throws -> Int16 {
    try requireScalar(Int16.self, key)
  }

  func decode(_: Int32.Type, forKey key: Key) throws -> Int32 {
    try requireScalar(Int32.self, key)
  }

  func decode(_: Int64.Type, forKey key: Key) throws -> Int64 {
    try requireScalar(Int64.self, key)
  }

  func decode(_: UInt.Type, forKey key: Key) throws -> UInt {
    try requireScalar(UInt.self, key)
  }

  func decode(_: UInt8.Type, forKey key: Key) throws -> UInt8 {
    try requireScalar(UInt8.self, key)
  }

  func decode(_: UInt16.Type, forKey key: Key) throws -> UInt16 {
    try requireScalar(UInt16.self, key)
  }

  func decode(_: UInt32.Type, forKey key: Key) throws -> UInt32 {
    try requireScalar(UInt32.self, key)
  }

  func decode(_: UInt64.Type, forKey key: Key) throws -> UInt64 {
    try requireScalar(UInt64.self, key)
  }

  func decodeIfPresent(_: Bool.Type, forKey key: Key) throws -> Bool? {
    try optionalScalar(Bool.self, key)
  }

  func decodeIfPresent(_: String.Type, forKey key: Key) throws -> String? {
    try optionalScalar(String.self, key)
  }

  func decodeIfPresent(_: Double.Type, forKey key: Key) throws -> Double? {
    try optionalScalar(Double.self, key)
  }

  func decodeIfPresent(_: Float.Type, forKey key: Key) throws -> Float? {
    try optionalScalar(Float.self, key)
  }

  func decodeIfPresent(_: Int.Type, forKey key: Key) throws -> Int? {
    try optionalScalar(Int.self, key)
  }

  func decodeIfPresent(_: Int8.Type, forKey key: Key) throws -> Int8? {
    try optionalScalar(Int8.self, key)
  }

  func decodeIfPresent(_: Int16.Type, forKey key: Key) throws -> Int16? {
    try optionalScalar(Int16.self, key)
  }

  func decodeIfPresent(_: Int32.Type, forKey key: Key) throws -> Int32? {
    try optionalScalar(Int32.self, key)
  }

  func decodeIfPresent(_: Int64.Type, forKey key: Key) throws -> Int64? {
    try optionalScalar(Int64.self, key)
  }

  func decodeIfPresent(_: UInt.Type, forKey key: Key) throws -> UInt? {
    try optionalScalar(UInt.self, key)
  }

  func decodeIfPresent(_: UInt8.Type, forKey key: Key) throws -> UInt8? {
    try optionalScalar(UInt8.self, key)
  }

  func decodeIfPresent(_: UInt16.Type, forKey key: Key) throws -> UInt16? {
    try optionalScalar(UInt16.self, key)
  }

  func decodeIfPresent(_: UInt32.Type, forKey key: Key) throws -> UInt32? {
    try optionalScalar(UInt32.self, key)
  }

  func decodeIfPresent(_: UInt64.Type, forKey key: Key) throws -> UInt64? {
    try optionalScalar(UInt64.self, key)
  }

  // MARK: Generic decoding

  /// Decodes any `Decodable` from the value bound to `key`.
  ///
  /// This is where XML's structure is interpreted. The decision tree:
  ///
  /// 1. A text key reads the element's own character data.
  /// 2. An attribute key reads the attribute's value.
  /// 3. Otherwise the key names child elements. Zero matches is
  ///    ``XMLDecoderError/keyNotFound(key:path:)``; one match is a single
  ///    value; several matches are a repeated sequence, which is how arrays and
  ///    sets are built.
  func decode<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
    // 1. Inner XML.
    if isMarkupKey(key) {
      let markup = engine.markup(of: element)
      guard !markup.isEmpty else {
        throw XMLDecoderError.keyNotFound(key: key.stringValue, path: codingPath.map(\.stringValue))
      }
      let child = engine.makeChild(node: .text(Array(markup.utf8)), key: key)
      return try _XMLScalarDispatch.decode(T.self, engine: child)
    }

    // 2. Text content.
    if isTextKey(key) {
      let text = engine.text(of: element)
      guard !text.isEmpty else {
        throw XMLDecoderError.keyNotFound(key: key.stringValue, path: codingPath.map(\.stringValue))
      }
      let child = engine.makeChild(node: .text(Array(text.utf8)), key: key)
      return try _XMLScalarDispatch.decode(T.self, engine: child)
    }

    // 2. An attribute.
    if let attributeName = attributeName(for: key) {
      guard let value = engine.attributes(of: element)[attributeName] else {
        throw XMLDecoderError.keyNotFound(key: key.stringValue, path: codingPath.map(\.stringValue))
      }
      let child = engine.makeChild(node: .attribute(Array(value.utf8)), key: key)
      return try _XMLScalarDispatch.decode(T.self, engine: child)
    }

    // 3. Child elements.
    let matches = engine.children(of: element, matching: key)

    if matches.isEmpty {
      // A dictionary that is present but empty means "no entries", which is
      // a value, not an absence. Distinguishing the two here is what lets
      // `["a": "1"]` survive a round trip: the encoder writes the entries as
      // children of this element, so an empty dictionary leaves no children
      // at all, and the decoder must not read that as a missing key.
      if let dictionaryType = T.self as? any _XMLDictionaryDecoding.Type {
        let child = engine.makeChild(node: .sequence([]), key: key)
        _ = child
        return try dictionaryType.decodeDictionary(engine: engine.makeChild(node: .sequence([]), key: key)) as! T
      }

      // An absent element is not automatically an error: what it means
      // depends on the target type, and only the dispatcher can tell.
      //
      //   * Optional  -> nil
      //   * Array/Set -> the empty collection
      //   * Dictionary-> the empty dictionary
      //   * anything else -> a genuine missing key
      //
      // Getting this wrong makes `<Library/>` fail to decode into
      // `struct Library { var book: [Book] }`, which is a document shape
      // that occurs constantly in practice.
      if type is any _XMLOptionalDecoding.Type
        || type is any _XMLRepeatedElementDecoding.Type
        || type is any _XMLDictionaryDecoding.Type
      {
        let child = engine.makeChild(node: .sequence([]), key: key)
        return try _XMLScalarDispatch.decode(T.self, engine: child)
      }
      throw XMLDecoderError.keyNotFound(key: key.stringValue, path: codingPath.map(\.stringValue))
    }

    // One or more matches: a repeated element. Arrays and sets consume the
    // whole sequence.
    if matches.count > 1 {
      let child = engine.makeChild(node: .sequence(matches), key: key)
      return try _XMLScalarDispatch.decode(T.self, engine: child)
    }

    // Exactly one match. For a collection this is ambiguous, because XML has
    // two ways to write a list and they are indistinguishable from a single
    // element:
    //
    //     <Library><book/><book/></Library>          repeated siblings
    //     <Library><book><book/></book></Library>    one wrapping element
    //
    // Both spellings occur in real documents, and a one-element list in the
    // second form is structurally identical to a single object in the first —
    // so a decoder must be told which reading to take, or it must be able to
    // prove it. `isRepeatedElementWrapper` proves it, and only then does the
    // decoder descend.
    if type is any _XMLRepeatedElementDecoding.Type,
       engine.isRepeatedElementWrapper(matches[0], keyName: engine.lookupName(for: key))
    {
      let inner = engine.elementChildren(of: matches[0])
      let child = engine.makeChild(node: .sequence(inner), key: key)
      return try _XMLScalarDispatch.decode(T.self, engine: child)
    }

    let child = engine.makeChild(node: .element(matches[0]), key: key)
    return try _XMLScalarDispatch.decode(T.self, engine: child)
  }

  func decodeIfPresent<T: Decodable>(_: T.Type, forKey key: Key) throws -> T? {
    // `decodeIfPresent` must distinguish "absent" from "present but not
    // decodable", and it must not throw for absence.
    if isMarkupKey(key) {
      let markup = engine.markup(of: element)
      guard !markup.isEmpty else {
        return nil
      }
      let child = engine.makeChild(node: .text(Array(markup.utf8)), key: key)
      return try _XMLScalarDispatch.decode(T.self, engine: child)
    }
    if isTextKey(key) {
      let text = engine.text(of: element)
      guard !text.isEmpty else {
        return nil
      }
      let child = engine.makeChild(node: .text(Array(text.utf8)), key: key)
      return try _XMLScalarDispatch.decode(T.self, engine: child)
    }

    if let attributeName = attributeName(for: key) {
      guard let value = engine.attributes(of: element)[attributeName] else {
        return nil
      }
      let child = engine.makeChild(node: .attribute(Array(value.utf8)), key: key)
      return try _XMLScalarDispatch.decode(T.self, engine: child)
    }

    let matches = engine.children(of: element, matching: key)
    guard !matches.isEmpty else {
      return nil
    }

    if matches.count == 1 {
      let match = matches[0]
      // `decodeIfPresent`'s `T` is the *wrapped* type: for a property of
      // type `Int?` the synthesized initializer calls
      // `decodeIfPresent(Int.self, forKey:)`. So this is the method that
      // decides what an empty element means for an optional, and it must
      // return `nil` here rather than letting an empty scalar reach the
      // numeric parser, which would fail on `""`.
      if engine.isExplicitlyNil(match) {
        return nil
      }

      // An empty dictionary is an empty dictionary, not `nil`.
      if let dictionaryType = T.self as? any _XMLDictionaryDecoding.Type,
         match.children.isEmpty, match.attributes.isEmpty
      {
        return try dictionaryType.decodeDictionary(engine: engine.makeChild(node: .element(match), key: key)) as? T
      }
      if match.children.isEmpty, match.attributes.isEmpty {
        // An element with no content means "no value" — except for types
        // that have an empty value of their own. `String` does: `""` is a
        // real string, so `<s/>` into `String?` is `Some("")`, while
        // `<n/>` into `Int?` is `nil`. Collapsing the two would make one
        // of them unrepresentable.
        if let emptyType = T.self as? any _XMLEmptyContentRepresentable.Type {
          return emptyType.emptyContentValue() as? T
        }
        return nil
      }

      let child = engine.makeChild(node: .element(match), key: key)
      return try _XMLScalarDispatch.decode(T.self, engine: child)
    }

    let child = engine.makeChild(node: .sequence(matches), key: key)
    return try _XMLScalarDispatch.decode(T.self, engine: child)
  }

  // MARK: Nested containers

  func nestedContainer<NestedKey: CodingKey>(
    keyedBy _: NestedKey.Type,
    forKey key: Key
  ) throws -> KeyedDecodingContainer<NestedKey> {
    let matches = try requiredChildren(for: key)
    return try engine.makeChild(node: .element(matches), key: key)
      .container(keyedBy: NestedKey.self)
  }

  func nestedUnkeyedContainer(forKey key: Key) throws -> any UnkeyedDecodingContainer {
    let matches = engine.children(of: element, matching: key)
    guard !matches.isEmpty else {
      throw XMLDecoderError.keyNotFound(key: key.stringValue, path: codingPath.map(\.stringValue))
    }
    let node: _XMLDecodeNode = matches.count == 1 ? .element(matches[0]) : .sequence(matches)
    return try engine.makeChild(node: node, key: key).unkeyedContainer()
  }

  func superDecoder() throws -> any Decoder {
    engine.makeChild(node: .element(element))
  }

  func superDecoder(forKey key: Key) throws -> any Decoder {
    let matches = try requiredChildren(for: key)
    return engine.makeChild(node: .element(matches), key: key)
  }

  // MARK: Private

  /// Resolves a coding key's attribute name, honouring ``XMLAttributeStrategy``.
  private func attributeName(for key: Key) -> String? {
    let raw = key.stringValue
    switch engine.configuration.attributeStrategy {
    case .useConvention:
      return XMLKeyConvention.attributeName(for: raw)
    case .none:
      return nil
    case let .keyedBy(names):
      if names.contains(raw) {
        return XMLKeyConvention.attributeName(for: raw) ?? raw
      }
      if let stripped = XMLKeyConvention.attributeName(for: raw), names.contains(stripped) {
        return stripped
      }
      return nil
    }
  }

  /// Whether `key` selects the element's inner XML.
  private func isMarkupKey(_ key: Key) -> Bool {
    key.stringValue == XMLKeyConvention.markupKey
  }

  /// Resolves a coding key's text-ness, honouring ``XMLTextStrategy``.
  private func isTextKey(_ key: Key) -> Bool {
    let raw = key.stringValue
    if raw == XMLKeyConvention.cdataKey {
      return true
    }
    switch engine.configuration.textStrategy {
    case .useConvention:
      return raw == XMLKeyConvention.textKey
    case let .keyedBy(name):
      return raw == name
    case .none:
      return false
    }
  }

  // MARK: Helpers

  /// The single child element bound to `key`, or an error.
  private func requiredChildren(for key: Key) throws -> XMLElement {
    let matches = engine.children(of: element, matching: key)
    guard let first = matches.first else {
      throw XMLDecoderError.keyNotFound(key: key.stringValue, path: codingPath.map(\.stringValue))
    }
    return first
  }

  /// Decodes a required scalar through the shared dispatch.
  private func requireScalar<T: Decodable>(_: T.Type, _ key: Key) throws -> T {
    try decode(T.self, forKey: key)
  }

  /// Decodes an optional scalar through the shared dispatch.
  private func optionalScalar<T: Decodable>(_: T.Type, _ key: Key) throws -> T? {
    try decodeIfPresent(T.self, forKey: key)
  }
}

// MARK: - Unkeyed container

/// An unkeyed container over a group of sibling elements.
struct _XMLUnkeyedDecodingContainer: UnkeyedDecodingContainer {
  // MARK: Lifecycle

  init(engine: _XMLDecoderEngine, elements: [XMLElement]) {
    self.engine = engine
    self.elements = elements
  }

  // MARK: Internal

  let engine: _XMLDecoderEngine
  let elements: [XMLElement]

  var codingPath: [any CodingKey] {
    engine.codingPath
  }

  var count: Int? {
    elements.count
  }

  var isAtEnd: Bool {
    position >= elements.count
  }

  var currentIndex: Int {
    position
  }

  mutating func decodeNil() throws -> Bool {
    guard position < elements.count else {
      throw XMLDecoderError.valueNotFound(
        expected: "an element",
        path: codingPath.map(\.stringValue),
        debugDescription: "unkeyed container is at end"
      )
    }
    if engine.isExplicitlyNil(elements[position]) {
      position += 1
      return true
    }
    return false
  }

  mutating func decode(_: Bool.Type) throws -> Bool {
    try decodeElement(Bool.self)
  }

  mutating func decode(_: String.Type) throws -> String {
    try decodeElement(String.self)
  }

  mutating func decode(_: Double.Type) throws -> Double {
    try decodeElement(Double.self)
  }

  mutating func decode(_: Float.Type) throws -> Float {
    try decodeElement(Float.self)
  }

  mutating func decode(_: Int.Type) throws -> Int {
    try decodeElement(Int.self)
  }

  mutating func decode(_: Int8.Type) throws -> Int8 {
    try decodeElement(Int8.self)
  }

  mutating func decode(_: Int16.Type) throws -> Int16 {
    try decodeElement(Int16.self)
  }

  mutating func decode(_: Int32.Type) throws -> Int32 {
    try decodeElement(Int32.self)
  }

  mutating func decode(_: Int64.Type) throws -> Int64 {
    try decodeElement(Int64.self)
  }

  mutating func decode(_: UInt.Type) throws -> UInt {
    try decodeElement(UInt.self)
  }

  mutating func decode(_: UInt8.Type) throws -> UInt8 {
    try decodeElement(UInt8.self)
  }

  mutating func decode(_: UInt16.Type) throws -> UInt16 {
    try decodeElement(UInt16.self)
  }

  mutating func decode(_: UInt32.Type) throws -> UInt32 {
    try decodeElement(UInt32.self)
  }

  mutating func decode(_: UInt64.Type) throws -> UInt64 {
    try decodeElement(UInt64.self)
  }

  mutating func decode<T: Decodable>(_: T.Type) throws -> T {
    let element = try advance()
    return try _XMLScalarDispatch.decode(T.self, engine: childDecoder(for: element))
  }

  mutating func decodeIfPresent(_: Bool.Type) throws -> Bool? {
    try decodeIfPresentElement(Bool.self)
  }

  mutating func decodeIfPresent(_: String.Type) throws -> String? {
    try decodeIfPresentElement(String.self)
  }

  mutating func decodeIfPresent(_: Double.Type) throws -> Double? {
    try decodeIfPresentElement(Double.self)
  }

  mutating func decodeIfPresent(_: Float.Type) throws -> Float? {
    try decodeIfPresentElement(Float.self)
  }

  mutating func decodeIfPresent(_: Int.Type) throws -> Int? {
    try decodeIfPresentElement(Int.self)
  }

  mutating func decodeIfPresent(_: Int8.Type) throws -> Int8? {
    try decodeIfPresentElement(Int8.self)
  }

  mutating func decodeIfPresent(_: Int16.Type) throws -> Int16? {
    try decodeIfPresentElement(Int16.self)
  }

  mutating func decodeIfPresent(_: Int32.Type) throws -> Int32? {
    try decodeIfPresentElement(Int32.self)
  }

  mutating func decodeIfPresent(_: Int64.Type) throws -> Int64? {
    try decodeIfPresentElement(Int64.self)
  }

  mutating func decodeIfPresent(_: UInt.Type) throws -> UInt? {
    try decodeIfPresentElement(UInt.self)
  }

  mutating func decodeIfPresent(_: UInt8.Type) throws -> UInt8? {
    try decodeIfPresentElement(UInt8.self)
  }

  mutating func decodeIfPresent(_: UInt16.Type) throws -> UInt16? {
    try decodeIfPresentElement(UInt16.self)
  }

  mutating func decodeIfPresent(_: UInt32.Type) throws -> UInt32? {
    try decodeIfPresentElement(UInt32.self)
  }

  mutating func decodeIfPresent(_: UInt64.Type) throws -> UInt64? {
    try decodeIfPresentElement(UInt64.self)
  }

  mutating func decodeIfPresent<T: Decodable>(_: T.Type) throws -> T? {
    guard position < elements.count else {
      return nil
    }
    if engine.isExplicitlyNil(elements[position]) {
      position += 1
      return nil
    }
    let element = try advance()
    return try _XMLScalarDispatch.decode(T.self, engine: childDecoder(for: element))
  }

  mutating func nestedContainer<NestedKey: CodingKey>(
    keyedBy _: NestedKey.Type
  ) throws -> KeyedDecodingContainer<NestedKey> {
    let element = try advance()
    return try childDecoder(for: element).container(keyedBy: NestedKey.self)
  }

  mutating func nestedUnkeyedContainer() throws -> any UnkeyedDecodingContainer {
    let element = try advance()
    // An array element used as an array: its children are the sequence.
    return _XMLUnkeyedDecodingContainer(
      engine: engine,
      elements: engine.elementChildren(of: element)
    )
  }

  mutating func superDecoder() throws -> any Decoder {
    let element = try advance()
    return childDecoder(for: element)
  }

  // MARK: Private

  private var position = 0

  private mutating func advance() throws -> XMLElement {
    guard position < elements.count else {
      throw XMLDecoderError.valueNotFound(
        expected: "an element",
        path: codingPath.map(\.stringValue),
        debugDescription: "unkeyed container is at end"
      )
    }
    let element = elements[position]
    position += 1
    return element
  }

  private mutating func childDecoder(for element: XMLElement) -> _XMLDecoderEngine {
    engine.makeChild(node: .element(element), index: position - 1)
  }

  /// Decodes the next element as `T`, resolving the empty-element case.
  ///
  /// An element with no content means "no value". What that is depends on `T`:
  ///
  /// * `T` optional — the value is `nil`, which is what makes `[Int?]` decode
  ///   `[1, nil, 3]` from `<n>1</n><n/><n>3</n>`.
  /// * `T` a type that can represent emptiness — `String` becomes `""`.
  /// * otherwise — an error, because silently dropping an item from a list
  ///   would change its meaning and shift every later index.
  private mutating func decodeElement<T: Decodable>(_: T.Type) throws -> T {
    let element = try advance()
    let decoder = childDecoder(for: element)

    if element.children.isEmpty, element.attributes.isEmpty, !engine.isExplicitlyNil(element) {
      if let empty = _XMLScalarDispatch.emptyValue(forAbsentContent: T.self) {
        return empty
      }
    }
    return try _XMLScalarDispatch.decode(T.self, engine: decoder)
  }

  private mutating func decodeIfPresentElement<T: Decodable>(_: T.Type) throws -> T? {
    guard position < elements.count else {
      return nil
    }
    return try decodeElement(T.self)
  }
}

// MARK: - Single value container

/// A container for a value with no key: an attribute, an element's text, or an
/// enum's raw value.
struct _XMLSingleValueDecodingContainer: SingleValueDecodingContainer {
  // MARK: Internal

  let engine: _XMLDecoderEngine
  let node: _XMLDecodeNode

  var codingPath: [any CodingKey] {
    engine.codingPath
  }

  func decodeNil() -> Bool {
    switch node {
    case let .element(element):
      engine.isExplicitlyNil(element) || (element.children.isEmpty && element.attributes.isEmpty)
    case let .sequence(elements):
      elements.isEmpty
    case let .attribute(text),
         let .text(text):
      text.isEmpty
    }
  }

  func decode(_: Bool.Type) throws -> Bool {
    try value(Bool.self)
  }

  func decode(_: String.Type) throws -> String {
    try value(String.self)
  }

  func decode(_: Double.Type) throws -> Double {
    try value(Double.self)
  }

  func decode(_: Float.Type) throws -> Float {
    try value(Float.self)
  }

  func decode(_: Int.Type) throws -> Int {
    try value(Int.self)
  }

  func decode(_: Int8.Type) throws -> Int8 {
    try value(Int8.self)
  }

  func decode(_: Int16.Type) throws -> Int16 {
    try value(Int16.self)
  }

  func decode(_: Int32.Type) throws -> Int32 {
    try value(Int32.self)
  }

  func decode(_: Int64.Type) throws -> Int64 {
    try value(Int64.self)
  }

  func decode(_: UInt.Type) throws -> UInt {
    try value(UInt.self)
  }

  func decode(_: UInt8.Type) throws -> UInt8 {
    try value(UInt8.self)
  }

  func decode(_: UInt16.Type) throws -> UInt16 {
    try value(UInt16.self)
  }

  func decode(_: UInt32.Type) throws -> UInt32 {
    try value(UInt32.self)
  }

  func decode(_: UInt64.Type) throws -> UInt64 {
    try value(UInt64.self)
  }

  func decode<T: Decodable>(_: T.Type) throws -> T {
    try value(T.self)
  }

  // MARK: Private

  private func value<T: Decodable>(_: T.Type) throws -> T {
    try _XMLScalarDispatch.decode(T.self, engine: engine.makeChild(node: node))
  }
}
