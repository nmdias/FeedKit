//
// XMLEncoder.swift
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

// MARK: - Scalar encoding support

/// A type whose XML representation is decided by the encoder itself rather than
/// by a `Codable` conformance.
///
/// Implemented for the types XML writes specially — `Bool`, the numeric types,
/// `Date`, `Data`, `Decimal` — so that a document contains `42` rather than
/// `{"int": 42}`. This matters because `Codable` synthesis for a scalar type
/// wraps it in a single-value container, and the default single-value encoding
/// for anything non-primitive is a *keyed* representation.
protocol _XMLValueEncodable {
  /// The value's XML text, or `nil` when the encoder should fall back to the
  /// type's own `Codable` conformance.
  func xmlEncodedText(encoder: _XMLEncoderEngine, path: [any CodingKey]) throws -> String?
}

extension Bool: _XMLValueEncodable {
  func xmlEncodedText(encoder _: _XMLEncoderEngine, path _: [any CodingKey]) throws -> String? {
    self ? "true" : "false"
  }
}

extension String: _XMLValueEncodable {
  func xmlEncodedText(encoder _: _XMLEncoderEngine, path _: [any CodingKey]) throws -> String? {
    self
  }
}

extension Double: _XMLValueEncodable {
  func xmlEncodedText(encoder _: _XMLEncoderEngine, path _: [any CodingKey]) throws -> String? {
    xmlFormatDouble(self)
  }
}

extension Float: _XMLValueEncodable {
  func xmlEncodedText(encoder _: _XMLEncoderEngine, path _: [any CodingKey]) throws -> String? {
    xmlFormatDouble(Double(self))
  }
}

extension Int: _XMLValueEncodable {
  func xmlEncodedText(encoder _: _XMLEncoderEngine, path _: [any CodingKey]) throws -> String? {
    String(self)
  }
}

extension Int8: _XMLValueEncodable {
  func xmlEncodedText(encoder _: _XMLEncoderEngine, path _: [any CodingKey]) throws -> String? {
    String(self)
  }
}

extension Int16: _XMLValueEncodable {
  func xmlEncodedText(encoder _: _XMLEncoderEngine, path _: [any CodingKey]) throws -> String? {
    String(self)
  }
}

extension Int32: _XMLValueEncodable {
  func xmlEncodedText(encoder _: _XMLEncoderEngine, path _: [any CodingKey]) throws -> String? {
    String(self)
  }
}

extension Int64: _XMLValueEncodable {
  func xmlEncodedText(encoder _: _XMLEncoderEngine, path _: [any CodingKey]) throws -> String? {
    String(self)
  }
}

extension UInt: _XMLValueEncodable {
  func xmlEncodedText(encoder _: _XMLEncoderEngine, path _: [any CodingKey]) throws -> String? {
    String(self)
  }
}

extension UInt8: _XMLValueEncodable {
  func xmlEncodedText(encoder _: _XMLEncoderEngine, path _: [any CodingKey]) throws -> String? {
    String(self)
  }
}

extension UInt16: _XMLValueEncodable {
  func xmlEncodedText(encoder _: _XMLEncoderEngine, path _: [any CodingKey]) throws -> String? {
    String(self)
  }
}

extension UInt32: _XMLValueEncodable {
  func xmlEncodedText(encoder _: _XMLEncoderEngine, path _: [any CodingKey]) throws -> String? {
    String(self)
  }
}

extension UInt64: _XMLValueEncodable {
  func xmlEncodedText(encoder _: _XMLEncoderEngine, path _: [any CodingKey]) throws -> String? {
    String(self)
  }
}

extension Date: _XMLValueEncodable {
  func xmlEncodedText(encoder: _XMLEncoderEngine, path _: [any CodingKey]) throws -> String? {
    switch encoder.configuration.dateEncodingStrategy {
    case .iso8601:
      return xmlISO8601String(from: self, fractionalSeconds: false)

    case .iso8601WithFractionalSeconds:
      return xmlISO8601String(from: self, fractionalSeconds: true)

    case .secondsSince1970:
      return xmlFormatDouble(timeIntervalSince1970)

    case .millisecondsSince1970:
      return xmlFormatDouble(timeIntervalSince1970 * 1000)

    case let .formatted(format, timeZone):
      let formatter: DateFormatter = .init()
      formatter.locale = Locale(identifier: "en_US_POSIX")
      formatter.timeZone = timeZone ?? TimeZone(secondsFromGMT: 0)
      formatter.dateFormat = format
      return formatter.string(from: self)

    case .deferredToDate:
      return nil
    }
  }
}

extension Data: _XMLValueEncodable {
  func xmlEncodedText(encoder: _XMLEncoderEngine, path _: [any CodingKey]) throws -> String? {
    switch encoder.configuration.dataEncodingStrategy {
    case .base64:
      return base64EncodedString()

    case .hexadecimal:
      var result = ""
      result.reserveCapacity(count * 2)
      for byte in self {
        result += String(byte, radix: 16, uppercase: false).leftPadded(to: 2)
      }
      return result

    case .deferredToData:
      return nil
    }
  }
}

extension Decimal: _XMLValueEncodable {
  func xmlEncodedText(encoder: _XMLEncoderEngine, path _: [any CodingKey]) throws -> String? {
    switch encoder.configuration.decimalEncodingStrategy {
    case .plain:
      description
    case .deferredToDecimal:
      nil
    }
  }
}

/// Types a third party can conform to in order to control how they appear as
/// XML text.
///
/// ```swift
/// extension Version: XMLScalarEncodable {
///     public var xmlText: String { description }
/// }
/// ```
public protocol XMLScalarEncodable {
  /// The value's XML text representation.
  var xmlText: String { get }
}

// MARK: - Text formatting helpers

/// Formats a `Double` so that it round-trips exactly and never uses a form XML
/// consumers misread.
///
/// `Swift`'s default description already produces the shortest representation
/// that round-trips, which is what is wanted. The one adjustment is that a
/// non-finite value is rejected by the caller rather than written, because XML
/// has no spelling for infinity or NaN.
func xmlFormatDouble(_ value: Double) -> String? {
  guard value.isFinite else {
    return nil
  }
  return "\(value)"
}

/// Formats a `Date` as ISO 8601 in UTC.
///
/// ## Why not `ISO8601DateFormatter`
///
/// `ISO8601DateFormatter` is not `Sendable`, so it cannot be cached in a
/// `Sendable` encoder; creating one per value is roughly an order of magnitude
/// slower than formatting the components directly. It is also unavailable in
/// swift-corelibs-foundation on some platforms.
///
/// ## Why not `gmtime_r`
///
/// The C route works, but it needs an `UnsafeMutablePointer<tm>` and therefore
/// opts the function out of strict memory-safety checking — for a formatting
/// routine that has no performance need for unsafe code. `Calendar` in the
/// ISO-8601 configuration gives the same civil-time components safely.
///
/// The result is always UTC with a trailing `Z`, which is what makes ISO 8601
/// values sort lexicographically and interoperate with every XML consumer.
func xmlISO8601String(from date: Date, fractionalSeconds: Bool) -> String {
  var calendar: Calendar = .init(identifier: .iso8601)
  calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .gmt

  let components = calendar.dateComponents(
    [.year, .month, .day, .hour, .minute, .second, .nanosecond],
    from: date
  )

  func pad(_ value: Int, _ width: Int) -> String {
    let text: String = .init(value)
    guard text.count < width else {
      return text
    }
    return String(repeating: "0", count: width - text.count) + text
  }

  var result = pad(components.year ?? 1970, 4)
  result += "-" + pad(components.month ?? 1, 2)
  result += "-" + pad(components.day ?? 1, 2)
  result += "T" + pad(components.hour ?? 0, 2)
  result += ":" + pad(components.minute ?? 0, 2)
  result += ":" + pad(components.second ?? 0, 2)

  if fractionalSeconds {
    // Nanoseconds truncated to milliseconds. Truncation rather than rounding
    // keeps the value monotonic with the printed seconds, so a rounded
    // `1000`ms can never carry into a second that was not printed.
    result += "." + pad((components.nanosecond ?? 0) / 1_000_000, 3)
  }

  return result + "Z"
}

private extension String {
  /// Left-pads to `width` with `character`.
  func leftPadded(to width: Int, with character: Character = "0") -> String {
    guard count < width else {
      return self
    }
    return String(repeating: String(character), count: width - count) + self
  }
}

// MARK: - Encoder

/// Encodes Swift values as XML documents.
///
/// The XML counterpart of `JSONEncoder`:
///
/// ```swift
/// let encoder = XMLEncoder()
/// encoder.rootElementName = "library"
/// let data = try encoder.encode(library)
/// ```
///
/// ## Mapping
///
/// A property becomes a child element; an array property becomes repeated child
/// elements. XML's other channels are selected with sigilled keys, which cannot
/// collide with element names because the sigils are not legal XML name
/// characters:
///
/// ```swift
/// struct Book: Codable {
///     var id: String        // <Book id="…">        via CodingKeys { case id = "@id" }
///     var title: String     // <title>…</title>
///     var text: String      // the element's text, via "#text"
///     var body: String      // a CDATA section,      via "#cdata"
/// }
/// ```
///
/// See ``XMLKeyConvention`` for the complete vocabulary.
///
/// ## What is rejected, and why
///
/// XML requires every element to have a name. A bare array has no name to give
/// its elements, so encoding `[T]` — at the top level, or as an element of
/// another array — throws
/// ``XMLEncoderError/unkeyedContainerNotRepresentable(path:)`` rather than
/// inventing a name such as `<item>`, which would produce a document that does
/// not match what the type says. Set ``rootElementName`` to encode a top-level
/// array under a known name.
///
/// A dictionary with non-`String` keys is rejected for the same reason: element
/// names are strings, so `[Int: T]` has no faithful representation.
///
/// ## Concurrency
///
/// `XMLEncoder` is a `Sendable` value type. Each `encode` call builds its own
/// private engine, so one instance can be used from many tasks at once with no
/// shared state.
public struct XMLEncoder: Sendable {
  // MARK: Lifecycle

  /// Creates an encoder with the default configuration.
  public init() {
    rootElementName = nil
    outputFormatting = []
    attributeStrategy = .useConvention
    textStrategy = .useConvention
    nilStrategy = .omitElement
    emptyElementStyle = .selfClosing
    dateEncodingStrategy = .iso8601
    dataEncodingStrategy = .base64
    decimalEncodingStrategy = .plain
    namespacePrefixes = [:]
    writesXMLDeclaration = false
    parserConfiguration = .default
    userInfo = [:]
  }

  // MARK: Public

  /// The name of the document element.
  ///
  /// When `nil`, the encoded type's name is used. Must be set to encode a
  /// top-level array, because there is no type name to fall back on.
  public var rootElementName: String?

  /// Formatting options.
  public var outputFormatting: XMLOutputFormatting

  /// How attribute keys are recognised.
  public var attributeStrategy: XMLAttributeStrategy

  /// How the text-content key is recognised.
  public var textStrategy: XMLTextStrategy

  /// How a `nil` value is written.
  public var nilStrategy: XMLNilStrategy

  /// Whether empty elements are self-closing.
  public var emptyElementStyle: XMLWriterConfiguration.EmptyElementStyle

  /// How `Date` values are written.
  public var dateEncodingStrategy: XMLDateEncodingStrategy

  /// How `Data` values are written.
  public var dataEncodingStrategy: XMLDataEncodingStrategy

  /// How `Decimal` values are written.
  public var decimalEncodingStrategy: XMLDecimalEncodingStrategy

  /// Namespace prefixes to use, keyed by namespace URI.
  ///
  /// When a coding key contains a namespace URI, the encoder looks the URI up
  /// here for a prefix. An unmapped URI gets a deterministic generated prefix
  /// (`ns0`, `ns1`, …), so output is valid without configuration.
  public var namespacePrefixes: [String: String]

  /// Whether to write an XML declaration.
  public var writesXMLDeclaration: Bool

  /// Limits applied while encoding.
  public var parserConfiguration: XMLParserConfiguration

  /// Values made available to every `Encoder` produced by this encoder.
  public var userInfo: [CodingUserInfoKey: any Sendable]

  // MARK: Entry points

  /// Encodes `value` as an XML document.
  ///
  /// - Throws: ``XMLEncoderError`` when the value has no faithful XML
  ///   representation. A serialization library that invents a representation
  ///   for an unrepresentable value produces documents that mean something
  ///   other than what the type says, so XMLKit fails instead.
  public func encode<T: Encodable>(_ value: T) throws -> [UInt8] {
    let engine: _XMLEncoderEngine = .init(configuration: self)
    let rootName = try resolveRootElementName(T.self)
    let element = try engine.encodeRoot(value, name: rootName)
    return engine.serialize(element)
  }

  /// Encodes `value` as an XML document, using `rootElementName` for this call
  /// only.
  ///
  /// Preferred over mutating a shared encoder when the name varies per call,
  /// because it keeps the encoder itself immutable and therefore trivially safe
  /// to share.
  public func encode(_ value: some Encodable, rootElementName: String) throws -> [UInt8] {
    var copy = self
    copy.rootElementName = rootElementName
    return try copy.encode(value)
  }

  /// Encodes `value` as an XML `String`.
  public func encodeToString(_ value: some Encodable) throws -> String {
    try String(decoding: encode(value), as: UTF8.self)
  }

  /// Encodes `value` as an XML `String`, naming the document element for this
  /// call only.
  public func encodeToString(_ value: some Encodable, rootElementName: String) throws -> String {
    try String(decoding: encode(value, rootElementName: rootElementName), as: UTF8.self)
  }

  /// Encodes `value` as XML `Data`.
  public func encodeToData(_ value: some Encodable) throws -> Data {
    try Data(encode(value))
  }

  /// Encodes `value` as XML `Data`, naming the document element for this call
  /// only.
  public func encodeToData(_ value: some Encodable, rootElementName: String) throws -> Data {
    try Data(encode(value, rootElementName: rootElementName))
  }

  // MARK: Private

  /// Determines the document element's name.
  private func resolveRootElementName(_ type: (some Encodable).Type) throws -> String {
    if let rootElementName, !rootElementName.isEmpty {
      return rootElementName
    }
    // A top-level array has no name to borrow, so the caller must supply one.
    if type is any _XMLRepeatedElementEncoding.Type {
      throw XMLEncoderError.missingRootElementName
    }
    let name: String = .init(describing: type)
    // Strip a module qualification, which `String(describing:)` adds for
    // types outside the current module.
    if let dot = name.lastIndex(of: ".") {
      return String(name[name.index(after: dot)...])
    }
    return name
  }
}

// MARK: - Encoded element

/// A minimal element built during encoding.
///
/// Deliberately *not* ``XMLElement``: the encoder needs ordered attributes, text
/// and children with a flat, allocation-light representation, and it must be able
/// to construct a tree bottom-up. `XMLElement` is a mutable reference type
/// designed for a parsed document, and reusing it here would add parent-pointer
/// maintenance and a child-index cache that encoding never reads.
final class _XMLEncodedElement {
  // MARK: Lifecycle

  init(name: String) {
    self.name = name
  }

  // MARK: Internal

  let name: String
  var attributes: [(name: String, value: String)] = []
  var namespaceDeclarations: [XMLNamespaceDeclaration] = []
  var children: [_XMLEncodedElement] = []
  /// Text content written before any child element.
  var text: String?
  /// Whether `text` should be written as a CDATA section.
  var textIsCDATA = false

  /// The text of this element and all of its descendants, concatenated.
  var allText: String {
    var result = text ?? ""
    for child in children {
      result += child.allText
    }
    return result
  }
}

// MARK: - Engine

/// Per-encode state.
///
/// A `final class` so that the node tree and namespace registry are shared across
/// the container hierarchy, exactly as the decoder shares its caches. Created
/// fresh per `encode` call and never escaping it, which is what keeps
/// ``XMLEncoder`` `Sendable`.
final class _XMLEncoderEngine: Encoder {
  // MARK: Lifecycle

  init(configuration: XMLEncoder) {
    self.configuration = configuration
    codingPath = []
    userInfo = configuration.userInfo
    namespacePrefixes = configuration.namespacePrefixes
  }

  private init(configuration: XMLEncoder, codingPath: [any CodingKey], prefixes: [String: String], nextIndex: Int) {
    self.configuration = configuration
    self.codingPath = codingPath
    userInfo = configuration.userInfo
    namespacePrefixes = prefixes
    nextGeneratedPrefixIndex = nextIndex
  }

  // MARK: Internal

  let configuration: XMLEncoder
  var codingPath: [any CodingKey]
  let userInfo: [CodingUserInfoKey: Any]

  /// Prefixes already in scope at this element, inherited from its ancestors.
  ///
  /// A namespace is declared once per document branch: re-declaring it on
  /// every descendant that uses it would be redundant, and a document that
  /// repeats a declaration on the same element is not well-formed at all.
  var prefixesInScope: Set<String> = []

  /// Prefixes this element declared, which are in scope for its children.
  var prefixesDeclaredHere: Set<String> = []

  // MARK: Encoder conformance

  /// The element this engine writes into when a container is requested.
  ///
  /// Set by ``encodeValue(_:into:)`` before the value's `encode(to:)` runs, so
  /// that a type calling `encoder.container(keyedBy:)` — the normal path — finds
  /// the element it belongs to. It is also how a container obtained directly
  /// from the root encoder gets a correctly named element rather than an
  /// unnamed one.
  var targetElement: _XMLEncodedElement?

  /// The name to give an element created for a directly-requested container.
  var pendingRootName: String = ""

  // MARK: Validation

  /// Rejects a name that is not a legal XML name.
  ///
  /// Checked here rather than at write time so the error carries a coding path.
  static func validate(name: String, path _: XMLCodingPath) throws {
    if let reason = xmlDiagnoseInvalidName(Array(name.utf8)) {
      throw XMLEncoderError.invalidName(name, reason: reason)
    }
  }

  /// Rejects text containing a character that XML forbids.
  ///
  /// This is the check that stops a control character from producing a document
  /// no parser will read — the failure would otherwise surface much later, in
  /// someone else's system.
  static func validate(text: String, path: XMLCodingPath) throws {
    for scalar in text.unicodeScalars {
      if !xmlIsLegalCharacter(scalar.value) {
        throw XMLEncoderError.invalidCharacter(scalar: scalar.value, path: path)
      }
    }
  }

  func makeChild(key: (any CodingKey)?, index: Int?) -> _XMLEncoderEngine {
    var path = codingPath
    if let key {
      path.append(key)
    }
    if let index {
      path.append(_XMLIndexKey(index))
    }
    let child: _XMLEncoderEngine = .init(
      configuration: configuration,
      codingPath: path,
      prefixes: namespacePrefixes,
      nextIndex: nextGeneratedPrefixIndex
    )
    child.prefixesInScope = prefixesInScope.union(prefixesDeclaredHere)
    return child
  }

  // MARK: Namespaces

  /// Returns the prefix to use for `uri`, generating a deterministic one when
  /// the caller has not configured one.
  func prefix(forNamespaceURI uri: String) -> String {
    if let existing = namespacePrefixes[uri] {
      return existing
    }
    let generated = "ns\(nextGeneratedPrefixIndex)"
    nextGeneratedPrefixIndex += 1
    namespacePrefixes[uri] = generated
    return generated
  }

  // MARK: Root

  func encodeRoot(_ value: some Encodable, name: String) throws -> _XMLEncodedElement {
    try _XMLEncoderEngine.validate(name: name, path: [])

    // A top-level array encodes as repeated elements *nested under* the root:
    //
    //     <n><n>1</n><n>2</n></n>
    //
    // The repetition is unavoidable, because a document has exactly one root
    // element and `XMLEncoder` produces documents, not fragments. Use
    // `XMLDocument.parseFragment` / `XMLWriter` to write a bare sequence of
    // elements.
    if let repeated = value as? any _XMLRepeatedElementEncoding {
      let element: _XMLEncodedElement = .init(name: name)
      try repeated.encodeRepeated(into: element, encoder: self)
      return element
    }

    let element: _XMLEncodedElement = .init(name: name)

    let child = makeChild(key: nil, index: nil)
    child.pendingRootName = name
    child.targetElement = element
    try child.encodeValue(value, into: element)
    return element
  }

  /// Encodes `value` into `element`, choosing text or children.
  func encodeValue<T: Encodable>(_ value: T, into element: _XMLEncodedElement) throws {
    // A scalar becomes the element's text directly. This is why the encoder
    // does not simply hand every value to `encode(to:)`: for a scalar that
    // opens a single-value container, and for anything the encoder does not
    // recognise the default representation would be keyed — which is how a
    // naive implementation ends up writing `<pages>{"int":42}</pages>`.
    if let scalar = value as? any _XMLValueEncodable {
      if let text = try scalar.xmlEncodedText(encoder: self, path: codingPath) {
        try _XMLEncoderEngine.validate(text: text, path: codingPath.map(\.stringValue))
        element.text = text
        return
      }

      // The type has a text representation in principle but declined to
      // produce one. Falling through to `value.encode(to:)` here would be a
      // serious bug rather than a graceful degradation: the single-value
      // container's `encode` calls straight back into this method, so the
      // two would recurse until the stack overflowed. Report instead.
      if T.self is Double.Type || T.self is Float.Type {
        throw XMLEncoderError.valueNotRepresentable(
          type: String(describing: T.self),
          path: codingPath.map(\.stringValue),
          reason: "XML has no spelling for infinity or NaN"
        )
      }
      throw XMLEncoderError.valueNotRepresentable(
        type: String(describing: T.self),
        path: codingPath.map(\.stringValue),
        reason: "the configured encoding strategy defers this type to its own Codable conformance, "
          + "which cannot produce element text; choose a different strategy"
      )
    }

    if let custom = value as? any XMLScalarEncodable {
      try _XMLEncoderEngine.validate(text: custom.xmlText, path: codingPath.map(\.stringValue))
      element.text = custom.xmlText
      return
    }

    // Not a scalar: the value describes its own element via a container.
    targetElement = element
    try value.encode(to: self)
  }

  // MARK: Serialisation

  /// Writes the encoded tree to UTF-8 bytes.
  func serialize(_ element: _XMLEncodedElement) -> [UInt8] {
    var configuration: XMLWriterConfiguration = .init()
    let wantsDeclaration = self.configuration.writesXMLDeclaration
    configuration.xmlDeclaration = wantsDeclaration ? XMLDeclaration() : nil
    configuration.writesXMLDeclaration = wantsDeclaration
    configuration.prettyPrinted = self.configuration.outputFormatting.contains(.prettyPrinted)
    configuration.emptyElementStyle = self.configuration.outputFormatting.contains(.explicitEmptyElements)
      ? .openClosePair
      : self.configuration.emptyElementStyle
    configuration.textEscaping = self.configuration.outputFormatting.contains(.escapeGreaterThan)
      ? .escapeGreaterThan
      : .minimal
    configuration.attributeOrdering = self.configuration.outputFormatting.contains(.sortedAttributes)
      ? .sortedByName
      : .insertionOrder

    var output: [UInt8] = []
    output.reserveCapacity(256)

    // `writeEncoded` only knows about elements, so the declaration is emitted
    // here. Serialising the tree without this step silently dropped the
    // declaration however it was configured — a bug that only a test asserting
    // the exact bytes would catch.
    if configuration.writesXMLDeclaration, let declaration = configuration.xmlDeclaration {
      output.append(contentsOf: "<?xml version=\"".utf8)
      output.append(contentsOf: declaration.version.utf8)
      output.append(UInt8(ascii: "\""))
      if let encoding = declaration.encoding {
        output.append(contentsOf: " encoding=\"".utf8)
        output.append(contentsOf: encoding.utf8)
        output.append(UInt8(ascii: "\""))
      }
      if let standalone = declaration.standalone {
        output.append(contentsOf: " standalone=\"".utf8)
        output.append(contentsOf: (standalone ? "yes" : "no").utf8)
        output.append(UInt8(ascii: "\""))
      }
      output.append(contentsOf: "?>".utf8)
      if configuration.prettyPrinted {
        output.append(UInt8(ascii: "\n"))
      }
    }

    writeEncoded(element, depth: 0, configuration: configuration, into: &output)
    if configuration.prettyPrinted {
      output.append(UInt8(ascii: "\n"))
    }
    return output
  }

  func container<Key: CodingKey>(keyedBy _: Key.Type) -> KeyedEncodingContainer<Key> {
    // The element is named after the root when the value was encoded directly
    // from the top level, which is what gives `<Book>` rather than `<>`.
    let element = targetElement ?? _XMLEncodedElement(name: pendingRootName)
    targetElement = element
    return KeyedEncodingContainer(_XMLKeyedEncodingContainer<Key>(encoder: self, element: element))
  }

  func unkeyedContainer() -> any UnkeyedEncodingContainer {
    let element = targetElement ?? _XMLEncodedElement(name: pendingRootName)
    // An unkeyed container requested without a name cannot have one invented
    // for it: the elements it creates would need a name and there is none to
    // use. `_XMLUnkeyedEncodingContainer` reports that as an error when the
    // first element is encoded.
    return _XMLUnkeyedEncodingContainer(encoder: self, element: element, name: nil)
  }

  func singleValueContainer() -> any SingleValueEncodingContainer {
    let element = targetElement ?? _XMLEncodedElement(name: pendingRootName)
    targetElement = element
    return _XMLSingleValueEncodingContainer(encoder: self, element: element)
  }

  // MARK: Private

  /// Prefixes assigned to namespace URIs during this encode, so a URI is
  /// declared once and reused.
  private var namespacePrefixes: [String: String] = [:]

  private var nextGeneratedPrefixIndex = 0

  /// Writes an encoded element, reusing the escaping implementation the DOM
  /// writer uses so there is exactly one escaping code path in the library.
  private func writeEncoded(
    _ element: _XMLEncodedElement,
    depth: Int,
    configuration: XMLWriterConfiguration,
    into output: inout [UInt8]
  ) {
    if configuration.prettyPrinted, depth > 0 {
      for _ in 0 ..< depth {
        output.append(contentsOf: configuration.indentation.utf8)
      }
    }

    output.append(UInt8(ascii: "<"))
    output.append(contentsOf: element.name.utf8)

    let quote = configuration.attributeQuote.byte
    let attributes = configuration.attributeOrdering == .sortedByName
      ? element.attributes.sorted { $0.name < $1.name }
      : element.attributes

    for attribute in attributes {
      output.append(UInt8(ascii: " "))
      output.append(contentsOf: attribute.name.utf8)
      output.append(UInt8(ascii: "="))
      output.append(quote)
      XMLWriter.appendEscapedAttributeValue(attribute.value, quote: quote, into: &output)
      output.append(quote)
    }

    for declaration in element.namespaceDeclarations {
      output.append(UInt8(ascii: " "))
      output.append(contentsOf: declaration.prefix.map { "xmlns:\($0)" }?.utf8 ?? "xmlns".utf8)
      output.append(UInt8(ascii: "="))
      output.append(quote)
      XMLWriter.appendEscapedAttributeValue(declaration.uri, quote: quote, into: &output)
      output.append(quote)
    }

    let hasText = !(element.text ?? "").isEmpty
    let hasChildren = !element.children.isEmpty

    if !hasText, !hasChildren {
      switch configuration.emptyElementStyle {
      case .selfClosing:
        output.append(contentsOf: "/>".utf8)
      case .openClosePair:
        output.append(contentsOf: "></".utf8)
        output.append(contentsOf: element.name.utf8)
        output.append(UInt8(ascii: ">"))
      }
      return
    }

    output.append(UInt8(ascii: ">"))

    if hasText, let text = element.text {
      if element.textIsCDATA {
        output.append(contentsOf: "<![CDATA[".utf8)
        output.append(contentsOf: text.utf8)
        output.append(contentsOf: "]]>".utf8)
      } else {
        switch configuration.textEscaping {
        case .minimal:
          XMLWriter.appendEscapedText(text, escapeGreaterThan: false, into: &output)
        case .escapeGreaterThan:
          XMLWriter.appendEscapedText(text, escapeGreaterThan: true, into: &output)
        }
      }
    }

    let shouldIndent = configuration.prettyPrinted && !hasText
    for child in element.children {
      if shouldIndent {
        output.append(UInt8(ascii: "\n"))
        writeEncoded(child, depth: depth + 1, configuration: configuration, into: &output)
      } else {
        writeEncoded(child, depth: 0, configuration: configuration, into: &output)
      }
    }

    if shouldIndent {
      output.append(UInt8(ascii: "\n"))
      for _ in 0 ..< depth {
        output.append(contentsOf: configuration.indentation.utf8)
      }
    }
    output.append(contentsOf: "</".utf8)
    output.append(contentsOf: element.name.utf8)
    output.append(UInt8(ascii: ">"))
  }
}

// MARK: - Repeated element encoding

/// A collection that XMLKit knows how to write as repeated elements.
///
/// `Array` and `Set` conform. Encoding a bare array requires a name for its
/// elements, which the encoder takes from ``XMLEncoder/rootElementName`` or from
/// the enclosing coding key.
protocol _XMLRepeatedElementEncoding {
  /// Writes this collection's elements as children of `element`.
  func encodeRepeated(into element: _XMLEncodedElement, encoder: _XMLEncoderEngine) throws
}

extension Array: _XMLRepeatedElementEncoding where Element: Encodable {
  func encodeRepeated(into element: _XMLEncodedElement, encoder: _XMLEncoderEngine) throws {
    for (index, item) in enumerated() {
      let child: _XMLEncodedElement = .init(name: element.name)
      let itemEncoder = encoder.makeChild(key: nil, index: index)
      itemEncoder.targetElement = child
      try itemEncoder.encodeValue(item, into: child)
      element.children.append(child)
    }
  }
}

extension Set: _XMLRepeatedElementEncoding where Element: Encodable {
  func encodeRepeated(into element: _XMLEncodedElement, encoder: _XMLEncoderEngine) throws {
    // `Set` has no stable iteration order, so output would differ between runs
    // for the same value — breaking reproducible builds, caching and signing.
    // Sorting by the encoded text makes it deterministic; XML has no ordering
    // semantics for a set, so nothing is lost.
    let items = sorted { String(describing: $0) < String(describing: $1) }
    for (index, item) in items.enumerated() {
      let child: _XMLEncodedElement = .init(name: element.name)
      let itemEncoder = encoder.makeChild(key: nil, index: index)
      itemEncoder.targetElement = child
      try itemEncoder.encodeValue(item, into: child)
      element.children.append(child)
    }
  }
}
