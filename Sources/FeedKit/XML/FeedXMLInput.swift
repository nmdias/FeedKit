//
// FeedXMLInput.swift
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
import XMLKit

/// Decoding entry point for feed documents, with the tolerance real feeds need.
///
/// XMLKit parses strictly, and for good reason: strictness is what makes its
/// guarantees about entities, depth and encodings possible. Feeds are not
/// strict, and FeedKit has always accepted them anyway:
///
/// - they are published in encodings other than UTF-8,
/// - they use namespace prefixes they never declare,
/// - they carry bytes after the document element, such as a trailing `[]`.
///
/// Each remedy is applied in front of the parser, and only when the parser
/// reports the problem it addresses, so a well-formed UTF-8 document is parsed
/// exactly once.
enum FeedXMLInput {
  // MARK: Internal

  /// Decodes a feed value from `data`.
  /// - Parameters:
  ///   - type: The feed type to decode.
  ///   - data: The document's bytes, in whatever encoding it declares.
  /// - Returns: The decoded value.
  /// - Throws: `XMLParserError` when the document cannot be parsed even after
  ///   the remedies below, or a `DecodingError` when it does not match `type`.
  static func decode<T: Decodable>(_: T.Type, from data: Data) throws -> T {
    var bytes: [UInt8] = .init(data)
    var declaredPrefixes: Set<String> = []
    var didTranscode = false
    var didTrimTrailingContent = false

    // A document that says it is not UTF-8, or whose first bytes can only be
    // UTF-16, is converted before it is parsed. Doing it here rather than in
    // response to an error matters because UTF-16 bytes fail the parser's *name*
    // rules before its encoding rules, and "invalid XML name" is not a diagnosis
    // a caller could act on.
    if let encoding = declaredNonUTF8Encoding(in: bytes) ?? byteOrderEncoding(in: bytes) {
      bytes = transcoding(bytes, using: encoding)
    }

    // Every remedy makes progress towards a parseable document, so the loop
    // terminates; the bound guards against a malformed report turning that
    // reasoning into an infinite loop.
    for _ in 0 ..< 32 {
      do {
        return try decoder().decode(T.self, from: bytes)
      } catch let error as XMLParserError {
        switch error {
        case .invalidUTF8 where !didTranscode:
          bytes = transcodedToUTF8(bytes)
          didTranscode = true

        case let .undeclaredNamespacePrefix(prefix, position):
          guard !declaredPrefixes.contains(prefix) else {
            throw error
          }
          declaredPrefixes.insert(prefix)
          bytes = declaring(prefixes: [prefix], in: bytes, at: position.byteOffset)

        case let .unexpectedContent(position, _) where !didTrimTrailingContent:
          // Content the parser rejects may be junk *after* a complete document.
          // If everything before the offending content is a document, that
          // document is the answer.
          didTrimTrailingContent = true
          let end = min(max(position.byteOffset, 0), bytes.count)
          guard !bytes[..<end].isEmpty, let value = try? decoder().decode(T.self, from: Array(bytes[..<end])) else {
            throw error
          }
          return value

        default:
          throw error
        }
      }
    }

    throw XMLParserError.malformedMarkup(
      position: .init(byteOffset: 0, line: 1, column: 1),
      reason: "the document could not be parsed after applying FeedKit's compatibility remedies"
    )
  }

  // MARK: Private

  /// Encodings tried when the document declares none and is not valid UTF-8.
  private static let fallbackEncodings: [String.Encoding] = [
    .utf8,
    .isoLatin1,
    .windowsCP1252,
    .shiftJIS,
    .utf16,
    .utf16LittleEndian,
    .utf16BigEndian,
    .isoLatin2,
    .windowsCP1250,
    .windowsCP1251
  ]

  /// The decoder FeedKit reads feeds with.
  private static func decoder() -> XMLDecoder {
    var decoder: XMLDecoder = .init()
    // Namespaces are keyed by URI, so a feed that writes Dublin Core under a
    // prefix other than `dc` — which happens — still decodes.
    decoder.namespaceStrategy = .uri
    // Publishers pad attribute values — `length="169600320 "` — and a number
    // with a trailing space is not a number.
    decoder.attributeTrimming = .whitespaceAndNewlines
    return decoder
  }

  /// Re-encodes `bytes` as UTF-8, using a byte order mark or the shape of the
  /// first bytes when the document has one, then the encoding it declares, then
  /// the encodings FeedKit has always tried.
  private static func transcodedToUTF8(_ bytes: [UInt8]) -> [UInt8] {
    if let encoding = byteOrderEncoding(in: bytes) {
      return transcoding(bytes, using: encoding)
    }
    if let name = declaredEncoding(in: bytes), let encoding = stringEncoding(named: name) {
      return transcoding(bytes, using: encoding)
    }
    for encoding in fallbackEncodings {
      if let string = String(data: Data(bytes), encoding: encoding) {
        return Array(string.utf8)
      }
    }
    return bytes
  }

  /// Re-encodes `bytes` as UTF-8 using `encoding`, or returns them unchanged when
  /// they are not valid in it.
  private static func transcoding(_ bytes: [UInt8], using encoding: String.Encoding) -> [UInt8] {
    guard let string = String(data: Data(bytes), encoding: encoding) else {
      return bytes
    }
    return Array(string.utf8)
  }

  /// The encoding a document declares, when it declares one other than UTF-8.
  private static func declaredNonUTF8Encoding(in bytes: [UInt8]) -> String.Encoding? {
    guard let name = declaredEncoding(in: bytes), let encoding = stringEncoding(named: name) else {
      return nil
    }
    return encoding == .utf8 ? nil : encoding
  }

  /// The encoding implied by a byte order mark, or by the alternating pattern of
  /// zeros that a BOM-less UTF-16 document starts with.
  private static func byteOrderEncoding(in bytes: [UInt8]) -> String.Encoding? {
    if bytes.count >= 2 {
      switch (bytes[0], bytes[1]) {
      case (0xFF, 0xFE): return .utf16LittleEndian
      case (0xFE, 0xFF): return .utf16BigEndian
      default: break
      }
    }
    if bytes.count >= 4 {
      if bytes[0] == 0x00, bytes[1] == UInt8(ascii: "<"), bytes[2] == 0x00, bytes[3] == UInt8(ascii: "?") {
        return .utf16BigEndian
      }
      if bytes[0] == UInt8(ascii: "<"), bytes[1] == 0x00, bytes[2] == UInt8(ascii: "?"), bytes[3] == 0x00 {
        return .utf16LittleEndian
      }
    }
    return nil
  }

  /// The value of the `encoding` pseudo-attribute of the XML declaration, when
  /// the document has one within its first bytes.
  private static func declaredEncoding(in bytes: [UInt8]) -> String? {
    guard bytes.count > 5, bytes[0] == UInt8(ascii: "<"), bytes[1] == UInt8(ascii: "?") else {
      return nil
    }
    let limit = min(bytes.count, 256)
    guard let end = (2 ..< limit).first(where: { bytes[$0] == UInt8(ascii: ">") }) else {
      return nil
    }
    let declaration: String = .init(decoding: bytes[0 ... end], as: UTF8.self)
    guard let range = declaration.range(of: "encoding") else {
      return nil
    }
    let remainder = declaration[range.upperBound...]
    guard let equals = remainder.firstIndex(of: "=") else {
      return nil
    }
    let value = remainder[remainder.index(after: equals)...].drop { $0 == " " || $0 == "\t" }
    guard let quote = value.first, quote == "\"" || quote == "'" else {
      return nil
    }
    let quoted = value.dropFirst()
    guard let closing = quoted.firstIndex(of: quote) else {
      return nil
    }
    return String(quoted[..<closing])
  }

  /// The `String.Encoding` for an encoding name as written in a declaration.
  private static func stringEncoding(named name: String) -> String.Encoding? {
    switch name.lowercased() {
    case "utf-8",
         "utf8": .utf8
    case "utf-16",
         "utf16": .utf16
    case "utf-16le": .utf16LittleEndian
    case "utf-16be": .utf16BigEndian
    case "iso-8859-1",
         "iso8859-1",
         "latin-1",
         "latin1": .isoLatin1
    case "iso-8859-2",
         "iso8859-2",
         "latin2": .isoLatin2
    case "cp1250",
         "windows-1250": .windowsCP1250
    case "cp1251",
         "windows-1251": .windowsCP1251
    case "cp1252",
         "windows-1252": .windowsCP1252
    case "shift_jis",
         "shift-jis",
         "sjis": .shiftJIS
    case "ascii",
         "us-ascii": .ascii
    default: nil
    }
  }

  /// Declares `prefixes` on the document element's start tag.
  ///
  /// Some feeds use a prefix without declaring it, which the parser XMLKit used
  /// before this migration ignored. Declaring it at the document element covers
  /// every use, and leaves the document's names exactly as written.
  private static func declaring(prefixes: Set<String>, in bytes: [UInt8], at offset: Int) -> [UInt8] {
    guard !prefixes.isEmpty else {
      return bytes
    }
    let insertion = rootTagInsertionPoint(in: bytes) ?? tagInsertionPoint(in: bytes, at: offset)
    guard let insertion else {
      return bytes
    }

    var declaration = ""
    for prefix in prefixes.sorted() {
      declaration += " xmlns:\(prefix)=\"urn:feedkit:undeclared:\(prefix)\""
    }

    var result = bytes
    result.insert(contentsOf: Array(declaration.utf8), at: insertion)
    return result
  }

  /// The offset just after the document element's name, where attributes are
  /// written, or `nil` when the document has no element.
  private static func rootTagInsertionPoint(in bytes: [UInt8]) -> Int? {
    var index = 0
    while index < bytes.count {
      guard bytes[index] == UInt8(ascii: "<") else {
        index += 1
        continue
      }
      let next = index + 1 < bytes.count ? bytes[index + 1] : 0
      switch next {
      case UInt8(ascii: "?"):
        index = skip(bytes, from: index + 2, until: [UInt8(ascii: "?"), UInt8(ascii: ">")]) + 2

      case UInt8(ascii: "!"):
        if matches(bytes, at: index, "<!--") {
          index = skip(bytes, from: index + 4, until: Array("-->".utf8)) + 3
        } else if matches(bytes, at: index, "<![CDATA[") {
          index = skip(bytes, from: index + 9, until: Array("]]>".utf8)) + 3
        } else {
          index = skip(bytes, from: index + 2, until: [UInt8(ascii: ">")]) + 1
        }

      case UInt8(ascii: "/"):
        index += 1

      default:
        var end = index + 1
        while end < bytes.count, !isNameTerminator(bytes[end]) {
          end += 1
        }
        return end
      }
    }
    return nil
  }

  /// The offset just after the name of the start tag containing `offset`.
  private static func tagInsertionPoint(in bytes: [UInt8], at offset: Int) -> Int? {
    var tagStart = min(max(offset, 0), max(bytes.count - 1, 0))
    while tagStart > 0, bytes[tagStart] != UInt8(ascii: "<") {
      tagStart -= 1
    }
    guard bytes.indices.contains(tagStart), bytes[tagStart] == UInt8(ascii: "<") else {
      return nil
    }
    var insertion = tagStart + 1
    while insertion < bytes.count, !isNameTerminator(bytes[insertion]) {
      insertion += 1
    }
    return insertion
  }

  /// Whether a byte ends an element or attribute name.
  private static func isNameTerminator(_ byte: UInt8) -> Bool {
    byte == UInt8(ascii: ">") || byte == UInt8(ascii: "/") || byte == UInt8(ascii: " ")
      || byte == UInt8(ascii: "\t") || byte == UInt8(ascii: "\n") || byte == UInt8(ascii: "\r")
  }

  /// The offset of `terminator`, or the end of the input.
  private static func skip(_ bytes: [UInt8], from start: Int, until terminator: [UInt8]) -> Int {
    var index = start
    while index + terminator.count <= bytes.count {
      if matches(bytes, at: index, terminator) {
        return index
      }
      index += 1
    }
    return bytes.count
  }

  /// Whether the byte sequence `needle` appears at `offset`.
  private static func matches(_ bytes: [UInt8], at offset: Int, _ needle: String) -> Bool {
    matches(bytes, at: offset, Array(needle.utf8))
  }

  /// Whether the byte sequence `needle` appears at `offset`.
  private static func matches(_ bytes: [UInt8], at offset: Int, _ needle: [UInt8]) -> Bool {
    guard offset + needle.count <= bytes.count else {
      return false
    }
    for (index, byte) in needle.enumerated() where bytes[offset + index] != byte {
      return false
    }
    return true
  }
}
