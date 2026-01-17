//
// XMLHeader.swift
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

/// A structure representing the XML header.
///
/// The `XMLHeader` structure provides properties and methods to create and
/// manage
/// an XML header, including the version, encoding, and standalone status.
public struct XMLHeader: Sendable {
  // MARK: Lifecycle

  /// Initializes a new XMLHeader with version, encoding, and optional
  /// standalone.
  /// - Parameters:
  ///   - version: The XML version (default is "1.0").
  ///   - encoding: The character encoding (default is "UTF-8").
  ///   - isStandalone: Indicates if the document is standalone (true for "yes",
  /// false for "no", nil for omitted).
  public init(
    version: String = "1.0",
    encoding: String.Encoding = .utf8,
    isStandalone: Bool? = nil
  ) {
    self.version = version
    self.encoding = encoding
    self.isStandalone = isStandalone
  }

  // MARK: Public

  public static let `default`: XMLHeader = .init(
    version: "1.0",
    encoding: .utf8,
    isStandalone: nil
  )

  /// The version of the XML document.
  /// This property represents the XML version, typically "1.0".
  public var version: String

  /// The character encoding of the XML document.
  /// This property specifies the encoding used in the XML document, such as
  /// UTF-8.
  public var encoding: String.Encoding

  /// Indicates whether the XML document is standalone.
  /// This property is optional and specifies if the XML document is standalone
  /// (i.e., does not rely on external definitions or DTDs).
  public var isStandalone: Bool?

  /// Generates the XML header as a string.
  /// - Returns: The XML header string.
  public func toXMLString() -> String {
    var header = "<?xml version=\"\(version)\" encoding=\"\(encoding.toXMLString())\""
    if let isStandalone {
      header += " standalone=\"\(isStandalone ? "yes" : "no")\""
    }
    header += "?>"
    return header
  }
}

extension String.Encoding {
  /// Converts `String.Encoding` to a valid encoding name.
  /// - Returns: The XML-compatible encoding name.
  func toXMLString() -> String {
    switch self {
    case .utf8:
      "UTF-8" // Most common encoding
    case .isoLatin1:
      "ISO-8859-1" // ISO-8859-1 (Latin-1) for Western European languages
    case .windowsCP1252:
      "Windows-1252" // Common in Western European Windows environments
    case .shiftJIS:
      "Shift_JIS" // Common for Japanese text
    case .utf16:
      "UTF-16" // UTF-16 for 2-byte encoding
    case .utf16LittleEndian:
      "UTF-16LE" // Little-endian UTF-16 encoding
    case .utf16BigEndian:
      "UTF-16BE" // Big-endian UTF-16 encoding
    case .isoLatin2:
      "ISO-8859-2" // ISO-8859-2 for Central and Eastern European languages
    case .windowsCP1250:
      "Windows-1250" // Windows-1250 for Central European languages
    case .windowsCP1251:
      "Windows-1251" // Windows-1251 for Cyrillic-based languages
    default:
      "UTF-8" // Default to UTF-8 for unsupported encodings
    }
  }
}
