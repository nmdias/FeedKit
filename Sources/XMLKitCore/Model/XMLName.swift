//
//  XMLName.swift
//  XMLKit
//

import Foundation

/// A validated XML 1.0 name.
///
/// `XMLName` is the library's guarantee that a string is a legal XML name, which
/// is what makes it possible for `XMLEncoder` and `XMLWriter` to be
/// *non-throwing* on the common path: once a value is an `XMLName`, no
/// well-formedness check is needed at serialization time.
///
/// It is also the type used for coding keys, so property names are validated
/// exactly once — at container creation — rather than on every lookup.
///
/// ```swift
/// let name = XMLName("book")!            // validated
/// let qname = XMLName(validating: "ns:book")  // throws on invalid
/// ```
///
/// - Note: `XMLName` permits a colon, because XML 1.0 `Name` allows it and a
///   qualified name is lexically a `Name`. Use ``XMLQualifiedName`` to split and
///   interpret the prefix; `XMLName` itself makes no namespace claim.
public struct XMLName: Hashable, Sendable, Comparable, CustomStringConvertible {
    /// The UTF-8 bytes of the name.
    ///
    /// Stored as bytes rather than `String` so that name comparisons in the
    /// decoder are byte comparisons and so that `XMLName` is trivially
    /// `Sendable` with no bridging cost.
    internal let utf8: [UInt8]

    /// Creates a name from a string, returning `nil` if it is not a legal XML
    /// name.
    public init?(_ string: String) {
        let bytes = Array(string.utf8)
        guard xmlIsValidName(bytes) else { return nil }
        self.utf8 = bytes
    }

    /// Creates a name, throwing a descriptive error if it is not legal.
    ///
    /// Preferred over the failable initialiser when the invalid case is a
    /// programming error that should surface with a reason.
    public init(validating string: String) throws {
        let bytes = Array(string.utf8)
        guard let failure = xmlDiagnoseInvalidName(bytes) else {
            self.utf8 = bytes
            return
        }
        throw XMLParserError.invalidName(string, reason: failure)
    }

    /// The name as a `String`.
    ///
    /// Because the name was validated as UTF-8 on construction, this is a
    /// non-failable, lossless conversion.
    public var stringValue: String {
        String(decoding: utf8, as: UTF8.self)
    }

    public var description: String { stringValue }

    /// The name's UTF-8 byte count.
    public var utf8Count: Int { utf8.count }

    /// `true` when the name contains a colon and therefore denotes a qualified
    /// name.
    public var isQualified: Bool {
        var index = 0
        while index < utf8.count {
            if utf8[index] == UInt8(ascii: ":") { return true }
            index += 1
        }
        return false
    }

    public static func < (lhs: XMLName, rhs: XMLName) -> Bool {
        xmlCompareBytes(lhs.utf8, rhs.utf8) < 0
    }
}

// MARK: - Validation helpers

/// Lexicographic byte comparison, used for stable ordering of names.
@inline(__always)
internal func xmlCompareBytes(_ lhs: [UInt8], _ rhs: [UInt8]) -> Int {
    let shared = Swift.min(lhs.count, rhs.count)
    var index = 0
    while index < shared {
        let left = lhs[index]
        let right = rhs[index]
        if left != right { return left < right ? -1 : 1 }
        index += 1
    }
    if lhs.count == rhs.count { return 0 }
    return lhs.count < rhs.count ? -1 : 1
}

/// Returns the index of the first occurrence of `byte`, or `nil`.
///
/// A hand-written loop rather than `firstIndex(of:)` because that method is a
/// `Collection` algorithm whose generic instantiation is measurably slower for
/// a single-byte search over a small array, and this is called per name.
@inline(__always)
internal func xmlFirstIndex(of byte: UInt8, in bytes: [UInt8]) -> Int? {
    var index = 0
    while index < bytes.count {
        if bytes[index] == byte { return index }
        index += 1
    }
    return nil
}

/// Decodes the next Unicode scalar starting at `index`, advancing `index`.
///
/// Returns `nil` only if the bytes are not valid UTF-8, which callers have
/// already excluded by validating before tokenisation.
@inline(__always)
internal func xmlDecodeScalar(_ bytes: [UInt8], _ index: inout Int) -> UInt32? {
    guard index < bytes.count else { return nil }
    let byte = bytes[index]

    if byte < 0x80 {
        index += 1
        return UInt32(byte)
    } else if byte & 0xE0 == 0xC0 {
        guard index + 1 < bytes.count else { return nil }
        let scalar = (UInt32(byte & 0x1F) << 6) | UInt32(bytes[index + 1] & 0x3F)
        index += 2
        return scalar
    } else if byte & 0xF0 == 0xE0 {
        guard index + 2 < bytes.count else { return nil }
        let scalar = (UInt32(byte & 0x0F) << 12)
            | (UInt32(bytes[index + 1] & 0x3F) << 6)
            | UInt32(bytes[index + 2] & 0x3F)
        index += 3
        return scalar
    } else if byte & 0xF8 == 0xF0 {
        guard index + 3 < bytes.count else { return nil }
        let scalar = (UInt32(byte & 0x07) << 18)
            | (UInt32(bytes[index + 1] & 0x3F) << 12)
            | (UInt32(bytes[index + 2] & 0x3F) << 6)
            | UInt32(bytes[index + 3] & 0x3F)
        index += 4
        return scalar
    }
    return nil
}

/// Validates that `bytes` matches the XML 1.0 `Name` production.
internal func xmlIsValidName(_ bytes: [UInt8]) -> Bool {
    xmlDiagnoseInvalidName(bytes) == nil
}

/// Returns a human-readable reason why `bytes` is not a legal XML name, or `nil`
/// if it is legal.
///
/// A diagnosed failure beats a bare `false`: "name starts with a digit" is
/// actionable, "invalid name" is not.
internal func xmlDiagnoseInvalidName(_ bytes: [UInt8]) -> String? {
    guard !bytes.isEmpty else { return "name is empty" }

    var index = 0
    guard let first = xmlDecodeScalar(bytes, &index) else {
        return "name is not valid UTF-8"
    }
    guard xmlIsNameStartScalar(first) else {
        if xmlIsASCIIDigit(UInt8(truncatingIfNeeded: first)) {
            return "name must not start with a digit"
        }
        if first == 0x2D {
            return "name must not start with '-'"
        }
        if first == 0x2E {
            return "name must not start with '.'"
        }
        if let scalar = UnicodeScalar(first), !(0x20...0x7E).contains(first) {
            return "name must not start with '\(Character(scalar))'"
        }
        return "name must not start with '\(Character(UnicodeScalar(first) ?? "?"))'"
    }

    while index < bytes.count {
        guard let scalar = xmlDecodeScalar(bytes, &index) else {
            return "name is not valid UTF-8"
        }
        guard xmlIsNameScalar(scalar) else {
            if scalar == 0x20 {
                return "name must not contain a space"
            }
            if let unicode = UnicodeScalar(scalar) {
                return "name must not contain '\(Character(unicode))'"
            }
            return "name contains an illegal character"
        }
    }

    return nil
}

// MARK: - Qualified names

/// A name split into an optional namespace prefix and a local part.
///
/// XML 1.0 `QName` is `[prefix ':'] localPart`. Splitting is done on the *first*
/// colon; a second colon makes the name illegal as a qualified name (it would
/// require the namespace-aware `NSName` production from XML Namespaces 1.1),
/// and XMLKit diagnoses that rather than silently accepting it.
public struct XMLQualifiedName: Hashable, Sendable {
    /// The prefix, or `nil` when the name is unprefixed.
    public let prefix: String?

    /// The local part of the name.
    public let localName: String

    /// The prefix's UTF-8 bytes, or `nil`.
    internal let prefixUTF8: [UInt8]?

    /// The local part's UTF-8 bytes.
    internal let localNameUTF8: [UInt8]

    /// Creates a qualified name from an already-validated name.
    ///
    /// - Throws: ``XMLParserError/invalidName(_:reason:)`` when the name
    ///   contains more than one colon.
    public init(_ name: XMLName) throws {
        let bytes = name.utf8
        guard let colon = xmlFirstIndex(of: UInt8(ascii: ":"), in: bytes) else {
            self.prefix = nil
            self.prefixUTF8 = nil
            self.localNameUTF8 = bytes
            self.localName = String(decoding: bytes, as: UTF8.self)
            return
        }

        let prefixBytes = Array(bytes[0..<colon])
        let localBytes = Array(bytes[(colon + 1)...])

        guard !prefixBytes.isEmpty else {
            throw XMLParserError.invalidName(name.stringValue, reason: "qualified name has an empty prefix")
        }
        guard !localBytes.isEmpty else {
            throw XMLParserError.invalidName(name.stringValue, reason: "qualified name has an empty local part")
        }
        guard !localBytes.contains(UInt8(ascii: ":")) else {
            throw XMLParserError.invalidName(
                name.stringValue,
                reason: "qualified name contains more than one ':'"
            )
        }
        guard xmlDiagnoseInvalidName(localBytes) == nil else {
            throw XMLParserError.invalidName(name.stringValue, reason: "qualified name has an invalid local part")
        }

        self.prefix = String(decoding: prefixBytes, as: UTF8.self)
        self.prefixUTF8 = prefixBytes
        self.localName = String(decoding: localBytes, as: UTF8.self)
        self.localNameUTF8 = localBytes
    }

    /// Creates a qualified name from a string already known to be valid.
    ///
    /// - Warning: This skips validation and exists only so a value round-tripped
    ///   out of a parsed document does not re-validate on every access. It is
    ///   internal precisely so it cannot be reached by a caller who has not
    ///   validated.
    internal init(unchecked name: String) {
        let bytes = Array(name.utf8)
        if let colon = xmlFirstIndex(of: UInt8(ascii: ":"), in: bytes) {
            self.prefixUTF8 = Array(bytes[0..<colon])
            self.localNameUTF8 = Array(bytes[(colon + 1)...])
            self.prefix = String(decoding: prefixUTF8!, as: UTF8.self)
            self.localName = String(decoding: localNameUTF8, as: UTF8.self)
        } else {
            self.prefix = nil
            self.prefixUTF8 = nil
            self.localNameUTF8 = bytes
            self.localName = name
        }
    }

    /// Creates a qualified name from a prefix and local part.
    public init(prefix: String?, localName: String) throws {
        guard let name = XMLName(localName) else {
            throw XMLParserError.invalidName(localName, reason: "invalid local name")
        }
        if let prefix {
            guard let prefixName = XMLName(prefix) else {
                throw XMLParserError.invalidName(prefix, reason: "invalid prefix")
            }
            try self.init(XMLName("\(prefixName.stringValue):\(name.stringValue)")!)
        } else {
            try self.init(name)
        }
    }

    /// The fully qualified name as it would appear in a document.
    public var stringValue: String {
        guard let prefix else { return localName }
        return "\(prefix):\(localName)"
    }
}

// MARK: - Literal support

/// Allows a validated name to be written as a string literal.
///
/// Exists so that XMLKit's macros can pass a property name or XML name to a
/// marker attribute without inventing an encoding, and so that
/// ``XMLAttribute``/``XMLCData`` can be written naturally:
///
/// ```swift
/// var id: String = ""      // role marker takes a literal name
/// ```
///
/// The literal is validated at run time, so a malformed literal is a clear error
/// rather than a document that cannot be written.
extension XMLName: ExpressibleByStringLiteral {
    /// Creates a name from a literal, validating it.
    ///
    /// Uses `Array(value.utf8)` rather than forwarding to `init?(_ string:)`,
    /// because forwarding a `String` into a failable initialiser is ambiguous with
    /// this one — Swift could choose it again and recurse forever. Constructing the
    /// storage directly makes the call unambiguous.
    ///
    /// A literal that is not a legal XML name traps with a clear message. That is
    /// the right severity: a malformed literal is a bug in the program, and
    /// trapping at the point of use is far easier to diagnose than a document that
    /// silently fails to write.
    public init(stringLiteral value: String) {
        let bytes = Array(value.utf8)
        if let reason = xmlDiagnoseInvalidName(bytes) {
            preconditionFailure("'\(value)' is not a legal XML name: \(reason)")
        }
        self.utf8 = bytes
    }
}

extension XMLQualifiedName: ExpressibleByStringLiteral {
    /// Creates a qualified name from a literal, validating it.
    public init(stringLiteral value: String) {
        do {
            try self.init(XMLName(stringLiteral: value))
        } catch {
            preconditionFailure("'\(value)' is not a legal XML qualified name: \(error)")
        }
    }
}

extension XMLQualifiedName: CustomStringConvertible {
    public var description: String { stringValue }
}

// MARK: - Names

/// A namespace URI with an optional preferred prefix.
///
/// The URI — not the prefix — identifies the namespace. `prefix` is a
/// serialization preference and is carried separately for exactly that reason;
/// see `Documentation/DESIGN.md` §2.4.
public struct XMLNamespace: Hashable, Sendable {
    /// The namespace URI. The empty string denotes "no namespace".
    public let uri: String

    /// A preferred prefix for serialization, or `nil` to let the encoder choose.
    public let prefix: String?

    /// The XML namespace, `http://www.w3.org/XML/1998/namespace`, conventionally
    /// bound to the prefix `xml`.
    ///
    /// This binding is implicit in XML and must never be emitted as a
    /// declaration, which is why it is a constant rather than user-supplied.
    public static let xml = XMLNamespace(uri: "http://www.w3.org/XML/1998/namespace", prefix: "xml")

    /// The namespace bound to the reserved `xmlns` prefix.
    ///
    /// Reserved by the specification; declaring it is an error.
    public static let xmlns = XMLNamespace(uri: "http://www.w3.org/2000/xmlns/", prefix: "xmlns")

    /// Creates a namespace.
    public init(uri: String, prefix: String? = nil) {
        self.uri = uri
        self.prefix = prefix
    }
}

extension XMLNamespace: CustomStringConvertible {
    public var description: String {
        guard let prefix else { return uri }
        return "\(prefix):\(uri)"
    }
}
