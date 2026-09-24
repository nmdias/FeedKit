//
// CommentAPITests.swift
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

/// Covers the `wfw:comment` and `wfw:commentRss` elements of the Comment API
/// namespace.
///
/// See https://github.com/nmdias/FeedKit/issues/216
struct CommentAPITests: FeedKitTestable {
  // MARK: Internal

  @Test
  func rssItemComments() throws {
    // Given
    let data = data(resource: "CommentAPI", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let items = try #require(feed.channel?.items)

    // Then
    #expect(items.count == 2)
    #expect(items[0].commentAPI?.comment == "https://example.com/comment?post=130")
    #expect(items[0].commentAPI?.commentRss == "https://example.com/news/130/comments.xml")
  }

  /// Both elements are optional, so an item may carry only one of them.
  @Test
  func rssItemWithCommentsFeedOnly() throws {
    // Given
    let data = data(resource: "CommentAPI", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let item = try #require(feed.channel?.items?.last)

    // Then
    #expect(item.commentAPI?.comment == nil)
    #expect(item.commentAPI?.commentRss == "https://example.com/news/131/comments.xml")
  }

  @Test
  func atomEntryComments() throws {
    // Given
    let data = data(resource: "AtomCommentAPI", withExtension: "xml")

    // When
    let feed = try AtomFeed(data: data)
    let entry = try #require(feed.entries?.first)

    // Then
    #expect(entry.commentAPI?.comment == "https://example.com/comment?post=130")
    #expect(entry.commentAPI?.commentRss == "https://example.com/news/130/comments.xml")
  }

  /// The specification asks readers to accept `wfw:commentRSS` alongside the
  /// correct `wfw:commentRss`, since both spellings have been published.
  @Test
  func capitalizedCommentRssSpelling() throws {
    // Given
    let data: Data = .init(Self.rssCapitalizedCommentRss.utf8)

    // When
    let feed = try RSSFeed(data: data)
    let item = try #require(feed.channel?.items?.first)

    // Then
    #expect(item.commentAPI?.commentRss == "https://example.com/news/130/comments.xml")
    #expect(item.commentAPI?.comment == nil)
  }

  /// A feed that does not use the namespace reports no comments, rather than
  /// empty placeholders.
  @Test
  func feedWithoutCommentAPIHasNone() throws {
    // Given
    let rssData = data(resource: "RSS", withExtension: "xml")
    let atomData = data(resource: "Atom", withExtension: "xml")

    // When
    let rssFeed = try RSSFeed(data: rssData)
    let atomFeed = try AtomFeed(data: atomData)

    // Then
    #expect(rssFeed.channel?.items?.allSatisfy { $0.commentAPI == nil } == true)
    #expect(atomFeed.entries?.allSatisfy { $0.commentAPI == nil } == true)
  }

  @Test
  func universalFeedCarriesCommentAPI() throws {
    // Given
    let data = data(resource: "CommentAPI", withExtension: "xml")

    // When
    let feed = try Feed(data: data)

    // Then
    #expect(feed.rss?.channel?.items?.first?.commentAPI?.comment == "https://example.com/comment?post=130")
  }

  /// The namespace is declared on the RSS root only when an item uses it, and
  /// the elements survive a decode of the generated document.
  @Test
  func encodingRoundTrip() throws {
    // Given
    let feed: RSSFeed = .init(
      channel: .init(
        title: "Example Feed",
        items: [
          .init(
            title: "Joining Mastodon",
            link: "https://example.com/news/130",
            commentAPI: .init(
              comment: "https://example.com/comment?post=130",
              commentRss: "https://example.com/news/130/comments.xml"
            )
          )
        ]
      )
    )

    // When
    let xml = try feed.toXMLString(formatted: true)
    let decoded = try RSSFeed(string: xml)

    // Then
    #expect(xml.contains("xmlns:wfw=\"http://wellformedweb.org/CommentAPI/\""))
    #expect(xml.contains("<wfw:commentRss>https://example.com/news/130/comments.xml</wfw:commentRss>"))
    #expect(xml.contains("<wfw:comment>https://example.com/comment?post=130</wfw:comment>"))
    #expect(decoded.channel?.items?.first?.commentAPI == .init(
      comment: "https://example.com/comment?post=130",
      commentRss: "https://example.com/news/130/comments.xml"
    ))
  }

  // MARK: Private

  /// An item that publishes the misspelled `wfw:commentRSS` element.
  private static let rssCapitalizedCommentRss = """
  <?xml version="1.0" encoding="UTF-8"?>
  <rss version="2.0" xmlns:wfw="http://wellformedweb.org/CommentAPI/">
    <channel>
      <title>Example Feed</title>
      <link>https://example.com/</link>
      <description>An example feed.</description>
      <item>
        <title>Joining Mastodon</title>
        <wfw:commentRSS>https://example.com/news/130/comments.xml</wfw:commentRSS>
      </item>
    </channel>
  </rss>
  """
}
