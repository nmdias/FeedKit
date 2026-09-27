//
// FeedDateParser.swift
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

/// Parses the date formats feed documents actually use, without a formatter.
///
/// A `DateFormatter` is the wrong tool for reading a feed. Feed dates arrive in
/// two families — RFC 3339/ISO 8601 (Atom, W3CDTF) and RFC 822/1123 (RSS 2.0) —
/// and a permissive reader must try several patterns to find the right one.
/// Every failed attempt reconfigures the formatter's ICU state, which costs
/// about 0.08 ms: a published date that the RFC 3339 pattern matches on the
/// second try can cost ~1.8 ms once the RFC 822 patterns have been tried first.
/// On a feed with 30 entries that is 55 ms of the 57 ms it takes to read it.
///
/// This parser recognises the same shapes directly, in one pass, and returns
/// `nil` for anything it does not recognise so that the formatter chain stays
/// the fallback for unusual documents.
///
/// ## What is accepted
///
/// The specification, plus the drift that real feeds show:
///
/// | Shape | Where it comes from |
/// |---|---|
/// | `2003-12-13T18:30:02Z` | RFC 3339, as Atom requires (RFC 4287 §3.3) |
/// | `2003-12-13T18:30:02.25Z`, `…02,25Z` | fractional seconds; ISO 8601 allows `,` as the separator |
/// | `2003-12-13T18:30:02+01:00`, `…+0100`, `…+01` | RFC 3339, and the RFC 822 spelling of an offset |
/// | `2003-12-13t18:30:02z` | RFC 3339 permits lower case |
/// | `2003-12-13 18:30:02Z` | a space where the `T` belongs |
/// | `2003-12-13T18:30:02` | no zone: read as UTC, as the formatter's GMT time zone did |
/// | `2003-12-13`, `2003-12`, `2003` | W3CDTF, which is what RSS 1.0's `dc:date` is |
/// | `Sat, 07 Sep 2002 00:00:01 GMT` | RFC 822/1123, as RSS 2.0 requires |
/// | `07 Sep 2002 00:00:01 +0000`, `Sat, 07 Sep 2002 00:00 +0000` | the optional weekday, and the optional seconds |
/// | `Fri, 09 Oct 2020 04:30:38 EST` | the US zone abbreviations RFC 822 defines |
/// | `Sat, 07 Sep 02 00:00:01 GMT` | a two-digit year, read with RFC 2822's window (00–49 → 2000s, 50–99 → 1900s) |
/// | `Fri, 09 Oct 2020 04:30:38` | no zone: read as UTC |
/// | `… GMT (UTC)` | a trailing RFC 822 comment |
///
/// ## What is deliberately not accepted
///
/// Anything ambiguous, because a wrong date is worse than a missing one — and
/// because the formatter chain already handles, or already rejects, these:
///
/// - a bare number (`1696003200`): it could be an epoch, and `20240101` could be
///   a date. Guessing between them silently invents a timestamp.
/// - month or weekday names outside English: RFC 822 fixes English, and mixing
///   locales to guess is how "Mär" becomes March in one locale and May in another.
/// - zone abbreviations outside RFC 822 (`BST`, `CEST`, `AEST`): their offsets
///   are not defined by any feed specification.
/// - out-of-range fields (`2003-02-30`, `25:00:00`): the formatter is lenient by
///   default, so leaving these to it keeps the previous behaviour exactly.
///
/// The weekday is never checked for consistency with the date, matching both the
/// specifications (it is redundant) and the formatter, which ignores it.
enum FeedDateParser {
  // MARK: Internal

  /// The instant `string` denotes, or `nil` when this parser does not recognise
  /// the shape.
  ///
  /// - Parameter string: The date as the document wrote it.
  /// - Returns: The date, or `nil` to fall back to `FeedDateFormatter`.
  static func date(from string: String) -> Date? {
    guard !string.isEmpty else {
      return nil
    }

    if let bytes = string.utf8.withContiguousStorageIfAvailable({ parse($0) }) {
      return bytes
    }
    return Array(string.utf8).withUnsafeBufferPointer { parse($0) }
  }

  // MARK: Private

  /// The zone abbreviations RFC 822 §5.2 defines, in seconds from UTC.
  ///
  /// `Z` is UTC, the single letters are the military zones of that section
  /// (`J` is deliberately unassigned), and the rest are the North American ones
  /// that appear in RSS documents.
  private static let namedZones: [Int: Int] = {
    func key(_ name: String) -> Int {
      var hash = 0
      for byte in name.utf8 {
        hash = hash << 8 | Int(byte | 0x20)
      }
      return hash
    }

    var zones: [Int: Int] = [
      key("gmt"): 0, key("ut"): 0, key("utc"): 0, key("z"): 0,
      key("est"): -5, key("edt"): -4,
      key("cst"): -6, key("cdt"): -5,
      key("mst"): -7, key("mdt"): -6,
      key("pst"): -8, key("pdt"): -7
    ]
    // Military zones: A–I are +1…+9, K–M are +10…+12, N–Y are −1…−12.
    for (offset, letter) in (UnicodeScalar("A").value ... UnicodeScalar("I").value).enumerated() {
      zones[Int(letter | 0x20)] = offset + 1
    }
    for (offset, letter) in (UnicodeScalar("K").value ... UnicodeScalar("M").value).enumerated() {
      zones[Int(letter | 0x20)] = offset + 10
    }
    for (offset, letter) in (UnicodeScalar("N").value ... UnicodeScalar("Y").value).enumerated() {
      zones[Int(letter | 0x20)] = -(offset + 1)
    }
    return zones
  }()

  /// The three-letter month names RFC 822 fixes, as month numbers.
  private static let monthNames: [Int: Int] = {
    let names = ["jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"]
    var months: [Int: Int] = [:]
    for (index, name) in names.enumerated() {
      var hash = 0
      for byte in name.utf8 {
        hash = hash << 8 | Int(byte)
      }
      months[hash] = index + 1
    }
    return months
  }()

  /// The RFC 2822 window for a two-digit year: `00`–`49` are the 2000s, `50`–`99`
  /// the 1900s. Reading `02` as the year 2 — which a `yyyy` pattern does — puts a
  /// 2020s feed two millennia away from its entries.
  private static func expandedYear(_ year: Int) -> Int {
    switch year {
    case 0 ..< 50: year + 2000
    case 50 ..< 100: year + 1900
    default: year
    }
  }

  /// Parses a date out of a slice of UTF-8, by shape.
  private static func parse(_ bytes: UnsafeBufferPointer<UInt8>) -> Date? {
    guard let first = bytes.first else {
      return nil
    }

    // ISO 8601 opens with a four-digit year; RFC 822 opens with either the
    // weekday name (`Sat, 07 Sep …`) or the day of the month (`07 Sep …`).
    if isDigit(first) {
      // `2003-12-13` and `2003` are W3CDTF; `07 Sep 2002 00:00:01 GMT` is RFC
      // 822. A four-digit year followed by a dash is the former, and so is a
      // run of digits with nothing else in it.
      if bytes.count >= 5, bytes[4] == UInt8(ascii: "-") {
        return parseISO8601(bytes)
      }
      if bytes.allSatisfy({ isDigit($0) }) {
        return parseISO8601(bytes)
      }
      return parseRFC822(bytes)
    }

    if isAlpha(first) {
      return parseRFC822(bytes)
    }

    return nil
  }

  // MARK: ISO 8601 / RFC 3339 / W3CDTF

  /// Parses `YYYY-MM-DD`, optionally followed by a time and a zone.
  private static func parseISO8601(_ bytes: UnsafeBufferPointer<UInt8>) -> Date? {
    var index = 0

    guard let year = readDigits(bytes, &index, count: 4), year > 0 else {
      return nil
    }

    var month = 1
    var day = 1

    if index < bytes.count {
      guard consume(bytes, &index, UInt8(ascii: "-")),
            let value = readDigits(bytes, &index, count: 2), (1 ... 12).contains(value)
      else {
        return nil
      }
      month = value

      if index < bytes.count {
        guard consume(bytes, &index, UInt8(ascii: "-")),
              let dayValue = readDigits(bytes, &index, count: 2), dayValue >= 1,
              dayValue <= daysInMonth(year: year, month: month)
        else {
          return nil
        }
        day = dayValue
      } else {
        // `YYYY-MM` is a legal W3CDTF instant.
        return instant(year: year, month: month, day: 1, hour: 0, minute: 0, second: 0, fraction: 0, offset: 0)
      }
    } else {
      // `YYYY` is a legal W3CDTF instant.
      return instant(year: year, month: 1, day: 1, hour: 0, minute: 0, second: 0, fraction: 0, offset: 0)
    }

    guard index < bytes.count else {
      return instant(year: year, month: month, day: day, hour: 0, minute: 0, second: 0, fraction: 0, offset: 0)
    }

    // The separator: `T` per the specification, a space in the wild.
    let separator = bytes[index]
    guard separator == UInt8(ascii: "T") || separator == UInt8(ascii: "t") || separator == UInt8(ascii: " ") else {
      return nil
    }
    index += 1

    guard let hour = readDigits(bytes, &index, count: 2), hour <= 23,
          consume(bytes, &index, UInt8(ascii: ":")),
          let minute = readDigits(bytes, &index, count: 2), minute <= 59
    else {
      return nil
    }

    var second = 0
    if consume(bytes, &index, UInt8(ascii: ":")) {
      // A leap second is written `:60`, and is a real value.
      guard let value = readDigits(bytes, &index, count: 2), value <= 60 else {
        return nil
      }
      second = value
    }

    var fraction = 0.0
    if index < bytes.count, bytes[index] == UInt8(ascii: ".") || bytes[index] == UInt8(ascii: ",") {
      index += 1
      var digits = 0
      var scale = 0.1
      while index < bytes.count, bytes[index] >= 0x30, bytes[index] <= 0x39 {
        fraction += Double(bytes[index] - 0x30) * scale
        scale /= 10
        digits += 1
        index += 1
      }
      guard digits > 0 else {
        return nil
      }
    }

    var offset = 0
    if index < bytes.count {
      guard let value = readZone(bytes, &index) else {
        return nil
      }
      offset = value
    }

    guard index == bytes.count else {
      return nil
    }

    return instant(
      year: year, month: month, day: day,
      hour: hour, minute: minute, second: second,
      fraction: fraction, offset: offset
    )
  }

  // MARK: RFC 822 / RFC 1123 / RFC 2822

  /// Parses `[Www, ]D Mon YYYY HH:MM[:SS][ zone]`.
  private static func parseRFC822(_ bytes: UnsafeBufferPointer<UInt8>) -> Date? {
    var index = 0

    // An optional weekday, which the day-of-month digit run would otherwise
    // swallow. It is redundant, so its value is not checked.
    if let letter = byte(bytes, index), isAlpha(letter) {
      var probe = index
      guard readWord(bytes, &probe) != nil else {
        return nil
      }
      index = probe
      _ = consume(bytes, &index, UInt8(ascii: ","))
      guard skipSpaces(bytes, &index) else {
        return nil
      }
    }

    guard let day = readDigits(bytes, &index, count: 1 ... 2), day >= 1, skipSpaces(bytes, &index) else {
      return nil
    }

    guard let month = readMonth(bytes, &index), skipSpaces(bytes, &index) else {
      return nil
    }

    guard let rawYear = readDigits(bytes, &index, count: 2 ... 4), skipSpaces(bytes, &index) else {
      return nil
    }
    let year = rawYear < 100 ? expandedYear(rawYear) : rawYear

    guard day <= daysInMonth(year: year, month: month) else {
      return nil
    }

    guard let hour = readDigits(bytes, &index, count: 2), hour <= 23,
          consume(bytes, &index, UInt8(ascii: ":")),
          let minute = readDigits(bytes, &index, count: 2), minute <= 59
    else {
      return nil
    }

    var second = 0
    if consume(bytes, &index, UInt8(ascii: ":")) {
      guard let value = readDigits(bytes, &index, count: 2), value <= 60 else {
        return nil
      }
      second = value
    }

    var offset = 0
    _ = skipSpaces(bytes, &index)
    if index < bytes.count {
      guard let value = readZone(bytes, &index) else {
        return nil
      }
      offset = value
    }

    // A trailing RFC 822 comment, as in `Fri, 09 Oct 2020 04:30:38 GMT (UTC)`.
    _ = skipSpaces(bytes, &index)
    if index < bytes.count, bytes[index] == UInt8(ascii: "(") {
      while index < bytes.count, bytes[index] != UInt8(ascii: ")") {
        index += 1
      }
      guard index < bytes.count else {
        return nil
      }
      index += 1
    }

    guard index == bytes.count else {
      return nil
    }

    return instant(
      year: year, month: month, day: day,
      hour: hour, minute: minute, second: second,
      fraction: 0, offset: offset
    )
  }

  // MARK: Zone

  /// Reads a zone — `Z`, a name from RFC 822, or a numeric offset — from
  /// `index`, advancing it. Returns seconds east of UTC, or `nil` when the text
  /// is not a zone this parser knows.
  private static func readZone(_ bytes: UnsafeBufferPointer<UInt8>, _ index: inout Int) -> Int? {
    guard let first = byte(bytes, index) else {
      return nil
    }

    if first == UInt8(ascii: "Z") || first == UInt8(ascii: "z") {
      index += 1
      return 0
    }

    if first == UInt8(ascii: "+") || first == UInt8(ascii: "-") {
      return readNumericOffset(bytes, &index)
    }

    if isAlpha(first) {
      var probe = index
      guard let word = readWord(bytes, &probe) else {
        return nil
      }
      guard let hours = namedZones[word] else {
        return nil
      }
      index = probe

      // `GMT+0200`: a named zone with the offset spelled out. Java's date
      // formatting produces it, and documents from it are in the wild. Only the
      // zero zones take an offset — `EST+0200` would contradict itself.
      if hours == 0, index < bytes.count,
         bytes[index] == UInt8(ascii: "+") || bytes[index] == UInt8(ascii: "-")
      {
        return readNumericOffset(bytes, &index)
      }

      return hours * 3600
    }

    return nil
  }

  /// Reads `+hhmm`, `+hh:mm` or `+hh` — the offset spellings that appear in
  /// documents — advancing `index`.
  private static func readNumericOffset(_ bytes: UnsafeBufferPointer<UInt8>, _ index: inout Int) -> Int? {
    guard let sign = byte(bytes, index), sign == UInt8(ascii: "+") || sign == UInt8(ascii: "-") else {
      return nil
    }
    index += 1
    guard let hours = readDigits(bytes, &index, count: 2), hours <= 23 else {
      return nil
    }

    var minutes = 0
    if consume(bytes, &index, UInt8(ascii: ":")) {
      guard let value = readDigits(bytes, &index, count: 2), value <= 59 else {
        return nil
      }
      minutes = value
    } else if let value = readDigits(bytes, &index, count: 2), value <= 59 {
      minutes = value
    }

    return (sign == UInt8(ascii: "-") ? -1 : 1) * (hours * 3600 + minutes * 60)
  }

  // MARK: Scanning

  private static func byte(_ bytes: UnsafeBufferPointer<UInt8>, _ index: Int) -> UInt8? {
    index < bytes.count ? bytes[index] : nil
  }

  private static func isAlpha(_ byte: UInt8) -> Bool {
    (byte >= 0x41 && byte <= 0x5A) || (byte >= 0x61 && byte <= 0x7A)
  }

  private static func isDigit(_ byte: UInt8) -> Bool {
    byte >= 0x30 && byte <= 0x39
  }

  private static func consume(_ bytes: UnsafeBufferPointer<UInt8>, _ index: inout Int, _ byte: UInt8) -> Bool {
    guard index < bytes.count, bytes[index] == byte else {
      return false
    }
    index += 1
    return true
  }

  /// Skips one or more spaces or tabs, as RFC 822 permits between tokens.
  private static func skipSpaces(_ bytes: UnsafeBufferPointer<UInt8>, _ index: inout Int) -> Bool {
    let start = index
    while index < bytes.count, bytes[index] == 0x20 || bytes[index] == 0x09 {
      index += 1
    }
    return index > start
  }

  /// Reads between `count.lowerBound` and `count.upperBound` digits.
  ///
  /// - Parameter count: A range, or a single count when both bounds are equal.
  private static func readDigits(
    _ bytes: UnsafeBufferPointer<UInt8>,
    _ index: inout Int,
    count: ClosedRange<Int>
  ) -> Int? {
    var value = 0
    var digits = 0
    var cursor = index
    while cursor < bytes.count, digits < count.upperBound, isDigit(bytes[cursor]) {
      value = value * 10 + Int(bytes[cursor] - 0x30)
      digits += 1
      cursor += 1
    }
    guard count.contains(digits) else {
      return nil
    }
    index = cursor
    return value
  }

  /// Reads exactly `count` digits.
  private static func readDigits(_ bytes: UnsafeBufferPointer<UInt8>, _ index: inout Int, count: Int) -> Int? {
    readDigits(bytes, &index, count: count ... count)
  }

  /// Reads a run of ASCII letters, lower-cased into a hash key.
  private static func readWord(_ bytes: UnsafeBufferPointer<UInt8>, _ index: inout Int) -> Int? {
    var hash = 0
    var cursor = index
    while cursor < bytes.count, isAlpha(bytes[cursor]) {
      hash = hash << 8 | Int(bytes[cursor] | 0x20)
      cursor += 1
    }
    guard cursor > index else {
      return nil
    }
    index = cursor
    return hash
  }

  /// Reads a three-letter month name.
  private static func readMonth(_ bytes: UnsafeBufferPointer<UInt8>, _ index: inout Int) -> Int? {
    var probe = index
    guard let word = readWord(bytes, &probe) else {
      return nil
    }
    guard let month = monthNames[word] else {
      return nil
    }
    index = probe
    return month
  }

  // MARK: Calendar arithmetic

  private static func daysInMonth(year: Int, month: Int) -> Int {
    switch month {
    case 1,
         3,
         5,
         7,
         8,
         10,
         12: 31
    case 4,
         6,
         9,
         11: 30
    case 2: isLeapYear(year) ? 29 : 28
    default: 0
    }
  }

  private static func isLeapYear(_ year: Int) -> Bool {
    (year % 4 == 0 && year % 100 != 0) || year % 400 == 0
  }

  /// The instant the fields denote.
  ///
  /// The date is turned into days since the epoch with Howard Hinnant's
  /// `days_from_civil`, which is exact for every year a document can write and
  /// needs no calendar, time zone database or locale.
  private static func instant(
    year: Int,
    month: Int,
    day: Int,
    hour: Int,
    minute: Int,
    second: Int,
    fraction: Double,
    offset: Int
  ) -> Date? {
    guard year >= 1, year <= 9999, (1 ... 12).contains(month), day >= 1, day <= daysInMonth(year: year, month: month),
          hour <= 23, minute <= 59, second <= 60
    else {
      return nil
    }

    let adjustedYear = month <= 2 ? year - 1 : year
    let era = (adjustedYear >= 0 ? adjustedYear : adjustedYear - 399) / 400
    let yearOfEra = adjustedYear - era * 400
    let dayOfYear = (153 * (month + (month > 2 ? -3 : 9)) + 2) / 5 + day - 1
    let dayOfEra = yearOfEra * 365 + yearOfEra / 4 - yearOfEra / 100 + dayOfYear
    let days = era * 146_097 + dayOfEra - 719_468

    let seconds = days * 86400 + hour * 3600 + minute * 60 + second - offset
    return Date(timeIntervalSince1970: Double(seconds) + fraction)
  }
}
