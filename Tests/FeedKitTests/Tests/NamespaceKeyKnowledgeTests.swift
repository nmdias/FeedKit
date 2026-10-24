//
// NamespaceKeyKnowledgeTests.swift
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

/// Covers the decoder learning what each key of a model holds, which
/// `XMLNamespaceKeyKnowledge` records and reuses for every later document.
///
/// A key whose type conforms to `XMLNamespaceCodable` is carried by the
/// namespace of its members — `<dc:creator>` carries `dc` — while a key holding
/// an ordinary element of the same name is not, as the `source` of an RSS item
/// is not carried by `<source:markdown>`. The two cannot be told apart from the
/// key, so the answer is read from the first document that decodes a value at
/// it, and every later document reads it back. These tests pin down what those
/// later documents must still find.
struct NamespaceKeyKnowledgeTests: FeedKitTestable {
  // MARK: Internal

  /// The prefix of `<source:markdown>` names an element that the item model has
  /// a plain key for, which is the one key a decoder cannot answer on the first
  /// attempt. Everything else the item carries has to survive it: the namespace
  /// containers that come after it in the model, and the ones a document only
  /// shows once the pass has moved past the key it could not answer.
  @Test
  func namespaceContainersSurviveAPlainKeyWithAPrefix() {
    // Given
    let data: Data = .init(Self.items.utf8)

    // When
    let feed = try? RSSFeed(data: data)

    // Then
    let items = feed?.channel?.items
    #expect(items?.count == 2)
    #expect(items?.allSatisfy { $0.markdown?.isEmpty == false } == true)
    #expect(items?.allSatisfy { $0.source == nil } == true)
    #expect(items?.allSatisfy { $0.dublinCore?.creator?.isEmpty == false } == true)
    #expect(items?.allSatisfy { $0.content?.encoded?.isEmpty == false } == true)
    #expect(items?.allSatisfy { $0.media?.contents?.isEmpty == false } == true)
    #expect(items?.allSatisfy { ($0.iTunes?.duration ?? 0) > 0 } == true)
  }

  /// The knowledge outlives the document that produced it, so a document has to
  /// decode the same way whether it is the first of its kind in the process or
  /// the hundredth — including the one that establishes what a key holds.
  @Test
  func decodingADocumentRepeatedlyGivesTheSameResult() {
    // Given
    let data: Data = .init(Self.items.utf8)

    // When
    let first = try? RSSFeed(data: data)
    let second = try? RSSFeed(data: data)
    let third = try? RSSFeed(data: data)

    // Then
    #expect(first == second)
    #expect(second == third)
    #expect(first?.channel?.items?.first?.dublinCore?.creator == "First Writer")
  }

  /// An Atom entry has an ordinary `content` element where an RSS item has the
  /// `Content` namespace container, and a document of one kind must not be read
  /// with what the other kind taught the decoder about that name.
  @Test
  func thesameKeyCanHoldDifferentTypesInDifferentModels() {
    // Given
    let xml: Data = .init(Self.items.utf8)
    let atom: Data = .init(Self.atom.utf8)

    // When
    let rss = try? RSSFeed(data: xml)
    let feed = try? AtomFeed(data: atom)

    // Then
    #expect(rss?.channel?.items?.first?.content?.encoded?.isEmpty == false)
    #expect(feed?.entries?.first?.content?.text?.isEmpty == false)
  }

  // MARK: Private

  /// Two items that carry a namespace container both before and after the plain
  /// key whose prefix collides with an element name.
  private static let items = """
  <?xml version="1.0" encoding="utf-8"?>
  <rss xmlns:source="http://source.scripting.com/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:content="http://purl.org/rss/1.0/modules/content/" xmlns:media="http://search.yahoo.com/mrss/" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" version="2.0">
    <channel>
      <title>Collision</title>
      <link>https://example.com/</link>
      <description>A feed whose items name a prefix as an element.</description>
      <item>
        <title>First</title>
        <dc:creator>First Writer</dc:creator>
        <content:encoded><![CDATA[<p>First body</p>]]></content:encoded>
        <source:markdown>First markdown</source:markdown>
        <media:content url="https://example.com/first.mp3" type="audio/mpeg" />
        <itunes:duration>00:21:00</itunes:duration>
      </item>
      <item>
        <title>Second</title>
        <dc:creator>Second Writer</dc:creator>
        <content:encoded><![CDATA[<p>Second body</p>]]></content:encoded>
        <source:markdown>Second markdown</source:markdown>
        <media:content url="https://example.com/second.mp3" type="audio/mpeg" />
        <itunes:duration>00:22:00</itunes:duration>
      </item>
    </channel>
  </rss>
  """

  /// An Atom feed with a `content` element, whose key holds an ordinary type in
  /// this model and a namespace container in the RSS one.
  private static let atom = """
  <?xml version="1.0" encoding="utf-8"?>
  <feed xmlns="http://www.w3.org/2005/Atom">
    <title>Atom</title>
    <id>https://example.com/</id>
    <updated>2024-12-05T10:30:00Z</updated>
    <entry>
      <title>Entry</title>
      <id>https://example.com/1</id>
      <updated>2024-12-05T10:30:00Z</updated>
      <content type="html">&lt;p&gt;Body&lt;/p&gt;</content>
    </entry>
  </feed>
  """
}
