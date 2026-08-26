//
// RSSFeedEncodingTests.swift
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

@Suite("RSS Encoding")
struct RSSFeedEncodingTests: FeedKitTestable {
  @Test("Ampersands in a media:content url attribute are escaped as &amp;")
  func escapesAmpersandInMediaContentURL() throws {
    // Given
    let feed = RSSFeed(
      channel: .init(
        title: "Test Channel",
        items: [
          .init(
            title: "Test Item",
            media: .init(
              contents: [
                .init(attributes: .init(url: "http://example.com/video?a=1&b=2"))
              ]
            )
          )
        ]
      )
    )

    // When
    let xml = try feed.toXMLString(formatted: true)

    // Then
    #expect(xml.contains(#"url="http://example.com/video?a=1&amp;b=2""#))
    #expect(!xml.contains(#"url="http://example.com/video?a=1&b=2""#))
  }

  @Test("Ampersands in element text (e.g. link) are escaped as &amp;")
  func escapesAmpersandInElementText() throws {
    // Given
    let feed = RSSFeed(
      channel: .init(
        title: "Test Channel",
        items: [
          .init(
            title: "Test Item",
            link: "http://example.com/article?a=1&b=2"
          )
        ]
      )
    )

    // When
    let xml = try feed.toXMLString(formatted: true)

    // Then
    #expect(xml.contains("<link>http://example.com/article?a=1&amp;b=2</link>"))
    #expect(!xml.contains("<link>http://example.com/article?a=1&b=2</link>"))
  }
}
