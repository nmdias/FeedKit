//
// EnclosureTests.swift
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

/// Covers `<enclosure>` attribute parsing, in particular attributes whose
/// values carry surrounding whitespace, as produced by the feed reported in
/// issue #192: https://www.groovelectric.com/groovelectric.xml
///
/// Some items in that feed declare the enclosure length as
/// `length="169600320 "`, with a trailing space. `Int64` does not accept
/// surrounding whitespace, so decoding used to fail with
/// `DecodingError.dataCorrupted` while the feed parsed fine in FeedKit 9.1.2.
struct EnclosureTests: FeedKitTestable {
  // MARK: Internal

  @Test
  func enclosureLengthWithTrailingSpaceParses() throws {
    // Given
    let data: Data = .init(Self.trailingSpaceLength.utf8)

    // When
    let feed = try RSSFeed(data: data)

    // Then
    let item = try #require(feed.channel?.items?.first)
    #expect(item.enclosure?.attributes?.length == 169_600_320)
    #expect(item.enclosure?.attributes?.url == "https://traffic.libsyn.com/djsteveboy/natural_selections.mp3")
    #expect(item.enclosure?.attributes?.type == "audio/mpeg")
  }

  @Test
  func enclosureLengthWithSurroundingWhitespaceParses() throws {
    // Given
    let data: Data = .init(Self.surroundingWhitespaceLength.utf8)

    // When
    let feed = try RSSFeed(data: data)

    // Then
    let item = try #require(feed.channel?.items?.first)
    #expect(item.enclosure?.attributes?.length == 24_986_239)
  }

  @Test
  func enclosureAttributeValuesAreTrimmed() throws {
    // Given
    let data: Data = .init(Self.trailingSpaceLength.utf8)
    let reader: XMLReader = .init(data: data)

    // When
    let root = try #require(try reader.read().get().root)
    let attributes = try #require(
      root.child(for: "channel")?
        .child(for: "item")?
        .child(for: "enclosure")?
        .child(for: "@attributes")
    )

    // Then
    #expect(attributes.child(for: "length")?.text == "169600320")
    #expect(attributes.child(for: "url")?.text == "https://traffic.libsyn.com/djsteveboy/natural_selections.mp3")
  }

  // MARK: Private

  /// An `<enclosure>` whose `length` attribute has a trailing space, as seen in
  /// the GrooveElectric feed from issue #192.
  private static let trailingSpaceLength = """
  <?xml version="1.0" encoding="UTF-8"?>
  <rss version="2.0">
    <channel>
      <title>GROOVELECTRIC: Downloadable Soul</title>
      <link>https://www.groovelectric.com</link>
      <description>Downloadable Soul</description>
      <item>
        <title>Natural Selections</title>
        <enclosure url="https://traffic.libsyn.com/djsteveboy/natural_selections.mp3" length="169600320 " type="audio/mpeg"/>
      </item>
    </channel>
  </rss>
  """

  /// An `<enclosure>` whose `length` attribute is wrapped in whitespace.
  private static let surroundingWhitespaceLength = """
  <?xml version="1.0" encoding="UTF-8"?>
  <rss version="2.0">
    <channel>
      <title>Sample</title>
      <link>http://example.com</link>
      <description>Sample</description>
      <item>
        <title>Sample</title>
        <enclosure url="http://dallas.example.com/joebob_050689.mp3" length=" 24986239 " type="audio/mpeg"/>
      </item>
    </channel>
  </rss>
  """
}
