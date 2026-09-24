//
// PodloveSimpleChaptersTests.swift
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

/// Covers the `psc:chapters` and `psc:chapter` elements of the Podlove Simple
/// Chapters namespace.
///
/// See https://github.com/nmdias/FeedKit/issues/201
struct PodloveSimpleChaptersTests: FeedKitTestable {
  @Test
  func rssItemChapters() throws {
    // Given
    let data = data(resource: "PodloveSimpleChapters", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let chapters = try #require(feed.channel?.items?.first?.podloveSimpleChapters?.chapters)

    // Then
    #expect(chapters.version == "1.2")
    #expect(chapters.chapters?.count == 4)
  }

  /// The `start` and `title` attributes are mandatory; `href` and `image` are
  /// optional, so a chapter may carry any combination of them.
  @Test
  func chapterAttributes() throws {
    // Given
    let data = data(resource: "PodloveSimpleChapters", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let chapters = try #require(feed.channel?.items?.first?.podloveSimpleChapters?.chapters?.chapters)

    // Then
    #expect(chapters[0].attributes?.start == "0")
    #expect(chapters[0].attributes?.title == "Welcome")
    #expect(chapters[0].attributes?.href == nil)
    #expect(chapters[0].attributes?.image == nil)

    #expect(chapters[1].attributes?.start == "3:07")
    #expect(chapters[1].attributes?.title == "Introducing Podlove")
    #expect(chapters[1].attributes?.href == "https://example.com/podlove")
    #expect(chapters[1].attributes?.image == nil)

    // Normal Play Time accepts an optional fractional part.
    #expect(chapters[2].attributes?.start == "8:26.250")
    #expect(chapters[2].attributes?.image == "https://example.com/images/plugin.png")

    #expect(chapters[3].attributes?.start == "12:42")
    #expect(chapters[3].attributes?.title == "Resumée")
  }

  /// The list is kept in the order it is published in, because clients must be
  /// able to resort it themselves.
  @Test
  func chapterOrderIsPreserved() throws {
    // Given
    let data = data(resource: "PodloveSimpleChapters", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let chapters = try #require(feed.channel?.items?.first?.podloveSimpleChapters?.chapters?.chapters)

    // Then
    #expect(chapters.map { $0.attributes?.start } == ["0", "3:07", "8:26.250", "12:42"])
  }

  /// The version attribute is optional and defaults to `1.0` when absent, which
  /// is reported as no published version rather than as an invented one.
  @Test
  func chapterListWithoutVersion() throws {
    // Given
    let data = data(resource: "PodloveSimpleChapters", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let chapters = try #require(feed.channel?.items?.last?.podloveSimpleChapters?.chapters)

    // Then
    #expect(chapters.version == nil)
    #expect(chapters.chapters?.count == 1)
    #expect(chapters.chapters?.first?.attributes?.start == "37")
    #expect(chapters.chapters?.first?.attributes?.title == "A Single Chapter")
  }

  /// An item that publishes no chapter list reports none, rather than an empty
  /// placeholder.
  @Test
  func itemWithoutChaptersHasNone() throws {
    // Given
    let data = data(resource: "PodloveSimpleChapters", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let item = try #require(feed.channel?.items?[1])

    // Then
    #expect(item.podloveSimpleChapters == nil)
  }

  @Test
  func atomEntryChapters() throws {
    // Given
    let data = data(resource: "AtomPodloveSimpleChapters", withExtension: "xml")

    // When
    let feed = try AtomFeed(data: data)
    let chapters = try #require(feed.entries?.first?.podloveSimpleChapters?.chapters)

    // Then
    #expect(chapters.version == "1.1")
    #expect(chapters.chapters?.count == 2)
    #expect(chapters.chapters?.first?.attributes?.start == "0")
    #expect(chapters.chapters?.first?.attributes?.title == "Welcome")
  }

  /// A feed that does not use the namespace reports no chapters.
  @Test
  func feedWithoutNamespaceHasNone() throws {
    // Given
    let rssData = data(resource: "RSS", withExtension: "xml")
    let atomData = data(resource: "Atom", withExtension: "xml")

    // When
    let rssFeed = try RSSFeed(data: rssData)
    let atomFeed = try AtomFeed(data: atomData)

    // Then
    #expect(rssFeed.channel?.items?.allSatisfy { $0.podloveSimpleChapters == nil } == true)
    #expect(atomFeed.entries?.allSatisfy { $0.podloveSimpleChapters == nil } == true)
  }

  @Test
  func universalFeedCarriesChapters() throws {
    // Given
    let data = data(resource: "PodloveSimpleChapters", withExtension: "xml")

    // When
    let feed = try Feed(data: data)

    // Then
    let chapters = try #require(feed.rss?.channel?.items?.first?.podloveSimpleChapters?.chapters)
    #expect(chapters.chapters?.count == 4)
  }

  /// The namespace is declared on the RSS root only when an item uses it, and
  /// the chapter list survives a decode of the generated document.
  @Test
  func encodingDeclaresNamespaceOnlyWhenUsed() throws {
    // Given
    let withoutChapters: RSSFeed = .init(channel: .init(
      title: "Example Feed",
      items: [.init(title: "Fiat Lux")]
    ))
    let withChapters: RSSFeed = .init(channel: .init(
      title: "Example Feed",
      items: [.init(
        title: "Fiat Lux",
        podloveSimpleChapters: .init(chapters: .init(
          version: "1.2",
          chapters: [
            .init(attributes: .init(start: "0", title: "Welcome")),
            .init(attributes: .init(
              start: "3:07",
              title: "Introducing Podlove",
              href: "https://example.com/podlove"
            ))
          ]
        ))
      )]
    ))

    // When
    let plainXML = try withoutChapters.toXMLString(formatted: true)
    let chaptersXML = try withChapters.toXMLString(formatted: true)

    // Then
    #expect(plainXML.contains("xmlns:psc") == false)
    #expect(chaptersXML.contains("xmlns:psc=\"http://podlove.org/simple-chapters\""))
    #expect(chaptersXML.contains("<psc:chapters version=\"1.2\">"))
    #expect(chaptersXML.contains("<psc:chapter start=\"0\" title=\"Welcome\" />"))

    let decoded = try RSSFeed(string: chaptersXML)
    let decodedChapters = try #require(
      decoded.channel?.items?.first?.podloveSimpleChapters?.chapters?.chapters
    )
    #expect(decodedChapters.count == 2)
    #expect(decodedChapters[0].attributes?.start == "0")
    #expect(decodedChapters[0].attributes?.title == "Welcome")
    #expect(decodedChapters[1].attributes?.start == "3:07")
    #expect(decodedChapters[1].attributes?.href == "https://example.com/podlove")
  }
}
