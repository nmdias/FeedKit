//
// RDFFeed.swift
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

/// Data model for the XML DOM of the RDF Site Summary (RSS 1.0) Specification.
/// See https://www.rssboard.org/rss-1-0
///
/// An RSS 1.0 document is an RDF document whose root element is `<rdf:RDF>`.
/// Unlike RSS 2.0, where a single `<channel>` element contains the items, an
/// RSS 1.0 document lists the `<channel>`, its `<item>`s and the optional
/// `<image>` and `<textinput>` elements as siblings. The `<channel>` merely
/// references those resources, so the items are decoded from the root element
/// rather than from the channel.
public struct RDFFeed {
  // MARK: Lifecycle

  public init(
    channel: RDFFeedChannel? = nil,
    items: [RSSFeedItem]? = nil,
    image: RSSFeedImage? = nil,
    textInput: RSSFeedTextInput? = nil
  ) {
    self.channel = channel
    self.items = items
    self.image = image
    self.textInput = textInput
  }

  // MARK: Public

  /// The `<channel>` element, which provides the feed's metadata and the
  /// references to the resources described elsewhere in the document.
  public var channel: RDFFeedChannel?

  /// The `<item>` elements. In RSS 1.0 the items are siblings of the
  /// `<channel>` element, not descendants of it.
  public var items: [RSSFeedItem]?

  /// The optional `<image>` element that can be displayed with the channel.
  public var image: RSSFeedImage?

  /// The optional `<textinput>` element that can be displayed with the channel.
  public var textInput: RSSFeedTextInput?
}

// MARK: - Sendable

extension RDFFeed: Sendable {}

// MARK: - Equatable

extension RDFFeed: Equatable {}

// MARK: - Hashable

extension RDFFeed: Hashable {}

// MARK: - Codable

extension RDFFeed: Codable {
  private enum CodingKeys: String, CodingKey {
    case channel
    case item
    case image
    case textInput = "textinput"
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<RDFFeed.CodingKeys> = try decoder.container(keyedBy: RDFFeed.CodingKeys.self)

    channel = try container.decodeIfPresent(RDFFeedChannel.self, forKey: CodingKeys.channel)
    items = try container.decodeIfPresent([RSSFeedItem].self, forKey: CodingKeys.item)
    image = try container.decodeIfPresent(RSSFeedImage.self, forKey: CodingKeys.image)
    textInput = try container.decodeIfPresent(RSSFeedTextInput.self, forKey: CodingKeys.textInput)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<RDFFeed.CodingKeys> = encoder.container(keyedBy: RDFFeed.CodingKeys.self)

    try container.encodeIfPresent(channel, forKey: CodingKeys.channel)
    try container.encodeIfPresent(items, forKey: CodingKeys.item)
    try container.encodeIfPresent(image, forKey: CodingKeys.image)
    try container.encodeIfPresent(textInput, forKey: CodingKeys.textInput)
  }
}

// MARK: - FeedInitializable

extension RDFFeed: FeedInitializable {}
