//
// MediaGroup.swift
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

/// The <media:group> element is a sub-element of <item>. It allows grouping
/// of <media:content> elements that are effectively the same content,
/// yet different representations. For instance: the same song recorded
/// in both the WAV and MP3 format. It's an optional element that must
/// only be used for this purpose.
public struct MediaGroup {
  // MARK: Lifecycle

  public init(
    contents: [MediaContent]? = nil,
    credits: [MediaCredit]? = nil,
    category: MediaCategory? = nil,
    rating: MediaRating? = nil,
    description: MediaDescription? = nil,
    thumbnails: [MediaThumbnail]? = nil,
    community: MediaCommunity? = nil
  ) {
    self.contents = contents
    self.credits = credits
    self.category = category
    self.rating = rating
    self.description = description
    self.thumbnails = thumbnails
    self.community = community
  }

  // MARK: Public

  /// <media:content> is a sub-element of either <item> or <media:group>.
  /// Media objects that are not the same content should not be included
  /// in the same <media:group> element. The sequence of these items implies
  /// the order of presentation. While many of the attributes appear to be
  /// audio/video specific, this element can be used to publish any type of
  /// media. It contains 14 attributes, most of which are optional.
  public var contents: [MediaContent]?

  /// Notable entity and the contribution to the creation of the media object.
  /// Current entities can include people, companies, locations, etc. Specific
  /// entities can have multiple roles, and several entities can have the same
  /// role. These should appear as distinct <media:credit> elements. It has two
  /// optional attributes.
  public var credits: [MediaCredit]?

  /// Allows a taxonomy to be set that gives an indication of the type of media
  /// content, and its particular contents. It has two optional attributes.
  public var category: MediaCategory?

  /// This allows the permissible audience to be declared. If this element is not
  /// included, it assumes that no restrictions are necessary. It has one
  /// optional attribute.
  public var rating: MediaRating?

  /// Short description describing the media object typically a sentence in
  /// length. It has one optional attribute.
  public var description: MediaDescription?

  /// Allows particular images to be used as representative images for the
  /// media object. If multiple thumbnails are included, and time coding is not
  /// at play, it is assumed that the images are in order of importance. It has
  /// one required attribute and three optional attributes.
  public var thumbnails: [MediaThumbnail]?

  /// This element stands for the community related content. This allows
  /// inclusion of the user perception about a media object in the form of view
  /// count, ratings and tags.
  public var community: MediaCommunity?
}

// MARK: - Sendable

extension MediaGroup: Sendable {}

// MARK: - Equatable

extension MediaGroup: Equatable {}

// MARK: - Hashable

extension MediaGroup: Hashable {}

// MARK: - Codable

extension MediaGroup: Codable {
  private enum CodingKeys: String, CodingKey {
    case contents = "media:content"
    case credits = "media:credit"
    case category = "media:category"
    case rating = "media:rating"
    case description = "media:description"
    case thumbnails = "media:thumbnail"
    case community = "media:community"
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<MediaGroup.CodingKeys> = try decoder.container(keyedBy: MediaGroup.CodingKeys.self)

    contents = try container.decodeIfPresent([MediaContent].self, forKey: MediaGroup.CodingKeys.contents)
    credits = try container.decodeIfPresent([MediaCredit].self, forKey: MediaGroup.CodingKeys.credits)
    category = try container.decodeIfPresent(MediaCategory.self, forKey: MediaGroup.CodingKeys.category)
    rating = try container.decodeIfPresent(MediaRating.self, forKey: MediaGroup.CodingKeys.rating)
    description = try container.decodeIfPresent(MediaDescription.self, forKey: MediaGroup.CodingKeys.description)
    thumbnails = try container.decodeIfPresent([MediaThumbnail].self, forKey: MediaGroup.CodingKeys.thumbnails)
    community = try container.decodeIfPresent(MediaCommunity.self, forKey: MediaGroup.CodingKeys.community)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<MediaGroup.CodingKeys> = encoder.container(keyedBy: MediaGroup.CodingKeys.self)

    try container.encodeIfPresent(contents, forKey: MediaGroup.CodingKeys.contents)
    try container.encodeIfPresent(credits, forKey: MediaGroup.CodingKeys.credits)
    try container.encodeIfPresent(category, forKey: MediaGroup.CodingKeys.category)
    try container.encodeIfPresent(rating, forKey: MediaGroup.CodingKeys.rating)
    try container.encodeIfPresent(description, forKey: MediaGroup.CodingKeys.description)
    try container.encodeIfPresent(thumbnails, forKey: MediaGroup.CodingKeys.thumbnails)
    try container.encodeIfPresent(community, forKey: MediaGroup.CodingKeys.community)
  }
}
