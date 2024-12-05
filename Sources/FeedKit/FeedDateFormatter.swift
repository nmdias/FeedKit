//
//  DateFormatters.swift
//
//  Copyright (c) 2016 - 2024 Nuno Dias
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

import Foundation

/// Enum representing different date specifications.
enum DateSpec {
  case iso8601
  case rfc3339
  case rfc822
  case permissive
}

/// Base class for date formatting, handling multiple date formats.
class BaseDateFormatter: DateFormatter, @unchecked Sendable {
  /// Array of date formats to try when converting from string to date.
  var dateFormats: [String] { [] }

  /// Initializes the formatter with default timezone and locale.
  override init() {
    super.init()
    timeZone = TimeZone(secondsFromGMT: 0)
    locale = Locale(identifier: "en_US_POSIX")
  }

  /// Unavailable initializer for decoding.
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) not supported")
  }

  /// Attempts to parse a string into a Date using available formats.
  override func date(from string: String) -> Date? {
    let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
    for format in dateFormats {
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
class ISO8601DateFormatter: BaseDateFormatter, @unchecked Sendable {
  /// List of date formats supported for ISO8601.
  override var dateFormats: [String] {
    [
      "yyyy-MM-dd'T'HH:mm:ss.SSZZZZZ",
      "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
      "yyyy-MM-dd'T'HH:mm",
    ]
  }
}

// MARK: - RFC3339 formatter

/// Formatter for RFC3339 date specification.
class RFC3339DateFormatter: BaseDateFormatter, @unchecked Sendable {
  /// List of date formats supported for RFC3339.
  override var dateFormats: [String] {
    [
      "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
      "yyyy-MM-dd'T'HH:mm:ss.SSZZZZZ",
      "yyyy-MM-dd'T'HH:mm:ss-SS:ZZ",
      "yyyy-MM-dd'T'HH:mm:ss",
    ]
  }
}

// MARK: - RFC822 formatter

/// Formatter for RFC822 date specification with backup formats.
class RFC822DateFormatter: BaseDateFormatter, @unchecked Sendable {
  /// List of date formats supported for RFC822.
  override var dateFormats: [String] {
    [
      "EEE, d MMM yyyy HH:mm:ss zzz",
      "EEE, d MMM yyyy HH:mm zzz",
      "d MMM yyyy HH:mm:ss Z",
      "yyyy-MM-dd HH:mm:ss Z",
    ]
  }

  /// Backup date formats to handle potential parsing issues.
  let backupFormats: [String] = [
    "d MMM yyyy HH:mm:ss zzz",
    "d MMM yyyy HH:mm zzz",
    "EEE, dd MMM yyyy, HH:mm:ss zzz",
  ]

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
    let trimRegEx = try! NSRegularExpression(pattern: "^[a-zA-Z]+, ([\\w :+-]+)$")
    let trimmed = trimRegEx.stringByReplacingMatches(
      in: string,
      options: [],
      range: NSMakeRange(0, string.count),
      withTemplate: "$1"
    )

    for format in backupFormats {
      dateFormat = format
      if let date = super.date(from: trimmed) {
        return date
      }
    }
    return nil
  }
}

// MARK: - UnifiedDateFormatter

/// A formatter that handles multiple date specifications (ISO8601, RFC3339, RFC822).
class FeedDateFormatter {
  /// ISO8601 date formatter.
  lazy var iso8601Formatter: ISO8601DateFormatter = {
    ISO8601DateFormatter()
  }()

  /// RFC3339 date formatter.
  lazy var rfc3339Formatter: RFC3339DateFormatter = {
    RFC3339DateFormatter()
  }()

  /// RFC822 date formatter.
  lazy var rfc822Formatter: RFC822DateFormatter = {
    RFC822DateFormatter()
  }()

  /// Converts a string to a Date based on the given date specification.
  ///
  /// - Parameters:
  ///   - string: The date string to be parsed.
  ///   - spec: The date specification to use.
  /// - Returns: A Date object if parsing is successful, otherwise nil.
  func date(from string: String, spec: DateSpec) -> Date? {
    switch spec {
    case .iso8601:
      return iso8601Formatter.date(from: string)
    case .rfc3339:
      return rfc3339Formatter.date(from: string)
    case .rfc822:
      return rfc822Formatter.date(from: string)
    case .permissive:
      return
        rfc822Formatter.date(from: string) ??
        rfc3339Formatter.date(from: string) ??
        iso8601Formatter.date(from: string)
    }
  }

  /// Converts a Date to a string based on the given date specification.
  ///
  /// - Parameters:
  ///   - date: The Date object to be converted to a string.
  ///   - spec: The date specification to use.
  /// - Returns: A string representation of the date.
  func string(from date: Date, spec: DateSpec) -> String {
    switch spec {
    case .iso8601:
      return iso8601Formatter.string(from: date)
    case .rfc3339:
      return rfc3339Formatter.string(from: date)
    case .rfc822:
      return rfc822Formatter.string(from: date)
    case .permissive:
      return iso8601Formatter.string(from: date)
    }
  }
}
