//
// RSSSerializationTests.swift
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

struct RSSSerializationTests: FeedKitTestable {
  @Test("Metacharacters in text and attributes survive a serialization round trip")
  func roundTripsMetacharacters() throws {
    // Given
    let feed: RSSFeed = .init(channel: .init(
      title: "A & B < C > D",
      link: "https://example.com/?a=1&b=2",
      description: #"Quotes: "double" and 'single'"#,
      items: [.init(
        title: "Tom & Jerry",
        link: "https://example.com/article?a=1&b=2",
        description: "5 < 6 & 7 > 2",
        enclosure: .init(attributes: .init(
          url: "https://example.com/audio?a=1&b=2",
          length: 42,
          type: "audio/mpeg"
        ))
      )]
    ))

    // When
    let xml = try feed.toXMLString(formatted: true)

    // Then the document is well-formed and decodes back to the original values.
    let decoded = try RSSFeed(string: xml)
    #expect(decoded.channel?.title == "A & B < C > D")
    #expect(decoded.channel?.link == "https://example.com/?a=1&b=2")
    #expect(decoded.channel?.description == #"Quotes: "double" and 'single'"#)

    let item = decoded.channel?.items?.first
    #expect(item?.title == "Tom & Jerry")
    #expect(item?.link == "https://example.com/article?a=1&b=2")
    #expect(item?.description == "5 < 6 & 7 > 2")
    #expect(item?.enclosure?.attributes?.url == "https://example.com/audio?a=1&b=2")

    // And the metacharacters are escaped in the emitted document.
    #expect(xml.contains("<title>A &amp; B &lt; C &gt; D</title>"))
    #expect(xml.contains(#"url="https://example.com/audio?a=1&amp;b=2""#))
    #expect(!xml.contains(#"url="https://example.com/audio?a=1&b=2""#))
  }

  @Test("Ampersands in a media:content url attribute are escaped")
  func escapesAmpersandInMediaContentURL() throws {
    // Given
    let feed: RSSFeed = .init(channel: .init(
      title: "Example Feed",
      items: [.init(
        title: "Example Item",
        media: .init(contents: [
          .init(attributes: .init(url: "https://example.com/video?a=1&b=2"))
        ])
      )]
    ))

    // When
    let xml = try feed.toXMLString(formatted: true)

    // Then
    #expect(xml.contains(#"url="https://example.com/video?a=1&amp;b=2""#))
    #expect(!xml.contains(#"url="https://example.com/video?a=1&b=2""#))

    let decoded = try RSSFeed(string: xml)
    #expect(
      decoded.channel?.items?.first?.media?.contents?.first?.attributes?.url ==
        "https://example.com/video?a=1&b=2"
    )
  }

  @Test("formatted: false emits a compact document")
  func honorsFormattedFlag() throws {
    // Given
    let feed: RSSFeed = .init(channel: .init(
      title: "Example Feed",
      items: [.init(title: "Example Item")]
    ))

    // When
    let compact = try feed.toXMLString(formatted: false)
    let formatted = try feed.toXMLString(formatted: true)

    // Then
    #expect(!compact.contains("\n"))
    #expect(formatted.contains("\n"))
    #expect(try RSSFeed(string: compact).channel?.title == "Example Feed")
  }
}
