//
//  XMLErrors.swift
//  XMLKit
//

import Foundation

// MARK: - Source position

/// A position within a document, expressed in both byte and human terms.
///
/// Byte offsets are what the tokenizer has cheaply; line and column are what a
/// human needs. Carrying both avoids a rescan when an error is formatted and
/// keeps the error `Equatable` for tests.
public struct XMLSourcePosition: Hashable, Sendable {
    /// The 0-based byte offset from the start of the document.
    public let byteOffset: Int

    /// The 1-based line number.
    public let line: Int

    /// The 1-based column number, counted in bytes.
    public let column: Int

    public init(byteOffset: Int, line: Int, column: Int) {
        self.byteOffset = byteOffset
        self.line = line
        self.column = column
    }
}

extension XMLSourcePosition: CustomStringConvertible {
    public var description: String { "line \(line), column \(column)" }
}

// MARK: - Parser errors

/// An error indicating that a document is not well-formed XML.
///
/// Every case that can point at a location carries an ``XMLSourcePosition``, so
/// diagnostics can say *where*, not merely *what*. This mirrors the level of
/// detail developers expect from modern compilers and is a deliberate departure
/// from `Foundation.XMLParser`, which reports line/column through a separate
/// delegate callback.
///
/// - Important: This enum is not `@frozen`. Match with a `default` clause so
///   that new cases can be added without breaking your build.
public enum XMLParserError: Error, Hashable, Sendable {
    /// The document is empty or contains only whitespace.
    case emptyDocument

    /// Input ended in the middle of a construct.
    ///
    /// - Parameters:
    ///   - position: Where the input ended.
    ///   - context: What was being parsed, e.g. `"element start tag"`.
    case unexpectedEndOfInput(position: XMLSourcePosition, context: String)

    /// The bytes are not valid UTF-8.
    case invalidUTF8(position: XMLSourcePosition)

    /// Markup is malformed at the given position.
    ///
    /// - Parameters:
    ///   - position: Where the problem was detected.
    ///   - reason: A short, human-readable explanation.
    case malformedMarkup(position: XMLSourcePosition, reason: String)

    /// A name does not match the XML `Name` production.
    case invalidName(_ name: String, reason: String)

    /// A name is not permitted to begin with the reserved string `xml`.
    case reservedNamePrefix(_ name: String)

    /// A start tag and its end tag do not agree.
    ///
    /// - Parameters:
    ///   - expected: The name opened by the start tag.
    ///   - found: The name in the end tag.
    ///   - position: The position of the end tag.
    case mismatchedEndTag(expected: String, found: String, position: XMLSourcePosition)

    /// An attribute appears twice on the same element.
    ///
    /// XML forbids duplicate attributes, unlike JSON's silently-last-wins
    /// duplicate keys, because accepting them hides data corruption.
    case duplicateAttribute(name: String, position: XMLSourcePosition)

    /// An attribute value is missing or unterminated.
    case invalidAttributeValue(name: String, position: XMLSourcePosition, reason: String)

    /// A character reference (`&#…;` / `&#x…;`) is malformed or out of range.
    case invalidCharacterReference(position: XMLSourcePosition, text: String)

    /// An entity reference names an entity that is not predefined.
    ///
    /// XMLKit does not process DTD internal subsets, so only the five
    /// predefined entities and numeric character references resolve. Reporting
    /// anything else is what makes XML external-entity and entity-expansion
    /// attacks structurally impossible.
    case unknownEntity(name: String, position: XMLSourcePosition)

    /// A character that is not legal in XML 1.0 appeared in the document.
    case invalidCharacter(scalar: UInt32, position: XMLSourcePosition)

    /// A `]]>` sequence appeared in ordinary content.
    case cdataTerminatorInContent(position: XMLSourcePosition)

    /// Content appeared where it is not allowed, e.g. before the root element
    /// or after it.
    case unexpectedContent(position: XMLSourcePosition, reason: String)

    /// A namespace prefix was used without a corresponding declaration.
    case undeclaredNamespacePrefix(prefix: String, position: XMLSourcePosition)

    /// A namespace declaration is itself invalid.
    case invalidNamespaceDeclaration(prefix: String, uri: String, reason: String, position: XMLSourcePosition)

    /// Nesting exceeded the configured maximum depth.
    ///
    /// This is the guard that makes stack-exhaustion denial-of-service
    /// impossible.
    case maximumDepthExceeded(limit: Int, position: XMLSourcePosition)

    /// A processing instruction is malformed, e.g. its target is `xml`.
    case invalidProcessingInstruction(position: XMLSourcePosition, reason: String)

    /// A comment is malformed, e.g. it contains `--` or ends with `--->`.
    case invalidComment(position: XMLSourcePosition, reason: String)

    /// A document type declaration is malformed.
    case invalidDocumentType(position: XMLSourcePosition, reason: String)

    /// A document contains external content that XMLKit does not resolve.
    case externalEntityNotSupported(systemID: String, position: XMLSourcePosition)
}

extension XMLParserError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .emptyDocument:
            return "document is empty"

        case let .unexpectedEndOfInput(position, context):
            return "unexpected end of input at \(position) while parsing \(context)"

        case let .invalidUTF8(position):
            return "input is not valid UTF-8 at \(position)"

        case let .malformedMarkup(position, reason):
            return "malformed markup at \(position): \(reason)"

        case let .invalidName(name, reason):
            return "invalid XML name '\(name)': \(reason)"

        case let .reservedNamePrefix(name):
            return "name '\(name)' is not permitted to begin with 'xml'"

        case let .mismatchedEndTag(expected, found, position):
            return "mismatched end tag at \(position): expected </\(expected)> but found </\(found)>"

        case let .duplicateAttribute(name, position):
            return "duplicate attribute '\(name)' at \(position)"

        case let .invalidAttributeValue(name, position, reason):
            return "invalid value for attribute '\(name)' at \(position): \(reason)"

        case let .invalidCharacterReference(position, text):
            return "invalid character reference '\(text)' at \(position)"

        case let .unknownEntity(name, position):
            return "unknown entity '&\(name);' at \(position); XMLKit resolves only the predefined entities and character references"

        case let .invalidCharacter(scalar, position):
            let hex = String(scalar, radix: 16, uppercase: true)
            return "character U+\(hex) is not permitted in XML at \(position)"

        case let .cdataTerminatorInContent(position):
            return "']]>' is not permitted in content at \(position); use ']]&gt;' or a CDATA section"

        case let .unexpectedContent(position, reason):
            return "unexpected content at \(position): \(reason)"

        case let .undeclaredNamespacePrefix(prefix, position):
            return "namespace prefix '\(prefix)' is used at \(position) but never declared"

        case let .invalidNamespaceDeclaration(prefix, uri, reason, position):
            return "invalid namespace declaration '\(prefix)' = '\(uri)' at \(position): \(reason)"

        case let .maximumDepthExceeded(limit, position):
            return "element nesting exceeds the maximum depth of \(limit) at \(position)"

        case let .invalidProcessingInstruction(position, reason):
            return "invalid processing instruction at \(position): \(reason)"

        case let .invalidComment(position, reason):
            return "invalid comment at \(position): \(reason)"

        case let .invalidDocumentType(position, reason):
            return "invalid document type declaration at \(position): \(reason)"

        case let .externalEntityNotSupported(systemID, position):
            return "external entity '\(systemID)' at \(position) is not supported"
        }
    }

    /// The position the error refers to, when it has one.
    public var position: XMLSourcePosition? {
        switch self {
        case .emptyDocument:
            return nil
        case let .unexpectedEndOfInput(position, _),
             let .invalidUTF8(position),
             let .malformedMarkup(position, _),
             let .mismatchedEndTag(_, _, position),
             let .duplicateAttribute(_, position),
             let .invalidAttributeValue(_, position, _),
             let .invalidCharacterReference(position, _),
             let .unknownEntity(_, position),
             let .invalidCharacter(_, position),
             let .cdataTerminatorInContent(position),
             let .unexpectedContent(position, _),
             let .undeclaredNamespacePrefix(_, position),
             let .invalidNamespaceDeclaration(_, _, _, position),
             let .maximumDepthExceeded(_, position),
             let .invalidProcessingInstruction(position, _),
             let .invalidComment(position, _),
             let .invalidDocumentType(position, _),
             let .externalEntityNotSupported(_, position):
            return position
        case .invalidName, .reservedNamePrefix:
            return nil
        }
    }
}

extension XMLParserError: LocalizedError {
    public var errorDescription: String? { description }
}

/// The error taxonomy expected by the conformance corpus in
/// `Tests/XMLKitTests/Conformance`.
///
/// The corpus is data, not code, so it names error kinds as strings. This
/// mapping keeps the corpus honest: a test failure says which kind it wanted and
/// which it got.
public enum XMLParserErrorKind: String, Sendable, CaseIterable {
    case emptyDocument
    case unexpectedEndOfInput
    case invalidUTF8
    case malformedMarkup
    case invalidName
    case reservedNamePrefix
    case mismatchedEndTag
    case duplicateAttribute
    case invalidAttributeValue
    case invalidCharacterReference
    case unknownEntity
    case invalidCharacter
    case cdataTerminatorInContent
    case unexpectedContent
    case undeclaredNamespacePrefix
    case invalidNamespaceDeclaration
    case maximumDepthExceeded
    case invalidProcessingInstruction
    case invalidComment
    case invalidDocumentType
    case externalEntityNotSupported
}

extension XMLParserError {
    /// The coarse kind of this error, for corpus-driven and table-driven tests.
    public var kind: XMLParserErrorKind {
        switch self {
        case .emptyDocument: return .emptyDocument
        case .unexpectedEndOfInput: return .unexpectedEndOfInput
        case .invalidUTF8: return .invalidUTF8
        case .malformedMarkup: return .malformedMarkup
        case .invalidName: return .invalidName
        case .reservedNamePrefix: return .reservedNamePrefix
        case .mismatchedEndTag: return .mismatchedEndTag
        case .duplicateAttribute: return .duplicateAttribute
        case .invalidAttributeValue: return .invalidAttributeValue
        case .invalidCharacterReference: return .invalidCharacterReference
        case .unknownEntity: return .unknownEntity
        case .invalidCharacter: return .invalidCharacter
        case .cdataTerminatorInContent: return .cdataTerminatorInContent
        case .unexpectedContent: return .unexpectedContent
        case .undeclaredNamespacePrefix: return .undeclaredNamespacePrefix
        case .invalidNamespaceDeclaration: return .invalidNamespaceDeclaration
        case .maximumDepthExceeded: return .maximumDepthExceeded
        case .invalidProcessingInstruction: return .invalidProcessingInstruction
        case .invalidComment: return .invalidComment
        case .invalidDocumentType: return .invalidDocumentType
        case .externalEntityNotSupported: return .externalEntityNotSupported
        }
    }
}

// MARK: - Coding paths

/// A `Sendable` rendering of a coding path.
///
/// `Codable`'s native representation is `[any CodingKey]`, which is not
/// `Sendable` and not `Equatable` in a useful way. XMLKit flattens paths to
/// strings for errors so that they can cross concurrency domains and be compared
/// in tests. The rendering is deliberately readable:
///
/// ```
/// ["library", "books", "[2]", "title"]
/// ```
public typealias XMLCodingPath = [String]

extension XMLCodingPath {
    /// Renders a coding path as a single dotted string, normalised so that the
    /// output matches the `path` produced by `DecodingError`'s `codingPath`.
    internal var dottedDescription: String {
        var result = ""
        for component in self {
            if component.hasPrefix("[") {
                result += component
            } else if result.isEmpty {
                result = component
            } else {
                result += ".\(component)"
            }
        }
        return result
    }
}

// MARK: - Decoder errors

/// An error indicating that a well-formed document does not match the requested
/// Swift type.
///
/// The cases deliberately mirror `DecodingError`, because a developer moving
/// between `JSONDecoder` and `XMLDecoder` should not have to learn a second
/// vocabulary for the same class of failure. XML-specific failures are the
/// additions.
///
/// - Important: This enum is not `@frozen`.
public enum XMLDecoderError: Error, Hashable, Sendable {
    /// No value was found for a required key.
    case keyNotFound(key: String, path: XMLCodingPath)

    /// A value was found but is not of the requested type.
    case typeMismatch(expected: String, actual: String, path: XMLCodingPath, debugDescription: String?)

    /// A value was present but could not be converted, typically a string that
    /// is not a valid number or date.
    case dataCorrupted(path: XMLCodingPath, debugDescription: String)

    /// The requested number of elements does not match the container.
    case valueNotFound(expected: String, path: XMLCodingPath, debugDescription: String?)

    /// An element mixes text and child elements, which no keyed container can
    /// represent.
    ///
    /// This is reported instead of silently discarding the interleaved text,
    /// because silent data loss is the worst failure mode a serialization
    /// library can have. Use ``XMLDocument`` to work with mixed content.
    case mixedContentNotRepresentable(element: String, path: XMLCodingPath)

    /// An element expected to hold a scalar also contains child elements.
    case elementHasChildren(expected: String, element: String, path: XMLCodingPath)

    /// Content was found that the decoded type does not account for, and
    /// ``UnknownContentStrategy/error`` was selected.
    case unknownContent(kind: String, name: String, path: XMLCodingPath)

    /// The document has no root element to decode.
    case missingRootElement

    /// A repeated element was requested but the document nests it instead (or
    /// vice versa) while ``RepeatedElementStrategy/strict`` was selected.
    case malformedRepeatedElement(name: String, path: XMLCodingPath, debugDescription: String)
}

extension XMLDecoderError: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .keyNotFound(key, path):
            return "no value found for key '\(key)'\(path.suffixDescription)"

        case let .typeMismatch(expected, actual, path, debugDescription):
            let base = "expected \(expected) but found \(actual)\(path.suffixDescription)"
            guard let debugDescription else { return base }
            return "\(base): \(debugDescription)"

        case let .dataCorrupted(path, debugDescription):
            return "data corrupted\(path.suffixDescription): \(debugDescription)"

        case let .valueNotFound(expected, path, debugDescription):
            let base = "expected \(expected) but found no value\(path.suffixDescription)"
            guard let debugDescription else { return base }
            return "\(base): \(debugDescription)"

        case let .mixedContentNotRepresentable(element, path):
            return """
                element <\(element)> mixes text and child elements\(path.suffixDescription), \
                which cannot be decoded into a keyed Swift type; use XMLDocument for mixed content
                """

        case let .elementHasChildren(expected, element, path):
            return """
                expected \(expected) for <\(element)>\(path.suffixDescription) but the element \
                contains child elements
                """

        case let .unknownContent(kind, name, path):
            return "unknown \(kind) '\(name)'\(path.suffixDescription)"

        case .missingRootElement:
            return "document contains no root element"

        case let .malformedRepeatedElement(name, path, debugDescription):
            return "malformed repeated element '\(name)'\(path.suffixDescription): \(debugDescription)"
        }
    }
}

extension XMLCodingPath {
    fileprivate var suffixDescription: String {
        isEmpty ? "" : " at \(dottedDescription)"
    }
}

extension XMLDecoderError: LocalizedError {
    public var errorDescription: String? { description }
}

// MARK: - Encoder errors

/// An error indicating that a Swift value cannot be represented as XML.
///
/// `XMLEncoder` throws rather than guessing. A silent fallback here would
/// produce a document that does not mean what the type says it means, and a
/// serialization library that lies is worse than one that fails.
///
/// - Important: This enum is not `@frozen`.
public enum XMLEncoderError: Error, Hashable, Sendable {
    /// An unkeyed container (a bare array) was requested where XML has no name
    /// to give the repeated elements.
    ///
    /// XML requires every element to be named, so a top-level array or an array
    /// nested directly in an array has no representable form. Wrap the array in
    /// a keyed type, or set ``XMLEncoder/rootElementName`` for a top-level array.
    case unkeyedContainerNotRepresentable(path: XMLCodingPath)

    /// A dictionary with non-string keys was requested, which XML cannot name.
    case nonStringDictionaryKey(path: XMLCodingPath, keyType: String)

    /// A value is not representable as XML text.
    case valueNotRepresentable(type: String, path: XMLCodingPath, reason: String)

    /// A name is not a legal XML name.
    case invalidName(String, reason: String)

    /// A value contains a character that is illegal in XML.
    case invalidCharacter(scalar: UInt32, path: XMLCodingPath)

    /// A key carries a namespace prefix that has no configured namespace.
    case unknownNamespacePrefix(prefix: String, path: XMLCodingPath)

    /// Two distinct namespace URIs were configured with the same prefix.
    case conflictingNamespacePrefix(prefix: String, existingURI: String, newURI: String)

    /// The value nests more deeply than the configured maximum.
    case maximumDepthExceeded(limit: Int, path: XMLCodingPath)

    /// A coding key and the configured text or attribute convention collide, so
    /// the document would be ambiguous.
    case ambiguousKey(name: String, path: XMLCodingPath, reason: String)

    /// No root element name was available.
    ///
    /// A name is required for the document element; supply
    /// ``XMLEncoder/rootElementName`` or encode a keyed type whose name can be
    /// derived.
    case missingRootElementName
}

extension XMLEncoderError: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .unkeyedContainerNotRepresentable(path):
            return """
                cannot encode an unkeyed container (array)\(path.suffixDescription) as XML because \
                the repeated elements would have no name; encode a keyed type instead, or set \
                rootElementName for a top-level array
                """

        case let .nonStringDictionaryKey(path, keyType):
            return "cannot encode a dictionary with \(keyType) keys as XML\(path.suffixDescription); XML element names are strings"

        case let .valueNotRepresentable(type, path, reason):
            return "cannot represent \(type) as XML text\(path.suffixDescription): \(reason)"

        case let .invalidName(name, reason):
            return "invalid XML name '\(name)': \(reason)"

        case let .invalidCharacter(scalar, path):
            let hex = String(scalar, radix: 16, uppercase: true)
            return "character U+\(hex) is not permitted in XML\(path.suffixDescription)"

        case let .unknownNamespacePrefix(prefix, path):
            return "no namespace is configured for prefix '\(prefix)'\(path.suffixDescription)"

        case let .conflictingNamespacePrefix(prefix, existingURI, newURI):
            return "prefix '\(prefix)' is configured for both '\(existingURI)' and '\(newURI)'"

        case let .maximumDepthExceeded(limit, path):
            return "value nesting exceeds the maximum depth of \(limit)\(path.suffixDescription)"

        case let .ambiguousKey(name, path, reason):
            return "coding key '\(name)' is ambiguous\(path.suffixDescription): \(reason)"

        case .missingRootElementName:
            return "no root element name is available; set XMLEncoder.rootElementName"
        }
    }
}

extension XMLEncoderError: LocalizedError {
    public var errorDescription: String? { description }
}

// MARK: - Internal error construction helpers

extension XMLParserError {
    /// Builds a `malformedMarkup` error, resolving line/column from `bytes`.
    @inline(__always)
    internal static func malformed(in bytes: [UInt8], at offset: Int, _ reason: String) -> XMLParserError {
        .malformedMarkup(position: xmlPosition(in: bytes, at: offset), reason: reason)
    }
}

/// Resolves a byte offset into an ``XMLSourcePosition`` without a line table.
///
/// Only for callers that have no cached table and expect at most one diagnostic.
/// Anything that may construct many diagnostics should build an ``XMLLineTable``
/// once; see its documentation for why.
@inline(__always)
internal func xmlPositionNoLineTable(in bytes: [UInt8], at offset: Int) -> XMLSourcePosition {
    xmlPosition(in: bytes, at: offset)
}

/// Resolves a byte offset into an ``XMLSourcePosition``.
@inline(__always)
internal func xmlPosition(in bytes: [UInt8], at offset: Int) -> XMLSourcePosition {
    let (line, column) = xmlLineAndColumn(in: bytes, atOffset: offset)
    return XMLSourcePosition(byteOffset: offset, line: line, column: column)
}
