//
// AtomTests.swift
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

struct AtomTests: FeedKitTestable {
  @Test
  func atom() throws {
    // Given
    let data = data(resource: "Atom", withExtension: "xml")
    let expected: AtomFeed = mock

    // When
    let actual = try AtomFeed(data: data)

    // Then
    #expect(expected == actual)
  }

  @Test
  func atomXhtml() throws {
    // Given
    let data = data(resource: "Atom + XHTML", withExtension: "xml")
    let expected: AtomFeed = xhtmlMock

    // When
    let actual = try AtomFeed(data: data)

    // Then
    #expect(expected == actual)
  }

  @Test("Metacharacters in text and attributes survive a serialization round trip")
  func roundTripsMetacharacters() throws {
    // Given
    let feed: AtomFeed = .init(
      title: .init(text: "A & B < C > D"),
      subtitle: .init(text: #"Quotes: "double" and 'single'"#),
      links: [.init(attributes: .init(href: "https://example.com/?a=1&b=2", rel: "self"))],
      authors: [.init(name: "Tom & Jerry", email: "tom@example.com")],
      id: "tag:example.com,2026:1",
      generator: .init(text: "Gen & Co", attributes: .init(version: "1.0")),
      entries: [.init(
        title: "Entry <one>",
        summary: .init(text: "5 < 6 & 7 > 2"),
        id: "tag:example.com,2026:1.1",
        content: .init(text: "Body & soul", attributes: .init(type: "html"))
      )]
    )

    // When
    let xml = try feed.toXMLString(formatted: true)

    // Then the document is well-formed and decodes back to the original values.
    let decoded = try AtomFeed(string: xml)
    #expect(decoded.title?.text == "A & B < C > D")
    #expect(decoded.subtitle?.text == #"Quotes: "double" and 'single'"#)
    #expect(decoded.links?.first?.attributes?.href == "https://example.com/?a=1&b=2")
    #expect(decoded.authors?.first?.name == "Tom & Jerry")

    let entry = decoded.entries?.first
    #expect(entry?.title == "Entry <one>")
    #expect(entry?.summary?.text == "5 < 6 & 7 > 2")
    #expect(entry?.content?.text == "Body & soul")

    // And the metacharacters are escaped in the emitted document.
    #expect(xml.contains("<title>A &amp; B &lt; C &gt; D</title>"))
    #expect(xml.contains(#"href="https://example.com/?a=1&amp;b=2""#))
    #expect(xml.contains("<summary>5 &lt; 6 &amp; 7 &gt; 2</summary>"))
  }

  @Test("Ampersands in a media:content url attribute are escaped")
  func escapesAmpersandInMediaContentURL() throws {
    // Given
    let feed: AtomFeed = .init(
      title: .init(text: "Example Feed"),
      entries: [.init(
        title: "Example Entry",
        media: .init(contents: [
          .init(attributes: .init(url: "https://example.com/video?a=1&b=2"))
        ])
      )]
    )

    // When
    let xml = try feed.toXMLString(formatted: true)

    // Then
    #expect(xml.contains(#"url="https://example.com/video?a=1&amp;b=2""#))
    #expect(!xml.contains(#"url="https://example.com/video?a=1&b=2""#))

    let decoded = try AtomFeed(string: xml)
    #expect(
      decoded.entries?.first?.media?.contents?.first?.attributes?.url ==
        "https://example.com/video?a=1&b=2"
    )
  }

  @Test("formatted: false emits a compact document")
  func honorsFormattedFlag() throws {
    // Given
    let feed: AtomFeed = .init(
      title: .init(text: "Example Feed"),
      entries: [.init(title: "Example Entry")]
    )

    // When
    let compact = try feed.toXMLString(formatted: false)
    let formatted = try feed.toXMLString(formatted: true)

    // Then
    #expect(!compact.contains("\n"))
    #expect(formatted.contains("\n"))
    #expect(try AtomFeed(string: compact).title?.text == "Example Feed")
  }
}
