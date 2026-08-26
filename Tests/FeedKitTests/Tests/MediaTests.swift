//
// MediaTests.swift
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
@testable import FeedKit
import Testing
import XMLKit

@Suite("Media")
struct MediaTests: FeedKitTestable {
  @Test
  func media() throws {
    // Given
    let data = data(resource: "Media", withExtension: "xml")
    let expected: RSSFeed = mock

    // When
    let actual = try RSSFeed(data: data)

    // Then
    #expect(expected == actual)
  }

  @Test("A declared, non-conventional prefix bound to the Media (MRSS) namespace URI still decodes")
  func mediaWithAlternatePrefix() throws {
    // Given
    let xml = """
    <?xml version="1.0"?>
    <rss version="2.0" xmlns:mrss="http://search.yahoo.com/mrss/">
      <channel>
        <title>Test Channel</title>
        <item>
          <title>Test Item</title>
          <mrss:content url="http://example.com/video.mp4" />
        </item>
      </channel>
    </rss>
    """

    // When
    let feed = try RSSFeed(string: xml)

    // Then
    #expect(feed.channel?.items?.first?.media?.contents?.first?.attributes?.url == "http://example.com/video.mp4")
  }

  @Test("An undeclared, conventionally-prefixed media: element decodes under .lenient but not under .strict")
  func mediaUndeclaredPrefixIsLenientByDefault() throws {
    // Given
    let xml = """
    <?xml version="1.0"?>
    <rss version="2.0">
      <channel>
        <title>Test Channel</title>
        <item>
          <title>Test Item</title>
          <media:content url="http://example.com/video.mp4" />
        </item>
      </channel>
    </rss>
    """
    let data = try #require(xml.data(using: .utf8))

    // When
    let lenientFeed = try RSSFeed(data: data, namespaceHandling: .lenient)
    let strictFeed = try RSSFeed(data: data, namespaceHandling: .strict)

    // Then
    #expect(lenientFeed.channel?.items?.first?.media?.contents?.first?.attributes?.url == "http://example.com/video.mp4")
    #expect(strictFeed.channel?.items?.first?.media == nil)
  }
}
