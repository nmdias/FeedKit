//
// FeedNamespaceTests.swift
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
import Testing

@Suite("FeedNamespace")
struct FeedNamespaceTests {
  @Test("Every namespace's attributeName is xmlns: followed by its bare prefix")
  func attributeNameMatchesPrefix() {
    for namespace in FeedNamespace.allCases {
      #expect(namespace.attributeName == "xmlns:\(namespace.prefix)")
    }
  }

  @Test("init?(url:) resolves every known namespace's URL back to itself")
  func urlLookupResolvesKnownNamespaces() {
    for namespace in FeedNamespace.allCases {
      #expect(FeedNamespace(url: namespace.url) == namespace)
    }
  }

  @Test("init?(url:) returns nil for an unknown URL")
  func urlLookupReturnsNilForUnknownNamespace() {
    #expect(FeedNamespace(url: "http://example.com/not-a-namespace") == nil)
  }

  @Test("namespaceMap contains every namespace's URL mapped to its bare prefix")
  func namespaceMapContainsAllCases() {
    let map = FeedNamespace.namespaceMap
    #expect(map.count == FeedNamespace.allCases.count)
    for namespace in FeedNamespace.allCases {
      #expect(map[namespace.url] == namespace.prefix)
    }
  }

  @Test("shouldInclude(in: RSSFeed) reflects channel- and item-level namespaced content")
  func shouldIncludeInRSSFeed() {
    let feed = RSSFeed(
      channel: .init(
        items: [.init(markdown: "**hi**", dublinCore: .init(creator: "Jane"))],
        dublinCore: .init(title: "Channel DC"),
        atom: .init(links: [.init(attributes: .init(href: "http://example.com/feed"))])
      )
    )

    #expect(FeedNamespace.dublinCore.shouldInclude(in: feed))
    #expect(FeedNamespace.atom.shouldInclude(in: feed))
    #expect(FeedNamespace.source.shouldInclude(in: feed))
    #expect(!FeedNamespace.media.shouldInclude(in: feed))
    #expect(!FeedNamespace.podcast.shouldInclude(in: feed))
  }

  @Test("shouldInclude(in: AtomFeed) includes dc and media, matching AtomFeed/AtomFeedEntry's actual fields")
  func shouldIncludeInAtomFeedCoversDublinCoreAndMedia() {
    let feedWithChannelLevelDublinCore = AtomFeed(dublinCore: .init(creator: "Jane"))
    let feedWithEntryLevelDublinCore = AtomFeed(entries: [.init(dublinCore: .init(creator: "Jane"))])
    let feedWithMedia = AtomFeed(entries: [
      .init(media: .init(contents: [.init(attributes: .init(url: "http://example.com/video.mp4"))]))
    ])
    let plainFeed = AtomFeed()

    #expect(FeedNamespace.dublinCore.shouldInclude(in: feedWithChannelLevelDublinCore))
    #expect(FeedNamespace.dublinCore.shouldInclude(in: feedWithEntryLevelDublinCore))
    #expect(FeedNamespace.media.shouldInclude(in: feedWithMedia))
    #expect(!FeedNamespace.dublinCore.shouldInclude(in: plainFeed))
    #expect(!FeedNamespace.media.shouldInclude(in: plainFeed))
  }

  @Test(
    "shouldInclude(in: AtomFeed) is false for namespaces AtomFeed/AtomFeedEntry have no field for",
    arguments: [
      FeedNamespace.itunes,
      FeedNamespace.syndication,
      FeedNamespace.content,
      FeedNamespace.gml,
      FeedNamespace.atom,
      FeedNamespace.podcast,
      FeedNamespace.source
    ]
  )
  func shouldIncludeInAtomFeedIsFalseForUnsupportedNamespaces(namespace: FeedNamespace) {
    let feed = AtomFeed(
      entries: [.init(
        media: .init(contents: [.init(attributes: .init(url: "http://example.com/video.mp4"))]),
        youTube: .init(videoID: "abc123"),
        geoRSS: .init(point: .init(position: (latitude: 45, longitude: -5)))
      )],
      dublinCore: .init(creator: "Jane")
    )

    #expect(!namespace.shouldInclude(in: feed))
  }
}
