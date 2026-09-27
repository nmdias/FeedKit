//
// XMLToken.swift
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

// MARK: - Token

/// A single lexical unit of an XML document.
///
/// - Warning: This type is internal. It is an implementation detail that the
///   public ``XMLDocument`` DOM deliberately hides, so the tokenizer can be
///   replaced — with a SIMD or streaming implementation — without a breaking
///   change. See `Documentation/DESIGN.md` §5.
struct XMLToken {
  enum Kind: UInt8 {
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
    /// `<name …>`
    case startTag
    /// `</name>`
    case endTag
    /// Character data.
    case text

    // MARK: Internal

    /// `true` for the two token kinds that nest and therefore participate in
    /// element matching.
    @inline(__always)
    var isTag: Bool {
      self == .startTag || self == .endTag
    }
  }

  var kind: Kind

  /// Absolute byte offset of the start of the construct.
  ///
  /// For every kind this is the first byte *of the construct itself*:
  /// the `<` for tags, declarations, comments, CDATA, DOCTYPE and processing
  /// instructions, and the first content byte for text.
  ///
  /// For every kind, `bytes[start..<end]` is the complete construct,
  /// delimiters included, so re-serialising a token stream reproduces the
  /// document exactly. That invariant is what makes full-fidelity round-tripping
  /// through the DOM a matter of copying bytes rather than re-escaping them.
  var start: Int

  /// Absolute byte offset just past the construct.
  var end: Int

  /// Absolute byte offset of the construct's *payload*, excluding delimiters.
  ///
  /// For `comment` and `processingInstruction` this skips `<!--` / `<?target`;
  /// for `cdata` it skips `<![CDATA[`; for `text` it equals ``start``. For tags
  /// it is the first byte after the `>`.
  var contentStart: Int

  /// Absolute byte offset just past the payload.
  ///
  /// For `comment` it is the offset of the `-` that begins `-->`; for `cdata`
  /// the `]` that begins `]]>`; for `processingInstruction` the `?` that begins
  /// `?>`; for `text` it equals ``end``.
  var contentEnd: Int

  /// Byte offset of the name, for kinds that have one.
  ///
  /// For `startTag` and `endTag` this is the element name. For
  /// `processingInstruction` it is the target. For `xmlDeclaration` and
  /// `documentType` it is the name of the declared root.
  var nameStart: Int

  /// Byte length of the name at ``nameStart``.
  var nameLength: Int

  /// For `startTag`: index of the matching `endTag` token. For `endTag`: index
  /// of the matching `startTag` token. Unused otherwise.
  ///
  /// Storing the match on both sides makes "find the element's extent" and
  /// "walk up to the parent" both O(1).
  var match: Int32

  /// For `startTag`: index of the first entry in the attribute array. `-1` when
  /// the element has no attributes.
  var attributeStart: Int32

  /// For `startTag`: number of entries in the attribute array.
  var attributeCount: Int32

  /// For `startTag`: index of the `/` in `<name/>`, or `-1` for a paired tag.
  ///
  /// This is what allows `<a/>` and `<a></a>` to remain distinguishable, which
  /// matters for round-tripping a document and for
  /// ``EmptyElementStrategy/selfClosing``.
  var selfClosingSlash: Int

  /// For `text` and attribute values: byte offset of the first character that
  /// requires unescaping (an `&`, or a `]` that may begin `]]>`, or a literal
  /// CR/TAB/LF needing normalisation), or `-1` when the slice is pure literal
  /// text.
  ///
  /// This single field is the reason the decoder can hand out text without
  /// allocating in the common case: if it is `-1`, the text is a verbatim UTF-8
  /// slice and needs no processing at all.
  var firstSpecial: Int
}

extension XMLToken {
  /// The token's name as a UTF-8 slice of the document.
  @inline(__always)
  func nameBytes(in document: [UInt8]) -> ArraySlice<UInt8> {
    document[nameStart ..< (nameStart + nameLength)]
  }
}

// MARK: - Attribute

/// A single attribute of an element.
///
/// Attributes are kept in a flat array rather than attached to their element so
/// that an element's attributes are a contiguous range — one cache-friendly
/// scan — and so that the token itself stays small.
struct XMLAttribute {
  /// Byte offset of the attribute name.
  var nameStart: Int

  /// Byte length of the attribute name.
  var nameLength: Int

  /// Byte offset of the first byte of the *raw*, still-escaped value.
  var valueStart: Int

  /// Byte offset just past the raw value.
  var valueEnd: Int

  /// Byte offset of the first byte needing unescaping in the raw value, or `-1`.
  var firstSpecial: Int

  /// The quote character used in the source (`"` or `'`), preserved so that a
  /// DOM round-trip can reproduce the original document.
  var quote: UInt8
}

// MARK: - Document

/// The result of tokenizing a document: the bytes plus their token structure.
///
/// Bundling the two together is what makes the token layer usable on its own and
/// keeps offset arithmetic in one place. `XMLKit` never exposes this type
/// publicly.
struct XMLTokenizedDocument {
  /// The document bytes.
  ///
  /// Held (not copied) from the caller. CRLF/lone-CR normalisation is *not*
  /// applied here because it is a content-level transform; the tokenizer
  /// records the raw offsets and ``XMLTextUnescaper`` performs normalisation
  /// only when text is materialised. A caller that never touches a text node
  /// therefore never pays for normalisation.
  var bytes: [UInt8]

  /// All tokens in document order.
  var tokens: [XMLToken]

  /// All attributes, in document order, grouped by their element.
  var attributes: [XMLAttribute]

  /// Index of the root element's `startTag` token, or `nil` for a document with
  /// no element (which is only reachable in fragment mode).
  var rootIndex: Int32

  /// Indices of every top-level element.
  ///
  /// Holds a single entry for a well-formed document and several for a
  /// fragment, which is what allows ``XMLDecoder`` to decode `[T]` from a
  /// document with repeated root-level elements.
  var rootIndices: [Int32]

  /// The XML declaration's token index, when the document had one.
  var declarationIndex: Int32

  /// The `<!DOCTYPE …>` token index, when the document had one.
  var documentTypeIndex: Int32

  /// The document's declared encoding, when present. Recorded for diagnostics
  /// and for ``XMLDocument`` fidelity; it never changes how bytes are read,
  /// because XMLKit always requires UTF-8 input.
  var declaredEncoding: String?

  /// The document's declared version, when present.
  var declaredVersion: String?

  /// The document's declared standalone value, when present.
  var declaredStandalone: Bool?

  /// The name of the root element, or `nil`.
  @inline(__always)
  var rootNameBytes: ArraySlice<UInt8>? {
    guard rootIndex >= 0 else {
      return nil
    }
    let token = tokens[Int(rootIndex)]
    return bytes[token.nameStart ..< (token.nameStart + token.nameLength)]
  }

  /// The `endTag` index matching `index`, or `index` itself when the element is
  /// self-closing.
  @inline(__always)
  func matchingEndIndex(of index: Int) -> Int {
    let match = tokens[index].match
    return match >= 0 ? Int(match) : index
  }

  /// The exclusive upper bound of the content of the element at `index`.
  ///
  /// For a self-closing element this is the element's own end, so the content
  /// range is empty without needing a special case at every call site.
  @inline(__always)
  func contentRange(of index: Int) -> Range<Int> {
    let token = tokens[index]
    guard token.match >= 0 else {
      return token.contentEnd ..< token.contentEnd
    }
    return token.contentStart ..< tokens[Int(token.match)].start
  }

  /// `true` when the element at `index` was written as `<name/>`.
  @inline(__always)
  func isSelfClosing(_ index: Int) -> Bool {
    tokens[index].selfClosingSlash >= 0
  }
}
