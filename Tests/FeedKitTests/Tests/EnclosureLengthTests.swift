//
// EnclosureLengthTests.swift
//
// Copyright (c) 2016 - 2025 Nuno Dias
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

@Suite("Enclosure Length Parsing")
struct EnclosureLengthTests {
  
  @Test
  func enclosureWithInvalidLengthShouldNotCrash() throws {
    // Given - RSS feed with various problematic length values
    let feedXML = """
    <?xml version="1.0" encoding="UTF-8"?>
    <rss version="2.0">
      <channel>
        <title>Test Feed</title>
        <description>Test feed for reproducing enclosure length parsing issue</description>
        <link>https://example.com</link>
        
        <item>
          <title>Test Episode 1</title>
          <description>Episode with empty length</description>
          <enclosure url="https://example.com/episode1.mp3" length="" type="audio/mpeg" />
        </item>
        
        <item>
          <title>Test Episode 2</title>
          <description>Episode with non-numeric length</description>
          <enclosure url="https://example.com/episode2.mp3" length="abc123" type="audio/mpeg" />
        </item>
        
        <item>
          <title>Test Episode 3</title>
          <description>Episode with whitespace in length</description>
          <enclosure url="https://example.com/episode3.mp3" length=" 1234567 " type="audio/mpeg" />
        </item>
        
        <item>
          <title>Test Episode 4</title>
          <description>Episode with valid length</description>
          <enclosure url="https://example.com/episode4.mp3" length="12345678" type="audio/mpeg" />
        </item>
        
      </channel>
    </rss>
    """
    
    let data = feedXML.data(using: .utf8)!
    
    // When & Then - This should not crash
    let feed = try Feed(data: data)
    
    // Verify we got an RSS feed
    #expect(feed.rss != nil)
    
    let items = feed.rss?.channel?.items ?? []
    #expect(items.count == 4)
    
    // Check that enclosures are parsed (with graceful handling of invalid lengths)
    let item1 = items[0]
    #expect(item1.enclosure?.attributes?.url == "https://example.com/episode1.mp3")
    #expect(item1.enclosure?.attributes?.length == nil) // Empty length should be nil
    
    let item2 = items[1]
    #expect(item2.enclosure?.attributes?.url == "https://example.com/episode2.mp3")
    #expect(item2.enclosure?.attributes?.length == nil) // Non-numeric length should be nil
    
    let item3 = items[2]
    #expect(item3.enclosure?.attributes?.url == "https://example.com/episode3.mp3")
    #expect(item3.enclosure?.attributes?.length == 1234567) // Whitespace trimmed length should work
    
    let item4 = items[3]
    #expect(item4.enclosure?.attributes?.url == "https://example.com/episode4.mp3")
    #expect(item4.enclosure?.attributes?.length == 12345678) // Valid length should work
  }

  @Test
  func enclosureWithExtremelyLargeLength() throws {
    // Given - RSS feed with extremely large length value
    let feedXML = """
    <?xml version="1.0" encoding="UTF-8"?>
    <rss version="2.0">
      <channel>
        <title>Test Feed</title>
        <description>Test feed with extreme length values</description>
        <link>https://example.com</link>
        
        <item>
          <title>Test Episode with huge length</title>
          <description>Episode with length larger than Int64.max</description>
          <enclosure url="https://example.com/huge.mp3" length="99999999999999999999999999999" type="audio/mpeg" />
        </item>
        
        <item>
          <title>Test Episode with negative length</title>
          <description>Episode with negative length</description>
          <enclosure url="https://example.com/negative.mp3" length="-123" type="audio/mpeg" />
        </item>
        
        <item>
          <title>Test Episode with zero length</title>
          <description>Episode with zero length</description>
          <enclosure url="https://example.com/zero.mp3" length="0" type="audio/mpeg" />
        </item>
        
      </channel>
    </rss>
    """
    
    let data = feedXML.data(using: .utf8)!
    
    // When & Then - This should not crash
    let feed = try Feed(data: data)
    
    let items = feed.rss?.channel?.items ?? []
    #expect(items.count == 3)
    
    // Check extreme length values
    let item1 = items[0]
    #expect(item1.enclosure?.attributes?.url == "https://example.com/huge.mp3")
    #expect(item1.enclosure?.attributes?.length == nil) // Huge length should be nil
    
    let item2 = items[1]
    #expect(item2.enclosure?.attributes?.url == "https://example.com/negative.mp3")
    #expect(item2.enclosure?.attributes?.length == -123) // Negative length should work
    
    let item3 = items[2]
    #expect(item3.enclosure?.attributes?.url == "https://example.com/zero.mp3")
    #expect(item3.enclosure?.attributes?.length == 0) // Zero length should work
  }

  @Test
  func enclosureEncodingRoundTrip() throws {
    // Given - Create an enclosure with known attributes
    let attributes = RSSFeedEnclosureAttributes(
      url: "https://example.com/test.mp3",
      length: 12345678,
      type: "audio/mpeg"
    )
    let enclosure = RSSFeedEnclosure(attributes: attributes)
    
    // When - Encode and decode
    let encoder = JSONEncoder()
    let encodedData = try encoder.encode(enclosure)
    
    let decoder = JSONDecoder()
    let decodedEnclosure = try decoder.decode(RSSFeedEnclosure.self, from: encodedData)
    
    // Then - Verify round-trip
    #expect(decodedEnclosure.attributes?.url == "https://example.com/test.mp3")
    #expect(decodedEnclosure.attributes?.length == 12345678)
    #expect(decodedEnclosure.attributes?.type == "audio/mpeg")
  }
}