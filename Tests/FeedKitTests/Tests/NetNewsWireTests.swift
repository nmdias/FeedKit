//
// NetNewsWireTests.swift
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

/// A real-world regression fixture: a frozen snapshot of
/// https://netnewswire.blog/feed.xml, an RSS feed that declares
/// `xmlns:source="http://source.scripting.com/"` and uses `source:markdown`
/// on every item.
@Suite("NetNewsWire")
struct NetNewsWireTests: FeedKitTestable {
  @Test
  func netNewsWire() throws {
    // Given
    let data = data(resource: "NetNewsWire", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)

    // Then
    #expect(feed.channel?.title == "NetNewsWire")
    #expect(feed.channel?.link == "https://netnewswire.blog/")

    let items = try #require(feed.channel?.items)
    #expect(items.count == 25)

    // Every item on this feed carries a source:markdown element; this is a
    // broad regression check that the source namespace resolves across the
    // whole document, not just for a single hand-picked item.
    #expect(items.allSatisfy { $0.markdown != nil })

    let first = try #require(items.first)
    #expect(first.title == "How to Beta Test NetNewsWire")
    #expect(first.link == "https://netnewswire.blog/2026/06/29/how-to-beta-test-netnewswire.html")
    #expect(first.guid?.text == "http://NetNewsWire.micro.blog/2026/06/29/how-to-beta-test-netnewswire.html")
    #expect(first.markdown == """
    We very much appreciate the bug reports and feedback from NetNewsWire beta testers —\u{00A0}and we want to make sure that everyone who might be interested in helping this way knows how to get started. It’s easy. 😀

    So we’ve written up a new [How to Beta Test NetNewsWire](https://netnewswire.com/help/beta-testing.html) page. Want to help make NetNewsWire a better app? This is how!
    """)
  }
}
