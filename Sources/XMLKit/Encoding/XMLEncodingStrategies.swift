//
// XMLEncodingStrategies.swift
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

/// Formatting options for ``XMLEncoder``.
///
/// An `OptionSet` rather than an enum, matching `JSONEncoder.OutputFormatting`,
/// so that options compose.
public struct XMLOutputFormatting: OptionSet, Sendable, Hashable {
  // MARK: Lifecycle

  public init(rawValue: Int) {
    self.rawValue = rawValue
  }

  // MARK: Public

  /// Indent nested elements.
  ///
  /// Inserts whitespace into the document. Safe for element-only content; an
  /// element whose content is text is never re-indented, because that would
  /// change its value. See ``XMLWriterConfiguration/prettyPrinted``.
  public static let prettyPrinted: XMLOutputFormatting = .init(rawValue: 1 << 0)

  /// Emit attributes in name order rather than insertion order.
  ///
  /// Makes output byte-for-byte reproducible, which matters for signing,
  /// caching and diffing. It does not affect meaning: XML attribute order is
  /// not significant.
  public static let sortedAttributes: XMLOutputFormatting = .init(rawValue: 1 << 1)

  /// Write empty elements as `<a></a>` instead of `<a/>`.
  ///
  /// Some consumers — notably a few legacy SOAP and HTML-derived toolkits —
  /// reject the self-closing form. Both are valid XML and mean the same thing.
  public static let explicitEmptyElements: XMLOutputFormatting = .init(rawValue: 1 << 2)

  /// Escape `>` in text as `&gt;`.
  ///
  /// Not required by XML, but harmless and safe against consumers that scan for
  /// `>` without parsing.
  public static let escapeGreaterThan: XMLOutputFormatting = .init(rawValue: 1 << 3)

  /// Emit text in CDATA sections where the value came from a CDATA coding key.
  public static let useCDATAForCDATAKeys: XMLOutputFormatting = .init(rawValue: 1 << 4)

  public let rawValue: Int
}

/// How ``XMLEncoder`` converts special Swift values to text.
public enum XMLDateEncodingStrategy: Sendable, Hashable {
  /// ISO 8601 with a `Z` time zone and no fractional seconds.
  ///
  /// The default, because it is the only widely interoperable spelling and it
  /// sorts lexicographically.
  case iso8601

  /// ISO 8601 including fractional seconds.
  case iso8601WithFractionalSeconds

  /// Seconds since 1970, as a decimal number.
  case secondsSince1970

  /// Milliseconds since 1970.
  case millisecondsSince1970

  /// A `DateFormatter` configured with the given format string.
  ///
  /// The formatter is created per encode call, because `DateFormatter` is not
  /// `Sendable` and caching one in a `Sendable` encoder would be a data race.
  case formatted(format: String, timeZone: TimeZone?)

  /// Send the value through its own `Codable` conformance.
  ///
  /// `Date`'s own conformance encodes as a number relative to 2001, which is
  /// almost never what an XML document wants; it is offered only for
  /// completeness.
  case deferredToDate
}

/// How ``XMLEncoder`` converts `Data` to text.
public enum XMLDataEncodingStrategy: Sendable, Hashable {
  /// Base64, the conventional encoding for binary content in XML.
  case base64

  /// Lowercase hexadecimal.
  case hexadecimal

  /// Send the value through its own `Codable` conformance, which produces an
  /// array of bytes and is therefore rarely what is wanted.
  case deferredToData
}

/// How ``XMLEncoder`` converts `Decimal` to text.
public enum XMLDecimalEncodingStrategy: Sendable, Hashable {
  /// Plain decimal notation, never scientific.
  case plain

  /// Send the value through its own `Codable` conformance.
  case deferredToDecimal
}
