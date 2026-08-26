//
// AtomFeedEncodingTests.swift
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

@Suite("Atom Encoding")
struct AtomFeedEncodingTests: FeedKitTestable {
  @Test("The default Atom namespace is always declared on the root element")
  func declaresDefaultAtomNamespace() throws {
    // Given
    let feed = AtomFeed(title: .init(text: "Test Feed"))

    // When
    let xml = try feed.toXMLString(formatted: true)

    // Then
    #expect(xml.contains(#"<feed xmlns="http://www.w3.org/2005/Atom">"#))
  }

  @Test("xmlns:media is declared when an entry has media content, and omitted otherwise")
  func declaresMediaNamespaceWhenPresent() throws {
    // Given
    let feedWithMedia = AtomFeed(
      title: .init(text: "Test Feed"),
      entries: [
        .init(
          title: "Entry 1",
          media: .init(contents: [.init(attributes: .init(url: "http://example.com/video.mp4"))])
        )
      ]
    )
    let feedWithoutMedia = AtomFeed(title: .init(text: "Test Feed"))

    // When
    let xmlWithMedia = try feedWithMedia.toXMLString(formatted: true)
    let xmlWithoutMedia = try feedWithoutMedia.toXMLString(formatted: true)

    // Then
    #expect(xmlWithMedia.contains(#"xmlns:media="http://search.yahoo.com/mrss/""#))
    #expect(!xmlWithoutMedia.contains("xmlns:media"))
  }

  @Test("xmlns:dc is declared when Dublin Core metadata is present, and omitted otherwise")
  func declaresDublinCoreNamespaceWhenPresent() throws {
    // Given
    let feedWithDublinCore = AtomFeed(
      title: .init(text: "Test Feed"),
      dublinCore: .init(creator: "Jane Doe")
    )
    let feedWithoutDublinCore = AtomFeed(title: .init(text: "Test Feed"))

    // When
    let xmlWithDublinCore = try feedWithDublinCore.toXMLString(formatted: true)
    let xmlWithoutDublinCore = try feedWithoutDublinCore.toXMLString(formatted: true)

    // Then
    #expect(xmlWithDublinCore.contains(#"xmlns:dc="http://purl.org/dc/elements/1.1/""#))
    #expect(!xmlWithoutDublinCore.contains("xmlns:dc"))
  }

  @Test("xmlns:yt is declared when an entry has YouTube metadata, and omitted otherwise")
  func declaresYouTubeNamespaceWhenPresent() throws {
    // Given
    let feedWithYouTube = AtomFeed(
      title: .init(text: "Test Feed"),
      entries: [.init(title: "Entry 1", youTube: .init(videoID: "abc123"))]
    )
    let feedWithoutYouTube = AtomFeed(title: .init(text: "Test Feed"))

    // When
    let xmlWithYouTube = try feedWithYouTube.toXMLString(formatted: true)
    let xmlWithoutYouTube = try feedWithoutYouTube.toXMLString(formatted: true)

    // Then
    #expect(xmlWithYouTube.contains(#"xmlns:yt="http://www.youtube.com/xml/schemas/2015""#))
    #expect(!xmlWithoutYouTube.contains("xmlns:yt"))
  }

  @Test("xmlns:georss is declared when an entry has GeoRSS data, and omitted otherwise")
  func declaresGeoRSSNamespaceWhenPresent() throws {
    // Given
    let feedWithGeoRSS = AtomFeed(
      title: .init(text: "Test Feed"),
      entries: [.init(title: "Entry 1", geoRSS: .init(point: .init(position: (latitude: 45, longitude: -5))))]
    )
    let feedWithoutGeoRSS = AtomFeed(title: .init(text: "Test Feed"))

    // When
    let xmlWithGeoRSS = try feedWithGeoRSS.toXMLString(formatted: true)
    let xmlWithoutGeoRSS = try feedWithoutGeoRSS.toXMLString(formatted: true)

    // Then
    #expect(xmlWithGeoRSS.contains(#"xmlns:georss="http://www.georss.org/georss""#))
    #expect(!xmlWithoutGeoRSS.contains("xmlns:georss"))
  }
}
