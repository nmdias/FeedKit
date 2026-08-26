//
// GeoRSSSimpleTests.swift
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

@Suite("GeoRSSSimple")
struct GeoRSSSimpleTests: FeedKitTestable {
  @Test
  func geoRSSSimple() throws {
    // Given
    let data = data(resource: "GeoRSSSimple", withExtension: "xml")
    let expected: AtomFeed = mock

    // When
    let actual = try AtomFeed(data: data)

    // Then
    #expect(expected == actual)
  }

  @Test("A declared, non-conventional prefix bound to the GeoRSS namespace URI still decodes")
  func geoRSSSimpleWithAlternatePrefix() throws {
    // Given
    let xml = """
    <?xml version="1.0"?>
    <feed xmlns="http://www.w3.org/2005/Atom" xmlns:geo="http://www.georss.org/georss">
      <title>Test Feed</title>
      <entry>
        <title>Entry 1</title>
        <geo:point>45 -5</geo:point>
      </entry>
    </feed>
    """

    // When
    let feed = try AtomFeed(string: xml)

    // Then
    #expect(feed.entries?.first?.geoRSS?.point?.position?.latitude == 45)
    #expect(feed.entries?.first?.geoRSS?.point?.position?.longitude == -5)
  }
}
