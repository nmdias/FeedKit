//
//  XMLTokenizer.swift
//  XMLKit
//
//  A hand-written, strict, iterative XML 1.0 (5th edition) tokenizer.
//

import Foundation

// MARK: - Character classification table

/// A 256-entry table classifying bytes for the text-scanning hot loop.
///
/// The point of the table is that "scan to the next interesting byte, then verify
/// the gap is legal" becomes two flat loops with a single indexed load each,
/// rather than a switch per byte. Table construction happens once, lazily, and is
/// immutable thereafter — so it is safe to share across threads without
/// synchronisation.
internal enum XMLByteClassTable {
    /// Bit flags for the text-scanning classification.
    internal enum Text: UInt8 {
        /// Ordinary ASCII character that is legal in XML content.
        case ordinary = 0
        /// `<` — ends character data.
        case lessThan = 1
        /// `&` — begins an entity or character reference.
        case ampersand = 2
        /// `]` — may begin the forbidden `]]>` sequence.
        case rightBracket = 3
        /// `>` — only interesting in content as the tail of `]]>`.
        case greaterThan = 4
        /// A byte that requires a content transform: literal CR/TAB in content
        /// (line-ending and attribute-value normalisation).
        case transformRequired = 7
        /// A byte that is not legal in XML content in any context.
        case illegal = 5
        /// A byte >= 0x80 — a UTF-8 lead or continuation byte needing decode.
        case nonASCII = 6
    }

    /// Classification of every byte value for content scanning. Built once.
    internal static let text: [Text] = {
        var table = [Text](repeating: .ordinary, count: 256)
        for value in 0...255 {
            let byte = UInt8(value)
            switch byte {
            case UInt8(ascii: "<"):
                table[value] = .lessThan
            case UInt8(ascii: "&"):
                table[value] = .ampersand
            case UInt8(ascii: "]"):
                table[value] = .rightBracket
            case UInt8(ascii: ">"):
                table[value] = .greaterThan
            case 0x20...0x7E:
                table[value] = .ordinary
            // TAB, LF and CR are legal in content but *not* verbatim: XML 1.0
            // §2.11 requires CRLF and lone CR to become LF, and §3.3.3 requires a
            // literal TAB/LF/CR in an attribute value to become a space. Marking
            // them as needing a transform is what makes the decoder's
            // "no special byte ⇒ hand out the slice untouched" fast path correct,
            // because a slice containing one of these is never verbatim.
            case 0x09, 0x0A, 0x0D:
                table[value] = .transformRequired
            case 0x80...0xFF:
                table[value] = .nonASCII
            default:
                // C0 controls other than tab/LF/CR, and DEL.
                table[value] = .illegal
            }
        }
        return table
    }()
}

// MARK: - Reserved names

/// Byte patterns for reserved markup, as lowercase ASCII.
///
/// XML reserves the case-insensitive prefix `xml`, so all comparisons against
/// these are ASCII-case-folded. Every one of these keywords is ASCII by
/// definition, so byte-wise folding is exactly correct and needs no Unicode
/// tables.
internal enum XMLReservedKeyword {
    static let xml: [UInt8] = Array("xml".utf8)
    static let version: [UInt8] = Array("version".utf8)
    static let encoding: [UInt8] = Array("encoding".utf8)
    static let standalone: [UInt8] = Array("standalone".utf8)
    static let cdata: [UInt8] = Array("cdata".utf8)
    static let doctype: [UInt8] = Array("doctype".utf8)
    static let xmlns: [UInt8] = Array("xmlns".utf8)
    static let xmlnsColon: [UInt8] = Array("xmlns:".utf8)
    static let system: [UInt8] = Array("system".utf8)
    static let lt: [UInt8] = Array("lt".utf8)
    static let gt: [UInt8] = Array("gt".utf8)
    static let amp: [UInt8] = Array("amp".utf8)
    static let quot: [UInt8] = Array("quot".utf8)
    static let apos: [UInt8] = Array("apos".utf8)
    static let publicID: [UInt8] = Array("public".utf8)
}

// MARK: - Tokenizer

/// Turns a UTF-8 byte buffer into a flat token array.
///
/// ## Design
///
/// The tokenizer is **iterative, never recursive**. Element matching uses an
/// explicit stack of token indices, so a document nested 100 000 levels deep
/// costs heap, not stack, and cannot overflow the stack. Depth is bounded
/// separately by `maxDepth` so that pathological input is rejected with a clear
/// error rather than consuming unbounded memory.
///
/// The tokenizer performs **no content transformation**. It does not normalise
/// line endings, expand entities, or decode text: it records offsets, sets
/// ``XMLToken/firstSpecial`` when a slice needs later processing, and moves on.
/// Well-formedness checks that can be done while scanning — UTF-8 validity,
/// character legality, name syntax, duplicate attributes, tag matching,
/// comment/PI syntax — *are* done while scanning, so that no malformed document
/// can reach the decoder.
///
/// Namespace resolution is deliberately **not** done here. It is performed
/// lazily by ``XMLNamespaceResolver`` against the token array, which means a
/// caller that does not care about namespaces (the common case for a
/// `Codable`-shaped document) pays nothing for them, and it keeps the tokenizer
/// free of any notion of scope.
internal enum XMLTokenizer {

    /// Tokenizes `bytes` as a complete XML document.
    ///
    /// - Parameters:
    ///   - bytes: The document, as UTF-8.
    ///   - maxDepth: Maximum element nesting depth. Defaults to
    ///     ``XMLParserConfiguration/defaultMaxDepth``.
    ///   - allowsMultipleRoots: When `true`, parses a *fragment*: content is
    ///     permitted before and after the root element, and more than one root
    ///     element is allowed. Used by ``XMLDocument`` fragment parsing and by
    ///     ``XMLDecoder`` when decoding a top-level array.
    /// - Throws: ``XMLParserError`` describing the first well-formedness
    ///   violation, with a precise source position.
    internal static func tokenize(
        bytes: [UInt8],
        configuration: XMLParserConfiguration = .default,
        allowsMultipleRoots: Bool = false
    ) throws -> XMLTokenizedDocument {
        var tokenizer = Tokenizer(
            bytes: bytes,
            configuration: configuration,
            allowsMultipleRoots: allowsMultipleRoots
        )
        return try tokenizer.run()
    }
}

// MARK: - Implementation

extension XMLTokenizer {
    /// Mutable tokenizer state. A `struct` with `mutating` methods, so the
    /// compiler keeps all scanner state in registers and there is no heap
    /// allocation beyond the three growing arrays.
    fileprivate struct Tokenizer {
        /// The document bytes. A `let` binding, so the optimizer can hoist
        /// `count` and the base-address computation out of the scan loops.
        let bytes: [UInt8]
        let maxDepth: Int
        let maxAttributesPerElement: Int
        let maxNameLength: Int
        let allowsMultipleRoots: Bool

        var position: Int = 0
        var tokens: [XMLToken] = []
        var attributes: [XMLAttribute] = []

        /// Stack of indices into `tokens` for currently-open start tags.
        var openElements: [Int32] = []

        var rootIndex: Int32 = -1

        /// Indices of all top-level elements. Only ever holds more than one entry
        /// in fragment mode.
        var rootIndices: [Int32] = []

        /// Index of the `<!DOCTYPE …>` token, when the document had one.
        var documentTypeIndex: Int32 = -1
        var declarationIndex: Int32 = -1
        var declaredEncoding: String?
        var declaredVersion: String?
        var declaredStandalone: Bool?

        /// Set once the root element has been closed, so subsequent content can
        /// be rejected.
        var hasClosedRoot: Bool = false

        /// Lazily built, then reused for every diagnostic in this parse.
        ///
        /// Each entry costs one O(n) pass to build, so building it per diagnostic
        /// would make a document with *k* errors cost O(k·n) — quadratic in
        /// practice, and precisely the pathology a parser must avoid. Caching it
        /// here makes the total cost one pass regardless of how many errors a
        /// fuzz run provokes.
        private var cachedLineTable: XMLLineTable?

        /// Resolves a byte offset into a source position.
        mutating func position(at offset: Int) -> XMLSourcePosition {
            let table: XMLLineTable
            if let cachedLineTable {
                table = cachedLineTable
            } else {
                let built = XMLLineTable(bytes: bytes)
                cachedLineTable = built
                table = built
            }
            let (line, column) = table.position(at: offset)
            return XMLSourcePosition(byteOffset: offset, line: line, column: column)
        }

        let byteCount: Int

        init(bytes: [UInt8], configuration: XMLParserConfiguration, allowsMultipleRoots: Bool) {
            let maxDepth = configuration.maxDepth
            // Strip a UTF-8 BOM if present. XML permits one, it is not content,
            // and leaving it in place would make the first token's offsets
            // include it and confuse the "text before root" check.
            if bytes.count >= 3,
               bytes[0] == 0xEF, bytes[1] == 0xBB, bytes[2] == 0xBF {
                self.bytes = Array(bytes[3...])
            } else {
                self.bytes = bytes
            }
            self.byteCount = self.bytes.count
            self.maxDepth = maxDepth
            self.maxAttributesPerElement = configuration.maxAttributesPerElement
            self.maxNameLength = configuration.maxNameLength
            self.allowsMultipleRoots = allowsMultipleRoots
        }

        // MARK: Entry point

        mutating func run() throws -> XMLTokenizedDocument {
            // Validate UTF-8 before anything else. Doing it up front means no
            // later stage has to consider malformed sequences, and the error
            // reports the exact offending byte.
            switch xmlValidateUTF8(bytes) {
            case .valid:
                break
            case let .invalid(offset):
                throw XMLParserError.invalidUTF8(position: position(at: offset))
            }

            guard byteCount > 0 else { throw XMLParserError.emptyDocument }

            try tokenizeProlog()

            guard rootIndex >= 0 || allowsMultipleRoots else {
                throw XMLParserError.unexpectedContent(
                    position: position(at: byteCount),
                    reason: "document contains no root element"
                )
            }

            try tokenizeEpilog()

            let document = makeDocument()

            // Resolve every namespace prefix once, at parse time. This is the only
            // whole-document pass, and it is what makes an undeclared prefix a
            // document error rather than something that surfaces only if a caller
            // happens to look at the offending element.
            try XMLNamespaceResolver(document: document).validate(document: document)

            return document
        }

        func makeDocument() -> XMLTokenizedDocument {
            XMLTokenizedDocument(
                bytes: bytes,
                tokens: tokens,
                attributes: attributes,
                rootIndex: rootIndex,
                rootIndices: rootIndices,
                declarationIndex: declarationIndex,
                documentTypeIndex: documentTypeIndex,
                declaredEncoding: declaredEncoding,
                declaredVersion: declaredVersion,
                declaredStandalone: declaredStandalone
            )
        }

        // MARK: Prolog

        /// Consumes the XML declaration, misc, and the root element.
        ///
        /// In fragment mode, continues until the input is exhausted so that a
        /// sequence of top-level elements is accepted; otherwise it stops after
        /// exactly one root element and ``tokenizeEpilog()`` validates the rest.
        mutating func tokenizeProlog() throws {
            try skipXMLDeclarationIfPresent()

            while position < byteCount {
                let byte = bytes[position]

                if byte == UInt8(ascii: "<") {
                    switch try peekMarkupKind() {
                    case .comment:
                        try scanComment()
                        continue
                    case .processingInstruction:
                        try scanProcessingInstruction()
                        continue
                    case .documentType:
                        try scanDocumentType()
                        continue
                    case .element:
                        let tokenCountBefore = tokens.count
                        try scanMarkup()
                        guard tokens.count > tokenCountBefore, tokens[tokenCountBefore].kind == .startTag else {
                            throw XMLParserError.unexpectedContent(
                                position: position(at: position),
                                reason: "expected an element"
                            )
                        }
                        rootIndices.append(Int32(tokenCountBefore))
                        if rootIndex < 0 { rootIndex = Int32(tokenCountBefore) }
                        if !allowsMultipleRoots { return }
                        continue
                    case .cdata:
                        throw XMLParserError.unexpectedContent(
                            position: position(at: position),
                            reason: "a CDATA section is not permitted outside the root element"
                        )
                    case .endElement:
                        throw XMLParserError.mismatchedEndTag(
                            expected: "(none)",
                            found: endTagNamePreview(),
                            position: position(at: position)
                        )
                    }
                }

                if xmlIsXMLWhitespace(byte) {
                    position += 1
                    continue
                }

                guard allowsMultipleRoots else {
                    throw XMLParserError.unexpectedContent(
                        position: position(at: position),
                        reason: "character data is not permitted before the root element"
                    )
                }
                // Fragment mode: text between top-level elements is still not
                // permitted, because it has no element to belong to.
                throw XMLParserError.unexpectedContent(
                    position: position(at: position),
                    reason: "character data is not permitted outside an element"
                )
            }
        }

        /// Consumes misc content and whitespace after the root element.
        mutating func tokenizeEpilog() throws {
            while position < byteCount {
                let byte = bytes[position]

                if byte == UInt8(ascii: "<") {
                    switch try peekMarkupKind() {
                    case .comment:
                        try scanComment()
                        continue
                    case .processingInstruction:
                        try scanProcessingInstruction()
                        continue
                    case .element where allowsMultipleRoots:
                        let tokenCountBefore = tokens.count
                        try scanMarkup()
                        guard tokens.count > tokenCountBefore, tokens[tokenCountBefore].kind == .startTag else {
                            throw XMLParserError.unexpectedContent(
                                position: position(at: position),
                                reason: "expected an element"
                            )
                        }
                        rootIndices.append(Int32(tokenCountBefore))
                        continue
                    default:
                        throw XMLParserError.unexpectedContent(
                            position: position(at: position),
                            reason: "only comments and processing instructions are permitted after the root element"
                        )
                    }
                }

                if xmlIsXMLWhitespace(byte) {
                    position += 1
                    continue
                }

                throw XMLParserError.unexpectedContent(
                    position: position(at: position),
                    reason: "character data is not permitted after the root element"
                )
            }
        }

        /// Classifies the markup that begins at `position`.
        enum MarkupKind {
            case comment
            case processingInstruction
            case documentType
            case cdata
            /// A start tag or an empty-element tag: `<name …>` or `<name … />`.
            case element
            /// An end tag: `</name>`.
            case endElement
        }

        /// Determines what kind of construct starts at the `<` at `position`,
        /// without consuming it.
        mutating func peekMarkupKind() throws -> MarkupKind {
            let start = position
            guard start + 1 < byteCount else {
                throw XMLParserError.unexpectedEndOfInput(
                    position: position(at: byteCount),
                    context: "markup"
                )
            }

            let next = bytes[start + 1]
            if next == UInt8(ascii: "!") {
                guard start + 3 < byteCount else {
                    throw XMLParserError.unexpectedEndOfInput(
                        position: position(at: byteCount),
                        context: "markup declaration"
                    )
                }
                if bytes[start + 2] == UInt8(ascii: "-"), bytes[start + 3] == UInt8(ascii: "-") {
                    return .comment
                }
                // Layout at `start` is always `<` `!` X …, so the keyword that
                // follows `<!` begins at `start + 2` for `DOCTYPE` and at
                // `start + 3` for `[CDATA[` (whose third byte is the bracket).
                if start + 9 <= byteCount,
                   xmlBytesEqualFoldedASCII(bytes, start + 3, 5, XMLReservedKeyword.cdata),
                   bytes[start + 8] == UInt8(ascii: "[") {
                    return .cdata
                }
                if xmlBytesEqualFoldedASCII(bytes, start + 2, 7, XMLReservedKeyword.doctype) {
                    return .documentType
                }
                throw XMLParserError.malformedMarkup(
                    position: position(at: start),
                    reason: "unrecognised markup declaration"
                )
            }
            if next == UInt8(ascii: "?") { return .processingInstruction }
            if next == UInt8(ascii: "/") { return .endElement }
            if next == UInt8(ascii: ">") {
                throw XMLParserError.malformedMarkup(
                    position: position(at: start),
                    reason: "expected an element name after '<'"
                )
            }
            return .element
        }

        /// A best-effort name for a stray end tag, for diagnostics.
        mutating func endTagNamePreview() -> String {
            var index = position + 2
            let nameStart = index
            while index < byteCount, !xmlIsXMLWhitespace(bytes[index]), bytes[index] != UInt8(ascii: ">") {
                index += 1
            }
            guard nameStart < index else { return "(empty)" }
            return String(decoding: bytes[nameStart..<index], as: UTF8.self)
        }

        mutating func nameString(ofTokenAt index: Int) -> String {
            let token = tokens[index]
            return String(decoding: bytes[token.nameStart..<(token.nameStart + token.nameLength)], as: UTF8.self)
        }

        // MARK: XML declaration

        /// Consumes `<?xml …?>` when it is the first construct in the document.
        mutating func skipXMLDeclarationIfPresent() throws {
            let start = position
            guard start + 5 <= byteCount else { return }
            guard bytes[start] == UInt8(ascii: "<"), bytes[start + 1] == UInt8(ascii: "?") else { return }
            guard xmlBytesEqualFoldedASCII(bytes, start + 2, 3, XMLReservedKeyword.xml) else {
                return
            }

            // `<?xml` is only an XML declaration when the target is exactly "xml",
            // i.e. when the next byte is whitespace. Otherwise this is an ordinary
            // processing instruction — `<?xml-stylesheet …?>` is extremely common
            // and must not be mistaken for a declaration. (A target that merely
            // *begins* with "xml", such as `<?xmlfoo?>`, is caught by the
            // reserved-target rule in `scanProcessingInstruction`.)
            let afterTarget = start + 5
            guard afterTarget < byteCount, xmlIsXMLWhitespace(bytes[afterTarget]) else {
                return
            }

            position = afterTarget
            let contentStart = try skipRequiredWhitespace(context: "the XML declaration", from: start)

            var sawVersion = false
            var sawEncodingOrStandalone = false

            while true {
                try skipWhitespace()
                guard position + 1 < byteCount else {
                    throw XMLParserError.unexpectedEndOfInput(
                        position: position(at: byteCount),
                        context: "the XML declaration"
                    )
                }
                if bytes[position] == UInt8(ascii: "?"), bytes[position + 1] == UInt8(ascii: ">") {
                    position += 2
                    break
                }

                let pseudoNameStart = position
                let pseudoNameLength = try scanName(context: "the XML declaration")

                try skipWhitespace()
                guard position < byteCount, bytes[position] == UInt8(ascii: "=") else {
                    throw XMLParserError.malformedMarkup(
                        position: position(at: position),
                        reason: "expected '=' after '\(previewString(from: pseudoNameStart, length: pseudoNameLength))' in the XML declaration"
                    )
                }
                position += 1
                try skipWhitespace()
                let (valueStart, valueEnd) = try scanQuotedValue(context: "the XML declaration")

                if xmlBytesEqualFoldedASCII(bytes, pseudoNameStart, pseudoNameLength, XMLReservedKeyword.version) {
                    guard !sawVersion else {
                        throw XMLParserError.malformedMarkup(
                            position: position(at: pseudoNameStart),
                            reason: "duplicate 'version' in the XML declaration"
                        )
                    }
                    sawVersion = true
                    declaredVersion = String(decoding: bytes[valueStart..<valueEnd], as: UTF8.self)
                } else if xmlBytesEqualFoldedASCII(bytes, pseudoNameStart, pseudoNameLength, XMLReservedKeyword.encoding) {
                    guard sawVersion else {
                        throw XMLParserError.malformedMarkup(
                            position: position(at: pseudoNameStart),
                            reason: "'encoding' must follow 'version' in the XML declaration"
                        )
                    }
                    sawEncodingOrStandalone = true
                    declaredEncoding = String(decoding: bytes[valueStart..<valueEnd], as: UTF8.self)
                } else if xmlBytesEqualFoldedASCII(bytes, pseudoNameStart, pseudoNameLength, XMLReservedKeyword.standalone) {
                    guard sawVersion else {
                        throw XMLParserError.malformedMarkup(
                            position: position(at: pseudoNameStart),
                            reason: "'standalone' must follow 'version' in the XML declaration"
                        )
                    }
                    sawEncodingOrStandalone = true
                    let raw = bytes[valueStart..<valueEnd]
                    if raw.elementsEqual("yes".utf8) {
                        declaredStandalone = true
                    } else if raw.elementsEqual("no".utf8) {
                        declaredStandalone = false
                    } else {
                        throw XMLParserError.malformedMarkup(
                            position: position(at: valueStart),
                            reason: "'standalone' must be 'yes' or 'no'"
                        )
                    }
                } else {
                    throw XMLParserError.malformedMarkup(
                        position: position(at: pseudoNameStart),
                        reason: "unexpected '\(previewString(from: pseudoNameStart, length: pseudoNameLength))' in the XML declaration"
                    )
                }
            }

            guard sawVersion else {
                throw XMLParserError.malformedMarkup(
                    position: position(at: start),
                    reason: "the XML declaration must specify 'version'"
                )
            }
            _ = sawEncodingOrStandalone

            tokens.append(
                XMLToken(
                    kind: .xmlDeclaration,
                    start: start,
                    end: position,
                    contentStart: contentStart,
                    contentEnd: position - 2,
                    nameStart: contentStart,
                    nameLength: 0,
                    match: -1,
                    attributeStart: -1,
                    attributeCount: 0,
                    selfClosingSlash: -1,
                    firstSpecial: -1
                )
            )
            declarationIndex = Int32(tokens.count - 1)
        }

        // MARK: Comments

        /// Consumes `<!-- … -->`, rejecting `--` inside and a trailing `--->`.
        mutating func scanComment() throws {
            let start = position
            position += 4 // "<!--"

            let contentStart = position
            var index = position

            while true {
                guard index + 2 < byteCount else {
                    throw XMLParserError.unexpectedEndOfInput(
                        position: position(at: byteCount),
                        context: "a comment"
                    )
                }
                let byte = bytes[index]
                if byte == UInt8(ascii: "-"), bytes[index + 1] == UInt8(ascii: "-") {
                    if bytes[index + 2] == UInt8(ascii: ">") {
                        break
                    }
                    throw XMLParserError.invalidComment(
                        position: position(at: index),
                        reason: "'--' is not permitted inside a comment"
                    )
                }
                index += 1
            }

            let contentEnd = index
            try validateCharacterRun(from: contentStart, to: contentEnd, context: "a comment")

            position = contentEnd + 3
            tokens.append(
                XMLToken(
                    kind: .comment,
                    start: start,
                    end: contentEnd + 3,
                    contentStart: contentStart,
                    contentEnd: contentEnd,
                    nameStart: contentStart,
                    nameLength: 0,
                    match: -1,
                    attributeStart: -1,
                    attributeCount: 0,
                    selfClosingSlash: -1,
                    firstSpecial: -1
                )
            )
            _ = start
        }

        // MARK: Processing instructions

        /// Consumes `<?target data?>`.
        ///
        /// The target `xml` (in any case) is reserved and rejected, per XML 1.0
        /// §2.6, but `xml-stylesheet` is a legal and common target.
        mutating func scanProcessingInstruction() throws {
            let start = position
            position += 2 // "<?"

            guard position < byteCount else {
                throw XMLParserError.unexpectedEndOfInput(
                    position: position(at: byteCount),
                    context: "a processing instruction"
                )
            }

            let targetStart = position
            let targetLength = try scanName(context: "a processing instruction target")

            // Reserved target check: exactly "xml", case-insensitively.
            if targetLength == 3,
               xmlBytesEqualFoldedASCII(bytes, targetStart, 3, XMLReservedKeyword.xml) {
                throw XMLParserError.invalidProcessingInstruction(
                    position: position(at: start),
                    reason: "'xml' is a reserved processing instruction target"
                )
            }

            // The target must be followed by whitespace or the terminator.
            var index = targetStart + targetLength
            if index < byteCount, !xmlIsXMLWhitespace(bytes[index]),
               !(bytes[index] == UInt8(ascii: "?") && index + 1 < byteCount && bytes[index + 1] == UInt8(ascii: ">")) {
                throw XMLParserError.invalidProcessingInstruction(
                    position: position(at: index),
                    reason: "the target must be followed by whitespace or '?>'"
                )
            }

            var contentStart = index
            if contentStart < byteCount, xmlIsXMLWhitespace(bytes[contentStart]) {
                // Skip the required whitespace so `data` excludes it.
                while contentStart < byteCount, xmlIsXMLWhitespace(bytes[contentStart]) {
                    contentStart += 1
                }
            }

            while true {
                guard index + 1 < byteCount else {
                    throw XMLParserError.unexpectedEndOfInput(
                        position: position(at: byteCount),
                        context: "a processing instruction"
                    )
                }
                if bytes[index] == UInt8(ascii: "?"), bytes[index + 1] == UInt8(ascii: ">") {
                    break
                }
                index += 1
            }

            var contentEnd = index
            // Trailing whitespace before "?>" is not part of the data.
            while contentEnd > contentStart, xmlIsXMLWhitespace(bytes[contentEnd - 1]) {
                contentEnd -= 1
            }

            try validateCharacterRun(from: contentStart, to: contentEnd, context: "a processing instruction")

            position = index + 2
            tokens.append(
                XMLToken(
                    kind: .processingInstruction,
                    start: start,
                    end: index + 2,
                    contentStart: contentStart,
                    contentEnd: contentEnd,
                    nameStart: targetStart,
                    nameLength: targetLength,
                    match: -1,
                    attributeStart: -1,
                    attributeCount: 0,
                    selfClosingSlash: -1,
                    firstSpecial: -1
                )
            )
        }

        // MARK: DOCTYPE

        /// Consumes `<!DOCTYPE …>` structurally without processing it.
        ///
        /// XMLKit does not support DTD internal subsets or entity declarations.
        /// The declaration is recognised so that documents containing one parse,
        /// but its contents are skipped with bracket balancing and its entity
        /// declarations are never applied. This is the decision that makes
        /// entity-expansion ("billion laughs") amplification structurally
        /// impossible rather than merely disabled — see `SECURITY.md`.
        mutating func scanDocumentType() throws {
            let start = position
            position += 2 // "<!"

            var index = position
            var depth = 0
            var sawInternalSubset = false

            while index < byteCount {
                let byte = bytes[index]
                switch byte {
                case UInt8(ascii: "["):
                    sawInternalSubset = true
                    depth += 1
                    if depth > 1 {
                        throw XMLParserError.invalidDocumentType(
                            position: position(at: index),
                            reason: "nested internal subsets are not permitted"
                        )
                    }
                case UInt8(ascii: "]"):
                    guard depth > 0 else {
                        throw XMLParserError.invalidDocumentType(
                            position: position(at: index),
                            reason: "unmatched ']' in the document type declaration"
                        )
                    }
                    depth -= 1
                case UInt8(ascii: ">"):
                    if depth == 0 {
                        let end = index + 1
                        documentTypeIndex = Int32(tokens.count)
                        tokens.append(
                            XMLToken(
                                kind: .documentType,
                                start: start,
                                end: end,
                                contentStart: start + 2,
                                contentEnd: end - 1,
                                nameStart: start,
                                nameLength: 0,
                                match: -1,
                                attributeStart: -1,
                                attributeCount: 0,
                                selfClosingSlash: -1,
                                firstSpecial: -1
                            )
                        )
                        position = end
                        _ = sawInternalSubset
                        return
                    }
                case UInt8(ascii: "\""), UInt8(ascii: "'"):
                    // Skip a quoted literal so a '>' inside it does not end the
                    // declaration.
                    let quote = byte
                    index += 1
                    while index < byteCount, bytes[index] != quote {
                        index += 1
                    }
                    guard index < byteCount else {
                        throw XMLParserError.unexpectedEndOfInput(
                            position: position(at: byteCount),
                            context: "a document type declaration"
                        )
                    }
                case 0x00...0x08, 0x0B, 0x0C, 0x0E...0x1F:
                    throw XMLParserError.invalidCharacter(
                        scalar: UInt32(byte),
                        position: position(at: index)
                    )
                default:
                    break
                }
                index += 1
            }

            throw XMLParserError.unexpectedEndOfInput(
                position: position(at: byteCount),
                context: "a document type declaration"
            )
        }

        // MARK: Elements

        /// Consumes one top-level element, including all of its nested content.
        ///
        /// The first tag is consumed unconditionally, and only then does the loop
        /// depend on the element stack. That distinction matters: a self-closing
        /// root (`<a/>`) never pushes onto the stack, so a loop guarded purely on
        /// "the stack is non-empty" would consume nothing at all.
        ///
        /// Shared by the prolog's root element and by fragment parsing, which may
        /// contain several top-level elements in sequence.
        mutating func scanMarkup() throws {
            var lastTextTokenIndex: Int = -1
            var hasStarted = false

            while !hasStarted || !openElements.isEmpty {
                hasStarted = true

                guard position < byteCount else {
                    guard let openIndex = openElements.last else {
                        throw XMLParserError.unexpectedEndOfInput(
                            position: position(at: byteCount),
                            context: "an element"
                        )
                    }
                    let openName = nameString(ofTokenAt: Int(openIndex))
                    throw XMLParserError.unexpectedEndOfInput(
                        position: position(at: byteCount),
                        context: "element <\(openName)>"
                    )
                }

                guard bytes[position] == UInt8(ascii: "<") else {
                    try scanText(mergingWith: &lastTextTokenIndex)
                    continue
                }

                switch try peekMarkupKind() {
                case .comment:
                    try scanComment()
                    lastTextTokenIndex = -1
                case .processingInstruction:
                    try scanProcessingInstruction()
                    lastTextTokenIndex = -1
                case .cdata:
                    try scanCDATASection()
                    lastTextTokenIndex = tokens.count - 1
                case .documentType:
                    throw XMLParserError.unexpectedContent(
                        position: position(at: position),
                        reason: "a document type declaration is only permitted before the root element"
                    )
                case .element, .endElement:
                    try scanStartOrEndTag()
                    lastTextTokenIndex = -1
                }
            }
        }

        /// Consumes a `startTag`, an `emptyElemTag`, or an `endTag`.
        mutating func scanStartOrEndTag() throws {
            let tagStart = position
            position += 1 // "<"

            guard position < byteCount else {
                throw XMLParserError.unexpectedEndOfInput(
                    position: position(at: byteCount),
                    context: "an element start tag"
                )
            }

            if bytes[position] == UInt8(ascii: "/") {
                // The end tag's own start is `tagStart`; the open element's
                // payload ends exactly there.
                position += 1
                try scanEndTag(tagStart: tagStart, contentEndOfOpenElement: tagStart)
                return
            }

            try scanStartTag(tagStart: tagStart)
        }

        /// Consumes `<name attribute="value" …>` or `<name … />`.
        mutating func scanStartTag(tagStart: Int) throws {
            let nameStart = position
            let nameLength = try scanName(context: "an element start tag")

            // The name must not begin with the reserved prefix "xml"
            // (case-insensitive), except for the name "xml" itself which is
            // reserved for the specification.
            if nameLength >= 3, xmlBytesEqualFoldedASCII(bytes, nameStart, 3, XMLReservedKeyword.xml) {
                throw XMLParserError.reservedNamePrefix(
                    String(decoding: bytes[nameStart..<(nameStart + nameLength)], as: UTF8.self)
                )
            }

            let attributeStartIndex = attributes.count
            var attributeCount = 0
            // Attribute names seen on this element, as (offset, length) pairs.
            // Offsets rather than `ArraySlice`: comparing two slices of the same
            // array instantiates a generic `Sequence` comparison, and with
            // thousands of attributes the per-call overhead of that dominates
            // entirely. Two integers plus a `memcmp` is what the hardware is good
            // at, and it is the difference between milliseconds and seconds for a
            // wide element.
            var seenNames: [(offset: Int, length: Int)] = []
            var isSelfClosing = false
            var selfClosingSlash = -1

            while true {
                let hadWhitespace = try skipWhitespaceReturningWhetherAny()
                guard position < byteCount else {
                    throw XMLParserError.unexpectedEndOfInput(
                        position: position(at: byteCount),
                        context: "an element start tag"
                    )
                }

                let byte = bytes[position]

                if byte == UInt8(ascii: ">") {
                    position += 1
                    break
                }

                if byte == UInt8(ascii: "/") {
                    guard position + 1 < byteCount, bytes[position + 1] == UInt8(ascii: ">") else {
                        throw XMLParserError.malformedMarkup(
                            position: position(at: position),
                            reason: "'/' must be followed by '>' in an empty-element tag"
                        )
                    }
                    selfClosingSlash = position
                    isSelfClosing = true
                    position += 2
                    break
                }

                guard hadWhitespace else {
                    throw XMLParserError.malformedMarkup(
                        position: position(at: position),
                        reason: "expected whitespace before an attribute"
                    )
                }

                guard attributeCount < maxAttributesPerElement else {
                    throw XMLParserError.malformedMarkup(
                        position: position(at: position),
                        reason: "element has more than \(maxAttributesPerElement) attributes"
                    )
                }
                try scanAttribute(into: &seenNames)
                attributeCount += 1
            }

            let tokenIndex = tokens.count
            tokens.append(
                XMLToken(
                    kind: .startTag,
                    start: tagStart,
                    end: position,
                    contentStart: position,
                    contentEnd: -1,
                    nameStart: nameStart,
                    nameLength: nameLength,
                    match: -1,
                    attributeStart: attributeCount == 0 ? -1 : Int32(attributeStartIndex),
                    attributeCount: Int32(attributeCount),
                    selfClosingSlash: selfClosingSlash,
                    firstSpecial: -1
                )
            )

            guard !isSelfClosing else { return }

            // The first element to open at top level is the document element.
            // Recording it here — rather than in the caller — keeps the rule in
            // one place and works identically for a document, a fragment, and a
            // nested subtree.
            if openElements.isEmpty, rootIndex < 0 {
                rootIndex = Int32(tokenIndex)
            }

            openElements.append(Int32(tokenIndex))
            if openElements.count > maxDepth {
                throw XMLParserError.maximumDepthExceeded(
                    limit: maxDepth,
                    position: position(at: tagStart)
                )
            }
        }

        /// Consumes one `name="value"` pair, rejecting duplicates.
        mutating func scanAttribute(into seenNames: inout [(offset: Int, length: Int)]) throws {
            let attributeNameStart = position
            let attributeNameLength = try scanName(context: "an attribute name")

            // Duplicate detection is O(k²) in the attribute count by necessity —
            // any two names may match — so the per-comparison cost has to be as
            // low as possible. A length check rejects most candidates in one
            // integer comparison, and a byte compare handles the rest.
            //
            // `memcmp` rather than `elementsEqual`: the latter is a generic
            // `Sequence` algorithm, and its per-call overhead is large enough to
            // make a 5 000-attribute element take seconds instead of
            // milliseconds. `XMLParserConfiguration.maxAttributesPerElement`
            // bounds k so that even the worst case stays bounded.
            // The comparison runs against the document's own storage through a
            // single hoisted pointer. Going through `withUnsafeBufferPointer` per
            // comparison would add two closure calls to each of the O(k²) checks,
            // which for a 5 000-attribute element is tens of millions of calls.
            var isDuplicate = false
            if !seenNames.isEmpty {
                isDuplicate = bytes.withUnsafeBufferPointer { buffer -> Bool in
                    guard let base = buffer.baseAddress else { return false }
                    let candidate = unsafe base + attributeNameStart
                    for seen in seenNames where seen.length == attributeNameLength {
                        if unsafe memcmp(unsafe base + seen.offset, candidate, attributeNameLength) == 0 {
                            return true
                        }
                    }
                    return false
                }
            }
            if isDuplicate {
                throw XMLParserError.duplicateAttribute(
                    name: String(
                        decoding: bytes[attributeNameStart..<(attributeNameStart + attributeNameLength)],
                        as: UTF8.self
                    ),
                    position: position(at: attributeNameStart)
                )
            }
            seenNames.append((offset: attributeNameStart, length: attributeNameLength))

            // The string "xml" is reserved as a *prefix*. Three forms are legal
            // despite beginning with it:
            //
            //   * `xmlns` and `xmlns:…`  — namespace declarations;
            //   * `xml:…`               — the `xml` prefix is predeclared by
            //                             Namespaces in XML and bound to the XML
            //                             namespace, which is why `xml:lang`,
            //                             `xml:space`, `xml:base` and `xml:id`
            //                             are legal with no declaration.
            //
            // Anything else beginning with "xml" is reserved for the
            // specification. Rejecting `xml:lang` here would make the parser
            // unusable on ordinary real-world documents.
            if attributeNameLength >= 3,
               xmlBytesEqualFoldedASCII(bytes, attributeNameStart, 3, XMLReservedKeyword.xml) {
                let isNamespaceDeclaration = attributeNameLength == 5
                    && xmlBytesEqualFoldedASCII(bytes, attributeNameStart, 5, XMLReservedKeyword.xmlns)
                let isPrefixedNamespaceDeclaration = attributeNameLength > 6
                    && xmlBytesEqualFoldedASCII(bytes, attributeNameStart, 6, XMLReservedKeyword.xmlnsColon)
                let isXMLPrefixUse = attributeNameLength > 4
                    && bytes[attributeNameStart + 3] == UInt8(ascii: ":")
                if !isNamespaceDeclaration && !isPrefixedNamespaceDeclaration && !isXMLPrefixUse {
                    throw XMLParserError.reservedNamePrefix(
                        String(
                            decoding: bytes[attributeNameStart..<(attributeNameStart + attributeNameLength)],
                            as: UTF8.self
                        )
                    )
                }
            }

            try skipWhitespace()
            guard position < byteCount, bytes[position] == UInt8(ascii: "=") else {
                throw XMLParserError.malformedMarkup(
                    position: position(at: position),
                    reason: "expected '=' after attribute '\(previewString(from: attributeNameStart, length: attributeNameLength))'"
                )
            }
            position += 1
            try skipWhitespace()

            let (valueStart, valueEnd, quote, firstSpecial) = try scanAttributeValue(
                name: previewString(from: attributeNameStart, length: attributeNameLength)
            )

            // Namespace declarations are validated here, while the name is still
            // in hand, rather than in a later pass.
            if attributeNameLength == 5,
               xmlBytesEqualFoldedASCII(bytes, attributeNameStart, 5, XMLReservedKeyword.xmlns) {
                try validateNamespaceDeclaration(
                    prefixLength: 0,
                    prefixStart: attributeNameStart,
                    valueStart: valueStart,
                    valueEnd: valueEnd
                )
            } else if attributeNameLength > 6,
                      xmlBytesEqualFoldedASCII(bytes, attributeNameStart, 6, XMLReservedKeyword.xmlnsColon) {
                try validateNamespaceDeclaration(
                    prefixLength: attributeNameLength - 6,
                    prefixStart: attributeNameStart + 6,
                    valueStart: valueStart,
                    valueEnd: valueEnd
                )
            }

            attributes.append(
                XMLAttribute(
                    nameStart: attributeNameStart,
                    nameLength: attributeNameLength,
                    valueStart: valueStart,
                    valueEnd: valueEnd,
                    firstSpecial: firstSpecial,
                    quote: quote
                )
            )
        }

        /// Validates an `xmlns` or `xmlns:prefix` declaration against the
        /// reserved-binding rules of Namespaces in XML.
        ///
        /// Enforced here:
        ///
        /// * `xmlns:prefix=""` is forbidden, because a prefix cannot be
        ///   un-declared — only the default namespace can, with `xmlns=""`.
        /// * The `xml` prefix is permanently bound to the XML namespace, and
        ///   `xmlns` to the xmlns namespace. Neither may be rebound, and no other
        ///   prefix may be bound *to* those URIs.
        ///
        /// Declaring the same prefix twice on one element needs no check here: the
        /// attribute names are identical, so the duplicate-attribute rule already
        /// rejects it.
        mutating func validateNamespaceDeclaration(
            prefixLength: Int,
            prefixStart: Int,
            valueStart: Int,
            valueEnd: Int
        ) throws {
            let valueBytes = bytes[valueStart..<valueEnd]

            if prefixLength == 0 {
                if valueBytes.elementsEqual(XMLNamespaceResolver.xmlNamespaceURIBytes) {
                    throw XMLParserError.invalidNamespaceDeclaration(
                        prefix: "",
                        uri: XMLNamespaceResolver.xmlNamespaceURI,
                        reason: "the default namespace may not be bound to the reserved XML namespace",
                        position: position(at: prefixStart)
                    )
                }
                if valueBytes.elementsEqual(XMLNamespaceResolver.xmlnsNamespaceURIBytes) {
                    throw XMLParserError.invalidNamespaceDeclaration(
                        prefix: "",
                        uri: XMLNamespaceResolver.xmlnsNamespaceURI,
                        reason: "the default namespace may not be bound to the reserved xmlns namespace",
                        position: position(at: prefixStart)
                    )
                }
                return
            }

            let prefix = String(decoding: bytes[prefixStart..<(prefixStart + prefixLength)], as: UTF8.self)

            guard !valueBytes.isEmpty else {
                throw XMLParserError.invalidNamespaceDeclaration(
                    prefix: prefix,
                    uri: "",
                    reason: "a prefix may not be bound to an empty namespace URI",
                    position: position(at: prefixStart)
                )
            }

            let isXMLPrefix = prefixLength == 3
                && xmlBytesEqualFoldedASCII(bytes, prefixStart, 3, XMLReservedKeyword.xml)
            let isXMLNSPrefix = prefixLength == 5
                && xmlBytesEqualFoldedASCII(bytes, prefixStart, 5, XMLReservedKeyword.xmlns)

            if isXMLNSPrefix {
                throw XMLParserError.invalidNamespaceDeclaration(
                    prefix: prefix,
                    uri: String(decoding: valueBytes, as: UTF8.self),
                    reason: "the xmlns prefix may not be declared",
                    position: position(at: prefixStart)
                )
            }

            if isXMLPrefix {
                guard valueBytes.elementsEqual(XMLNamespaceResolver.xmlNamespaceURIBytes) else {
                    throw XMLParserError.invalidNamespaceDeclaration(
                        prefix: prefix,
                        uri: String(decoding: valueBytes, as: UTF8.self),
                        reason: "the xml prefix may only be bound to \(XMLNamespaceResolver.xmlNamespaceURI)",
                        position: position(at: prefixStart)
                    )
                }
                return
            }

            guard !valueBytes.elementsEqual(XMLNamespaceResolver.xmlNamespaceURIBytes),
                  !valueBytes.elementsEqual(XMLNamespaceResolver.xmlnsNamespaceURIBytes) else {
                throw XMLParserError.invalidNamespaceDeclaration(
                    prefix: prefix,
                    uri: String(decoding: valueBytes, as: UTF8.self),
                    reason: "the reserved namespace URIs may only be bound to xml and xmlns",
                    position: position(at: prefixStart)
                )
            }
        }

        /// Consumes `</name>` and links it to its start tag.
        mutating func scanEndTag(tagStart: Int, contentEndOfOpenElement: Int) throws {
            let nameStart = position
            let nameLength = try scanName(context: "an element end tag")

            try skipWhitespace()
            guard position < byteCount, bytes[position] == UInt8(ascii: ">") else {
                throw XMLParserError.malformedMarkup(
                    position: position(at: position),
                    reason: "expected '>' to close an element end tag"
                )
            }
            position += 1

            let foundName = bytes[nameStart..<(nameStart + nameLength)]

            guard let openIndex = openElements.popLast() else {
                throw XMLParserError.mismatchedEndTag(
                    expected: "(none)",
                    found: String(decoding: foundName, as: UTF8.self),
                    position: position(at: tagStart)
                )
            }

            let openToken = tokens[Int(openIndex)]
            let expectedStart = openToken.nameStart
            let expectedLength = openToken.nameLength

            // Compare with an explicit loop rather than via `ArraySlice`:
            // `elementsEqual` on two slices derived from the same array compiles
            // to a generic sequence comparison whose instantiation is
            // substantially larger and slower than the direct byte loop, and this
            // runs once per element in the document.
            var namesMatch = expectedLength == nameLength
            if namesMatch {
                var offset = 0
                while offset < nameLength {
                    if bytes[expectedStart + offset] != bytes[nameStart + offset] {
                        namesMatch = false
                        break
                    }
                    offset += 1
                }
            }

            guard namesMatch else {
                let expectedName = bytes[expectedStart..<(expectedStart + expectedLength)]
                throw XMLParserError.mismatchedEndTag(
                    expected: String(decoding: expectedName, as: UTF8.self),
                    found: String(decoding: foundName, as: UTF8.self),
                    position: position(at: tagStart)
                )
            }

            let endTokenIndex = tokens.count
            tokens.append(
                XMLToken(
                    kind: .endTag,
                    start: tagStart,
                    end: position,
                    contentStart: position,
                    contentEnd: position,
                    nameStart: nameStart,
                    nameLength: nameLength,
                    match: openIndex,
                    attributeStart: -1,
                    attributeCount: 0,
                    selfClosingSlash: -1,
                    firstSpecial: -1
                )
            )
            tokens[Int(openIndex)].match = Int32(endTokenIndex)
            // A start tag's payload extent is only known once its end tag has been
            // seen, so it is recorded here rather than at construction. The payload
            // ends where the end tag begins.
            tokens[Int(openIndex)].contentEnd = contentEndOfOpenElement
        }


        // MARK: Text

        /// Consumes character data up to the next `<`, merging into a preceding
        /// text token when the two are *directly* adjacent.
        ///
        /// ## Why merging is restricted to direct adjacency
        ///
        /// XML defines an element's character data as the concatenation of its
        /// text nodes, so `a&amp;<!-- c -->b` has the same logical content as
        /// `a&amp;b`. It is tempting to merge those two text tokens.
        ///
        /// That would be wrong: a text token's payload is the byte range
        /// `start..<end`, and the two fragments are separated by the comment's
        /// bytes. Merging them would make the slice include `<!-- c -->` as
        /// literal text. Merging is therefore only performed when the previous
        /// token ends exactly where this one begins, which keeps every token's
        /// byte range exactly equal to its content. A caller that wants the
        /// concatenated value joins adjacent text tokens, which is cheap and
        /// explicit; ``XMLDocument`` does exactly that when building a DOM.
        mutating func scanText(mergingWith lastTextTokenIndex: inout Int) throws {
            let start = position
            let table = XMLByteClassTable.text
            var index = position
            var firstSpecial = -1

            scan: while index < byteCount {
                let classification = table[Int(bytes[index])]
                switch classification {
                case .ordinary:
                    index += 1
                case .lessThan:
                    break scan
                case .ampersand, .rightBracket, .greaterThan, .transformRequired:
                    if firstSpecial < 0 { firstSpecial = index }
                    index += 1
                case .illegal:
                    throw XMLParserError.invalidCharacter(
                        scalar: UInt32(bytes[index]),
                        position: position(at: index)
                    )
                case .nonASCII:
                    let scalarStart = index
                    guard let scalar = xmlDecodeScalar(bytes, &index) else {
                        throw XMLParserError.invalidUTF8(position: position(at: scalarStart))
                    }
                    guard xmlIsLegalCharacter(scalar) else {
                        throw XMLParserError.invalidCharacter(
                            scalar: scalar,
                            position: position(at: scalarStart)
                        )
                    }
                }
            }

            let end = index

            // Validate the two content-level rules that the fast scan cannot
            // express: `]]>` is forbidden in character data, and every `&` must
            // begin a legal reference.
            //
            // Entity references are resolved lazily (the decoder expands them only
            // when it actually wants the text), but they are *validated* here, so
            // that an unknown entity is a document error rather than something
            // that depends on which part of the document a caller happens to read.
            if firstSpecial >= 0 {
                var probe = firstSpecial
                while probe < end {
                    let byte = bytes[probe]
                    if byte == UInt8(ascii: "]") {
                        if probe + 2 < end,
                           bytes[probe + 1] == UInt8(ascii: "]"),
                           bytes[probe + 2] == UInt8(ascii: ">") {
                            throw XMLParserError.cdataTerminatorInContent(
                                position: position(at: probe)
                            )
                        }
                        probe += 1
                    } else if byte == UInt8(ascii: "&") {
                        probe = try validateReference(at: probe, limit: end)
                    } else {
                        probe += 1
                    }
                }
            }

            guard end > start else { return }
            position = end

            if lastTextTokenIndex >= 0,
               tokens[lastTextTokenIndex].kind == .text,
               tokens[lastTextTokenIndex].end == start {
                // Directly adjacent: safe to extend the previous token.
                tokens[lastTextTokenIndex].end = end
                if tokens[lastTextTokenIndex].firstSpecial < 0 {
                    tokens[lastTextTokenIndex].firstSpecial = firstSpecial
                }
                return
            }

            tokens.append(
                XMLToken(
                    kind: .text,
                    start: start,
                    end: end,
                    contentStart: start,
                    contentEnd: end,
                    nameStart: start,
                    nameLength: 0,
                    match: -1,
                    attributeStart: -1,
                    attributeCount: 0,
                    selfClosingSlash: -1,
                    firstSpecial: firstSpecial
                )
            )
            lastTextTokenIndex = tokens.count - 1
        }

        // MARK: CDATA

        /// Consumes `<![CDATA[ … ]]>`.
        mutating func scanCDATASection() throws {
            let start = position
            position += 9 // "<![CDATA["
            let contentStart = position

            var index = position
            while true {
                guard index + 2 < byteCount else {
                    throw XMLParserError.unexpectedEndOfInput(
                        position: position(at: byteCount),
                        context: "a CDATA section"
                    )
                }
                if bytes[index] == UInt8(ascii: "]"),
                   bytes[index + 1] == UInt8(ascii: "]"),
                   bytes[index + 2] == UInt8(ascii: ">") {
                    break
                }
                index += 1
            }

            let contentEnd = index
            try validateCharacterRun(from: contentStart, to: contentEnd, context: "a CDATA section")

            position = contentEnd + 3
            tokens.append(
                XMLToken(
                    kind: .cdata,
                    start: start,
                    end: position,
                    contentStart: contentStart,
                    contentEnd: contentEnd,
                    nameStart: contentStart,
                    nameLength: 0,
                    match: -1,
                    attributeStart: -1,
                    attributeCount: 0,
                    selfClosingSlash: -1,
                    firstSpecial: -1
                )
            )
            _ = start
        }

        // MARK: Scanning primitives

        /// Scans an XML `Name`, returning its byte length.
        ///
        /// The ASCII fast path is a flat table-free loop; only a byte >= 0x80
        /// falls back to scalar decoding and the full Unicode `NameStartChar` /
        /// `NameChar` ranges. This keeps the overwhelmingly common ASCII case
        /// allocation-free and branch-light while remaining fully Unicode-correct.
        @discardableResult
        mutating func scanName(context: String) throws -> Int {
            let start = position
            guard start < byteCount else {
                throw XMLParserError.unexpectedEndOfInput(
                    position: position(at: byteCount),
                    context: context
                )
            }

            var index = start
            var byte = bytes[index]

            // First character: NameStartChar.
            if byte < 0x80 {
                guard xmlIsASCIIAlpha(byte) || byte == UInt8(ascii: "_") || byte == UInt8(ascii: ":") else {
                    throw XMLParserError.invalidName(
                        previewString(from: start, length: Swift.min(8, byteCount - start)),
                        reason: nameDiagnosis(forFirstByte: byte)
                    )
                }
                index += 1
            } else {
                guard let scalar = xmlDecodeScalar(bytes, &index) else {
                    throw XMLParserError.invalidUTF8(position: position(at: start))
                }
                guard xmlIsNameStartScalar(scalar) else {
                    throw XMLParserError.invalidName(
                        String(decoding: bytes[start..<index], as: UTF8.self),
                        reason: "character is not permitted at the start of a name"
                    )
                }
            }

            // Remaining characters: NameChar.
            while index < byteCount {
                byte = bytes[index]
                if byte < 0x80 {
                    if xmlIsASCIIAlphanumeric(byte)
                        || byte == UInt8(ascii: "_")
                        || byte == UInt8(ascii: ":")
                        || byte == UInt8(ascii: "-")
                        || byte == UInt8(ascii: ".") {
                        index += 1
                        continue
                    }
                    break
                }
                let scalarStart = index
                guard let scalar = xmlDecodeScalar(bytes, &index) else {
                    throw XMLParserError.invalidUTF8(position: position(at: scalarStart))
                }
                guard xmlIsNameScalar(scalar) else {
                    throw XMLParserError.invalidName(
                        String(decoding: bytes[start..<scalarStart], as: UTF8.self),
                        reason: "character is not permitted in a name"
                    )
                }
            }

            let length = index - start
            guard length > 0 else {
                throw XMLParserError.invalidName("", reason: "name is empty")
            }
            guard length <= maxNameLength else {
                throw XMLParserError.invalidName(
                    previewString(from: start, length: 32),
                    reason: "name is longer than the permitted \(maxNameLength) bytes"
                )
            }
            position = index
            return length
        }

        /// Explains why a byte cannot start a name, for diagnostics.
        mutating func nameDiagnosis(forFirstByte byte: UInt8) -> String {
            if xmlIsASCIIDigit(byte) { return "name must not start with a digit" }
            if byte == UInt8(ascii: "-") { return "name must not start with '-'" }
            if byte == UInt8(ascii: ".") { return "name must not start with '.'" }
            if byte == UInt8(ascii: ">") || byte == UInt8(ascii: "/") || byte == UInt8(ascii: "?") {
                return "expected an element or attribute name"
            }
            if byte == UInt8(ascii: "!") { return "expected an element or attribute name" }
            if byte <= 0x20 { return "expected an element or attribute name" }
            return "character '\(Character(UnicodeScalar(byte)))' is not permitted at the start of a name"
        }

        /// Scans a quoted attribute value, returning its bounds, quote, and the
        /// offset of the first byte needing unescaping.
        mutating func scanAttributeValue(name: String) throws -> (start: Int, end: Int, quote: UInt8, firstSpecial: Int) {
            guard position < byteCount else {
                throw XMLParserError.unexpectedEndOfInput(
                    position: position(at: byteCount),
                    context: "the value of attribute '\(name)'"
                )
            }

            let quote = bytes[position]
            guard quote == UInt8(ascii: "\"") || quote == UInt8(ascii: "'") else {
                throw XMLParserError.invalidAttributeValue(
                    name: name,
                    position: position(at: position),
                    reason: "value must be quoted with '\"' or '\''"
                )
            }
            position += 1
            let valueStart = position

            var index = position
            var firstSpecial = -1

            while true {
                guard index < byteCount else {
                    throw XMLParserError.unexpectedEndOfInput(
                        position: position(at: byteCount),
                        context: "the value of attribute '\(name)'"
                    )
                }
                let byte = bytes[index]
                if byte == quote { break }

                if byte < 0x80 {
                    switch byte {
                    case UInt8(ascii: "<"):
                        throw XMLParserError.invalidAttributeValue(
                            name: name,
                            position: position(at: index),
                            reason: "'<' is not permitted in an attribute value"
                        )
                    case 0x20:
                        index += 1
                    case 0x09, 0x0A:
                        // Literal TAB/LF is normalised to a space (XML 1.0 §3.3.3).
                        if firstSpecial < 0 { firstSpecial = index }
                        index += 1
                    case 0x0D:
                        // CR and CRLF both normalise and both collapse to a single
                        // space, so the CRLF pair is consumed as one unit here.
                        // Without this the LF would be processed separately and
                        // produce two spaces.
                        if firstSpecial < 0 { firstSpecial = index }
                        index += 1
                        if index < byteCount, bytes[index] == 0x0A { index += 1 }
                    case UInt8(ascii: "&"):
                        // A reference always needs expansion, regardless of what
                        // was seen earlier in the value. Using `??=` here rather
                        // than `if firstSpecial < 0` is deliberate: an earlier
                        // literal whitespace must not mask a later reference.
                        if firstSpecial < 0 { firstSpecial = index }
                        index += 1
                    case UInt8(ascii: ">"):
                        index += 1
                    case 0x21...0x7E:
                        index += 1
                    default:
                        throw XMLParserError.invalidCharacter(
                            scalar: UInt32(byte),
                            position: position(at: index)
                        )
                    }
                } else {
                    let scalarStart = index
                    guard let scalar = xmlDecodeScalar(bytes, &index) else {
                        throw XMLParserError.invalidUTF8(position: position(at: scalarStart))
                    }
                    guard xmlIsLegalCharacter(scalar) else {
                        throw XMLParserError.invalidCharacter(
                            scalar: scalar,
                            position: position(at: scalarStart)
                        )
                    }
                }
            }

            let valueEnd = index

            // Validate every reference in the value. Attribute values are scanned
            // with the same branch-light loop as content, so references are checked
            // afterwards.
            if firstSpecial >= 0 {
                var probe = firstSpecial
                while probe < valueEnd {
                    if bytes[probe] == UInt8(ascii: "&") {
                        probe = try validateReference(at: probe, limit: valueEnd)
                    } else {
                        probe += 1
                    }
                }
            }

            position = index + 1 // consume the closing quote
            return (valueStart, valueEnd, quote, firstSpecial)
        }

        /// Validates the reference beginning at `ampersand` without expanding it.
        ///
        /// - Returns: The offset just past the reference.
        ///
        /// This is the check that makes XMLKit's security posture real: only the
        /// five predefined entities and numeric character references are
        /// accepted, so a document cannot reference a DTD-declared entity. Since
        /// XMLKit never processes DTD internal subsets at all, entity-expansion
        /// amplification ("billion laughs") and external-entity retrieval (XXE)
        /// are impossible by construction rather than disabled by a flag.
        mutating func validateReference(at ampersand: Int, limit: Int) throws -> Int {
            var index = ampersand + 1
            guard index < limit else {
                throw XMLParserError.invalidCharacterReference(
                    position: position(at: ampersand),
                    text: "&"
                )
            }

            if bytes[index] == UInt8(ascii: "#") {
                index += 1
                let isHexadecimal = index < limit
                    && (bytes[index] == UInt8(ascii: "x") || bytes[index] == UInt8(ascii: "X"))
                if isHexadecimal { index += 1 }

                let digitsStart = index
                var scalar: UInt32 = 0
                var digitCount = 0
                while index < limit, bytes[index] != UInt8(ascii: ";") {
                    let byte = bytes[index]
                    let digit: UInt32
                    if xmlIsASCIIDigit(byte) {
                        digit = UInt32(byte - UInt8(ascii: "0"))
                    } else if isHexadecimal, xmlIsASCIIHexDigit(byte) {
                        digit = UInt32(xmlASCIILowercased(byte) - UInt8(ascii: "a") + 10)
                    } else {
                        throw XMLParserError.invalidCharacterReference(
                            position: position(at: ampersand),
                            text: previewString(from: ampersand, length: Swift.min(12, limit - ampersand))
                        )
                    }
                    if digitCount < 7 {
                        scalar = scalar * (isHexadecimal ? 16 : 10) + digit
                    }
                    digitCount += 1
                    index += 1
                }

                guard index < limit, index > digitsStart, digitCount <= 7 else {
                    throw XMLParserError.invalidCharacterReference(
                        position: position(at: ampersand),
                        text: previewString(from: ampersand, length: Swift.min(12, limit - ampersand))
                    )
                }
                guard UnicodeScalar(scalar) != nil, xmlIsLegalCharacter(scalar) else {
                    throw XMLParserError.invalidCharacter(
                        scalar: scalar,
                        position: position(at: ampersand)
                    )
                }
                return index + 1
            }

            let nameStart = index
            while index < limit, bytes[index] != UInt8(ascii: ";") {
                let byte = bytes[index]
                guard xmlIsASCIIAlphanumeric(byte)
                    || byte == UInt8(ascii: "_")
                    || byte == UInt8(ascii: "-")
                    || byte == UInt8(ascii: ":")
                    || byte == UInt8(ascii: ".") else {
                    throw XMLParserError.invalidCharacterReference(
                        position: position(at: ampersand),
                        text: previewString(from: ampersand, length: Swift.min(12, limit - ampersand))
                    )
                }
                index += 1
            }
            guard index < limit, index > nameStart else {
                throw XMLParserError.invalidCharacterReference(
                    position: position(at: ampersand),
                    text: previewString(from: ampersand, length: Swift.min(12, limit - ampersand))
                )
            }

            let length = index - nameStart
            let isPredefined = (length == 2 && (xmlBytesEqual(bytes, nameStart, 2, XMLReservedKeyword.lt)
                    || xmlBytesEqual(bytes, nameStart, 2, XMLReservedKeyword.gt)))
                || (length == 3 && xmlBytesEqual(bytes, nameStart, 3, XMLReservedKeyword.amp))
                || (length == 4 && (xmlBytesEqual(bytes, nameStart, 4, XMLReservedKeyword.quot)
                    || xmlBytesEqual(bytes, nameStart, 4, XMLReservedKeyword.apos)))

            guard isPredefined else {
                throw XMLParserError.unknownEntity(
                    name: String(decoding: bytes[nameStart..<index], as: UTF8.self),
                    position: position(at: ampersand)
                )
            }
            return index + 1
        }

        /// Consumes any run of whitespace, reporting whether there was one.
        @discardableResult
        mutating func skipWhitespaceReturningWhetherAny() throws -> Bool {
            let start = position
            while position < byteCount, xmlIsXMLWhitespace(bytes[position]) {
                position += 1
            }
            return position > start
        }

        /// Consumes any run of whitespace.
        mutating func skipWhitespace() throws {
            while position < byteCount, xmlIsXMLWhitespace(bytes[position]) {
                position += 1
            }
        }

        /// Consumes at least one whitespace character.
        @discardableResult
        mutating func skipRequiredWhitespace(context: String, from errorStart: Int) throws -> Int {
            guard try skipWhitespaceReturningWhetherAny() else {
                throw XMLParserError.malformedMarkup(
                    position: position(at: errorStart),
                    reason: "expected whitespace in \(context)"
                )
            }
            return position
        }

        /// Scans a quoted literal without interpreting it.
        mutating func scanQuotedValue(context: String) throws -> (Int, Int) {
            guard position < byteCount else {
                throw XMLParserError.unexpectedEndOfInput(
                    position: position(at: byteCount),
                    context: context
                )
            }
            let quote = bytes[position]
            guard quote == UInt8(ascii: "\"") || quote == UInt8(ascii: "'") else {
                throw XMLParserError.malformedMarkup(
                    position: position(at: position),
                    reason: "expected a quoted value in \(context)"
                )
            }
            position += 1
            let start = position
            while position < byteCount, bytes[position] != quote {
                position += 1
            }
            guard position < byteCount else {
                throw XMLParserError.unexpectedEndOfInput(
                    position: position(at: byteCount),
                    context: context
                )
            }
            let end = position
            position += 1
            return (start, end)
        }

        /// Validates that every character in `range` is legal XML, rejecting
        /// illegal control bytes and scalars.
        ///
        /// Used for comment, CDATA, and processing-instruction bodies, none of
        /// which undergo entity processing but all of which must be well-formed.
        mutating func validateCharacterRun(from start: Int, to end: Int, context: String) throws {
            var index = start
            while index < end {
                let byte = bytes[index]
                if byte < 0x80 {
                    switch byte {
                    case 0x09, 0x0A, 0x0D, 0x20...0x7E:
                        index += 1
                    default:
                        throw XMLParserError.invalidCharacter(
                            scalar: UInt32(byte),
                            position: position(at: index)
                        )
                    }
                } else {
                    let scalarStart = index
                    guard let scalar = xmlDecodeScalar(bytes, &index), index <= end else {
                        throw XMLParserError.invalidUTF8(position: position(at: scalarStart))
                    }
                    guard xmlIsLegalCharacter(scalar) else {
                        throw XMLParserError.invalidCharacter(
                            scalar: scalar,
                            position: position(at: scalarStart)
                        )
                    }
                }
            }
            _ = context
        }

        /// Renders a bounded preview of a byte slice for an error message, so a
        /// malformed document cannot produce a multi-megabyte error string.
        func previewString(from start: Int, length: Int) -> String {
            let bounded = Swift.max(0, Swift.min(length, 32))
            guard start >= 0, start + bounded <= byteCount else { return "" }
            return String(decoding: bytes[start..<(start + bounded)], as: UTF8.self)
        }
    }
}

// MARK: - Reserved markup helpers
