//
// RDFTests.swift
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

/// Covers RDF Site Summary (RSS 1.0) feeds.
///
/// See https://github.com/nmdias/FeedKit/issues/175
struct RDFTests: FeedKitTestable {
  @Test
  func rdf() throws {
    // Given
    let data = data(resource: "RDF", withExtension: "xml")
    let expected: RDFFeed = mock

    // When
    let actual = try RDFFeed(data: data)

    // Then
    #expect(expected == actual)
  }

  @Test
  func rdfDublinCoreAndSyndication() throws {
    // Given
    let data = data(resource: "RDFDC", withExtension: "xml")
    let expected: RDFFeed = dcMock

    // When
    let actual = try RDFFeed(data: data)

    // Then
    #expect(expected == actual)
  }

  @Test
  func rdfItemsAreSiblingsOfTheChannel() throws {
    // Given
    // An RSS 1.0 document lists the items beside the channel rather than inside
    // it, and the channel's `<items>` element only holds an `<rdf:Seq>` of
    // references to them. See https://github.com/nmdias/FeedKit/issues/175
    let string = """
    <?xml version="1.0" encoding="UTF-8"?>
    <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns="http://purl.org/rss/1.0/">
      <channel rdf:about="https://example.com/">
        <title>Example</title>
        <link>https://example.com/</link>
        <description>An example feed.</description>
        <items>
          <rdf:Seq>
            <rdf:li rdf:resource="https://example.com/1" />
          </rdf:Seq>
        </items>
      </channel>
      <item rdf:about="https://example.com/1">
        <title>First</title>
        <link>https://example.com/1</link>
      </item>
      <item rdf:about="https://example.com/2">
        <title>Second</title>
        <link>https://example.com/2</link>
      </item>
    </rdf:RDF>
    """

    // When
    let feed = try RDFFeed(string: string)

    // Then
    // The items come from the root, in document order.
    #expect(feed.channel?.title == "Example")
    #expect(feed.items?.count == 2)
    #expect(feed.items?.first?.title == "First")
    #expect(feed.items?.last?.title == "Second")
  }
}
