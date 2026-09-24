//
// PodcastLiveItem.swift
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

// MARK: - Live Item

/// Attributes for the `<podcast:liveItem>` element.
public struct PodcastLiveItemAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(status: String? = nil, start: String? = nil, end: String? = nil) {
    self.status = status
    self.start = start
    self.end = end
  }

  // MARK: Public

  /// The current state of the stream, as the `pending`, `live` or `ended`
  /// string published in the feed.
  public var status: String?

  /// An ISO 8601 timestamp denoting when the stream is intended to start.
  public var start: String?

  /// An ISO 8601 timestamp denoting when the stream is intended to end.
  public var end: String?
}

/// Delivers a live audio or video stream to podcast apps.
///
/// It takes the same format as a standard `<item>` episode tag, so every
/// element that is valid as a child of an `<item>` is decoded into `item`.
///
/// Example:
/// ```xml
/// <podcast:liveItem status="live" start="2021-09-26T07:30:00.000-0600" end="2021-09-26T09:30:00.000-0600">
///   <title>Podcasting 2.0 Live Show</title>
///   <podcast:contentLink href="https://youtube.com/livestream">Live on YouTube!</podcast:contentLink>
/// </podcast:liveItem>
/// ```
///
/// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/live-item.md
public struct PodcastLiveItem: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(
    status: String? = nil,
    start: String? = nil,
    end: String? = nil,
    item: RSSFeedItem? = nil
  ) {
    self.status = status
    self.start = start
    self.end = end
    self.item = item
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
    let attributes: PodcastLiveItemAttributes? = try container.decodeIfPresent(
      PodcastLiveItemAttributes.self,
      forKey: CodingKeys.attributes
    )

    status = attributes?.status
    start = attributes?.start
    end = attributes?.end
    // The remaining elements are the ones that are valid as children of a
    // standard `<item>`, so the item model decodes from this same element.
    item = try RSSFeedItem(from: decoder)
  }

  // MARK: Public

  /// The current state of the stream: `pending`, `live` or `ended`.
  public var status: String?

  /// An ISO 8601 timestamp denoting when the stream is intended to start.
  public var start: String?

  /// An ISO 8601 timestamp denoting when the stream is intended to end.
  public var end: String?

  /// The title, description, enclosure, guid and every other element that is
  /// valid as a child of a standard `<item>`.
  public var item: RSSFeedItem?

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)

    try container.encodeIfPresent(PodcastLiveItemAttributes(
      status: status,
      start: start,
      end: end
    ), forKey: CodingKeys.attributes)
    try item?.encode(to: encoder)
  }

  // MARK: Private

  private enum CodingKeys: String, CodingKey {
    case attributes = "@attributes"
  }
}
