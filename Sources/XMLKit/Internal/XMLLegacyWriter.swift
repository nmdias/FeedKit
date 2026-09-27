//
// XMLLegacyWriter.swift
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

/// The one spelling difference between the engine's serialiser and the one
/// XMLKit published before this migration.
///
/// XMLKit wrote an empty element as `<name />`; the engine writes `<name/>`.
/// Both are XML, and a caller that parses the output cannot tell them apart —
/// but a caller that compares it against a stored document, or signs it, can.
/// Rather than ask every caller to adapt, the documents this release emits keep
/// the spelling they have always had.
enum XMLLegacyWriter {
  // MARK: Internal

  /// Inserts the space XMLKit puts before the slash of an empty element.
  ///
  /// The scan is lexical, not textual: `/>` inside text, a comment, a CDATA
  /// section, a processing instruction or an attribute value is left alone, so
  /// only real markup is rewritten.
  ///
  /// - Parameter bytes: The serialised document.
  /// - Returns: The same document, with `<name/>` written `<name />`.
  static func applyingLegacyEmptyElementSpacing(to bytes: [UInt8]) -> [UInt8] {
    var result: [UInt8] = []
    result.reserveCapacity(bytes.count + 16)

    var index = 0
    while index < bytes.count {
      let byte = bytes[index]

      guard byte == UInt8(ascii: "<") else {
        result.append(byte)
        index += 1
        continue
      }

      // Constructs whose content is not markup: copy them verbatim, so a `/>`
      // inside one of them is never mistaken for an empty element's slash.
      if let terminator = verbatimTerminator(at: index, in: bytes) {
        let end = indexOf(terminator, in: bytes, from: index + terminator.count)
        let stop = end.map { $0 + terminator.count } ?? bytes.count
        result.append(contentsOf: bytes[index ..< stop])
        index = stop
        continue
      }

      let end = endOfTag(in: bytes, from: index)
      if end > index + 1, bytes[end - 1] == UInt8(ascii: "/") {
        result.append(contentsOf: bytes[index ..< (end - 1)])
        result.append(UInt8(ascii: " "))
        result.append(contentsOf: bytes[(end - 1) ... end])
      } else {
        result.append(contentsOf: bytes[index ... end])
      }
      index = end + 1
    }

    return result
  }

  // MARK: Private

  /// The terminator of the construct starting at `offset`, when that construct is
  /// copied verbatim.
  private static func verbatimTerminator(at offset: Int, in bytes: [UInt8]) -> [UInt8]? {
    let constructs: [(opening: String, terminator: String)] = [
      ("<!--", "-->"),
      ("<![CDATA[", "]]>"),
      ("<?", "?>")
    ]
    for construct in constructs where matches(bytes, at: offset, construct.opening) {
      return ASCII(construct.terminator)
    }
    // A DOCTYPE has no terminator of its own; it is skipped whole below.
    return nil
  }

  /// The offset of the `>` ending the tag that starts at `offset`, ignoring `>`
  /// inside a quoted attribute value.
  private static func endOfTag(in bytes: [UInt8], from offset: Int) -> Int {
    var index = offset + 1
    var quote: UInt8?

    while index < bytes.count {
      let byte = bytes[index]
      if let openQuote = quote {
        if byte == openQuote {
          quote = nil
        }
      } else if byte == UInt8(ascii: "\"") || byte == UInt8(ascii: "'") {
        quote = byte
      } else if byte == UInt8(ascii: ">") {
        return index
      }
      index += 1
    }

    return bytes.count - 1
  }

  /// The offset of `needle` at or after `start`.
  private static func indexOf(_ needle: [UInt8], in bytes: [UInt8], from start: Int) -> Int? {
    var index = max(start, 0)
    while index + needle.count <= bytes.count {
      if matches(bytes, at: index, needle) {
        return index
      }
      index += 1
    }
    return nil
  }

  /// Whether `needle` appears at `offset`.
  private static func matches(_ bytes: [UInt8], at offset: Int, _ needle: String) -> Bool {
    matches(bytes, at: offset, ASCII(needle))
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

  /// The bytes of an ASCII literal.
  private static func ASCII(_ string: String) -> [UInt8] {
    Array(string.utf8)
  }
}
