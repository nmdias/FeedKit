//
// XMLTokenSequence.swift
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

/// The lexical kind of an XML construct.
///
/// - Important: This enum is not `@frozen`. Match with a `default` clause so
///   that additional construct kinds can be added without breaking your build.
public enum XMLTokenKind: Sendable, Hashable {
  /// `<?xml version="1.0" …?>`
  case xmlDeclaration
  /// `<?target data?>`
  case processingInstruction
  /// `<!-- comment -->`
  case comment
  /// `<!DOCTYPE …>`
  case documentType
  /// `<![CDATA[ … ]]>`
  case cdata
  /// `<name …>` or `<name … />`
  case startTag
  /// `</name>`
  case endTag
  /// Character data.
  case text
}

/// One lexical construct within a document.
///
/// A token is a *lexical* unit, not a node: it reports what the document says,
/// not what it means. In particular an element produces two tokens (a start tag
/// and an end tag), and ``XMLDocument`` is the right API when the tree is what
/// you want.
///
/// The value of this API is that it gives access to the constructs `Codable` and
/// even a tree cannot express directly — where CDATA begins and ends, which
/// elements were written self-closing, and the exact source position of
/// everything — without the caller having to write a parser.
public struct XMLTokenInfo: Sendable {
  /// The construct's kind.
  public let kind: XMLTokenKind

  /// The element or attribute name, or a processing instruction's target.
  public let name: String?

  /// The construct's payload: an element's text, a CDATA section's contents, a
  /// comment's text, a processing instruction's data, or an attribute value.
  ///
  /// Text is already unescaped and line-ending-normalised, exactly as XML
  /// requires. For a tag this is `nil`, because a tag's "payload" is its
  /// attributes, which are reported separately.
  public let text: String?

  /// The 0-based byte offset where the construct begins, including its
  /// delimiter.
  public let byteOffset: Int

  /// The 1-based line where the construct begins.
  public let line: Int

  /// The 1-based column where the construct begins.
  public let column: Int

  /// The element's attributes, in document order. Empty for other kinds.
  ///
  /// Namespace declarations that were written as `xmlns` attributes appear
  /// here too, because lexically that is what they are.
  public let attributes: [XMLAttributeInfo]

  /// Whether the element was written `<name/>`.
  ///
  /// `false` for every kind except ``XMLTokenKind/startTag``.
  public let isEmptyElement: Bool
}

/// An attribute as it appeared in the document.
///
/// Named `XMLAttributeInfo` rather than `XMLAttribute` so that it cannot be
/// confused with the parser's internal attribute representation, which is an
/// offset pair rather than a pair of strings.
public struct XMLAttributeInfo: Sendable, Hashable {
  /// The attribute's name, exactly as written, including any prefix.
  public let name: String

  /// The attribute's value, already unescaped and whitespace-normalised as XML
  /// requires.
  public let value: String
}

/// A document's tokens, in document order.
///
/// Obtained from ``XMLDocument/tokens``. Iterating this is a linear scan with no
/// allocation per token, so it is suitable for large documents.
public struct XMLTokenSequence: Sendable {
  // MARK: Lifecycle

  init(tokens: [XMLTokenInfo]) {
    self.tokens = tokens
  }

  // MARK: Public

  /// The number of tokens.
  public var count: Int {
    tokens.count
  }

  /// The token at `index`.
  public subscript(index: Int) -> XMLTokenInfo {
    tokens[index]
  }

  /// Every token whose kind matches.
  ///
  /// A convenience for the common "give me all the comments" query, which
  /// otherwise needs a filter over an existential-free array.
  public func tokens(ofKind kind: XMLTokenKind) -> [XMLTokenInfo] {
    tokens.filter { $0.kind == kind }
  }

  // MARK: Private

  private let tokens: [XMLTokenInfo]
}

extension XMLTokenSequence: RandomAccessCollection {
  public var startIndex: Int {
    tokens.startIndex
  }

  public var endIndex: Int {
    tokens.endIndex
  }
}

extension XMLTokenSequence: Sequence {
  public func makeIterator() -> IndexingIterator<[XMLTokenInfo]> {
    tokens.makeIterator()
  }
}

// MARK: - Construction from the token layer

extension XMLTokenSequence {
  /// Builds the public token view from the internal token array.
  ///
  /// This is where the internal offset representation is converted into the
  /// public value representation. It is the *only* place that mapping exists,
  /// which is what allows the internal representation to change without
  /// affecting the public API.
  init(buildingFrom document: XMLTokenizedDocument) {
    var result: [XMLTokenInfo] = []
    result.reserveCapacity(document.tokens.count)

    // The line table is built **once** for the whole document. Calling
    // `xmlPosition(in:at:)` per token would build a fresh table each time —
    // one full pass over the document per token, i.e. O(tokens × bytes). On a
    // 96 KB document with 5 000 tokens that measured 880 ms against 1.8 ms for
    // a complete DOM parse, which is how the mistake was found.
    let lineTable: XMLLineTable = .init(bytes: document.bytes)

    for (index, token) in document.tokens.enumerated() {
      let (line, column) = lineTable.position(at: token.start)
      let position: XMLSourcePosition = .init(byteOffset: token.start, line: line, column: column)
      let kind: XMLTokenKind = Self.publicKind(of: token.kind)

      var attributes: [XMLAttributeInfo] = []
      if token.kind == .startTag, token.attributeStart >= 0 {
        let start: Int = .init(token.attributeStart)
        attributes.reserveCapacity(Int(token.attributeCount))
        for attributeIndex in start ..< (start + Int(token.attributeCount)) {
          let attribute = document.attributes[attributeIndex]
          let name: String = .init(
            decoding: document.bytes[attribute.nameStart ..< (attribute.nameStart + attribute.nameLength)],
            as: UTF8.self
          )
          let value: String = if let decoded = try? XMLTextUnescaper.decode(
            document: document.bytes,
            start: attribute.valueStart,
            end: attribute.valueEnd,
            firstSpecial: attribute.firstSpecial,
            isAttributeValue: true
          ) {
            decoded.string(in: document.bytes)
          } else {
            String(decoding: document.bytes[attribute.valueStart ..< attribute.valueEnd], as: UTF8.self)
          }
          attributes.append(XMLAttributeInfo(name: name, value: value))
        }
      }

      var name: String?
      if token.nameLength > 0 {
        name = String(
          decoding: document.bytes[token.nameStart ..< (token.nameStart + token.nameLength)],
          as: UTF8.self
        )
      }

      // Only constructs with a payload report text; a tag's content is its
      // attributes, and reporting the following text here would be wrong.
      var text: String? = switch token.kind {
      case .text:
        (try? XMLTextUnescaper.decode(
          document: document.bytes,
          start: token.contentStart,
          end: token.contentEnd,
          firstSpecial: token.firstSpecial
        ))?.string(in: document.bytes)

      case .cdata,
           .comment,
           .processingInstruction:
        String(decoding: document.bytes[token.contentStart ..< token.contentEnd], as: UTF8.self)

      case .documentType,
           .endTag,
           .startTag,
           .xmlDeclaration:
        nil
      }

      result.append(
        XMLTokenInfo(
          kind: kind,
          name: name,
          text: text,
          byteOffset: position.byteOffset,
          line: position.line,
          column: position.column,
          attributes: attributes,
          isEmptyElement: token.kind == .startTag && token.selfClosingSlash >= 0
        )
      )
      _ = index
    }

    tokens = result
  }

  private static func publicKind(of kind: XMLToken.Kind) -> XMLTokenKind {
    switch kind {
    case .xmlDeclaration: .xmlDeclaration
    case .processingInstruction: .processingInstruction
    case .comment: .comment
    case .documentType: .documentType
    case .cdata: .cdata
    case .startTag: .startTag
    case .endTag: .endTag
    case .text: .text
    }
  }
}
