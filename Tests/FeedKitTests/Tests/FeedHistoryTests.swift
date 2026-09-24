//
// FeedHistoryTests.swift
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

/// Covers the empty `fh:complete` and `fh:archive` elements of Feed Paging and
/// Archiving (RFC 5005).
///
/// See https://github.com/nmdias/FeedKit/issues/194
struct FeedHistoryTests: FeedKitTestable {
  // MARK: Internal

  @Test
  func atomArchiveDocument() throws {
    // Given
    let data = data(resource: "AtomFeedHistory", withExtension: "xml")

    // When
    let feed = try AtomFeed(data: data)

    // Then
    #expect(feed.feedHistory?.isArchive == true)
    #expect(feed.feedHistory?.isComplete == nil)
  }

  @Test
  func atomCompleteFeed() throws {
    // Given
    let data: Data = .init(Self.atomComplete.utf8)

    // When
    let feed = try AtomFeed(data: data)

    // Then
    #expect(feed.feedHistory?.isComplete == true)
    #expect(feed.feedHistory?.isArchive == nil)
  }

  @Test
  func rssArchiveDocument() throws {
    // Given
    let data = data(resource: "RSSFeedHistory", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)

    // Then
    #expect(feed.channel?.feedHistory?.isArchive == true)
    #expect(feed.channel?.feedHistory?.isComplete == nil)
  }

  @Test
  func rssCompleteFeed() throws {
    // Given
    let data: Data = .init(Self.rssComplete.utf8)

    // When
    let feed = try RSSFeed(data: data)

    // Then
    #expect(feed.channel?.feedHistory?.isComplete == true)
    #expect(feed.channel?.feedHistory?.isArchive == nil)
  }

  /// A feed that does not use the namespace reports no history, rather than
  /// empty placeholders.
  @Test
  func feedWithoutHistoryHasNone() throws {
    // Given
    let atomData = data(resource: "Atom", withExtension: "xml")
    let rssData = data(resource: "RSS", withExtension: "xml")

    // When
    let atomFeed = try AtomFeed(data: atomData)
    let rssFeed = try RSSFeed(data: rssData)

    // Then
    #expect(atomFeed.feedHistory == nil)
    #expect(rssFeed.channel?.feedHistory == nil)
  }

  @Test
  func universalFeedCarriesHistory() throws {
    // Given
    let data = data(resource: "AtomFeedHistory", withExtension: "xml")

    // When
    let feed = try Feed(data: data)

    // Then
    #expect(feed.atom?.feedHistory?.isArchive == true)
  }

  /// `fh:complete` is an empty element, so it must be written without text and
  /// must survive a decode of the generated document.
  @Test
  func encodingRoundTrip() throws {
    // Given
    let feed: RSSFeed = .init(
      channel: .init(
        title: "Example Feed",
        feedHistory: .init(isComplete: true)
      )
    )

    // When
    let xml = try feed.toXMLString(formatted: true)
    let decoded = try RSSFeed(string: xml)

    // Then
    #expect(xml.contains("xmlns:fh=\"http://purl.org/syndication/history/1.0\""))
    #expect(xml.contains("<fh:complete />"))
    #expect(decoded.channel?.feedHistory?.isComplete == true)
    #expect(decoded.channel?.feedHistory?.isArchive == nil)
  }

  // MARK: Private

  /// A complete feed, from Section 2 of RFC 5005.
  private static let atomComplete = """
  <?xml version="1.0" encoding="utf-8"?>
  <feed xmlns="http://www.w3.org/2005/Atom" xmlns:fh="http://purl.org/syndication/history/1.0">
    <title>NetMovies Queue</title>
    <id>urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6</id>
    <updated>2003-12-13T18:30:02Z</updated>
    <fh:complete/>
  </feed>
  """

  /// A complete feed, from Appendix B of RFC 5005.
  private static let rssComplete = """
  <?xml version="1.0"?>
  <rss version="2.0" xmlns:fh="http://purl.org/syndication/history/1.0">
    <channel>
      <title>NetMovies Queue</title>
      <link>http://netmovies.example.org/</link>
      <description>The DVDs you'll receive next.</description>
      <fh:complete/>
      <item>
        <title>Casablanca</title>
        <link>http://netmovies.example.org/movies/Casablanca</link>
        <description>Here's looking at you, kid...</description>
        <pubDate>Tue, 03 Jun 2003 09:39:21 GMT</pubDate>
        <guid isPermaLink="false">urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a</guid>
      </item>
    </channel>
  </rss>
  """
}
