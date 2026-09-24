//
// SourceMarkdownTests.swift
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
@testable import XMLKit

/// Covers `<source:markdown>` elements from the `http://source.scripting.com/`
/// namespace, as produced by micro.blog feeds such as
/// https://netnewswire.blog/feed.xml
///
/// The item element and the namespace share the name `source`, so an item that
/// uses `<source:markdown>` without a plain RSS `<source>` element is what
/// previously made decoding pick the wrong node.
struct SourceMarkdownTests: FeedKitTestable {
  // MARK: Internal

  @Test
  func markdownOnlyItemParses() throws {
    // Given
    let data: Data = .init(Self.markdownOnly.utf8)

    // When
    let feed = try Feed(data: data)

    // Then
    guard case let .rss(rss) = feed else {
      Issue.record("Expected an RSS feed.")
      return
    }
    let item = try #require(rss.channel?.items?.first)
    #expect(item.markdown?.contains("On his blog") == true)
    #expect(item.source == nil)
  }

  @Test
  func markdownOnlyItemParsesAsRSSFeed() throws {
    // Given
    let data: Data = .init(Self.markdownOnly.utf8)

    // When
    let feed = try RSSFeed(data: data)

    // Then
    let item = try #require(feed.channel?.items?.first)
    #expect(item.markdown?.contains("On his blog") == true)
    #expect(item.source == nil)
  }

  /// The `source` prefix of `<source:markdown>` must not be resolved to the RSS
  /// `<source>` element, which is the failure reported in issue #215.
  @Test
  func markdownPrefixIsNotAnElement() throws {
    // Given
    let data: Data = .init(Self.markdownOnly.utf8)
    let reader: XMLReader = .init(data: data)
    let root = try #require(try reader.read().get().root)
    let item = try #require(root.child(for: "channel")?.child(for: "item"))

    // When
    let child = item.child(for: "source")

    // Then
    #expect(child == nil)
    #expect(item.child(for: "source:markdown")?.text?.contains("On his blog") == true)
  }

  /// A `<source:markdown>` element next to a real `<source>` element must still
  /// let the markdown be decoded and the source element keep its own text.
  @Test
  func markdownAndSourceElementCoexist() throws {
    // Given
    let data: Data = .init("""
    <?xml version="1.0" encoding="utf-8" standalone="yes" ?>
    <rss xmlns:source="http://source.scripting.com/" version="2.0">
      <channel>
        <item>
          <source:markdown>markdown body</source:markdown>
          <source url="http://la.example.com/rss.xml">Los Angeles Herald-Examiner</source>
        </item>
      </channel>
    </rss>
    """.utf8)

    // When
    let feed = try RSSFeed(data: data)

    // Then
    let item = try #require(feed.channel?.items?.first)
    #expect(item.markdown == "markdown body")
    #expect(item.source?.text == "Los Angeles Herald-Examiner")
    #expect(item.source?.attributes?.url == "http://la.example.com/rss.xml")
  }

  /// Parses the feed as reported in issue #215, which is a valid RSS feed that
  /// uses `<source:markdown>` for every item and no plain `<source>` element.
  @Test
  func netNewsWireFeedParses() throws {
    // Given
    let data = data(resource: "NetNewsWire", withExtension: "xml")

    // When
    let feed = try Feed(data: data)

    // Then
    guard case let .rss(rss) = feed else {
      Issue.record("Expected an RSS feed.")
      return
    }
    let items = try #require(rss.channel?.items)
    #expect(items.count == 25)
    #expect(items.allSatisfy { $0.markdown?.isEmpty == false })
    #expect(items.allSatisfy { $0.source == nil })
  }

  // MARK: Private

  /// A `<source:markdown>` element with no plain `<source>` sibling.
  private static let markdownOnly = """
  <?xml version="1.0" encoding="utf-8" standalone="yes" ?>
  <rss xmlns:source="http://source.scripting.com/" version="2.0">
    <channel>
      <title>NetNewsWire</title>
      <link>https://netnewswire.blog/</link>
      <description></description>
      <item>
        <title>Time to Start Doing Feature Requests</title>
        <link>https://netnewswire.blog/2026/08/26/time-to-start-doing-feature.html</link>
        <guid>http://NetNewsWire.micro.blog/2026/08/26/time-to-start-doing-feature.html</guid>
        <description>&lt;p&gt;On his blog.&lt;/p&gt;</description>
        <source:markdown>On his blog, Brent writes about how we've fixed most of the bugs.
  </source:markdown>
      </item>
    </channel>
  </rss>
  """
}
