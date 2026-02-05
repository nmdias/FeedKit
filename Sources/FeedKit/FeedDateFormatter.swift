//
// FeedDateFormatter.swift
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

/// PermissiveDateFormatter, used as a base class for date formatting,
/// handling multiple date formats and backup formats.
class PermissiveDateFormatter: DateFormatter, @unchecked Sendable {
  // MARK: Lifecycle

  /// Initializes the formatter with default timezone and locale.
  override init() {
    super.init()
    timeZone = TimeZone(secondsFromGMT: 0)
    locale = Locale(identifier: "en_US_POSIX")
  }

  /// Unavailable initializer for decoding.
  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) not supported")
  }

  // MARK: Internal

  /// Array of date formats to try when converting from string to date.
  var dateFormats: [String] {
    []
  }

  /// Array of date formats to try when converting from string to date.
  /// Used in permissive parsing strategies when feeds are not fully
  /// compliant with the specification and multiple formats need to be
  /// attempted to ensure proper date parsing.
  var permissiveDateFormats: [String] {
    []
  }

  /// Attempts to parse a string into a Date using available formats.
  override func date(from string: String) -> Date? {
    let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)

    guard !trimmedString.isEmpty else {
      return nil
    }

    // Attempts parsing with the last successful format first to avoid
    // unnecessary iterations over all formats.
    if dateFormat != nil, !dateFormat.isEmpty {
      if let date = super.date(from: trimmedString) {
        return date
      }
    }

    for format in dateFormats + permissiveDateFormats {
      dateFormat = format
      if let date = super.date(from: trimmedString) {
        return date
      }
    }
    return nil
  }

  /// Converts a Date to a string using available formats.
  override func string(from date: Date) -> String {
    for format in dateFormats {
      dateFormat = format
      let string = super.string(from: date)
      if !string.isEmpty {
        return string
      }
    }
    return ""
  }
}

// MARK: - ISO8601 formatter

/// Formatter for ISO8601 date specification.
final class ISO8601DateFormatter: PermissiveDateFormatter, @unchecked Sendable {
  /// List of date formats supported for ISO8601.
  override var dateFormats: [String] {
    [
      "yyyy-MM-dd'T'HH:mm:ss.SSZZZZZ",
      "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
      "yyyy-MM-dd'T'HH:mm"
    ]
  }

  override var permissiveDateFormats: [String] {
    [
      // Not fully compatible with ISO8601.
      // The correct ISO8601 format would separate the seconds (SS) from the timezone
      // offset (ZZZZZ) with a colon or period.
      "yyyy-MM-dd'T'HH:mmSSZZZZZ"
    ]
  }
}

// MARK: - RFC3339 formatter

/// Formatter for RFC3339 date specification.
final class RFC3339DateFormatter: PermissiveDateFormatter, @unchecked Sendable {
  /// List of date formats supported for RFC3339.
  override var dateFormats: [String] {
    [
      // RFC 3339 without fractional seconds.
      "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
      // RFC 3339 with 2-digit fractional seconds (limited precision).
      "yyyy-MM-dd'T'HH:mm:ss.SSZZZZZ"
    ]
  }

  override var permissiveDateFormats: [String] {
    [
      // Not fully compatible with RFC3339 (incorrect timezone format).
      "yyyy-MM-dd'T'HH:mm:ss-SS:ZZ",
      // Not fully compatible with RFC3339 (missing timezone information).
      "yyyy-MM-dd'T'HH:mm:ss"
    ]
  }
}

// MARK: - RFC822 formatter

/// Formatter for RFC822 date specification with backup formats.
final class RFC822DateFormatter: PermissiveDateFormatter, @unchecked Sendable {
  // MARK: Internal

  /// List of date formats supported for RFC822.
  override var dateFormats: [String] {
    [
      // RFC 822/1123 format with seconds.
      "EEE, d MMM yyyy HH:mm:ss zzz",
      // RFC 822/1123 format without seconds.
      "EEE, d MMM yyyy HH:mm zzz",
      // RFC 822 compatible, includes day, month, year, time, and timezone.
      "d MMM yyyy HH:mm:ss zzz",
      // RFC 822 compatible, similar to above but without seconds.
      "d MMM yyyy HH:mm zzz",
      // RFC 822 compatible, includes weekday, day, month, year, time, and timezone.
      "EEE, dd MMM yyyy, HH:mm:ss zzz"
    ]
  }

  /// Backup date formats to handle potential parsing issues.
  override var permissiveDateFormats: [String] {
    [
      // Non-standard, similar to RFC 822 with numeric timezone.
      "d MMM yyyy HH:mm:ss Z",
      // Non-standard, ISO-like format with numeric timezone.
      "yyyy-MM-dd HH:mm:ss Z",
      // Non-standard format with both numeric and named timezones (e.g. "UTC").
      "yyyy-MM-dd HH:mm:ss Z zzz"
    ]
  }

  /// Attempts to parse a string into a Date using primary and backup formats.
  override func date(from string: String) -> Date? {
    if let date = super.date(from: string) {
      return date
    }

    // Attempt to remove weekday prefix (e.g., "Tues") for compatibility.
    // See if we can lop off a text weekday, as DateFormatter does not
    // handle these in full compliance with Unicode tr35-31. For example,
    // "Tues, 6 November 2007 12:00:00 GMT" is rejected because of the "Tues",
    // even though "Tues" is used as an example for EEE in tr35-31.
    let trimmed = Self.trimRegEx.stringByReplacingMatches(
      in: string,
      options: [],
      range: NSMakeRange(0, string.count),
      withTemplate: "$1"
    )

    for format in permissiveDateFormats {
      dateFormat = format
      if let date = super.date(from: trimmed) {
        return date
      }
    }
    return nil
  }

  // MARK: Private

  private static let trimRegEx = try! NSRegularExpression(pattern: "^[a-zA-Z]+, ([\\w :+-]+)$")
}

// MARK: - RFC1123 formatter

/// Formatter for RFC1123 date specification.
final class RFC1123DateFormatter: PermissiveDateFormatter, @unchecked Sendable {
  /// List of date formats supported for RFC1123.
  override var dateFormats: [String] {
    [
      "EEE, dd MMM yyyy HH:mm:ss z"
    ]
  }

  override var permissiveDateFormats: [String] {
    [
      // Omits the time and timezone
      "EEE, dd MMM yyyy"
    ]
  }
}

// MARK: - DateSpec

/// Enum representing different date specifications.
enum DateSpec {
  /// ISO8601 date format (e.g., 2024-12-05T10:30:00Z).
  case iso8601
  /// RFC3339 date format (e.g., 2024-12-05T10:30:00+00:00).
  case rfc3339
  /// RFC822 date format (e.g., Tue, 05 Dec 2024 10:30:00 GMT).
  case rfc822
  /// RFC1123 date format (e.g., Fri, 06 Sep 2024 12:34:56 GMT).
  case rfc1123
  /// Permissive mode which attempts to parse the date using multiple formats.
  /// It tries RFC822 first, then RFC3339, RFC1123 and finally ISO8601 in that order.
  case permissive
}

// MARK: - FeedDateFormatter

/// A formatter that handles multiple date specifications (ISO8601, RFC3339, RFC822, RFC1123).
final class FeedDateFormatter: DateFormatter, @unchecked Sendable {
  // MARK: Lifecycle

  /// Initializes the date formatter with a specified date format.
  ///
  /// - Parameter spec: The date specification (ISO8601, RFC3339, RFC822, etc.).
  init(spec: DateSpec) {
    self.spec = spec
    super.init()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  /// Converts a string to a Date based on the given date specification.
  ///
  /// - Parameters:
  ///   - string: The date string to be parsed.
  /// - Returns: A Date object if parsing is successful, otherwise nil.
  override func date(from string: String) -> Date? {
    guard !string.isEmpty else {
      return nil
    }

    return switch spec {
    case .iso8601:
      iso8601Formatter.date(from: string)
    case .rfc3339:
      rfc3339Formatter.date(from: string)
    case .rfc822:
      rfc822Formatter.date(from: string)
    case .rfc1123:
      rfc1123Formatter.date(from: string)
    case .permissive:
      rfc822Formatter.date(from: string) ??
        rfc3339Formatter.date(from: string) ??
        rfc1123Formatter.date(from: string) ??
        iso8601Formatter.date(from: string)
    }
  }

  /// Converts a Date to a string based on the given date specification.
  ///
  /// - Parameters:
  ///   - date: The Date object to be converted to a string.
  /// - Returns: A string representation of the date.
  override func string(from date: Date) -> String {
    switch spec {
    case .iso8601:
      iso8601Formatter.string(from: date)
    case .rfc3339:
      rfc3339Formatter.string(from: date)
    case .rfc822:
      rfc822Formatter.string(from: date)
    case .rfc1123:
      rfc1123Formatter.string(from: date)
    case .permissive:
      fatalError()
    }
  }

  // MARK: Private

  /// The date specification to use for formatting dates.
  private let spec: DateSpec

  /// ISO8601 date formatter.
  private lazy var iso8601Formatter: ISO8601DateFormatter = .init()

  /// RFC3339 date formatter.
  private lazy var rfc3339Formatter: RFC3339DateFormatter = .init()

  /// RFC822 date formatter.
  private lazy var rfc822Formatter: RFC822DateFormatter = .init()

  /// RFC1123 date formatter.
  private lazy var rfc1123Formatter: RFC1123DateFormatter = .init()
}
