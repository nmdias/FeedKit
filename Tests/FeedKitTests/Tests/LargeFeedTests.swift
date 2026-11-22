//
// LargeFeedTests.swift
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

/// A channel with thousands of items, the shape of a long-running podcast's
/// full archive. Building that tree used to re-parent every existing item on
/// each append; this pins that every item still decodes, in order, with its
/// fields intact.
struct LargeFeedTests: FeedKitTestable {
  // MARK: Internal

  @Test
  func thousandsOfItemsDecodeInOrder() throws {
    // Given
    let count = 3000
    let data: Data = .init(Self.feed(itemCount: count).utf8)

    // When
    let feed = try RSSFeed(data: data)

    // Then
    let items = try #require(feed.channel?.items)
    #expect(feed.channel?.title == "Archive")
    #expect(items.count == count)
    #expect(items.map(\.guid?.text) == (0 ..< count).map { "episode-\($0)" })
    #expect(items.allSatisfy { $0.pubDate != nil })
    #expect(items.last?.enclosure?.attributes?.url == "https://example.com/\(count - 1).mp3")
    #expect(items.last?.iTunes?.duration == 3600)
  }

  // MARK: Private

  private static func feed(itemCount: Int) -> String {
    let items = (0 ..< itemCount).map { index in
      """
      <item>
        <title>Episode \(index)</title>
        <guid isPermaLink="false">episode-\(index)</guid>
        <pubDate>Mon, 02 Nov 2026 10:00:00 +0000</pubDate>
        <enclosure url="https://example.com/\(index).mp3" length="1000" type="audio/mpeg"/>
        <itunes:duration>01:00:00</itunes:duration>
      </item>
      """
    }.joined(separator: "\n")

    return """
    <?xml version="1.0" encoding="UTF-8"?>
    <rss version="2.0" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd">
    <channel>
      <title>Archive</title>
    \(items)
    </channel>
    </rss>
    """
  }
}
