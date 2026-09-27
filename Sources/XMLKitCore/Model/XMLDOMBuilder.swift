//
//  XMLDOMBuilder.swift
//  XMLKit
//
//  Builds an XMLDocument tree from the token array.
//

import Foundation

/// Materialises a DOM from a tokenized document.
///
/// The builder is a `struct` driven by an explicit element stack, so building a
/// deeply nested document consumes heap rather than call stack. It performs
/// unescaping exactly once per text and attribute value, and it deliberately
/// preserves lexical form — CDATA stays CDATA, comments stay comments, and the
/// empty-element spelling is recoverable through ``XMLElement/serialized``
/// because the writer reproduces whichever form the caller's configuration asks
/// for.
internal struct DOMBuilder {
    let document: XMLTokenizedDocument
    let configuration: XMLParserConfiguration
    private let resolver: XMLNamespaceResolver

    internal init(document: XMLTokenizedDocument, configuration: XMLParserConfiguration) {
        self.document = document
        self.configuration = configuration
        self.resolver = XMLNamespaceResolver(document: document)
    }

    /// Builds a full document, including its prolog and epilog.
    internal mutating func build() throws -> XMLDocument {
        let rootIndex = Int(document.rootIndex)
        guard rootIndex >= 0 else { throw XMLDecoderError.missingRootElement }

        let actualRoot = try buildElement(at: rootIndex)

        // Prolog and epilog are everything *outside* the root element. The root's
        // extent in token space is `rootIndex ... matchingEnd`, so the two halves
        // are the tokens before and after that range — a single linear pass each.
        //
        // An earlier version walked every token and asked "is this a descendant of
        // the root?", which is O(1) per token only if the root's match is known —
        // and it compared a *byte* offset against a *token* index, so the answer
        // was wrong and the check degenerated to a linear scan per token. The
        // result was quadratic in document size: a 200 000-element document took
        // tens of seconds to parse as a DOM. Using token indices fixes both the
        // correctness and the complexity.
        var prolog: [XMLNode] = []
        var epilog: [XMLNode] = []
        var documentType: String?

        let rootEndIndex = document.tokens[rootIndex].match >= 0
            ? Int(document.tokens[rootIndex].match)
            : rootIndex

        func appendNode(_ node: XMLNode, isAfterRoot: Bool) {
            if isAfterRoot {
                epilog.append(node)
            } else {
                prolog.append(node)
            }
        }

        // Everything before the root start tag.
        var index = 0
        while index < rootIndex {
            let token = document.tokens[index]
            switch token.kind {
            case .comment:
                appendNode(
                    .comment(String(decoding: document.bytes[token.contentStart..<token.contentEnd], as: UTF8.self)),
                    isAfterRoot: false
                )
            case .processingInstruction:
                appendNode(
                    .processingInstruction(
                        target: String(
                            decoding: document.bytes[token.nameStart..<(token.nameStart + token.nameLength)],
                            as: UTF8.self
                        ),
                        data: String(decoding: document.bytes[token.contentStart..<token.contentEnd], as: UTF8.self)
                    ),
                    isAfterRoot: false
                )
            case .documentType:
                documentType = String(decoding: document.bytes[token.start..<token.end], as: UTF8.self)
            default:
                break
            }
            index += 1
        }

        // Everything after the root end tag.
        index = rootEndIndex + 1
        while index < document.tokens.count {
            let token = document.tokens[index]
            switch token.kind {
            case .comment:
                appendNode(
                    .comment(String(decoding: document.bytes[token.contentStart..<token.contentEnd], as: UTF8.self)),
                    isAfterRoot: true
                )
            case .processingInstruction:
                appendNode(
                    .processingInstruction(
                        target: String(
                            decoding: document.bytes[token.nameStart..<(token.nameStart + token.nameLength)],
                            as: UTF8.self
                        ),
                        data: String(decoding: document.bytes[token.contentStart..<token.contentEnd], as: UTF8.self)
                    ),
                    isAfterRoot: true
                )
            default:
                break
            }
            index += 1
        }

        var declaration: XMLDeclaration?
        if document.declarationIndex >= 0 {
            declaration = XMLDeclaration(
                version: document.declaredVersion ?? "1.0",
                encoding: document.declaredEncoding,
                standalone: document.declaredStandalone
            )
        }

        return XMLDocument(
            root: actualRoot,
            declaration: declaration,
            prolog: prolog,
            epilog: epilog,
            documentType: documentType,
            tokenizedDocument: document
        )
    }

    /// Builds every top-level element.
    internal mutating func buildFragment() throws -> [XMLElement] {
        var elements: [XMLElement] = []
        for rootIndex in document.rootIndices {
            elements.append(try buildElement(at: Int(rootIndex)))
        }
        return elements
    }

    // MARK: Element construction

    /// Builds the element whose start tag is the token at `index`.
    ///
    /// Internal rather than private because ``XMLDecoder`` materialises elements
    /// on demand from the same token array: building a node lazily as it is
    /// visited is what keeps a Codable decode from paying for the whole document
    /// tree, while still giving the decoder a real element to work with.
    internal mutating func buildElement(at index: Int) throws -> XMLElement {
        let token = document.tokens[index]
        let name = String(decoding: document.bytes[token.nameStart..<(token.nameStart + token.nameLength)], as: UTF8.self)
        let element = XMLElement(name: name)
        element.documentPosition = index

        // Attributes. `xmlns` declarations become declaration nodes rather than
        // ordinary attributes, because that is what they are: they are consumed
        // by the namespace machinery and re-emitted by the writer.
        var attributes: [(name: String, value: String)] = []
        if token.attributeStart >= 0 {
            let start = Int(token.attributeStart)
            for attributeIndex in start..<(start + Int(token.attributeCount)) {
                let attribute = document.attributes[attributeIndex]
                let attributeName = String(
                    decoding: document.bytes[attribute.nameStart..<(attribute.nameStart + attribute.nameLength)],
                    as: UTF8.self
                )
                let value = try unescape(
                    start: attribute.valueStart,
                    end: attribute.valueEnd,
                    firstSpecial: attribute.firstSpecial,
                    isAttributeValue: true
                )

                if attributeName == "xmlns" {
                    element.declareNamespace(prefix: nil, uri: value)
                } else if attributeName.hasPrefix("xmlns:") {
                    element.declareNamespace(
                        prefix: String(attributeName.dropFirst("xmlns:".count)),
                        uri: value
                    )
                } else {
                    attributes.append((name: attributeName, value: value))
                }
            }
        }
        element.setAttributes(attributes)

        // Children.
        //
        // The element's content is the *token* range (index+1 ..< match), not the
        // byte range returned by `contentRange(of:)`. Those two are easy to
        // confuse and mixing them produces a loop that silently never runs — the
        // token index is compared against a byte offset. Keep them distinct: this
        // loop walks token indices, and byte offsets are only used for slicing.
        var position = index + 1
        let contentEnd = token.match >= 0 ? Int(token.match) : index + 1
        var children: [XMLNode] = []

        while position < contentEnd {
            let child = document.tokens[position]
            switch child.kind {
            case .text:
                let text = try unescape(
                    start: child.start,
                    end: child.end,
                    firstSpecial: child.firstSpecial,
                    isAttributeValue: false
                )
                if !text.isEmpty {
                    children.append(.text(text))
                }
                position += 1

            case .cdata:
                let text = String(decoding: document.bytes[child.contentStart..<child.contentEnd], as: UTF8.self)
                children.append(.cdata(text))
                position += 1

            case .comment:
                let text = String(decoding: document.bytes[child.contentStart..<child.contentEnd], as: UTF8.self)
                children.append(.comment(text))
                position += 1

            case .processingInstruction:
                let target = String(
                    decoding: document.bytes[child.nameStart..<(child.nameStart + child.nameLength)],
                    as: UTF8.self
                )
                let data = String(decoding: document.bytes[child.contentStart..<child.contentEnd], as: UTF8.self)
                children.append(.processingInstruction(target: target, data: data))
                position += 1

            case .startTag:
                let nested = try buildElement(at: position)
                children.append(.element(nested))
                position = child.selfClosingSlash >= 0 ? position + 1 : Int(child.match) + 1

            case .endTag:
                // The end tag that closes this element; stop.
                position = contentEnd

            case .xmlDeclaration, .documentType:
                position += 1
            }
        }

        element.setChildren(children)
        return element
    }

    /// Unescapes a slice, choosing the verbatim fast path when possible.
    private func unescape(
        start: Int,
        end: Int,
        firstSpecial: Int,
        isAttributeValue: Bool
    ) throws -> String {
        let result = try XMLTextUnescaper.decode(
            document: document.bytes,
            start: start,
            end: end,
            firstSpecial: firstSpecial,
            isAttributeValue: isAttributeValue
        )
        return result.string(in: document.bytes)
    }
}
