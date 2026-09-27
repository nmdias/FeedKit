//
// DateParsingTests.swift
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

@testable import FeedKit
import Foundation
import Testing

/// Coverage for the direct date parser, including the shapes real feeds use
/// that the specifications do not allow.
struct DateParsingTests {
  // MARK: Internal

  @Test("RFC 3339, the format Atom requires")
  func parsesRFC3339() {
    #expect(FeedDateParser.date(from: "2003-12-13T18:30:02Z") == date(2003, 12, 13, 18, 30, 2))
    #expect(FeedDateParser.date(from: "2003-12-13T18:30:02+01:00") == date(2003, 12, 13, 17, 30, 2))
    #expect(FeedDateParser.date(from: "2003-12-13T18:30:02-08:00") == date(2003, 12, 14, 2, 30, 2))
    #expect(FeedDateParser.date(from: "2003-12-13T18:30:02.25Z") == date(2003, 12, 13, 18, 30, 2, fraction: 0.25))
    #expect(FeedDateParser.date(from: "2003-12-13T18:30:02.250Z") == date(2003, 12, 13, 18, 30, 2, fraction: 0.25))
  }

  @Test("RFC 822, the format RSS 2.0 requires")
  func parsesRFC822() {
    #expect(FeedDateParser.date(from: "Sat, 07 Sep 2002 00:00:01 GMT") == date(2002, 9, 7, 0, 0, 1))
    #expect(FeedDateParser.date(from: "Sat, 07 Sep 2002 00:00:01 +0000") == date(2002, 9, 7, 0, 0, 1))
    #expect(FeedDateParser.date(from: "Sat, 07 Sep 2002 00:00:01 -0500") == date(2002, 9, 7, 5, 0, 1))
    #expect(FeedDateParser.date(from: "Sat, 07 Sep 2002 00:00 GMT") == date(2002, 9, 7, 0, 0, 0))
    #expect(FeedDateParser.date(from: "07 Sep 2002 00:00:01 GMT") == date(2002, 9, 7, 0, 0, 1))
  }

  @Test("The drift real feeds show, and what it means")
  func parsesRealWorldDrift() {
    // A space where the specification requires a `T`, lower case, an offset
    // without a colon, a comma as the decimal mark: all of these appear in the
    // wild, and all of them mean what the canonical spelling means.
    #expect(FeedDateParser.date(from: "2020-10-09 04:30:38Z") == date(2020, 10, 9, 4, 30, 38))
    #expect(FeedDateParser.date(from: "2020-10-09t04:30:38z") == date(2020, 10, 9, 4, 30, 38))
    #expect(FeedDateParser.date(from: "2020-10-09T04:30:38+0100") == date(2020, 10, 9, 3, 30, 38))
    #expect(FeedDateParser.date(from: "2020-10-09T04:30:38,25Z") == date(2020, 10, 9, 4, 30, 38, fraction: 0.25))
    #expect(FeedDateParser.date(from: "2020-10-09T04:30:38+01") == date(2020, 10, 9, 3, 30, 38))
    // A trailing RFC 822 comment.
    #expect(FeedDateParser.date(from: "Fri, 09 Oct 2020 04:30:38 GMT (UTC)") == date(2020, 10, 9, 4, 30, 38))
    // A named zone with the offset written out, as Java formats it.
    #expect(FeedDateParser.date(from: "Tue, 03 Oct 2023 09:00:00 GMT+0200") == date(2023, 10, 3, 7, 0, 0))
    #expect(FeedDateParser.date(from: "Tue, 03 Oct 2023 09:00:00 GMT-05:00") == date(2023, 10, 3, 14, 0, 0))
  }

  @Test("A date with no zone is read as UTC, never as the device's zone")
  func assumesUTCWithoutAZone() {
    #expect(FeedDateParser.date(from: "2020-10-09T04:30:38") == date(2020, 10, 9, 4, 30, 38))
    #expect(FeedDateParser.date(from: "Fri, 09 Oct 2020 04:30:38") == date(2020, 10, 9, 4, 30, 38))
  }

  @Test("W3CDTF instants of any precision, which RSS 1.0's dc:date uses")
  func parsesW3CDTF() {
    #expect(FeedDateParser.date(from: "2003") == date(2003, 1, 1, 0, 0, 0))
    #expect(FeedDateParser.date(from: "2003-12") == date(2003, 12, 1, 0, 0, 0))
    #expect(FeedDateParser.date(from: "2003-12-13") == date(2003, 12, 13, 0, 0, 0))
  }

  @Test("A two-digit year is read with RFC 2822's window")
  func expandsTwoDigitYears() {
    // `Sat, 07 Sep 02` is 2002, not the year 2 — which is what a `yyyy` pattern
    // reads it as, and what this library used to report.
    #expect(FeedDateParser.date(from: "Sat, 07 Sep 02 00:00:01 GMT") == date(2002, 9, 7, 0, 0, 1))
    #expect(FeedDateParser.date(from: "Sat, 07 Sep 96 00:00:01 GMT") == date(1996, 9, 7, 0, 0, 1))
    #expect(RFC822DateFormatter().date(from: "Sat, 07 Sep 02 00:00:01 GMT") == date(2, 9, 7, 0, 0, 1))
  }

  @Test("The zone abbreviations RFC 822 defines")
  func parsesNamedZones() {
    #expect(FeedDateParser.date(from: "Fri, 09 Oct 2020 04:30:38 UT") == date(2020, 10, 9, 4, 30, 38))
    #expect(FeedDateParser.date(from: "Fri, 09 Oct 2020 04:30:38 UTC") == date(2020, 10, 9, 4, 30, 38))
    #expect(FeedDateParser.date(from: "Fri, 09 Oct 2020 04:30:38 EST") == date(2020, 10, 9, 9, 30, 38))
    #expect(FeedDateParser.date(from: "Fri, 09 Oct 2020 04:30:38 PDT") == date(2020, 10, 9, 11, 30, 38))
  }

  @Test("A weekday is redundant, and is not checked against the date")
  func ignoresTheWeekday() {
    // The 9th of October 2020 was a Friday; a document that says otherwise is
    // still read, because the specification calls the weekday redundant.
    #expect(FeedDateParser.date(from: "Mon, 09 Oct 2020 04:30:38 GMT") == date(2020, 10, 9, 4, 30, 38))
  }

  @Test("The parser agrees with the formatter wherever the formatter can parse")
  func agreesWithTheFormatter() {
    let samples = [
      "2003-12-13T18:30:02Z",
      "2003-12-13T18:30:02.25Z",
      "2003-12-13T18:30:02+01:00",
      "2003-12-13T18:30:02-08:00",
      "Sat, 07 Sep 2002 00:00:01 GMT",
      "Sat, 07 Sep 2002 00:00:01 +0000",
      "Sat, 07 Sep 2002 00:00:01 -0500",
      "Fri, 09 Oct 2020 04:30:38 EST",
      "Fri, 09 Oct 2020 04:30:38 PDT",
      "Sun, 16 Aug 2015 05:00:00 GMT",
      "Mon, 26 Jan 2004 16:31:00 EST",
      "Thu, 01 Apr 2021 08:00:00 EST",
      "Fri, 15 Mar 2019 02:18:06 +0200",
      "2007-10-05T15:00:00Z"
    ]

    // The formatters without the direct parser in front of them: this is the
    // behaviour the parser has to reproduce, not change.
    let iso: RFC3339DateFormatter = .init()
    let rfc: RFC822DateFormatter = .init()

    for sample in samples {
      guard let expected = iso.date(from: sample) ?? rfc.date(from: sample) else {
        Issue.record("the formatter chain no longer parses \(sample)")
        continue
      }
      #expect(FeedDateParser.date(from: sample) == expected, "\(sample)")
    }
  }

  @Test("Shapes that are ambiguous or outside the specifications are refused")
  func refusesWhatItShould() {
    // A bare number could be an epoch or a compact date; guessing invents a time.
    #expect(FeedDateParser.date(from: "1696003200") == nil)
    #expect(FeedDateParser.date(from: "20240101") == nil)

    // Month names outside English: RFC 822 fixes English, and a locale guess
    // would read the same word differently on different devices.
    #expect(FeedDateParser.date(from: "Fr, 15 Mär 2019 02:18:06 +0200") == nil)

    // Zone abbreviations no feed specification defines.
    #expect(FeedDateParser.date(from: "Fri, 09 Oct 2020 04:30:38 CEST") == nil)
    #expect(FeedDateParser.date(from: "Fri, 09 Oct 2020 04:30:38 BST") == nil)

    // Out of range: the formatter is lenient, so these stay with the formatter.
    #expect(FeedDateParser.date(from: "2003-02-30T00:00:00Z") == nil)
    #expect(FeedDateParser.date(from: "2003-12-13T25:00:00Z") == nil)
    #expect(FeedDateParser.date(from: "2003-13-13T00:00:00Z") == nil)

    // Not a date at all.
    #expect(FeedDateParser.date(from: "") == nil)
    #expect(FeedDateParser.date(from: "yesterday") == nil)
    #expect(FeedDateParser.date(from: "2003-12-13T18:30:02Z junk") == nil)
  }

  @Test("Every date in the fixtures is parsed by the direct parser")
  func parsesTheFixtureDates() {
    // The parser must not quietly hand work back to the formatter: a fixture
    // date that only the formatter can read means the fast path is missing a
    // shape real feeds use.
    for resource in ["RSS", "RDF", "RDFDC", "RSSDC", "Atom", "AtomDC", "AtomMedia", "iTunes", "Podcast"] {
      guard let url = Bundle.module.url(forResource: resource, withExtension: "xml"),
            let text = try? String(contentsOf: url, encoding: .utf8)
      else {
        Issue.record("missing fixture \(resource).xml")
        continue
      }

      for date in Self.dateElements(in: text) {
        #expect(FeedDateParser.date(from: date) != nil, "\(resource).xml: \(date)")
      }
    }
  }

  // MARK: Private

  /// The text of every date-bearing element in a document.
  private static func dateElements(in xml: String) -> [String] {
    let pattern = "<(pubDate|lastBuildDate|updated|published|dc:date|itunes:releaseDate)>([^<]*)</"
    guard let regex = try? NSRegularExpression(pattern: pattern) else {
      return []
    }
    let text = xml as NSString
    return regex
      .matches(in: xml, range: NSRange(location: 0, length: text.length))
      .map { text.substring(with: $0.range(at: 2)) }
      .filter { !$0.isEmpty }
  }

  /// The instant a UTC date denotes, for readability.
  private func date(
    _ year: Int,
    _ month: Int,
    _ day: Int,
    _ hour: Int,
    _ minute: Int,
    _ second: Int,
    fraction: Double = 0
  ) -> Date {
    var components: DateComponents = .init()
    components.year = year
    components.month = month
    components.day = day
    components.hour = hour
    components.minute = minute
    components.second = second
    var calendar: Calendar = .init(identifier: .gregorian)
    calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
    let base = calendar.date(from: components) ?? .distantPast
    return base.addingTimeInterval(fraction)
  }
}
