//
//  XMLDecoder.swift
//  XMLKit
//
//  The Codable bridge, read side.
//

import Foundation

// MARK: - Scalar protocols

/// A type that XMLKit knows how to read from an element's text.
///
/// Conforming a type to this protocol teaches ``XMLDecoder`` about a scalar it
/// could not otherwise handle. Pair it with ``XMLScalarEncodable`` to make the
/// type round-trip — a domain identifier, a unit-specific
/// measurement, a currency:
///
/// ```swift
/// extension Version: XMLScalarDecodable, XMLScalarEncodable {
///     public init?(xmlText: String) { self.init(parsing: xmlText) }
///     public var xmlText: String { description }
/// }
/// ```
///
/// The initializer takes a `String` rather than a byte slice because conformances
/// live outside the module and a `String` is the only representation that can
/// cross that boundary. The built-in numeric types deliberately do **not** use
/// this path: they are parsed straight from the document's UTF-8 bytes, which
/// avoids allocating a `String` per number.
public protocol XMLScalarDecodable {
    /// Creates a value from an element's text, already trimmed according to
    /// ``XMLDecoder/textTrimming``.
    ///
    /// Return `nil` when the text is not a valid representation; the decoder
    /// turns that into ``XMLDecoderError/dataCorrupted(path:debugDescription:)``.
    init?(xmlText: String)
}

// MARK: - Repeated-element support

/// A type that can be built from a group of sibling elements.
///
/// `Array` and `Set` conform, and this is the mechanism that lets ``XMLDecoder``
/// read `[T]` from repeated sibling elements — how XML actually spells a list.
///
/// ## Why this protocol exists
///
/// For `Array<Element>`, the standard library's
/// `KeyedDecodingContainer.decode<T>(_:forKey:)` reaches
/// `nestedUnkeyedContainer(forKey:)` and decodes each element from that nested
/// container. There is no way to intercept that path and say "this array is not a
/// nested container; it is the set of sibling elements with this name".
///
/// However, for a *generic* `T`, `decode<T>(_:forKey:)` does dispatch through the
/// protocol requirement — verified on Swift 6.4, see
/// `Documentation/probes/array-dispatch-probe.swift`. XMLKit can therefore take
/// the decision over, provided it can construct the collection itself. That is
/// exactly what this protocol supplies.
///
/// - Note: Public only because `Array` and `Set` must conform to it from within
///   this module and because the requirement mentions an internal-adjacent
///   decoder. It is not intended as an extension point; use
///   ``XMLScalarDecodable`` for that.
public protocol XMLRepeatedElementDecodable {
    /// Decodes `Self` from `children`, which are the sibling elements that
    /// matched the coding key.
    static func decodeRepeated(from children: [XMLElement], decoder: any Decoder) throws -> Self

    /// Type-erased entry point used by the decoder's runtime dispatch.
    ///
    /// - Warning: Not intended to be implemented by hand; the default
    ///   implementation forwards to ``decodeRepeated(from:decoder:)``.
    static func _decodeRepeated(from children: [XMLElement], decoder: any Decoder) throws -> Any
}

extension XMLRepeatedElementDecodable {
    public static func _decodeRepeated(from children: [XMLElement], decoder: any Decoder) throws -> Any {
        try decodeRepeated(from: children, decoder: decoder)
    }
}

// `Element: Decodable` is part of the conformance, not the protocol, because the
// protocol is only meaningful for collections whose elements can be decoded —
// and stating it on the extension is what lets the implementation call
// `Element(from:)` without an unsafe cast.
extension Array: XMLRepeatedElementDecodable where Element: Decodable {
    public static func decodeRepeated(from children: [XMLElement], decoder: any Decoder) throws -> [Element] {
        guard !children.isEmpty else { return [] }
        guard let engine = decoder as? _XMLDecoderEngine else {
            // Not our decoder: fall back to the standard path, which will report
            // a clear type mismatch rather than silently producing an empty array.
            throw XMLDecoderError.typeMismatch(
                expected: "an XMLKit decoder",
                actual: String(describing: type(of: decoder)),
                path: decoder.codingPath.map(\.stringValue),
                debugDescription: "repeated-element decoding requires XMLDecoder"
            )
        }

        var result: [Element] = []
        result.reserveCapacity(children.count)
        for (offset, child) in children.enumerated() {
            // Each element decodes through its own decoder, positioned at that
            // child and with the index appended to the coding path. Without the
            // index, a failure inside the fourth `<item>` would report the same
            // path as a failure inside the first, making a real document's error
            // impossible to locate.
            let childDecoder = engine.makeChild(node: .element(child), index: offset)
            result.append(try _XMLScalarDispatch.decode(Element.self, engine: childDecoder))
        }
        return result
    }
}

extension Set: XMLRepeatedElementDecodable where Element: Decodable {
    public static func decodeRepeated(from children: [XMLElement], decoder: any Decoder) throws -> Set<Element> {
        Set(try Array<Element>.decodeRepeated(from: children, decoder: decoder))
    }
}

// MARK: - Decoder

/// Decodes Swift values from XML documents.
///
/// The XML counterpart of `JSONDecoder`: the same shape, the same error
/// vocabulary, and the same feel — with XML's extra structure (attributes, text,
/// namespaces, repeated elements) exposed through explicit strategies rather
/// than guessed at.
///
/// ```swift
/// let library = try XMLDecoder().decode(Library.self, from: xmlData)
/// ```
///
/// ## Mapping
///
/// A plain property maps to a child element:
///
/// ```swift
/// struct Book: Codable { var title: String }   // <Book><title>…</title></Book>
/// ```
///
/// XML's other channels are reached with sigilled keys, which cannot collide with
/// element names because the sigils are not legal XML name characters:
///
/// ```swift
/// struct Book: Codable {
///     var id: String        // the element <id>
///     var lang: String      // the attribute lang, via CodingKeys { case lang = "@lang" }
///     var text: String      // the element's own text, via CodingKeys { case text = "#text" }
/// }
/// ```
///
/// See ``XMLKeyConvention`` for the complete key vocabulary. If a type cannot be
/// annotated, ``attributeStrategy`` / ``textStrategy`` accept explicit key sets
/// instead.
///
/// ## Repeated elements
///
/// An array property reads repeated sibling elements, the natural XML spelling:
///
/// ```swift
/// struct Library: Codable { var book: [Book] }
/// // <Library><book/><book/></Library>
/// ```
///
/// With the default ``XMLRepeatedElementStrategy/automatic``, a single wrapping
/// element (`<book><book/><book/></book>`) is also accepted, because both shapes
/// occur in real documents.
///
/// ## Mixed content is rejected, not silently flattened
///
/// If an element must be a keyed container but contains text interleaved with
/// child elements, the decoder throws
/// ``XMLDecoderError/mixedContentNotRepresentable(element:path:)``. Silently
/// dropping the interleaved text would lose data, and a serialization library
/// that loses data quietly is worse than one that fails. Use ``XMLDocument`` for
/// mixed content.
///
/// ## Concurrency
///
/// `XMLDecoder` is a `Sendable` value type holding only configuration, so one
/// instance can be shared across tasks. Every `decode` call builds a private
/// engine and shares no mutable state with any other, so concurrent decodes are
/// entirely independent. There is no global cache and no actor.
public struct XMLDecoder: Sendable {
    /// Limits applied while parsing.
    public var parserConfiguration: XMLParserConfiguration

    /// How attribute keys are recognised.
    public var attributeStrategy: XMLAttributeStrategy

    /// How the text-content key is recognised.
    public var textStrategy: XMLTextStrategy

    /// How namespaces appear in coding keys.
    public var namespaceStrategy: XMLNamespaceStrategy

    /// How whitespace around a scalar value is treated.
    public var textTrimming: XMLTextTrimming

    /// How arrays are matched to the document.
    public var repeatedElementStrategy: XMLRepeatedElementStrategy

    /// What to do with content the decoded type does not account for.
    public var unknownContentStrategy: XMLUnknownContentStrategy

    /// Values made available to every `Decoder` produced by this decoder.
    public var userInfo: [CodingUserInfoKey: any Sendable]

    /// Whether a document with several top-level elements may be decoded as an
    /// array.
    ///
    /// When `true`, `decode([T].self, from:)` reads repeated root-level elements
    /// instead of requiring one root. Off by default, because accepting a
    /// fragment where a document is expected hides malformed input.
    public var allowsFragments: Bool

    /// Creates a decoder with the default configuration.
    public init() {
        self.parserConfiguration = .default
        self.attributeStrategy = .useConvention
        self.textStrategy = .useConvention
        self.namespaceStrategy = .uri
        self.textTrimming = .whitespaceAndNewlines
        self.repeatedElementStrategy = .automatic
        self.unknownContentStrategy = .ignore
        self.userInfo = [:]
        self.allowsFragments = false
    }

    // MARK: Entry points

    /// Decodes a value from a UTF-8 XML document.
    ///
    /// - Throws: ``XMLParserError`` when the document is not well-formed, or
    ///   ``XMLDecoderError`` when it is well-formed but does not match `T`.
    public func decode<T: Decodable>(_ type: T.Type, from bytes: [UInt8]) throws -> T {
        let tokenized = try XMLTokenizer.tokenize(
            bytes: bytes,
            configuration: parserConfiguration,
            allowsMultipleRoots: allowsFragments
        )
        let engine = _XMLDecoderEngine(document: tokenized, configuration: self)
        return try engine.decodeRoot(T.self)
    }

    /// Decodes a value from an XML `String`.
    public func decode<T: Decodable>(_ type: T.Type, from string: String) throws -> T {
        try decode(T.self, from: Array(string.utf8))
    }

    /// Decodes a value from XML `Data`.
    public func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        try decode(T.self, from: [UInt8](data))
    }
}

// MARK: - Position

/// Where a decoder is currently reading from.
///
/// The cases are explicit so that "what does decoding a number mean here?" always
/// has a defined answer instead of a fallback:
///
/// * `.element` — an object, or the element's own text if a scalar is wanted.
/// * `.sequence` — an array, set or dictionary.
/// * `.text` — a scalar with no element of its own, such as an attribute or an
///   enum's raw value.
internal enum _XMLDecodeNode {
    case element(XMLElement)
    case sequence([XMLElement])
    /// Text with no element of its own: an enum's raw value, or any other scalar
    /// the caller supplies directly.
    case text([UInt8])
    /// An attribute value, already unescaped and whitespace-normalised by the
    /// tokenizer.
    ///
    /// A distinct case from ``text`` because the two are read from different
    /// places. An attribute's value never comes from the element's character
    /// data, so decoding one as element text yields either nothing or a
    /// truncation at the first entity reference — which is exactly the bug that
    /// made `<T a="&#13;"/>` decode to `""`.
    case attribute([UInt8])

    internal var describingName: String {
        switch self {
        case let .element(element): return element.qualifiedName
        case let .sequence(elements): return elements.first?.qualifiedName ?? "(empty sequence)"
        case .text: return "(text)"
        case .attribute: return "(attribute)"
        }
    }
}

// MARK: - Engine

/// Per-decode state.
///
/// A `final class` so nested containers share one instance: the child and
/// attribute caches live exactly as long as the decode and are released with it.
///
/// - Important: An engine is created **fresh for each `decode` call** and never
///   escapes it. No state is shared between documents, which is why
///   ``XMLDecoder`` can be `Sendable` with no locks and no actor.
internal final class _XMLDecoderEngine: Decoder {
    let document: XMLTokenizedDocument
    let configuration: XMLDecoder
    let codingPath: [any CodingKey]
    let userInfo: [CodingUserInfoKey: Any]

    /// The position this decoder reads from.
    var node: _XMLDecodeNode

    /// Caches shared by every container in this decode.
    let cache: _XMLDecodeCache

    /// Materialises elements from tokens on demand.
    private var builder: DOMBuilder

    init(document: XMLTokenizedDocument, configuration: XMLDecoder) {
        self.document = document
        self.configuration = configuration
        self.codingPath = []
        self.userInfo = configuration.userInfo
        self.node = .text([])
        self.cache = _XMLDecodeCache()
        self.builder = DOMBuilder(document: document, configuration: configuration.parserConfiguration)
    }

    private init(
        document: XMLTokenizedDocument,
        node: _XMLDecodeNode,
        codingPath: [any CodingKey],
        userInfo: [CodingUserInfoKey: Any],
        configuration: XMLDecoder,
        cache: _XMLDecodeCache,
        builder: DOMBuilder
    ) {
        self.document = document
        self.node = node
        self.codingPath = codingPath
        self.userInfo = userInfo
        self.configuration = configuration
        self.cache = cache
        self.builder = builder
    }

    /// A child engine positioned at `node`, sharing this engine's caches.
    func makeChild(node: _XMLDecodeNode, key: (any CodingKey)? = nil) -> _XMLDecoderEngine {
        var path = codingPath
        if let key { path.append(key) }
        return _XMLDecoderEngine(
            document: document,
            node: node,
            codingPath: path,
            userInfo: userInfo,
            configuration: configuration,
            cache: cache,
            builder: builder
        )
    }

    /// A child engine positioned at an array element, appending the index.
    func makeChild(node: _XMLDecodeNode, index: Int) -> _XMLDecoderEngine {
        makeChild(node: node, key: _XMLIndexKey(index))
    }

    /// Materialises the element rooted at `tokenIndex`, memoised.
    func element(at index: Int) throws -> XMLElement {
        if let cached = cache.elements[index] { return cached }
        let built = try builder.buildElement(at: index)
        cache.elements[index] = built
        return built
    }

    /// The element children of `element`, memoised.
    ///
    /// A struct with a dozen properties asks for a dozen keys; without this each
    /// ask rescans the same child list, making a decode O(properties × children).
    func elementChildren(of element: XMLElement) -> [XMLElement] {
        guard let position = element.documentPosition else { return element.childElements }
        if let cached = cache.childLists[position] { return cached }
        let children = element.childElements
        cache.childLists[position] = children
        return children
    }

    /// The attributes of `element` keyed by name, memoised.
    func attributes(of element: XMLElement) -> [String: String] {
        guard let position = element.documentPosition else {
            return Dictionary(element.attributes, uniquingKeysWith: { first, _ in first })
        }
        if let cached = cache.attributeMaps[position] { return cached }
        let map = Dictionary(element.attributes, uniquingKeysWith: { first, _ in first })
        cache.attributeMaps[position] = map
        return map
    }

    /// The concatenated text of `element`, memoised.
    func text(of element: XMLElement) -> String {
        guard let position = element.documentPosition else { return element.text }
        if let cached = cache.textValues[position] { return cached }
        let value = element.text
        cache.textValues[position] = value
        return value
    }

    // MARK: Child matching

    /// The name `key` resolves to for lookup, honouring ``XMLNamespaceStrategy``.
    func lookupName(for key: any CodingKey) -> String {
        let raw = key.stringValue
        let isAttribute = raw.hasPrefix(XMLKeyConvention.attributeSigil)
        let bare = isAttribute ? String(raw.dropFirst(1)) : raw
        let sigil = isAttribute ? XMLKeyConvention.attributeSigil : ""

        switch configuration.namespaceStrategy {
        case .ignoreNamespace:
            return sigil + localPart(of: bare)
        case .qualifiedNameAsWritten:
            return raw
        case .uri:
            // A key of the form "uri localName" is already namespace-resolved.
            // Anything else is a bare local name.
            return raw
        }
    }

    private func localPart(of name: String) -> String {
        guard let colon = name.firstIndex(of: ":") else { return name }
        return String(name[name.index(after: colon)...])
    }

    /// Child elements of `parent` that match `key`.
    ///
    /// Matching is on the fully-resolved name, so with the default `.uri`
    /// strategy a key of `"urn:x local"` matches an element with local name
    /// `local` in namespace `urn:x`, however it was prefixed in the document.
    func children(of parent: XMLElement, matching key: any CodingKey, namespace: String? = nil) -> [XMLElement] {
        let wanted = lookupName(for: key)
        var matches: [XMLElement] = []
        for child in elementChildren(of: parent) where child.qualifiedName == wanted {
            matches.append(child)
        }
        return matches
    }

    /// The single child matching `key`, or `nil` when there is none or several.
    func child(of parent: XMLElement, matching key: any CodingKey) -> XMLElement? {
        let matches = children(of: parent, matching: key)
        return matches.count == 1 ? matches[0] : nil
    }

    // MARK: Root

    func decodeRoot<T: Decodable>(_ type: T.Type) throws -> T {
        let roots = try document.rootIndices.map { try element(at: Int($0)) }

        guard !roots.isEmpty else { throw XMLDecoderError.missingRootElement }

        // An array at the top level means "the repeated root elements".
        if type is any XMLRepeatedElementDecodable.Type {
            node = .sequence(roots)
        } else if roots.count == 1 {
            node = .element(roots[0])
        } else {
            node = .sequence(roots)
        }

        return try _XMLScalarDispatch.decode(T.self, engine: self)
    }

    // MARK: Decoder conformance

    func container<Key: CodingKey>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> {
        switch node {
        case let .element(element):
            return KeyedDecodingContainer(
                _XMLKeyedDecodingContainer<Key>(engine: self, element: element)
            )
        case let .sequence(elements):
            guard elements.count == 1, let only = elements.first else {
                throw XMLDecoderError.typeMismatch(
                    expected: "a single element",
                    actual: "a sequence of \(elements.count) elements",
                    path: codingPath.map(\.stringValue),
                    debugDescription: "a keyed container needs exactly one element to read from"
                )
            }
            return KeyedDecodingContainer(
                _XMLKeyedDecodingContainer<Key>(engine: self, element: only)
            )
        case .text, .attribute:
            throw XMLDecoderError.typeMismatch(
                expected: "an element",
                actual: node.describingName,
                path: codingPath.map(\.stringValue),
                debugDescription: "text cannot be decoded into a keyed container"
            )
        }
    }

    func unkeyedContainer() throws -> any UnkeyedDecodingContainer {
        switch node {
        case let .sequence(elements):
            return _XMLUnkeyedDecodingContainer(engine: self, elements: elements)
        case let .element(element):
            // A lone element used as an array is a one-element array, which is
            // what makes `var items: [Item]` work against a document containing a
            // single `<items>` element — a very common shape.
            return _XMLUnkeyedDecodingContainer(engine: self, elements: [element])
        case .text, .attribute:
            throw XMLDecoderError.typeMismatch(
                expected: "an array",
                actual: node.describingName,
                path: codingPath.map(\.stringValue),
                debugDescription: nil
            )
        }
    }

    func singleValueContainer() throws -> any SingleValueDecodingContainer {
        _XMLSingleValueDecodingContainer(engine: self, node: node)
    }
}

// MARK: - Caches

/// Caches shared by every container in one decode.
internal final class _XMLDecodeCache {
    var elements: [Int: XMLElement] = [:]
    var childLists: [Int: [XMLElement]] = [:]
    var attributeMaps: [Int: [String: String]] = [:]
    var textValues: [Int: String] = [:]
}

// MARK: - Coding key for array positions

/// A coding key for an array position, so error paths read `items[2].title`.
internal struct _XMLIndexKey: CodingKey {
    var intValue: Int?
    var stringValue: String

    init(_ index: Int) {
        self.intValue = index
        self.stringValue = "[\(index)]"
    }

    init?(stringValue: String) {
        guard stringValue.hasPrefix("["), stringValue.hasSuffix("]"),
              let value = Int(stringValue.dropFirst().dropLast()) else { return nil }
        self.intValue = value
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        self.init(intValue)
    }
}

// MARK: - Empty document placeholder

extension XMLTokenizedDocument {
    /// An empty document, used only where a tokenized document is required but
    /// none exists.
    internal static var empty: XMLTokenizedDocument {
        XMLTokenizedDocument(
            bytes: [],
            tokens: [],
            attributes: [],
            rootIndex: -1,
            rootIndices: [],
            declarationIndex: -1,
            documentTypeIndex: -1,
            declaredEncoding: nil,
            declaredVersion: nil,
            declaredStandalone: nil
        )
    }
}
