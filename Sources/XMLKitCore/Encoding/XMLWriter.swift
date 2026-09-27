//
//  XMLWriter.swift
//  XMLKit
//
//  Serialisation: trees and byte buffers out.
//

import Foundation

/// Escaping and serialisation settings.
public struct XMLWriterConfiguration: Sendable, Hashable {
    /// How empty elements are written.
    public enum EmptyElementStyle: Sendable, Hashable {
        /// `<a/>`. Shorter, and what most generators emit.
        case selfClosing
        /// `<a></a>`. Required by some consumers, notably some HTML-derived
        /// tooling and a few legacy SOAP stacks.
        case openClosePair
    }

    /// How text is escaped.
    public enum TextEscaping: Sendable, Hashable {
        /// Escape only what must be escaped: `&`, `<`, and `>` where it would
        /// form `]]>`.
        ///
        /// Produces smaller output and is exactly what XML requires. The `>`
        /// character is legal unescaped in content, so escaping it is optional.
        case minimal
        /// Additionally escape `>` everywhere.
        ///
        /// Slightly larger output, but immune to naive downstream tooling that
        /// scans for `>` without a parser. This is the default because the cost is
        /// one byte per `>` and the failure mode it prevents — a corrupted
        /// document at a third party — is expensive and hard to diagnose.
        case escapeGreaterThan
    }

    /// The character used to quote attribute values.
    public enum AttributeQuote: Sendable, Hashable {
        case double
        case single

        internal var byte: UInt8 {
            switch self {
            case .double: UInt8(ascii: "\"")
            case .single: UInt8(ascii: "'")
            }
        }
    }

    /// Written as the XML declaration.
    ///
    /// When `nil`, ``XMLDocument`` falls back to the declaration the document was
    /// parsed with, so a parse/serialise round-trip preserves it by default. Set
    /// ``writesXMLDeclaration`` to `false` to suppress it entirely.
    public var xmlDeclaration: XMLDeclaration?

    /// Whether to write the XML declaration at all.
    ///
    /// Defaults to `true` when a declaration is available. This flag exists
    /// because "no declaration" is a distinct intent from "use the document's
    /// declaration", and a single optional cannot express both.
    public var writesXMLDeclaration: Bool

    /// How empty elements are written.
    public var emptyElementStyle: EmptyElementStyle

    /// How text is escaped.
    public var textEscaping: TextEscaping

    /// How attribute values are quoted.
    public var attributeQuote: AttributeQuote

    /// Whether to pretty-print.
    ///
    /// - Important: Pretty-printing inserts whitespace into the document. That is
    ///   safe for element-only content but **changes the value of any element
    ///   whose text is significant**, and it has no effect on elements that
    ///   contain text, because indenting those would alter their content. This is
    ///   inherent to XML, not a limitation of the implementation: whitespace *is*
    ///   content in XML, so no pretty-printer can be universally safe. XMLKit
    ///   therefore only indents inside elements that have no text children.
    public var prettyPrinted: Bool

    /// The string used for one level of indentation when ``prettyPrinted``.
    public var indentation: String

    /// Attribute ordering.
    public enum AttributeOrdering: Sendable, Hashable {
        /// The order attributes were added.
        case insertionOrder
        /// Sorted by name, which makes output deterministic for diffing and
        /// reproducible builds.
        case sortedByName
    }

    /// How attributes are ordered in output.
    public var attributeOrdering: AttributeOrdering

    /// Creates a writer configuration.
    public init(
        xmlDeclaration: XMLDeclaration? = nil,
        writesXMLDeclaration: Bool = true,
        emptyElementStyle: EmptyElementStyle = .selfClosing,
        textEscaping: TextEscaping = .escapeGreaterThan,
        attributeQuote: AttributeQuote = .double,
        prettyPrinted: Bool = false,
        indentation: String = "  ",
        attributeOrdering: AttributeOrdering = .insertionOrder
    ) {
        self.xmlDeclaration = xmlDeclaration
        self.writesXMLDeclaration = writesXMLDeclaration
        self.emptyElementStyle = emptyElementStyle
        self.textEscaping = textEscaping
        self.attributeQuote = attributeQuote
        self.prettyPrinted = prettyPrinted
        self.indentation = indentation
        self.attributeOrdering = attributeOrdering
    }

    /// The default configuration: no declaration, self-closing empty elements,
    /// `>` escaped, double-quoted attributes, compact output.
    public static let `default` = XMLWriterConfiguration()
}

/// An XML declaration, as written in the prolog.
public struct XMLDeclaration: Sendable, Hashable {
    /// The XML version. Only `1.0` is supported for output, because XML 1.0 and
    /// 1.1 differ in character rules XMLKit does not implement for 1.1.
    public var version: String

    /// The declared encoding.
    ///
    /// XMLKit always reads and writes UTF-8; this value only labels the output
    /// for consumers that inspect the declaration. Declaring an encoding other
    /// than UTF-8 while writing UTF-8 bytes would produce a document that
    /// misdescribes itself, so ``XMLWriter`` rejects that combination.
    public var encoding: String?

    /// The standalone document declaration.
    public var standalone: Bool?

    /// Creates a declaration.
    public init(version: String = "1.0", encoding: String? = "UTF-8", standalone: Bool? = nil) {
        self.version = version
        self.encoding = encoding
        self.standalone = standalone
    }

    /// The conventional UTF-8 declaration: `<?xml version="1.0" encoding="UTF-8"?>`.
    public static let utf8 = XMLDeclaration()
}

/// Serialises an ``XMLDocument`` or an ``XMLElement`` to UTF-8 bytes.
///
/// Kept separate from the document model so that a document can be parsed once
/// and written many times with different settings, and so that the encoder can
/// share exactly one escaping implementation with the DOM.
///
/// ## Escaping
///
/// Escaping is driven by a 256-entry lookup table, so the scan for characters
/// needing escape is a table lookup per byte and the common case — a run of
/// ordinary text — is a straight copy. The five predefined entities are used
/// where they suffice; XMLKit deliberately does **not** emit character
/// references for ordinary non-ASCII text, because UTF-8 handles it and escaping
/// it would bloat output and hurt readability.
public struct XMLWriter: Sendable {
    /// The configuration.
    public var configuration: XMLWriterConfiguration

    /// Creates a writer.
    public init(configuration: XMLWriterConfiguration = .default) {
        self.configuration = configuration
    }

    /// Serialises `document` to UTF-8 bytes.
    public func bytes(for document: XMLDocument) -> [UInt8] {
        var output: [UInt8] = []
        output.reserveCapacity(256)
        write(document, into: &output)
        return output
    }

    /// Serialises `document` to a `String`.
    public func string(for document: XMLDocument) -> String {
        String(decoding: bytes(for: document), as: UTF8.self)
    }

    /// Serialises `element` to UTF-8 bytes.
    public func bytes(for element: XMLElement) -> [UInt8] {
        var output: [UInt8] = []
        output.reserveCapacity(256)
        write(element, into: &output)
        return output
    }

    /// Serialises `element` to a `String`.
    public func string(for element: XMLElement) -> String {
        String(decoding: bytes(for: element), as: UTF8.self)
    }

    /// Serialises a document into `output`.
    public func write(_ document: XMLDocument, into output: inout [UInt8]) {
        if configuration.writesXMLDeclaration, let declaration = configuration.xmlDeclaration {
            writeDeclaration(declaration, into: &output)
        }
        for node in document.prolog {
            write(node, depth: 0, into: &output)
        }
        write(document.root, depth: 0, into: &output)
        for node in document.epilog {
            write(node, depth: 0, into: &output)
        }
        if configuration.prettyPrinted {
            output.append(UInt8(ascii: "\n"))
        }
    }

    /// Serialises an element into `output`.
    public func write(_ element: XMLElement, into output: inout [UInt8]) {
        // No trailing newline: an element fragment is not a document, and adding
        // one would surprise a caller embedding it in other output.
        write(element, depth: 0, into: &output)
    }

    /// Serialises `element` as a standalone document fragment.
    public func fragmentBytes(for element: XMLElement) -> [UInt8] {
        var output: [UInt8] = []
        write(element, depth: 0, into: &output)
        return output
    }

    // MARK: - Declaration

    private func writeDeclaration(_ declaration: XMLDeclaration, into output: inout [UInt8]) {
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

    // MARK: - Nodes

    private func write(_ node: XMLNode, depth: Int, into output: inout [UInt8]) {
        switch node {
        case let .element(element):
            write(element, depth: depth, into: &output)
        case let .text(text):
            writeText(text, into: &output)
        case let .cdata(text):
            writeCData(text, into: &output)
        case let .comment(text):
            writeComment(text, into: &output)
        case let .processingInstruction(target, data):
            writeProcessingInstruction(target: target, data: data, into: &output)
        }
    }

    private func write(_ element: XMLElement, depth: Int, into output: inout [UInt8]) {
        write(element, depth: depth, preIndented: false, into: &output)
    }

    /// Writes an element.
    ///
    /// - Parameter preIndented: When `true`, the caller has already emitted this
    ///   element's indentation and the writer must not emit it again. Without
    ///   this, a parent that indents its child and a child that indents itself
    ///   compound, and every level of nesting doubles the indent.
    private func write(_ element: XMLElement, depth: Int, preIndented: Bool, into output: inout [UInt8]) {
        if configuration.prettyPrinted, !preIndented { indent(depth, into: &output) }

        output.append(UInt8(ascii: "<"))
        output.append(contentsOf: element.qualifiedName.utf8)
        writeAttributes(of: element, into: &output)
        writeNamespaceDeclarations(of: element, into: &output)

        let hasContent = !element.children.isEmpty
        if !hasContent {
            switch configuration.emptyElementStyle {
            case .selfClosing:
                output.append(contentsOf: "/>".utf8)
                return
            case .openClosePair:
                output.append(UInt8(ascii: ">"))
                output.append(contentsOf: "</".utf8)
                output.append(contentsOf: element.qualifiedName.utf8)
                output.append(UInt8(ascii: ">"))
                return
            }
        }

        output.append(UInt8(ascii: ">"))

        // Pretty-printing must not change the value of an element whose content is
        // text, so indentation is applied only when every child is an element,
        // comment or processing instruction. This is the one place where XML's
        // "whitespace is content" rule forces a conservative choice.
        let containsText = element.children.contains { child in
            switch child {
            case .text, .cdata: true
            default: false
            }
        }
        let shouldIndent = configuration.prettyPrinted && !containsText

        if shouldIndent {
            // The newline goes *before* each child, not after. Emitting it after
            // would place a newline between a child and its parent's end tag,
            // producing
            //     <c>
            //       <d/>
            //     </c>
            // only by accident and
            //     <c>      <d/>
            //     </c>
            // in practice. Putting it before is what makes indentation nest
            // correctly and leaves the parent's end tag on its own line.
            for child in element.children {
                output.append(UInt8(ascii: "\n"))
                indent(depth + 1, into: &output)
                if case let .element(nested) = child {
                    write(nested, depth: depth + 1, preIndented: true, into: &output)
                } else {
                    write(child, depth: depth + 1, into: &output)
                }
            }
            output.append(UInt8(ascii: "\n"))
            indent(depth, into: &output)
        } else {
            for child in element.children {
                write(child, depth: depth, into: &output)
            }
        }

        output.append(contentsOf: "</".utf8)
        output.append(contentsOf: element.qualifiedName.utf8)
        output.append(UInt8(ascii: ">"))
    }

    private func writeAttributes(of element: XMLElement, into output: inout [UInt8]) {
        guard !element.attributes.isEmpty else { return }

        let pairs: [(name: String, value: String)]
        switch configuration.attributeOrdering {
        case .insertionOrder:
            pairs = element.attributes
        case .sortedByName:
            pairs = element.attributes.sorted { $0.name < $1.name }
        }

        let quote = configuration.attributeQuote.byte
        for (name, value) in pairs {
            output.append(UInt8(ascii: " "))
            output.append(contentsOf: name.utf8)
            output.append(UInt8(ascii: "="))
            output.append(quote)
            XMLWriter.appendEscapedAttributeValue(value, quote: quote, into: &output)
            output.append(quote)
        }
    }

    private func writeNamespaceDeclarations(of element: XMLElement, into output: inout [UInt8]) {
        guard !element.namespaceDeclarations.isEmpty else { return }
        let quote = configuration.attributeQuote.byte

        for declaration in element.namespaceDeclarations {
            output.append(UInt8(ascii: " "))
            if let prefix = declaration.prefix {
                output.append(contentsOf: "xmlns:".utf8)
                output.append(contentsOf: prefix.utf8)
            } else {
                output.append(contentsOf: "xmlns".utf8)
            }
            output.append(UInt8(ascii: "="))
            output.append(quote)
            XMLWriter.appendEscapedAttributeValue(declaration.uri, quote: quote, into: &output)
            output.append(quote)
        }
    }

    private func writeText(_ text: String, into output: inout [UInt8]) {
        switch configuration.textEscaping {
        case .minimal:
            XMLWriter.appendEscapedText(text, escapeGreaterThan: false, into: &output)
        case .escapeGreaterThan:
            XMLWriter.appendEscapedText(text, escapeGreaterThan: true, into: &output)
        }
    }

    private func writeCData(_ text: String, into output: inout [UInt8]) {
        output.append(contentsOf: "<![CDATA[".utf8)
        // `]]>` cannot appear inside a CDATA section. Splitting it across two
        // sections is the standard remedy and preserves the text exactly:
        // `a]]>b` becomes `<![CDATA[a]]]]><![CDATA[>b]]>`.
        var remainder = Substring(text)
        while let range = remainder.range(of: "]]>") {
            output.append(contentsOf: remainder[remainder.startIndex..<range.lowerBound].utf8)
            output.append(contentsOf: "]]]]><![CDATA[>".utf8)
            remainder = remainder[range.upperBound...]
        }
        output.append(contentsOf: remainder.utf8)
        output.append(contentsOf: "]]>".utf8)
    }

    private func writeComment(_ text: String, into output: inout [UInt8]) {
        output.append(contentsOf: "<!--".utf8)
        // A comment may not contain `--`. Inserting a space keeps the comment
        // readable and well-formed; silently dropping the text would lose data,
        // and a comment is never semantically significant enough to justify
        // throwing.
        var index = text.startIndex
        var previousWasHyphen = false
        while index < text.endIndex {
            let character = text[index]
            if character == "-", previousWasHyphen {
                output.append(UInt8(ascii: " "))
            }
            output.append(contentsOf: String(character).utf8)
            previousWasHyphen = character == "-"
            index = text.index(after: index)
        }
        output.append(contentsOf: "-->".utf8)
    }

    private func writeProcessingInstruction(target: String, data: String, into output: inout [UInt8]) {
        output.append(contentsOf: "<?".utf8)
        output.append(contentsOf: target.utf8)
        if !data.isEmpty {
            output.append(UInt8(ascii: " "))
            output.append(contentsOf: data.utf8)
        }
        output.append(contentsOf: "?>".utf8)
    }

    private func indent(_ depth: Int, into output: inout [UInt8]) {
        guard depth > 0 else { return }
        for _ in 0..<depth {
            output.append(contentsOf: configuration.indentation.utf8)
        }
    }
}

// MARK: - Escaping

extension XMLWriter {
    /// Escaping table: `true` when the byte must be escaped in text content.
    ///
    /// A table rather than a `CharacterSet` or a switch, because this is the
    /// single hottest loop in serialisation and an indexed load is the cheapest
    /// possible test.
    private static let textEscapes: [Bool] = {
        var table = [Bool](repeating: false, count: 256)
        table[Int(UInt8(ascii: "&"))] = true
        table[Int(UInt8(ascii: "<"))] = true
        return table
    }()

    /// Appends `text`, escaping what must be escaped in element content.
    ///
    /// Only `&` and `<` are strictly required. `>` must be escaped only when it
    /// would complete a `]]>` sequence, which is checked directly. A separate
    /// pass is avoided: a fast scan finds the first byte needing attention and
    /// copies the run before it verbatim, so ordinary text costs one comparison
    /// per byte and no allocation.
    internal static func appendEscapedText(
        _ text: String,
        escapeGreaterThan: Bool,
        into output: inout [UInt8]
    ) {
        let table = textEscapes
        var runStart = text.startIndex
        var index = text.startIndex

        while index < text.endIndex {
            let character = text[index]
            guard let ascii = character.asciiValue else {
                index = text.index(after: index)
                continue
            }

            var needsEscape = table[Int(ascii)]
            if ascii == UInt8(ascii: ">") {
                if escapeGreaterThan {
                    needsEscape = true
                } else {
                    // Escape only to break a `]]>` sequence.
                    let before = text.index(before: index)
                    if index > text.startIndex, text[before] == "]" {
                        let beforeTwo = text.index(before, offsetBy: -1, limitedBy: text.startIndex)
                        if let beforeTwo, text[beforeTwo] == "]" { needsEscape = true }
                    }
                }
            }

            if needsEscape {
                output.append(contentsOf: text[runStart..<index].utf8)
                switch ascii {
                case UInt8(ascii: "&"): output.append(contentsOf: "&amp;".utf8)
                case UInt8(ascii: "<"): output.append(contentsOf: "&lt;".utf8)
                case UInt8(ascii: ">"): output.append(contentsOf: "&gt;".utf8)
                default: break
                }
                index = text.index(after: index)
                runStart = index
            } else {
                index = text.index(after: index)
            }
        }

        output.append(contentsOf: text[runStart...].utf8)
    }

    /// Appends an attribute value, escaping what must be escaped.
    ///
    /// In addition to `&` and `<`, XML 1.0 §3.3.3 requires that a literal TAB, LF
    /// or CR in an attribute value be written as a *character reference*.
    /// Otherwise a parser normalises it to a space and the value does not
    /// round-trip — so `"a\tb"` must be written `a&#9;b`. This is why attribute
    /// escaping cannot simply be "escape the quote character and hope".
    ///
    /// The active quote character is escaped too. Escaping *both* quote kinds
    /// would be unnecessary, but escaping the active one is mandatory, and
    /// choosing per value lets the writer avoid escaping the other.
    internal static func appendEscapedAttributeValue(
        _ value: String,
        quote: UInt8,
        into output: inout [UInt8]
    ) {
        var runStart = value.startIndex
        var index = value.startIndex

        while index < value.endIndex {
            let character = value[index]

            let replacement: [UInt8]?
            if let ascii = character.asciiValue {
                switch ascii {
                case UInt8(ascii: "&"):
                    replacement = ampersandEntity
                case UInt8(ascii: "<"):
                    replacement = lessThanEntity
                case UInt8(ascii: ">"):
                    // Legal unescaped in an attribute value, but escaping it keeps
                    // the output safe for naive downstream scanners. Unlike in
                    // content, `>` here can never form `]]>` that matters.
                    replacement = greaterThanEntity
                case 0x09:
                    replacement = tabReference
                case 0x0A:
                    replacement = lineFeedReference
                case 0x0D:
                    replacement = carriageReturnReference
                case quote:
                    replacement = (quote == UInt8(ascii: "\"")) ? quoteEntity : apostropheEntity
                default:
                    replacement = nil
                }
            } else {
                replacement = nil
            }

            guard let replacement else {
                index = value.index(after: index)
                continue
            }

            output.append(contentsOf: value[runStart..<index].utf8)
            output.append(contentsOf: replacement)
            index = value.index(after: index)
            runStart = index
        }

        output.append(contentsOf: value[runStart...].utf8)
    }

    // Entity byte sequences, as constants so the escaping loop allocates nothing.
    private static let ampersandEntity: [UInt8] = Array("&amp;".utf8)
    private static let lessThanEntity: [UInt8] = Array("&lt;".utf8)
    private static let greaterThanEntity: [UInt8] = Array("&gt;".utf8)
    private static let quoteEntity: [UInt8] = Array("&quot;".utf8)
    private static let apostropheEntity: [UInt8] = Array("&apos;".utf8)
    private static let tabReference: [UInt8] = Array("&#9;".utf8)
    private static let lineFeedReference: [UInt8] = Array("&#10;".utf8)
    private static let carriageReturnReference: [UInt8] = Array("&#13;".utf8)
}
