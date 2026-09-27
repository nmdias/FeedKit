//
// XMLByteUtilities.swift
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

#if canImport(Darwin)
  import Darwin
#elseif canImport(Glibc)
  import Glibc
#endif

// MARK: - Character classification

/// Byte classification tables used by the tokenizer's hot loop.
///
/// A 256-entry `UInt8` table indexed by the byte value replaces a chain of
/// comparisons in the scanner. This is the single highest-leverage
/// micro-optimisation in the tokenizer: the text-scanning loop becomes
/// `while table[buffer[i]] == .ordinary { i += 1 }`.
@inline(__always)
func xmlIsASCIIAlpha(_ byte: UInt8) -> Bool {
  (byte >= 0x41 && byte <= 0x5A) || (byte >= 0x61 && byte <= 0x7A)
}

@inline(__always)
func xmlIsASCIIDigit(_ byte: UInt8) -> Bool {
  byte >= 0x30 && byte <= 0x39
}

@inline(__always)
func xmlIsASCIIAlphanumeric(_ byte: UInt8) -> Bool {
  xmlIsASCIIAlpha(byte) || xmlIsASCIIDigit(byte)
}

@inline(__always)
func xmlIsASCIIHexDigit(_ byte: UInt8) -> Bool {
  xmlIsASCIIDigit(byte) || (byte >= 0x41 && byte <= 0x46) || (byte >= 0x61 && byte <= 0x66)
}

/// Whitespace as defined by XML 1.0 §2.3: space, tab, CR, LF.
///
/// This is deliberately *not* the same set as `CharacterSet.whitespacesAndNewlines`
/// (which includes Unicode spaces such as U+00A0), and deliberately not the same
/// as the JSON whitespace set. Using the XML set is required for correctness.
@inline(__always)
func xmlIsXMLWhitespace(_ byte: UInt8) -> Bool {
  byte == 0x20 || byte == 0x09 || byte == 0x0A || byte == 0x0D
}

/// The XML `S` production value, as a byte.
let xmlSpace: UInt8 = .init(0x20)
let xmlTab: UInt8 = .init(0x09)
let xmlLineFeed: UInt8 = .init(0x0A)
let xmlCarriageReturn: UInt8 = .init(0x0D)

// MARK: - XML 1.0 name characters

/// Returns `true` if `scalar` is an XML 1.0 (5th ed.) `NameStartChar`.
///
/// This is the *full* Unicode production, not an ASCII approximation. Documents
/// in the wild use non-ASCII element names (Japanese, Greek, accented Latin),
/// and rejecting them would make the parser wrong rather than fast.
@inline(__always)
func xmlIsNameStartScalar(_ scalar: UInt32) -> Bool {
  switch scalar {
  case 0x3A,
       0x41 ... 0x5A,
       0x5F,
       0x61 ... 0x7A:
    true
  case 0xC0 ... 0xD6,
       0xD8 ... 0xF6,
       0xF8 ... 0x2FF,
       0x370 ... 0x37D,
       0x37F ... 0x1FFF,
       0x200C ... 0x200D,
       0x2070 ... 0x218F,
       0x2C00 ... 0x2FEF,
       0x3001 ... 0xD7FF,
       0xF900 ... 0xFDCF,
       0xFDF0 ... 0xFFFD,
       0x10000 ... 0xEFFFF:
    true
  default:
    false
  }
}

/// Returns `true` if `scalar` is an XML 1.0 (5th ed.) `NameChar`.
@inline(__always)
func xmlIsNameScalar(_ scalar: UInt32) -> Bool {
  if xmlIsNameStartScalar(scalar) {
    return true
  }
  switch scalar {
  case 0x2D,
       0x2E,
       0x30 ... 0x39,
       0xB7,
       0x0300 ... 0x036F,
       0x203F ... 0x2040:
    return true
  default:
    return false
  }
}

// MARK: - Legal XML characters

/// Returns `true` if `scalar` is a legal XML 1.0 `Char`.
///
/// The `Char` production excludes most C0 controls, the surrogate range, and
/// `U+FFFE`/`U+FFFF`. Enforcing it is what makes control-character injection
/// into a generated document impossible.
@inline(__always)
func xmlIsLegalCharacter(_ scalar: UInt32) -> Bool {
  switch scalar {
  case 0x09,
       0x0A,
       0x0D:
    true
  case 0x20 ... 0xD7FF:
    true
  case 0xE000 ... 0xFFFD:
    true
  case 0x10000 ... 0x10FFFF:
    true
  default:
    false
  }
}

// MARK: - Byte sequence comparison

/// Compares a slice of `storage` against `other`, byte for byte.
///
/// Equivalent to `memcmp` but expressed so it does not need unsafe pointers and
/// so the compiler can vectorise it. Used for element-name lookups, which are
/// the second-hottest operation in the decoder after tokenisation.
@inline(__always)
func xmlBytesEqual(
  _ storage: [UInt8],
  _ start: Int,
  _ length: Int,
  _ other: [UInt8]
) -> Bool {
  guard length == other.count else {
    return false
  }
  guard length > 0 else {
    return true
  }
  return storage.withUnsafeBufferPointer { storageBuffer in
    other.withUnsafeBufferPointer { otherBuffer in
      guard let lhs = storageBuffer.baseAddress, let rhs = otherBuffer.baseAddress else {
        return false
      }
      return memcmp(lhs + start, rhs, length) == 0
    }
  }
}

/// Compares two slices of the *same* byte array, byte for byte.
///
/// The same-array form exists so callers can compare names without materialising
/// either as an `ArraySlice`, whose generic `Sequence` comparison is markedly
/// slower for the short strings that element and attribute names always are.
@inline(__always)
func xmlBytesEqual(
  _ storage: [UInt8],
  _ leftStart: Int,
  _ leftLength: Int,
  _ otherStorage: [UInt8],
  _ rightStart: Int
) -> Bool {
  guard leftLength >= 0 else {
    return false
  }
  guard leftLength > 0 else {
    return true
  }
  guard rightStart >= 0, leftStart >= 0,
        leftStart + leftLength <= storage.count,
        rightStart + leftLength <= otherStorage.count
  else {
    return false
  }
  return storage.withUnsafeBufferPointer { left in
    otherStorage.withUnsafeBufferPointer { right in
      guard let leftBase = left.baseAddress, let rightBase = right.baseAddress else {
        return false
      }
      return memcmp(leftBase + leftStart, rightBase + rightStart, leftLength) == 0
    }
  }
}

/// Compares a slice of `storage` against a UTF-8 string literal pattern.
@inline(__always)
func xmlBytesEqual(
  _ storage: [UInt8],
  _ start: Int,
  _ length: Int,
  _ other: UnsafeBufferPointer<UInt8>
) -> Bool {
  guard length == other.count else {
    return false
  }
  guard length > 0 else {
    return true
  }
  return storage.withUnsafeBufferPointer { storageBuffer in
    guard let lhs = storageBuffer.baseAddress, let rhs = other.baseAddress else {
      return false
    }
    return memcmp(lhs + start, rhs, length) == 0
  }
}

/// Returns `true` when `storage[start..<start+length]` consists solely of XML
/// whitespace.
@inline(__always)
func xmlIsAllWhitespace(_ storage: [UInt8], _ start: Int, _ end: Int) -> Bool {
  var index = start
  while index < end {
    if !xmlIsXMLWhitespace(storage[index]) {
      return false
    }
    index += 1
  }
  return true
}

// MARK: - ASCII case conversion

@inline(__always)
func xmlASCIIUppercased(_ byte: UInt8) -> UInt8 {
  (byte >= 0x61 && byte <= 0x7A) ? byte - 0x20 : byte
}

@inline(__always)
func xmlASCIILowercased(_ byte: UInt8) -> UInt8 {
  (byte >= 0x41 && byte <= 0x5A) ? byte + 0x20 : byte
}

/// Case-insensitive ASCII comparison against a lowercase ASCII pattern.
///
/// Used for the reserved markup keywords (`xml`, `version`, `encoding`,
/// `standalone`, `CDATA`, `DOCTYPE`), all of which are ASCII by definition, so
/// byte-wise ASCII folding is exactly correct and needs no Unicode tables.
@inline(__always)
func xmlBytesEqualFoldedASCII(
  _ storage: [UInt8],
  _ start: Int,
  _ length: Int,
  _ lowercasePattern: [UInt8]
) -> Bool {
  guard length == lowercasePattern.count, start >= 0, start + length <= storage.count else {
    return false
  }
  var offset = 0
  while offset < length {
    if xmlASCIILowercased(storage[start + offset]) != lowercasePattern[offset] {
      return false
    }
    offset += 1
  }
  return true
}

// NOTE: there is deliberately no `xmlBytesEqualFoldedASCII(_:_:)` overload that
// compares a whole array against a pattern. An earlier version had one, and it
// silently ignored the offset arguments at its call sites, so every reserved
// keyword check searched from byte 0 of the document. Removing the overload made
// that mistake impossible to express.

// MARK: - UTF-8 validation

/// The outcome of validating UTF-8 input.
enum UTF8ValidationOutcome: Equatable {
  case valid
  /// `offset` is the byte offset of the first byte of the offending sequence.
  case invalid(offset: Int)
}

/// Validates that `bytes` is well-formed UTF-8, returning the offset of the
/// first error.
///
/// Hand-rolled rather than `String(decoding:)`-based because:
///  * it must report a byte offset (Swift's repair path does not);
///  * it must run before tokenisation so that no malformed sequence can be
///    silently repaired into `U+FFFD` and then written back out;
///  * it avoids allocating a `String` for the sole purpose of throwing it away.
///
/// The implementation is the branch-light DFA-free formulation: each lead byte
/// validates its continuation count and range, with explicit rejection of
/// overlong forms, surrogates, and values above `U+10FFFF`.
func xmlValidateUTF8(_ bytes: [UInt8]) -> UTF8ValidationOutcome {
  bytes.withUnsafeBufferPointer { buffer in
    xmlValidateUTF8(buffer)
  }
}

func xmlValidateUTF8(_ buffer: UnsafeBufferPointer<UInt8>) -> UTF8ValidationOutcome {
  guard let base = buffer.baseAddress else {
    return .valid
  }
  let count = buffer.count
  var index = 0

  while index < count {
    let byte = base[index]
    if byte < 0x80 {
      index += 1
      continue
    }

    var scalar: UInt32
    let width: Int

    if byte & 0xE0 == 0xC0 {
      width = 2
      scalar = UInt32(byte & 0x1F)
    } else if byte & 0xF0 == 0xE0 {
      width = 3
      scalar = UInt32(byte & 0x0F)
    } else if byte & 0xF8 == 0xF0 {
      width = 4
      scalar = UInt32(byte & 0x07)
    } else {
      // Continuation byte as lead, or an invalid 0xF8...0xFF lead.
      return .invalid(offset: index)
    }

    guard index + width <= count else {
      return .invalid(offset: index)
    }

    for offset in 1 ..< width {
      let continuation = base[index + offset]
      guard continuation & 0xC0 == 0x80 else {
        return .invalid(offset: index)
      }
      scalar = (scalar << 6) | UInt32(continuation & 0x3F)
    }

    // Reject overlong encodings, surrogate halves, and out-of-range scalars.
    switch width {
    case 2 where scalar < 0x80:
      return .invalid(offset: index)
    case 3 where scalar < 0x800:
      return .invalid(offset: index)
    case 4 where scalar < 0x10000:
      return .invalid(offset: index)
    default:
      break
    }
    if scalar > 0x10FFFF {
      return .invalid(offset: index)
    }
    if scalar >= 0xD800, scalar <= 0xDFFF {
      return .invalid(offset: index)
    }

    index += width
  }

  return .valid
}

// MARK: - Line/column resolution

/// The byte offsets at which each line begins, for turning offsets into
/// line/column pairs without rescanning.
///
/// ## Why this exists
///
/// The obvious implementation of "which line is byte 40 000 on?" scans from the
/// start of the document. That is fine for a single error and catastrophic for a
/// corpus of them: a soak test or fuzz run that triggers one error per element
/// becomes quadratic in document size — which is exactly the pathology a parser
/// must not have, and which a security test with 200 000 elements exposed.
///
/// Building the table once turns each later lookup into a binary search. It is
/// constructed lazily, only when a position is first needed, so a successful
/// parse with no diagnostics pays nothing at all.
struct XMLLineTable {
  // MARK: Lifecycle

  init(bytes: [UInt8]) {
    var starts: [Int] = [0]
    starts.reserveCapacity(64)
    var index = 0
    while index < bytes.count {
      let byte = bytes[index]
      if byte == xmlLineFeed {
        starts.append(index + 1)
        index += 1
      } else if byte == xmlCarriageReturn {
        // CRLF is one break, not two, so that the reported line matches
        // what an editor shows for a document using Windows line endings.
        if index + 1 < bytes.count, bytes[index + 1] == xmlLineFeed {
          index += 2
        } else {
          index += 1
        }
        starts.append(index)
      } else {
        index += 1
      }
    }
    lineStarts = starts
    byteCount = bytes.count
  }

  // MARK: Internal

  /// The 1-based line and column for `offset`.
  ///
  /// The column counts bytes from the start of the line, which is what a
  /// terminal shows for ASCII text and the only measure computable without
  /// decoding the line.
  func position(at offset: Int) -> (line: Int, column: Int) {
    let clamped = max(0, min(offset, byteCount))

    // Binary search for the last line start at or before `clamped`.
    var low = 0
    var high = lineStarts.count - 1
    while low < high {
      let middle = (low + high + 1) / 2
      if lineStarts[middle] <= clamped {
        low = middle
      } else {
        high = middle - 1
      }
    }
    return (line: low + 1, column: clamped - lineStarts[low] + 1)
  }

  // MARK: Private

  /// Byte offsets of the first byte of each line. Always begins with `0`.
  private let lineStarts: [Int]
  private let byteCount: Int
}

/// Computes a 1-based line and column for a byte offset.
///
/// A convenience for callers that need a single position; prefer
/// ``XMLLineTable`` when more than one is needed.
func xmlLineAndColumn(in bytes: [UInt8], atOffset offset: Int) -> (line: Int, column: Int) {
  XMLLineTable(bytes: bytes).position(at: offset)
}

// MARK: - String trimming

extension String {
  /// This string without leading or trailing spaces and tabs.
  func trimmingXMLSpaces() -> String {
    var start = startIndex
    var end = endIndex
    while start < end, self[start] == " " || self[start] == "\t" {
      start = index(after: start)
    }
    while end > start, self[index(before: end)] == " " || self[index(before: end)] == "\t" {
      end = index(before: end)
    }
    return String(self[start ..< end])
  }

  /// This string without leading or trailing XML whitespace.
  func trimmingXMLWhitespace() -> String {
    var start = startIndex
    var end = endIndex
    while start < end, isXMLWhitespace(self[start]) {
      start = index(after: start)
    }
    while end > start, isXMLWhitespace(self[index(before: end)]) {
      end = index(before: end)
    }
    return String(self[start ..< end])
  }

  private func isXMLWhitespace(_ character: Character) -> Bool {
    character == " " || character == "\t" || character == "\n" || character == "\r"
  }
}
