//
// XMLDecoderInput.swift
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
import XMLKitCore

/// Turns the bytes of a document into the engine's root element, applying the
/// tolerance XMLKit has always shown towards real-world feeds.
///
/// The engine parses strictly, and for good reason: strictness is what makes its
/// security guarantees possible. Feeds, however, are not strict — they use
/// prefixes they never declare, carry trailing bytes after the root element, and
/// are published in encodings other than UTF-8. XMLKit has always accepted those
/// documents, and FeedKit's fixtures contain all three, so the adaptations live
/// here, in front of the engine, instead of weakening it.
///
/// The encoding is resolved before parsing, from the declaration and the first
/// bytes; each of the remaining remedies costs a re-parse and is only attempted
/// when the engine reports the problem it addresses, so a UTF-8 document that
/// declares no stray prefixes is parsed exactly once.
enum XMLDecoderInput {
  // MARK: Internal

  /// The root element of `data`.
  /// - Parameter data: The document's bytes, in whatever encoding it declares.
  /// - Returns: The document's root element.
  /// - Throws: `XMLParserError` when the document cannot be parsed even after
  ///   the compatibility remedies below.
  static func rootElement(from data: Data) throws -> XMLKitCore.XMLElement {
    var bytes: [UInt8] = .init(data)
    var declaredPrefixes: Set<String> = []
    var didTranscode = false
    var didTrimTrailingContent = false

    // A document that says it is not UTF-8, or whose first bytes can only be
    // UTF-16, is converted before it is parsed. Doing it here rather than in
    // response to an error matters because UTF-16 bytes fail the engine's *name*
    // rules before its encoding rules, and a diagnosis of "invalid XML name" is
    // not a reason a caller could act on.
    if let encoding = declaredNonUTF8Encoding(in: bytes) ?? byteOrderEncoding(in: bytes) {
      bytes = transcoding(bytes, using: encoding)
    }

    // Every remedy makes progress towards a parseable document, so the loop
    // terminates; the bound is a guard against a malformed error report turning
    // that reasoning into an infinite loop.
    for _ in 0 ..< 32 {
      do {
        return try parse(bytes).root
      } catch let error as XMLParserError {
        switch error {
        case .invalidUTF8 where !didTranscode:
          // Bytes that no declaration accounts for: fall back to the encodings
          // XMLKit has always tried.
          bytes = transcodedToUTF8(bytes)
          didTranscode = true

        case let .undeclaredNamespacePrefix(prefix, position):
          guard !declaredPrefixes.contains(prefix) else {
            throw error
          }
          declaredPrefixes.insert(prefix)
          bytes = declaring(prefixes: [prefix], in: bytes, at: position.byteOffset)

        case let .unexpectedContent(position, _) where !didTrimTrailingContent:
          // Content the engine rejects may be junk *after* a complete document,
          // which XMLKit has always ignored: some feeds append bytes such as
          // "[]" to the XML. If everything before the offending content is a
          // document, that document is the answer.
          didTrimTrailingContent = true
          let end = min(max(position.byteOffset, 0), bytes.count)
          guard !bytes[..<end].isEmpty, let document = try? parse(Array(bytes[..<end])) else {
            throw error
          }
          return document.root

        default:
          throw error
        }
      }
    }

    throw XMLError.unexpected(reason: "The document could not be parsed after applying compatibility remedies.")
  }

  // MARK: Private

  /// Encodings tried, in order, when the document declares none and is not valid
  /// UTF-8. The list is the one the previous implementation used, which was
  /// chosen for the encodings feeds are actually published in.
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

  /// Parses well-formed UTF-8 bytes.
  private static func parse(_ bytes: [UInt8]) throws -> XMLKitCore.XMLDocument {
    try XMLKitCore.XMLDocument(bytes: bytes)
  }

  /// Re-encodes `bytes` as UTF-8, using a byte order mark or the shape of the
  /// first bytes when the document has one, then the encoding it declares, then
  /// the encodings XMLKit has always tried.
  private static func transcodedToUTF8(_ bytes: [UInt8]) -> [UInt8] {
    let data: Data = .init(bytes)

    // A byte order mark, or the byte pattern of a UTF-16 document without one,
    // is decisive and has to be checked before the declaration: a UTF-16
    // declaration cannot be read as ASCII, and a single-byte fallback would
    // "succeed" on UTF-16 bytes and produce mojibake.
    if let encoding = byteOrderEncoding(in: bytes) {
      return transcoding(bytes, using: encoding)
    }

    if let name = declaredEncoding(in: bytes), let encoding = stringEncoding(named: name),
       let string = String(data: data, encoding: encoding)
    {
      return Array(string.utf8)
    }

    for encoding in fallbackEncodings {
      if let string = String(data: data, encoding: encoding) {
        return Array(string.utf8)
      }
    }

    return bytes
  }

  /// Re-encodes `bytes` as UTF-8 using `encoding`, or returns them unchanged when
  /// they are not valid in it.
  private static func transcoding(_ bytes: [UInt8], using encoding: String.Encoding) -> [UInt8] {
    guard let string = String(data: Data(bytes), encoding: encoding) else { return bytes }
    return Array(string.utf8)
  }

  /// The encoding a document declares, when it declares one other than UTF-8.
  ///
  /// `nil` for a UTF-8 document — the common case, which must not pay for a
  /// conversion — and for an encoding name this platform does not know.
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

    // `<?xml` in UTF-16, most significant byte first, is 00 3C 00 3F; least
    // significant byte first it is 3C 00 3F 00.
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
    // The declaration is required to be at the very start of the document.
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
  /// The engine rejects a prefixed name whose prefix is not declared, and some
  /// feeds rely on the leniency of the parser XMLKit used before this migration,
  /// which ignored prefixes. Declaring the prefix on the document element covers
  /// every use in the document, and keeps the document's names exactly as
  /// written — only the namespace *resolution* changes, and the decoder matches
  /// on names as written.
  ///
  /// - Parameters:
  ///   - prefixes: The prefixes to declare.
  ///   - bytes: The document.
  ///   - offset: Where the engine reported the first use, used only when the
  ///     document element cannot be located — which cannot happen for a document
  ///     that got this far.
  /// - Returns: The document with the declarations added.
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
      declaration += " xmlns:\(prefix)=\"urn:xmlkit:undeclared:\(prefix)\""
    }

    var result = bytes
    result.insert(contentsOf: Array(declaration.utf8), at: insertion)
    return result
  }

  /// The offset just after the document element's name, where attributes are
  /// written, or `nil` when the document has no element.
  ///
  /// The prolog is skipped rather than searched: an XML declaration, a comment, a
  /// processing instruction or a DOCTYPE can all contain a `>` that is not the end
  /// of a tag, and the first `<` that starts none of them begins the document
  /// element.
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
        if matches(bytes, at: index, ASCII("<!--")) {
          index = skip(bytes, from: index + 4, until: ASCII("-->")) + 3
        } else if matches(bytes, at: index, ASCII("<![CDATA[")) {
          index = skip(bytes, from: index + 9, until: ASCII("]]>")) + 3
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

  /// Whether `needle` appears at `offset`.
  private static func matches(_ bytes: [UInt8], at offset: Int, _ needle: [UInt8]) -> Bool {
    guard offset + needle.count <= bytes.count else {
      return false
    }
    for (index, byte) in needle.enumerated() where bytes[offset + index] != byte {
      return false
    }
    return true
  }

  /// The bytes of an ASCII literal.
  private static func ASCII(_ string: String) -> [UInt8] {
    Array(string.utf8)
  }
}
