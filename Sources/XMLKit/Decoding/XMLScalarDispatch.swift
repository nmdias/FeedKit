//
// XMLScalarDispatch.swift
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

// MARK: - Primitive protocol

/// Types XMLKit parses directly from a document's UTF-8 bytes.
///
/// This is a performance protocol, not a user-facing extension point: numbers are
/// the most common leaf in real documents, and
/// `Int(String(decoding:bytes))` allocates a `String` per value and then re-scans
/// it. Parsing from bytes avoids the allocation entirely and is several times
/// faster on number-heavy input.
///
/// Use ``XMLScalarDecodable`` to add your own scalar types.
protocol _XMLPrimitiveDecodable {
  /// Parses a value from trimmed UTF-8 bytes.
  ///
  /// - Parameter bytes: The text with surrounding whitespace already removed.
  /// - Returns: The value, or `nil` when `bytes` is not a valid representation.
  static func decodeXMLPrimitive(_ bytes: ArraySlice<UInt8>) -> Self?
}

extension Bool: _XMLPrimitiveDecodable {
  /// Parses the boolean spellings that occur in XML.
  ///
  /// The set is deliberately wide, because XML has no boolean type: a schema
  /// may spell a boolean as `true`/`false`, as `1`/`0` (XML Schema), or as
  /// `yes`/`no` (common in configuration dialects). Rejecting any of them would
  /// make the library unusable against documents that are, in practice,
  /// unambiguous.
  ///
  /// Comparison is case-insensitive and allocation-free: each spelling is
  /// matched by length and folded byte comparison, so no `String` is created.
  static func decodeXMLPrimitive(_ bytes: ArraySlice<UInt8>) -> Bool? {
    switch bytes.count {
    case 1:
      guard let byte = bytes.first else {
        return nil
      }
      switch xmlASCIILowercased(byte) {
      case UInt8(ascii: "1"),
           UInt8(ascii: "t"),
           UInt8(ascii: "y"):
        return true
      case UInt8(ascii: "0"),
           UInt8(ascii: "f"),
           UInt8(ascii: "n"):
        return false
      default:
        return nil
      }

    case 2:
      if xmlMatchesASCIIFolded(bytes, xmlNoBytes) {
        return false
      }
      return nil

    case 3:
      if xmlMatchesASCIIFolded(bytes, xmlYesBytes) {
        return true
      }
      return nil

    case 4:
      if xmlMatchesASCIIFolded(bytes, xmlTrueBytes) {
        return true
      }
      return nil

    case 5:
      if xmlMatchesASCIIFolded(bytes, xmlFalseBytes) {
        return false
      }
      return nil

    default:
      return nil
    }
  }
}

extension String: _XMLPrimitiveDecodable {
  static func decodeXMLPrimitive(_ bytes: ArraySlice<UInt8>) -> String? {
    String(decoding: bytes, as: UTF8.self)
  }
}

extension Double: _XMLPrimitiveDecodable {
  static func decodeXMLPrimitive(_ bytes: ArraySlice<UInt8>) -> Double? {
    xmlParseDouble(bytes)
  }
}

extension Float: _XMLPrimitiveDecodable {
  static func decodeXMLPrimitive(_ bytes: ArraySlice<UInt8>) -> Float? {
    guard let value = xmlParseDouble(bytes) else {
      return nil
    }
    return Float(value)
  }
}

extension Int: _XMLPrimitiveDecodable {
  static func decodeXMLPrimitive(_ bytes: ArraySlice<UInt8>) -> Int? {
    xmlParseSignedInteger(bytes).map(Int.init)
  }
}

extension Int8: _XMLPrimitiveDecodable {
  static func decodeXMLPrimitive(_ bytes: ArraySlice<UInt8>) -> Int8? {
    guard let value = xmlParseSignedInteger(bytes) else {
      return nil
    }
    return Int8(exactly: value)
  }
}

extension Int16: _XMLPrimitiveDecodable {
  static func decodeXMLPrimitive(_ bytes: ArraySlice<UInt8>) -> Int16? {
    guard let value = xmlParseSignedInteger(bytes) else {
      return nil
    }
    return Int16(exactly: value)
  }
}

extension Int32: _XMLPrimitiveDecodable {
  static func decodeXMLPrimitive(_ bytes: ArraySlice<UInt8>) -> Int32? {
    guard let value = xmlParseSignedInteger(bytes) else {
      return nil
    }
    return Int32(exactly: value)
  }
}

extension Int64: _XMLPrimitiveDecodable {
  static func decodeXMLPrimitive(_ bytes: ArraySlice<UInt8>) -> Int64? {
    xmlParseSignedInteger(bytes)
  }
}

extension UInt: _XMLPrimitiveDecodable {
  static func decodeXMLPrimitive(_ bytes: ArraySlice<UInt8>) -> UInt? {
    guard let value = xmlParseUnsignedInteger(bytes) else {
      return nil
    }
    return UInt(exactly: value)
  }
}

extension UInt8: _XMLPrimitiveDecodable {
  static func decodeXMLPrimitive(_ bytes: ArraySlice<UInt8>) -> UInt8? {
    guard let value = xmlParseUnsignedInteger(bytes) else {
      return nil
    }
    return UInt8(exactly: value)
  }
}

extension UInt16: _XMLPrimitiveDecodable {
  static func decodeXMLPrimitive(_ bytes: ArraySlice<UInt8>) -> UInt16? {
    guard let value = xmlParseUnsignedInteger(bytes) else {
      return nil
    }
    return UInt16(exactly: value)
  }
}

extension UInt32: _XMLPrimitiveDecodable {
  static func decodeXMLPrimitive(_ bytes: ArraySlice<UInt8>) -> UInt32? {
    guard let value = xmlParseUnsignedInteger(bytes) else {
      return nil
    }
    return UInt32(exactly: value)
  }
}

extension UInt64: _XMLPrimitiveDecodable {
  static func decodeXMLPrimitive(_ bytes: ArraySlice<UInt8>) -> UInt64? {
    xmlParseUnsignedInteger(bytes)
  }
}

// MARK: - Byte-level number parsing

/// The boolean spellings, as bytes.
///
/// Static arrays rather than `StaticString`: converting a `StaticString` inside
/// the comparison would allocate a fresh array on every call, which for a
/// boolean-heavy document is the difference between a fast decode and a slow one.
private let xmlTrueBytes: [UInt8] = Array("true".utf8)
private let xmlFalseBytes: [UInt8] = Array("false".utf8)
private let xmlYesBytes: [UInt8] = Array("yes".utf8)
private let xmlNoBytes: [UInt8] = Array("no".utf8)

/// Matches `bytes` against a lowercase ASCII pattern, case-insensitively.
@inline(__always)
private func xmlMatchesASCIIFolded(_ bytes: ArraySlice<UInt8>, _ pattern: [UInt8]) -> Bool {
  guard bytes.count == pattern.count else {
    return false
  }
  var index = bytes.startIndex
  var offset = 0
  while offset < pattern.count {
    if xmlASCIILowercased(bytes[index]) != pattern[offset] {
      return false
    }
    index += 1
    offset += 1
  }
  return true
}

/// Parses a signed decimal integer from UTF-8 bytes.
///
/// Hand-written rather than `Int(String)` because the obvious version allocates a
/// `String` for every number in the document. Overflow is detected rather than
/// trapping, so an out-of-range value becomes a decoding error instead of a
/// crash — a serialization library must never crash on untrusted input.
func xmlParseSignedInteger(_ bytes: ArraySlice<UInt8>) -> Int64? {
  var index = bytes.startIndex
  let end = bytes.endIndex
  guard index < end else {
    return nil
  }

  var negative = false
  if bytes[index] == UInt8(ascii: "-") {
    negative = true
    index += 1
  } else if bytes[index] == UInt8(ascii: "+") {
    index += 1
  }
  guard index < end else {
    return nil
  }

  var magnitude: UInt64 = 0
  var sawDigit = false
  while index < end {
    let byte = bytes[index]
    guard xmlIsASCIIDigit(byte) else {
      return nil
    }
    sawDigit = true
    let digit: UInt64 = .init(byte - UInt8(ascii: "0"))
    let (multiplied, overflowMultiply) = magnitude.multipliedReportingOverflow(by: 10)
    guard !overflowMultiply else {
      return nil
    }
    let (added, overflowAdd) = multiplied.addingReportingOverflow(digit)
    guard !overflowAdd else {
      return nil
    }
    magnitude = added
    index += 1
  }
  guard sawDigit else {
    return nil
  }

  if negative {
    guard magnitude <= UInt64(Int64.max) + 1 else {
      return nil
    }
    if magnitude == UInt64(Int64.max) + 1 {
      return Int64.min
    }
    return -Int64(magnitude)
  }
  guard magnitude <= UInt64(Int64.max) else {
    return nil
  }
  return Int64(magnitude)
}

/// Parses an unsigned decimal integer from UTF-8 bytes.
func xmlParseUnsignedInteger(_ bytes: ArraySlice<UInt8>) -> UInt64? {
  var index = bytes.startIndex
  let end = bytes.endIndex
  guard index < end else {
    return nil
  }

  if bytes[index] == UInt8(ascii: "+") {
    index += 1
  }
  guard index < end, xmlIsASCIIDigit(bytes[index]) else {
    return nil
  }

  var value: UInt64 = 0
  while index < end {
    let byte = bytes[index]
    guard xmlIsASCIIDigit(byte) else {
      return nil
    }
    let digit: UInt64 = .init(byte - UInt8(ascii: "0"))
    let (multiplied, overflowMultiply) = value.multipliedReportingOverflow(by: 10)
    guard !overflowMultiply else {
      return nil
    }
    let (added, overflowAdd) = multiplied.addingReportingOverflow(digit)
    guard !overflowAdd else {
      return nil
    }
    value = added
    index += 1
  }
  return value
}

/// Parses a decimal floating-point number from UTF-8 bytes.
///
/// ## Correctness note
///
/// The obvious implementation — accumulate the digits as an integer and scale by
/// a power of ten — is **wrong** for the general case. `3.14159` accumulated as
/// `314159` and multiplied by `10^-5` yields `3.1415900000000003`, because
/// `10^-5` is not exactly representable and the product is rounded twice. Two
/// roundings do not give the correctly-rounded result.
///
/// So the fast path is used only where it is provably exact: a value that is a
/// plain integer of at most 15 significant digits, which any `Double` represents
/// exactly. Everything else is handed to the standard library's parser, which is
/// correctly rounded for every input into a small buffer.
///
/// This costs one small stack buffer for fractional or exponent notation, and it
/// means the library never silently returns a value that differs from the one
/// written in the document — which for a serialization library is the only
/// acceptable behaviour.
func xmlParseDouble(_ bytes: ArraySlice<UInt8>) -> Double? {
  guard !bytes.isEmpty else {
    return nil
  }

  // Fast path: plain integer syntax, exactly representable.
  if xmlIsPlainIntegerSyntax(bytes) {
    let negative = bytes.first == UInt8(ascii: "-")
    let digits = (bytes.first == UInt8(ascii: "-") || bytes.first == UInt8(ascii: "+"))
      ? bytes.dropFirst()
      : bytes
    if digits.count <= 15, let magnitude = xmlParseUnsignedInteger(digits) {
      let value: Double = .init(magnitude)
      return negative ? -value : value
    }
  }

  // General path: correctly rounded by the standard library.
  var buffer: [UInt8] = []
  buffer.reserveCapacity(bytes.count)
  buffer.append(contentsOf: bytes)
  guard let value = Double(String(decoding: buffer, as: UTF8.self)) else {
    return nil
  }
  guard value.isFinite || !value.isNaN else {
    return nil
  }
  return value
}

/// `true` when `bytes` is an optionally signed run of decimal digits with no
/// fraction and no exponent.
@inline(__always)
private func xmlIsPlainIntegerSyntax(_ bytes: ArraySlice<UInt8>) -> Bool {
  var index = bytes.startIndex
  let end = bytes.endIndex
  guard index < end else {
    return false
  }
  if bytes[index] == UInt8(ascii: "-") || bytes[index] == UInt8(ascii: "+") {
    index += 1
  }
  guard index < end else {
    return false
  }
  while index < end {
    guard xmlIsASCIIDigit(bytes[index]) else {
      return false
    }
    index += 1
  }
  return true
}

// MARK: - Dispatch

/// Decodes a `Decodable` value from an ``_XMLDecodeNode``.
///
/// ## Why this exists
///
/// `Codable` has no concept of XML, so the standard library's container
/// machinery decodes `[T]` from a *nested container* and `T?` from
/// `decodeIfPresent`. XML spells a list as repeated siblings, and an optional as
/// an absent element — neither of which is a nested container.
///
/// For a generic `T`, `KeyedDecodingContainer.decode<T>(_:forKey:)` dispatches
/// through the `KeyedDecodingContainerProtocol` requirement, so XMLKit gets to
/// make the decision. This type makes it:
///
/// 1. `Optional<Wrapped>` is unwrapped and decided by the *presence* of content.
/// 2. A type conforming to ``XMLRepeatedElementDecodable`` (that is, `Array` and
///    `Set`) is built from the matching sibling elements.
/// 3. `Dictionary` is built from sibling elements keyed by their names.
/// 4. Anything else is decoded by the type itself via `init(from:)`, which will
///    ask for whichever container it needs.
///
/// This is the single most important part of the Codable bridge: without it,
/// arrays and optionals would fail at runtime for every real document.
enum _XMLScalarDispatch {
  /// The value `T` takes when an element is present but has no content.
  ///
  /// Returns `nil` when `T` cannot represent emptiness, in which case the caller
  /// should attempt a normal decode so the failure names the type and the path
  /// rather than being papered over.
  static func emptyValue<T: Decodable>(forAbsentContent _: T.Type) -> T? {
    if let optionalType = T.self as? any _XMLOptionalDecoding.Type {
      // `Optional<Wrapped>.none` erased to `Any` is not the same as
      // `nil as Any`, so the value is produced by the optional's own
      // absent-content path rather than by a cast of `nil`.
      return optionalType.emptyOptional() as? T
    }
    if T.self is String.Type {
      return "" as? T
    }
    return nil
  }

  /// Decodes `T` from `engine`'s current node.
  static func decode<T: Decodable>(_: T.Type, engine: _XMLDecoderEngine) throws -> T {
    // 1. Optionals are decided by presence, never by a nested container.
    if let optionalType = T.self as? any _XMLOptionalDecoding.Type {
      guard let value = try optionalType.decodeOptional(engine: engine) as? T else {
        // `decodeOptional` returns `Optional<Wrapped>.none` for absent
        // content; reaching here means the cast itself failed, which
        // cannot happen for a well-formed `Optional`.
        throw XMLDecoderError.typeMismatch(
          expected: String(describing: T.self),
          actual: engine.node.describingName,
          path: engine.codingPath.map(\.stringValue),
          debugDescription: "failed to decode an optional value"
        )
      }
      return value
    }

    // 2. Repeated elements: Array, Set.
    //
    // The check must be against `_XMLRepeatedElementDecoding`, not against the
    // public `XMLRepeatedElementDecodable`: the public protocol's conformance
    // is conditional on `Element: Decodable`, and a conditional conformance in
    // a runtime `is` check against `any P.Type` matches every array,
    // including `[Opaque]`, which would then fail to decode.
    if let repeatedType = T.self as? any _XMLRepeatedElementDecoding.Type {
      return try repeatedType.decodeRepeatedElements(engine: engine) as! T
    }
    if let publicRepeatedType = T.self as? any XMLRepeatedElementDecodable.Type {
      // A third-party collection that conforms to the public protocol but
      // not the internal one: hand it the matching children.
      let elements = try engine.repeatedElementsForCurrentNode()
      let decoder = engine.makeChild(node: .sequence(elements))
      return try publicRepeatedType._decodeRepeated(from: elements, decoder: decoder) as! T
    }

    // 3. Dictionary, keyed by element name.
    if let dictionaryType = T.self as? any _XMLDictionaryDecoding.Type {
      return try dictionaryType.decodeDictionary(engine: engine) as! T
    }

    // 4. Scalars, read from the element's text. Registration order matters:
    //    the built-in numeric conformances win, and a user's
    //    `XMLScalarDecodable` conformance is consulted next.
    if let valueType = T.self as? any _XMLValueDecoding.Type {
      return try valueType.decodeValue(engine: engine) as! T
    }
    if let scalarType = T.self as? any XMLScalarDecodable.Type {
      return try _xmlScalarDecodableBox(scalarType).decodeValue(engine: engine) as! T
    }

    // 5. Anything else decodes itself.
    return try T(from: engine)
  }
}

/// A type that has a meaningful value for an element with no content.
///
/// Only `String` qualifies among the built-in types: `""` is a legitimate string
/// and must not be conflated with absence. Numbers, dates and the like have no
/// such value, so an empty element for them means "no value".
protocol _XMLEmptyContentRepresentable {
  /// The value an empty element produces.
  static func emptyContentValue() -> Any
}

extension String: _XMLEmptyContentRepresentable {
  static func emptyContentValue() -> Any {
    ""
  }
}

/// Type-erased optional decoding.
protocol _XMLOptionalDecoding {
  static func decodeOptional(engine: _XMLDecoderEngine) throws -> Any

  /// An absent optional value, type-erased.
  ///
  /// Needed because `nil as Any` produces an `Optional<Any>.none`, which is not
  /// the same value as `Optional<Wrapped>.none` and would fail the cast back to
  /// `T`.
  static func emptyOptional() -> Any
}

extension Optional: _XMLOptionalDecoding where Wrapped: Decodable {
  static func emptyOptional() -> Any {
    Wrapped?.none as Any
  }

  static func decodeOptional(engine: _XMLDecoderEngine) throws -> Any {
    // An absent element, an explicit `xsi:nil`, or empty content all mean
    // "no value". Anything else is decoded as `Wrapped`.
    switch engine.node {
    case let .element(element):
      if engine.isExplicitlyNil(element) {
        return Wrapped?.none as Any
      }
      // An element with no content at all is `nil` for an optional scalar,
      // which is how `<tag/>` conventionally means "absent".
      if element.children.isEmpty, Wrapped.self is any _XMLValueDecoding.Type {
        return Wrapped?.none as Any
      }
      return try Wrapped?.some(_XMLScalarDispatch.decode(Wrapped.self, engine: engine)) as Any

    case let .sequence(elements):
      guard !elements.isEmpty else {
        return Wrapped?.none as Any
      }
      return try Wrapped?.some(_XMLScalarDispatch.decode(Wrapped.self, engine: engine)) as Any

    case let .attribute(text),
         let .text(text):
      // An empty attribute is a legitimate empty value, so an empty string
      // is `Some("")` while an empty numeric is `nil`.
      if text.isEmpty, !(Wrapped.self is String.Type) {
        return Wrapped?.none as Any
      }
      return try Wrapped?.some(_XMLScalarDispatch.decode(Wrapped.self, engine: engine)) as Any
    }
  }
}

/// Type-erased repeated-element decoding.
protocol _XMLRepeatedElementDecoding {
  static func decodeRepeatedElements(engine: _XMLDecoderEngine) throws -> Any
}

extension Array: _XMLRepeatedElementDecoding where Element: Decodable {
  static func decodeRepeatedElements(engine: _XMLDecoderEngine) throws -> Any {
    switch engine.node {
    case let .sequence(elements):
      return try Array<Element>.decodeRepeated(from: elements, decoder: engine)
    case let .element(element):
      // A single element is a one-element array, which is what makes an
      // array property work against a document that happens to have exactly
      // one occurrence.
      return try Array<Element>.decodeRepeated(from: [element], decoder: engine)
    case .attribute,
         .text:
      throw XMLDecoderError.typeMismatch(
        expected: "an array",
        actual: engine.node.describingName,
        path: engine.codingPath.map(\.stringValue),
        debugDescription: nil
      )
    }
  }
}

extension Set: _XMLRepeatedElementDecoding where Element: Decodable {
  static func decodeRepeatedElements(engine: _XMLDecoderEngine) throws -> Any {
    let array = try Array<Element>.decodeRepeatedElements(engine: engine) as! [Element]
    return Set(array)
  }
}

/// Type-erased dictionary decoding.
protocol _XMLDictionaryDecoding {
  static func decodeDictionary(engine: _XMLDecoderEngine) throws -> Any
}

extension Dictionary: _XMLDictionaryDecoding where Value: Decodable {
  static func decodeDictionary(engine: _XMLDecoderEngine) throws -> Any {
    // XML has no dictionary literal, so the natural spelling is repeated
    // elements whose *names* are the keys:
    //
    //     <properties><color>red</color><size>large</size></properties>
    //
    // That is exactly what a dictionary means, and it is the only
    // interpretation under which a dictionary round-trips.
    guard Key.self == String.self else {
      throw XMLDecoderError.typeMismatch(
        expected: "a dictionary with String keys",
        actual: "a dictionary with \(Key.self) keys",
        path: engine.codingPath.map(\.stringValue),
        debugDescription: "XML element names are strings, so only String-keyed dictionaries are representable"
      )
    }

    // The entries are the node's child elements, named by their keys. This
    // mirrors encoding exactly: a dictionary is written as repeated children
    // of the property's element, with no wrapper, so decoding must read the
    // same children back.
    let elements: [XMLElement]
    switch engine.node {
    case let .sequence(sequence):
      elements = sequence
    case let .element(element):
      elements = engine.elementChildren(of: element)
    case .attribute,
         .text:
      throw XMLDecoderError.typeMismatch(
        expected: "a dictionary",
        actual: engine.node.describingName,
        path: engine.codingPath.map(\.stringValue),
        debugDescription: nil
      )
    }

    var result: [String: Value] = [:]
    result.reserveCapacity(elements.count)
    for (offset, element) in elements.enumerated() {
      let childDecoder = engine.makeChild(node: .element(element), index: offset)
      result[element.qualifiedName] = try _XMLScalarDispatch.decode(Value.self, engine: childDecoder)
    }
    return result as Any
  }
}

/// Type-erased scalar decoding: the bridge from `Decodable` dispatch to a
/// concrete type's text parser.
///
/// ## Why the two-step generic call
///
/// An existential cast (`T.self as? any P.Type`) proves conformance but discards
/// which concrete type `Self` is, so a static requirement returning `Self`
/// cannot be called on the result. Passing `T.self` into a generic function
/// makes the compiler bind `T`, after which `_XMLScalarBox<T>` satisfies the
/// requirement with `Self == T`. This is the standard technique for recovering a
/// concrete type from a metatype, and it is why the dispatch below can be both
/// type-safe and free of `unsafeBitCast`.
protocol _XMLValueDecoding {
  static func decodeValue(engine: _XMLDecoderEngine) throws -> Any
}

/// A scalar decoded by parsing the element's text.
private struct _XMLScalarBox<T: _XMLPrimitiveDecodable>: _XMLValueDecoding {
  static func decodeValue(engine: _XMLDecoderEngine) throws -> Any {
    let bytes = try engine.scalarBytes()
    guard let value = T.decodeXMLPrimitive(bytes) else {
      throw XMLDecoderError.dataCorrupted(
        path: engine.codingPath.map(\.stringValue),
        debugDescription: "\(String(decoding: bytes, as: UTF8.self).debugDescription) is not a valid \(T.self)"
      )
    }
    return value
  }
}

/// Binds `T` so that `_XMLScalarBox<T>` can be used.
@inline(__always)
private func _xmlScalarBox<T: _XMLPrimitiveDecodable>(_: T.Type) -> any _XMLValueDecoding.Type {
  _XMLScalarBox<T>.self
}

/// A scalar decoded by an ``XMLScalarDecodable`` conformance.
private struct _XMLScalarDecodableBox<T: XMLScalarDecodable>: _XMLValueDecoding {
  static func decodeValue(engine: _XMLDecoderEngine) throws -> Any {
    let bytes = try engine.scalarBytes()
    let text: String = .init(decoding: bytes, as: UTF8.self)
    guard let value = T(xmlText: text) else {
      throw XMLDecoderError.dataCorrupted(
        path: engine.codingPath.map(\.stringValue),
        debugDescription: "\(text.debugDescription) is not a valid \(T.self)"
      )
    }
    return value
  }
}

@inline(__always)
private func _xmlScalarDecodableBox<T: XMLScalarDecodable>(_: T.Type) -> any _XMLValueDecoding.Type {
  _XMLScalarDecodableBox<T>.self
}

// MARK: - Built-in conformances

extension Bool: _XMLValueDecoding {
  static func decodeValue(engine: _XMLDecoderEngine) throws -> Any {
    try _xmlScalarBox(Bool.self).decodeValue(engine: engine)
  }
}

extension String: _XMLValueDecoding {
  static func decodeValue(engine: _XMLDecoderEngine) throws -> Any {
    // A string is decoded from the element's text with the configured
    // trimming applied, so `<a>\n  hi \n</a>` yields "hi" under the default
    // strategy. Trimming at this single point is what makes every scalar type
    // agree; if each type trimmed for itself they would drift.
    try String(decoding: engine.scalarBytes(), as: UTF8.self)
  }
}

extension Double: _XMLValueDecoding {
  static func decodeValue(engine: _XMLDecoderEngine) throws -> Any {
    try _xmlScalarBox(Double.self).decodeValue(engine: engine)
  }
}

extension Float: _XMLValueDecoding {
  static func decodeValue(engine: _XMLDecoderEngine) throws -> Any {
    try _xmlScalarBox(Float.self).decodeValue(engine: engine)
  }
}

extension Int: _XMLValueDecoding {
  static func decodeValue(engine: _XMLDecoderEngine) throws -> Any {
    try _xmlScalarBox(Int.self).decodeValue(engine: engine)
  }
}

extension Int8: _XMLValueDecoding {
  static func decodeValue(engine: _XMLDecoderEngine) throws -> Any {
    try _xmlScalarBox(Int8.self).decodeValue(engine: engine)
  }
}

extension Int16: _XMLValueDecoding {
  static func decodeValue(engine: _XMLDecoderEngine) throws -> Any {
    try _xmlScalarBox(Int16.self).decodeValue(engine: engine)
  }
}

extension Int32: _XMLValueDecoding {
  static func decodeValue(engine: _XMLDecoderEngine) throws -> Any {
    try _xmlScalarBox(Int32.self).decodeValue(engine: engine)
  }
}

extension Int64: _XMLValueDecoding {
  static func decodeValue(engine: _XMLDecoderEngine) throws -> Any {
    try _xmlScalarBox(Int64.self).decodeValue(engine: engine)
  }
}

extension UInt: _XMLValueDecoding {
  static func decodeValue(engine: _XMLDecoderEngine) throws -> Any {
    try _xmlScalarBox(UInt.self).decodeValue(engine: engine)
  }
}

extension UInt8: _XMLValueDecoding {
  static func decodeValue(engine: _XMLDecoderEngine) throws -> Any {
    try _xmlScalarBox(UInt8.self).decodeValue(engine: engine)
  }
}

extension UInt16: _XMLValueDecoding {
  static func decodeValue(engine: _XMLDecoderEngine) throws -> Any {
    try _xmlScalarBox(UInt16.self).decodeValue(engine: engine)
  }
}

extension UInt32: _XMLValueDecoding {
  static func decodeValue(engine: _XMLDecoderEngine) throws -> Any {
    try _xmlScalarBox(UInt32.self).decodeValue(engine: engine)
  }
}

extension UInt64: _XMLValueDecoding {
  static func decodeValue(engine: _XMLDecoderEngine) throws -> Any {
    try _xmlScalarBox(UInt64.self).decodeValue(engine: engine)
  }
}

extension Decimal: _XMLValueDecoding {
  static func decodeValue(engine: _XMLDecoderEngine) throws -> Any {
    // `Decimal`'s own `Codable` conformance expects a JSON-style number, which
    // a text node is not. Parsing the text directly is both correct for XML
    // and avoids a round trip through a numeric representation.
    let text = try String(decoding: engine.scalarBytes(), as: UTF8.self)
    guard let value = Decimal(string: text, locale: nil) else {
      throw XMLDecoderError.dataCorrupted(
        path: engine.codingPath.map(\.stringValue),
        debugDescription: "\(text.debugDescription) is not a valid Decimal"
      )
    }
    return value
  }
}
