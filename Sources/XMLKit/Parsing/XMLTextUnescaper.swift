//
// XMLTextUnescaper.swift
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

/// The result of materialising a raw text or attribute slice.
enum XMLUnescapedText {
  /// The slice needed no processing: it is verbatim UTF-8.
  ///
  /// This is the common case and the reason the decoder is fast. It is
  /// represented as a distinct case rather than an empty-edit list so that
  /// callers can take a zero-copy path.
  case verbatim(ArraySlice<UInt8>)

  /// The slice required entity expansion, character-reference decoding, line
  /// ending normalisation, or whitespace normalisation.
  ///
  /// The associated value is the fully decoded text.
  case decoded([UInt8])
}

extension XMLUnescapedText {
  /// The text as a `String`, without an intermediate copy when possible.
  @inline(__always)
  func string(in _: [UInt8]) -> String {
    switch self {
    case let .verbatim(slice):
      String(decoding: slice, as: UTF8.self)
    case let .decoded(bytes):
      String(decoding: bytes, as: UTF8.self)
    }
  }

  /// The text's UTF-8 bytes, as a slice of `document` when possible.
  @inline(__always)
  func byteSlice(in _: [UInt8]) -> ArraySlice<UInt8> {
    switch self {
    case let .verbatim(slice):
      slice
    case let .decoded(bytes):
      bytes[...]
    }
  }
}

/// Decodes XML text and attribute values.
///
/// ## What is transformed, and why
///
/// XML 1.0 requires four distinct transforms, all of which are applied here so
/// that no other part of the library has to know about them:
///
/// 1. **Entity and character reference expansion** (§4.4). Exactly five
///    entities are predefined (`amp`, `lt`, `gt`, `quot`, `apos`); everything
///    else is either a numeric character reference or an error. XMLKit does not
///    process DTD internal subsets, so there is no entity declaration table to
///    consult — which is what makes entity-expansion amplification attacks
///    impossible rather than merely limited.
///
/// 2. **Line-ending normalisation** (§2.11): `\r\n` and lone `\r` become `\n`.
///    Critically, a `\r` *produced by* `&#13;` must **not** be normalised,
///    because normalisation is a lexical transform on the source, not on the
///    result. The two phases are therefore kept strictly separate below.
///
/// 3. **Attribute-value whitespace normalisation** (§3.3.3): a literal tab, LF or
///    CR in an attribute value becomes a space. Again, `&#10;` produces a real
///    newline and is *not* normalised, so the phase separation matters and is
///    observable.
///
/// 4. **Nothing else.** In particular, XMLKit does not trim, collapse runs of
///    spaces, or interpret `xml:space`. Trimming is a *decoding strategy*
///    (``XMLTextTrimming``) applied by the decoder, never by the parser, so the
///    document model stays lossless.
enum XMLTextUnescaper {
  // MARK: Internal

  /// Decodes a raw character-data slice.
  ///
  /// - Parameters:
  ///   - document: The full document bytes.
  ///   - start: Start offset of the raw slice.
  ///   - end: End offset of the raw slice.
  ///   - firstSpecial: Offset of the first byte needing processing, or `-1`
  ///     when the slice is verbatim. Supplied by the tokenizer so the common
  ///     case costs no scan.
  ///   - isAttributeValue: When `true`, literal whitespace is normalised to a
  ///     space after line-ending normalisation.
  static func decode(
    document: [UInt8],
    start: Int,
    end: Int,
    firstSpecial: Int,
    isAttributeValue: Bool = false
  ) throws -> XMLUnescapedText {
    // Verbatim fast path: no entity, no `]]>`, and (for text) nothing at all
    // to do. A verbatim attribute value still needs whitespace normalisation
    // only if it contains literal whitespace other than a space, which the
    // tokenizer already flagged via `firstSpecial`.
    if firstSpecial < 0 {
      return .verbatim(document[start ..< end])
    }

    var output: [UInt8] = []
    output.reserveCapacity(end - start)

    var index = start
    while index < end {
      let byte = document[index]

      // Phase 1: lexical normalisation and reference expansion.
      //
      // Order matters: a literal CR must be consumed together with a
      // following LF, otherwise CRLF would produce two characters instead
      // of one. In content that means one LF; in an attribute value it
      // means one space. Getting this backwards produces "p\n q" for
      // `p\r\nq`, which is the classic XML normalisation bug.
      if byte == xmlCarriageReturn {
        var next = index + 1
        if next < end, document[next] == xmlLineFeed {
          next += 1
        }
        // In content, CR/CRLF normalises to a single LF (§2.11).
        // In an attribute value, the resulting LF is then itself
        // normalised to a space (§3.3.3), so the pair collapses to one
        // space rather than two.
        output.append(isAttributeValue ? xmlSpace : xmlLineFeed)
        index = next
        continue
      }

      if isAttributeValue, byte == xmlTab || byte == xmlLineFeed {
        // Attribute-value normalisation applies to literal whitespace.
        output.append(xmlSpace)
        index += 1
        continue
      }

      if byte == UInt8(ascii: "&") {
        let (bytes, next) = try decodeReference(document: document, at: index, limit: end)
        // Phase 2: the result of a character reference is *not* subject to
        // lexical normalisation, so append it verbatim.
        output.append(contentsOf: bytes)
        index = next
        continue
      }

      output.append(byte)
      index += 1
    }

    return .decoded(output)
  }

  // MARK: Private

  /// Decodes a single `&…;` reference starting at `ampersand`.
  ///
  /// - Returns: The decoded bytes and the offset just past the reference.
  @inline(__always)
  private static func decodeReference(
    document: [UInt8],
    at ampersand: Int,
    limit: Int
  ) throws -> ([UInt8], Int) {
    var index = ampersand + 1
    guard index < limit else {
      throw XMLParserError.invalidCharacterReference(
        position: xmlPosition(in: document, at: ampersand),
        text: "&"
      )
    }

    if document[index] == UInt8(ascii: "#") {
      return try decodeCharacterReference(document: document, at: index, ampersand: ampersand, limit: limit)
    }

    // Named reference. The name must be non-empty and terminated by ';'.
    let nameStart = index
    while index < limit, document[index] != UInt8(ascii: ";") {
      let byte = document[index]
      guard xmlIsASCIIAlphanumeric(byte) || byte == UInt8(ascii: "_") || byte == UInt8(ascii: "-") || byte == UInt8(ascii: ":") || byte == UInt8(ascii: ".") else {
        throw XMLParserError.invalidCharacterReference(
          position: xmlPosition(in: document, at: ampersand),
          text: preview(document: document, from: ampersand, to: Swift.min(limit, ampersand + 12))
        )
      }
      index += 1
    }
    guard index < limit, index > nameStart else {
      throw XMLParserError.invalidCharacterReference(
        position: xmlPosition(in: document, at: ampersand),
        text: preview(document: document, from: ampersand, to: Swift.min(limit, ampersand + 12))
      )
    }

    let name = document[nameStart ..< index]
    let next = index + 1

    switch name.count {
    case 2 where name.elementsEqual("lt".utf8):
      return ([UInt8(ascii: "<")], next)
    case 2 where name.elementsEqual("gt".utf8):
      return ([UInt8(ascii: ">")], next)
    case 3 where name.elementsEqual("amp".utf8):
      return ([UInt8(ascii: "&")], next)
    case 4 where name.elementsEqual("quot".utf8):
      return ([UInt8(ascii: "\"")], next)
    case 4 where name.elementsEqual("apos".utf8):
      return ([UInt8(ascii: "'")], next)
    default:
      throw XMLParserError.unknownEntity(
        name: String(decoding: name, as: UTF8.self),
        position: xmlPosition(in: document, at: ampersand)
      )
    }
  }

  /// Decodes `&#ddd;` or `&#xhhhh;`.
  @inline(__always)
  private static func decodeCharacterReference(
    document: [UInt8],
    at hash: Int,
    ampersand: Int,
    limit: Int
  ) throws -> ([UInt8], Int) {
    var index = hash + 1
    guard index < limit else {
      throw XMLParserError.invalidCharacterReference(
        position: xmlPosition(in: document, at: ampersand),
        text: "&#"
      )
    }

    let isHexadecimal = document[index] == UInt8(ascii: "x") || document[index] == UInt8(ascii: "X")
    if isHexadecimal {
      index += 1
    }

    let digitsStart = index
    var scalar: UInt32 = 0
    var digitCount = 0

    while index < limit, document[index] != UInt8(ascii: ";") {
      let byte = document[index]
      let digit: UInt32
      if xmlIsASCIIDigit(byte) {
        digit = UInt32(byte - UInt8(ascii: "0"))
      } else if isHexadecimal, xmlIsASCIIHexDigit(byte) {
        digit = UInt32(xmlASCIILowercased(byte) - UInt8(ascii: "a") + 10)
      } else {
        throw XMLParserError.invalidCharacterReference(
          position: xmlPosition(in: document, at: ampersand),
          text: preview(document: document, from: ampersand, to: Swift.min(limit, ampersand + 12))
        )
      }

      // Overflow guard: a character reference longer than 7 digits cannot
      // be a legal scalar, so stop accumulating rather than wrapping.
      if digitCount < 7 {
        scalar = scalar * (isHexadecimal ? 16 : 10) + digit
      }
      digitCount += 1
      index += 1
    }

    guard index < limit, index > digitsStart, digitCount <= 7 else {
      throw XMLParserError.invalidCharacterReference(
        position: xmlPosition(in: document, at: ampersand),
        text: preview(document: document, from: ampersand, to: Swift.min(limit, ampersand + 12))
      )
    }

    guard let unicode = UnicodeScalar(scalar), xmlIsLegalCharacter(scalar) else {
      throw XMLParserError.invalidCharacter(
        scalar: scalar,
        position: xmlPosition(in: document, at: ampersand)
      )
    }

    // Encode the scalar back to UTF-8.
    var buffer: [UInt8] = []
    buffer.reserveCapacity(4)
    var value = unicode.value
    if value < 0x80 {
      buffer.append(UInt8(value))
    } else if value < 0x800 {
      buffer.append(UInt8(0xC0 | (value >> 6)))
      buffer.append(UInt8(0x80 | (value & 0x3F)))
    } else if value < 0x10000 {
      buffer.append(UInt8(0xE0 | (value >> 12)))
      buffer.append(UInt8(0x80 | ((value >> 6) & 0x3F)))
      buffer.append(UInt8(0x80 | (value & 0x3F)))
    } else {
      buffer.append(UInt8(0xF0 | (value >> 18)))
      buffer.append(UInt8(0x80 | ((value >> 12) & 0x3F)))
      buffer.append(UInt8(0x80 | ((value >> 6) & 0x3F)))
      buffer.append(UInt8(0x80 | (value & 0x3F)))
    }
    value = 0

    return (buffer, index + 1)
  }

  /// Renders a short, bounded preview of a slice for diagnostics.
  private static func preview(document: [UInt8], from start: Int, to end: Int) -> String {
    guard start < end, end <= document.count else {
      return ""
    }
    return String(decoding: document[start ..< end], as: UTF8.self)
  }
}
