//
// DublinCoreTests.swift
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

@Suite("Dublin Core")
struct DublinCoreTests: FeedKitTestable {
  @Test
  func dublinCoreRSS() throws {
    // Given
    let data = data(resource: "RSSDC", withExtension: "xml")
    let expected: RSSFeed = rssMock

    // When
    let actual = try RSSFeed(data: data)

    // Then
    #expect(expected == actual)
  }

  @Test
  func dublinCoreAtom() throws {
    // Given
    let data = data(resource: "AtomDC", withExtension: "xml")
    let expected: AtomFeed = atomMock

    // When
    let actual = try AtomFeed(data: data)

    // Then
    #expect(expected == actual)
  }

  @Test("A declared, non-conventional prefix bound to the Dublin Core namespace URI still decodes")
  func dublinCoreWithAlternatePrefix() throws {
    // Given
    let xml = """
    <?xml version="1.0"?>
    <rss version="2.0" xmlns:dcterms="http://purl.org/dc/elements/1.1/">
      <channel>
        <title>Test Channel</title>
        <item>
          <title>Test Item</title>
          <dcterms:creator>Jane Doe</dcterms:creator>
        </item>
      </channel>
    </rss>
    """

    // When
    let feed = try RSSFeed(string: xml)

    // Then
    #expect(feed.channel?.items?.first?.dublinCore?.creator == "Jane Doe")
  }

  @Test("An undeclared, conventionally-prefixed dc: element decodes under .lenient but not under .strict")
  func dublinCoreUndeclaredPrefixIsLenientByDefault() throws {
    // Given
    let xml = """
    <?xml version="1.0"?>
    <rss version="2.0">
      <channel>
        <title>Test Channel</title>
        <item>
          <title>Test Item</title>
          <dc:creator>Jane Doe</dc:creator>
        </item>
      </channel>
    </rss>
    """
    let data = try #require(xml.data(using: .utf8))

    // When
    let lenientFeed = try RSSFeed(data: data, namespaceHandling: .lenient)
    let strictFeed = try RSSFeed(data: data, namespaceHandling: .strict)

    // Then
    #expect(lenientFeed.channel?.items?.first?.dublinCore?.creator == "Jane Doe")
    #expect(strictFeed.channel?.items?.first?.dublinCore == nil)
  }
}
