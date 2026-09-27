//
// DateFormattingTests.swift
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
import Testing
@testable import FeedKit

/// The permissive formatter picks the date's family from the date itself, so a
/// feed that mixes families — which real feeds do — still reads both.
@Suite("Date formatting")
struct DateFormattingTests {
  /// The instant a UTC date denotes.
  private static func utc(_ year: Int, _ month: Int, _ day: Int, _ hour: Int, _ minute: Int, _ second: Int) -> Date {
    var components = DateComponents()
    components.year = year; components.month = month; components.day = day
    components.hour = hour; components.minute = minute; components.second = second
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
    return calendar.date(from: components) ?? .distantPast
  }

  @Test("A document that mixes both date families decodes both")
  func decodesMixedFamilies() throws {
    // The shape the Guardian, InfoQ and Medium feeds actually publish: an
    // RFC 822 `pubDate` beside an ISO `dc:date`, item by item.
    let feed = try RSSFeed(string: """
    <rss version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/">
      <channel>
        <title>Mixed</title>
        <lastBuildDate>Sun, 27 Sep 2026 11:00:57 -0400</lastBuildDate>
        <item>
          <title>One</title>
          <pubDate>Sun, 27 Sep 2026 11:00:57 -0400</pubDate>
          <dc:date>2026-09-27T15:00:57Z</dc:date>
        </item>
        <item>
          <title>Two</title>
          <pubDate>Mon, 28 Sep 2026 08:30:00 GMT</pubDate>
          <dc:date>2026-09-28T08:30:00Z</dc:date>
        </item>
      </channel>
    </rss>
    """)

    let first = try #require(feed.channel?.items?.first)
    #expect(first.pubDate == Self.utc(2026, 9, 27, 15, 0, 57))
    #expect(first.dublinCore?.date == Self.utc(2026, 9, 27, 15, 0, 57))
    #expect(feed.channel?.items?.last?.pubDate == Self.utc(2026, 9, 28, 8, 30, 0))
  }

  @Test("Both families are read through the permissive formatter")
  func readsBothFamilies() {
    let formatter: FeedDateFormatter = .init(spec: .permissive)

    // ISO first, RFC 822 second: the order in which they are tried must not
    // decide what a date means.
    #expect(formatter.date(from: "2026-09-24T22:55:00Z") == Self.utc(2026, 9, 24, 22, 55, 0))
    #expect(formatter.date(from: "Sat, 07 Sep 2002 00:00:01 GMT") == Self.utc(2002, 9, 7, 0, 0, 1))
    #expect(formatter.date(from: "2026-09-24T22:55:00.529Z") != nil)
    #expect(formatter.date(from: "2026-09-27T14:14:00Z") != nil)
  }

  @Test("A date with no time is read as midnight UTC, which W3CDTF allows")
  func readsDateOnlyInstants() {
    let formatter: FeedDateFormatter = .init(spec: .permissive)

    // RSS 1.0's `dc:date` and the `prism:coverDate` of syndicated newspaper
    // feeds write these; 289 of them appeared across 242 live feeds, and every
    // one decoded to nil before.
    #expect(formatter.date(from: "2026-09-24") == Self.utc(2026, 9, 24, 0, 0, 0))
    #expect(formatter.date(from: "2026-09") == Self.utc(2026, 9, 1, 0, 0, 0))
  }
}
