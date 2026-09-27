//
// FeedDateFormatting.swift
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
  /// The shape of the value decides which family is tried first.
  /// Serialization uses RFC3339.
  case permissive
}

// MARK: - FeedDateFormatting

/// Reading and writing the dates feed documents carry.
///
/// Every format is an immutable `Date.ParseStrategy` or `Date.ISO8601FormatStyle`
/// held in a `static` cache, built once and shared. Nothing here mutates a
/// formatter while parsing, and nothing is carried between dates.
///
/// That is the point of the type. A `DateFormatter` is reconfigured by assigning
/// `dateFormat`, which rebuilds its ICU state, so a reader that finds the right
/// pattern by trying the wrong ones pays that cost per attempt. On 242 live
/// feeds, dates were 83% of the time it took to read a document, and a single
/// feed spent 1.5 seconds on them. A `Date.ParseStrategy` is a value whose
/// format is fixed when it is created, so an attempt costs a parse and nothing
/// else.
///
/// The values parsed here are the ones the previous `DateFormatter`-based
/// implementation parsed, with the same instants: the two agree on all 10,994
/// date values collected from those 242 feeds.
enum FeedDateFormatting {
  // MARK: Internal

  /// The instant `string` denotes, or `nil` when no known format matches.
  ///
  /// The family is chosen from the shape of the value, never from the feed's
  /// format: Atom feeds carry RFC 822 dates and RSS feeds carry ISO ones, and 30
  /// of the 242 live feeds measured carried both side by side, item by item. The
  /// decision is made per date.
  ///
  /// - Parameter string: The date as the document wrote it.
  /// - Returns: The date, or `nil`.
  static func date(from string: String?) -> Date? {
    guard let string else {
      return nil
    }

    let text = string.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !text.isEmpty else {
      return nil
    }

    return isISO8601Shaped(text)
      ? (parse(text, using: iso8601) ?? parseRFC822(text, using: rfc822 + rfc1123))
      : (parseRFC822(text, using: rfc822 + rfc1123) ?? parse(text, using: iso8601))
  }

  /// The instant `string` denotes under one specification.
  ///
  /// - Parameters:
  ///   - string: The date as the document wrote it.
  ///   - spec: The specification to read it with.
  /// - Returns: The date, or `nil`.
  static func date(from string: String, spec: DateSpec) -> Date? {
    switch spec {
    case .iso8601,
         .rfc3339:
      parse(string, using: iso8601)
    case .rfc822:
      parseRFC822(string, using: rfc822)
    case .rfc1123:
      parse(string, using: rfc1123)
    case .permissive:
      date(from: string)
    }
  }

  /// `date` written in the given specification.
  ///
  /// - Parameters:
  ///   - date: The date to write.
  ///   - spec: The specification to write it in.
  /// - Returns: The date as text.
  static func string(from date: Date, spec: DateSpec) -> String {
    switch spec {
    case .iso8601:
      // Fractional seconds are written with three digits rather than the two
      // the previous implementation's `SS` pattern produced. No feed model is
      // serialized with this specification; RSS 2.0 is RFC 822 and everything
      // else is RFC 3339.
      iso8601Output.format(date)
    case .permissive,
         .rfc3339:
      rfc3339Output.format(date)
    case .rfc822:
      rfc822Output.format(date)
    case .rfc1123:
      rfc1123Output.format(date)
    }
  }

  // MARK: Private

  /// One way of reading a date.
  private enum Parser {
    /// A pattern of the ISO 8601 family, which parses several orders of
    /// magnitude faster than a general-purpose strategy.
    case iso(Date.ISO8601FormatStyle)

    /// A fixed pattern.
    case strategy(Date.ParseStrategy)

    // MARK: Internal

    /// The instant `string` denotes, or `nil`.
    func date(from string: String) -> Date? {
      switch self {
      case let .iso(style):
        try? style.parse(string)
      case let .strategy(strategy):
        try? strategy.parse(string)
      }
    }
  }

  /// Feed dates are written in UTC with English month and day names, whatever
  /// the reader's locale is; a document does not change meaning because of the
  /// device it is read on.
  private static let locale: Locale = .init(identifier: "en_US_POSIX")
  private static let timeZone: TimeZone = .init(secondsFromGMT: 0) ?? .current
  private static let calendar: Calendar = {
    var calendar: Calendar = .init(identifier: .gregorian)
    calendar.locale = locale
    calendar.timeZone = timeZone
    return calendar
  }()

  // MARK: Reading

  /// The ISO 8601 family, tried in the order values are written in the wild.
  ///
  /// The first two entries are the whole specification as Foundation reads it
  /// and are what most ISO 8601 dates need; the rest accept the spellings feeds
  /// write when they are not quite compliant.
  private static let iso8601: [Parser] = [
    // 2024-12-05T10:30:00Z, 2024-12-05T10:30:00+00:00, 2024-12-05T10:30:00.123Z
    .iso(.init(timeZone: timeZone)),
    .iso(.init(includingFractionalSeconds: true, timeZone: timeZone)),
    // 2024-12-05T10:30+00:00, 2024-12-05T10:30
    strategy("\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)T\(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits)\(timeZone: .iso8601(.short))"),
    strategy("\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)T\(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits)"),
    // Not fully compatible with ISO 8601: no timezone at all.
    strategy("\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)T\(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits)"),
    // Not fully compatible with ISO 8601: the seconds and the offset are not
    // separated by a colon or a period.
    strategy("\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)T\(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits)\(second: .twoDigits)\(timeZone: .iso8601(.short))"),
    // Not fully compatible with RFC 3339: the offset is written with a dash.
    strategy("\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)T\(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits)-\(second: .twoDigits):\(timeZone: .iso8601(.short))")
  ]

  /// RFC 822, as RSS 2.0 requires it, and the spellings feeds use instead.
  private static let rfc822: [Parser] = [
    // Fri, 05 Dec 2024 10:30:00 GMT
    strategy("\(weekday: .abbreviated), \(day: .defaultDigits) \(month: .abbreviated) \(year: .defaultDigits) \(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits) \(timeZone: .specificName(.short))"),
    strategy("\(weekday: .abbreviated), \(day: .defaultDigits) \(month: .abbreviated) \(year: .defaultDigits) \(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits) \(timeZone: .specificName(.short))"),
    // Fri, 05 Dec 2024, 10:30:00 GMT
    strategy("\(weekday: .abbreviated), \(day: .defaultDigits) \(month: .abbreviated) \(year: .defaultDigits), \(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits) \(timeZone: .specificName(.short))"),
    // Non-standard, RFC 822 with a numeric offset.
    strategy("\(day: .defaultDigits) \(month: .abbreviated) \(year: .defaultDigits) \(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits) \(timeZone: .localizedGMT(.short))"),
    // Non-standard, ISO-like format with a numeric offset.
    strategy("\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits) \(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits) \(timeZone: .localizedGMT(.short))"),
    // Non-standard format with both a numeric and a named timezone.
    strategy("\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits) \(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits) \(timeZone: .localizedGMT(.short)) \(timeZone: .specificName(.short))")
  ]

  /// The same values without a weekday, for the ones that spell it out in full.
  private static let rfc822WithoutWeekday: [Parser] = [
    strategy("\(day: .defaultDigits) \(month: .abbreviated) \(year: .defaultDigits) \(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits) \(timeZone: .specificName(.short))"),
    strategy("\(day: .defaultDigits) \(month: .abbreviated) \(year: .defaultDigits) \(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits) \(timeZone: .specificName(.short))"),
    // Non-standard, RFC 822 with a numeric offset.
    strategy("\(day: .defaultDigits) \(month: .abbreviated) \(year: .defaultDigits) \(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits) \(timeZone: .localizedGMT(.short))"),
    // Non-standard, ISO-like format with a numeric offset.
    strategy("\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits) \(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits) \(timeZone: .localizedGMT(.short))"),
    // Non-standard format with both a numeric and a named timezone.
    strategy("\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits) \(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits) \(timeZone: .localizedGMT(.short)) \(timeZone: .specificName(.short))")
  ]

  /// RFC 1123, whose date may also arrive without a time.
  private static let rfc1123: [Parser] = [
    strategy("\(weekday: .abbreviated), \(day: .defaultDigits) \(month: .abbreviated) \(year: .defaultDigits) \(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits) \(timeZone: .specificName(.short))"),
    strategy("\(weekday: .abbreviated), \(day: .twoDigits) \(month: .abbreviated) \(year: .defaultDigits)")
  ]

  // MARK: Writing

  /// RFC 3339 without fractional seconds, which is how the previous
  /// implementation wrote it and what JSON Feed and Atom expect.
  private static let rfc3339Output: Date.ISO8601FormatStyle = .init(timeZone: timeZone)

  /// ISO 8601 with fractional seconds.
  private static let iso8601Output: Date.ISO8601FormatStyle = .init(includingFractionalSeconds: true, timeZone: timeZone)

  /// RFC 822, as RSS 2.0 requires it.
  private static let rfc822Output: Date.VerbatimFormatStyle = .init(
    format: "\(weekday: .abbreviated), \(day: .defaultDigits) \(month: .abbreviated) \(year: .defaultDigits) \(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits) \(timeZone: .specificName(.short))",
    locale: locale,
    timeZone: timeZone,
    calendar: calendar
  )

  /// RFC 1123.
  private static let rfc1123Output: Date.VerbatimFormatStyle = .init(
    format: "\(weekday: .abbreviated), \(day: .twoDigits) \(month: .abbreviated) \(year: .defaultDigits) \(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits) \(timeZone: .specificName(.short))",
    locale: locale,
    timeZone: timeZone,
    calendar: calendar
  )

  /// The strategy for one pattern.
  private static func strategy(_ format: Date.FormatString) -> Parser {
    // The calendar is the one `locale` and `timeZone` imply: en_US_POSIX and
    // UTC, which is the Gregorian calendar. Passing one explicitly reads the
    // same dates but spells the initialiser differently between toolchains.
    .strategy(.init(
      format: format,
      locale: locale,
      timeZone: timeZone,
      isLenient: true
    ))
  }

  /// The first parser that reads `string`, or `nil`.
  private static func parse(_ string: String, using parsers: [Parser]) -> Date? {
    for parser in parsers {
      if let date = parser.date(from: string) {
        return date
      }
    }
    return nil
  }

  /// The first parser that reads `string`, or `nil`, allowing for a leading
  /// text weekday the patterns cannot express.
  private static func parseRFC822(_ string: String, using parsers: [Parser]) -> Date? {
    if let date = parse(string, using: parsers) {
      return date
    }

    guard let remainder = withoutWeekday(string) else {
      return nil
    }
    return parse(remainder, using: rfc822WithoutWeekday)
  }

  /// `string` without its leading text weekday, or `nil` when it has none.
  ///
  /// RFC 822 allows a weekday to be spelled out in full, and feeds write "Tues"
  /// and "Thurs" as well. Patterns read three-letter weekdays, so a value such
  /// as `"Tues, 6 November 2007 12:00:00 GMT"` is read without one.
  private static func withoutWeekday(_ string: String) -> String? {
    guard let comma = string.firstIndex(of: ","), comma > string.startIndex else {
      return nil
    }

    guard string[string.startIndex ..< comma].allSatisfy(\.isLetter) else {
      return nil
    }

    let remainder = string[string.index(after: comma)...].drop { $0 == " " }
    return remainder.isEmpty ? nil : String(remainder)
  }

  /// Whether `string` opens with a calendar date, which is how every ISO 8601
  /// and W3CDTF instant starts and how no RFC 822 instant does.
  private static func isISO8601Shaped(_ string: String) -> Bool {
    var digits = 0
    for character in string {
      if character.isNumber {
        digits += 1
        if digits > 4 {
          return false
        }
        continue
      }
      return digits == 4 && character == "-"
    }
    return false
  }
}

// MARK: - Containers

extension KeyedDecodingContainer {
  /// Decodes a date from the text bound to `key`.
  ///
  /// A key that is absent is `nil`. A key that is present but unreadable is an
  /// error, which is what the decoder reported before this type existed: a feed
  /// whose date cannot be understood is a feed with a defect its reader should
  /// hear about, not one to read with a silent hole in it.
  ///
  /// - Parameter key: The key holding the date.
  /// - Throws: `DecodingError.dataCorruptedError` when the text is not a date.
  /// - Returns: The date, or `nil` when the key is absent.
  func decodeFeedDate(forKey key: Key) throws -> Date? {
    guard let text = try decodeIfPresent(String.self, forKey: key) else {
      return nil
    }

    guard let date = FeedDateFormatting.date(from: text) else {
      throw DecodingError.dataCorruptedError(
        forKey: key,
        in: self,
        debugDescription: "\(text.debugDescription) is not a date this library can read"
      )
    }

    return date
  }
}

extension KeyedEncodingContainer {
  /// Encodes a date in the specification its vocabulary defines.
  ///
  /// - Parameters:
  ///   - date: The date to encode, or `nil`.
  ///   - key: The key to encode it under.
  ///   - spec: The specification to write it in.
  /// - Throws: An error if encoding fails.
  mutating func encodeFeedDate(_ date: Date?, forKey key: Key, spec: DateSpec) throws {
    guard let date else {
      return
    }

    try encode(FeedDateFormatting.string(from: date, spec: spec), forKey: key)
  }
}
