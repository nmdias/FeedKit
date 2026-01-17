//
// JSONFeedItem.swift
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

/// An individual item of a JSON Feed, acting as a container for metadata and data
/// associated with the item.
public struct JSONFeedItem {
  // MARK: Lifecycle

  public init(
    id: String? = nil,
    url: String? = nil,
    externalURL: String? = nil,
    title: String? = nil,
    contentText: String? = nil,
    contentHtml: String? = nil,
    summary: String? = nil,
    image: String? = nil,
    bannerImage: String? = nil,
    datePublished: Date? = nil,
    dateModified: Date? = nil,
    author: JSONFeedAuthor? = nil,
    tags: [String]? = nil,
    attachments: [JSONFeedAttachment]? = nil
  ) {
    self.id = id
    self.url = url
    self.externalURL = externalURL
    self.title = title
    self.contentText = contentText
    self.contentHtml = contentHtml
    self.summary = summary
    self.image = image
    self.bannerImage = bannerImage
    self.datePublished = datePublished
    self.dateModified = dateModified
    self.author = author
    self.tags = tags
    self.attachments = attachments
  }

  // MARK: Public

  /// (required, string) is unique for that item for that feed over time. If an
  /// item is ever updated, the id should be unchanged. New items should never
  /// use a previously-used id. If an id is presented as a number or other type,
  /// a JSON Feed reader must coerce it to a string. Ideally, the id is the full
  /// URL of the resource described by the item, since URLs make great unique
  /// identifiers.
  public var id: String?

  /// (optional, string) is the URL of the resource described by the item. It's
  /// the permalink. This may be the same as the id - but should be present
  /// regardless.
  public var url: String?

  /// (very optional, string) is the URL of a page elsewhere. This is especially
  /// useful for linkblogs. If url links to where you're talking about a thing,
  /// then external_url links to the thing you're talking about.
  public var externalURL: String?

  /// (optional, string) is plain text. Microblog items in particular may omit
  /// titles.
  public var title: String?

  /// content_html and content_text are each optional strings - but one or both
  /// must be present. This is the HTML or plain text of the item. Important:
  /// the only place HTML is allowed in this format is in content_html. A
  /// Twitter-like service might use content_text, while a blog might use
  /// content_html. Use whichever makes sense for your resource. (It doesn't
  /// even have to be the same for each item in a feed.)
  public var contentText: String?

  /// content_html and content_text are each optional strings - but one or both
  /// must be present. This is the HTML or plain text of the item. Important:
  /// the only place HTML is allowed in this format is in content_html. A
  /// Twitter-like service might use content_text, while a blog might use
  /// content_html. Use whichever makes sense for your resource. (It doesn't
  /// even have to be the same for each item in a feed.)
  public var contentHtml: String?

  /// (optional, string) is a plain text sentence or two describing the item.
  /// This might be presented in a timeline, for instance, where a detail view
  /// would display all of content_html or content_text.
  public var summary: String?

  /// (optional, string) is the URL of the main image for the item. This image
  /// may also appear in the content_html - if so, it's a hint to the feed reader
  /// that this is the main, featured image. Feed readers may use the image as a
  /// preview (probably resized as a thumbnail and placed in a timeline).
  public var image: String?

  /// (optional, string) is the URL of an image to use as a banner. Some blogging
  /// systems (such as Medium) display a different banner image chosen to go with
  /// each post, but that image wouldn't otherwise appear in the content_html.
  /// A feed reader with a detail view may choose to show this banner image at
  /// the top of the detail view, possibly with the title overlaid.
  public var bannerImage: String?

  /// (optional, string) specifies the date in RFC 3339 format.
  /// (Example: 2010-02-07T14:04:00-05:00.)
  public var datePublished: Date?

  /// (optional, string) specifies the modification date in RFC 3339 format.
  public var dateModified: Date?

  /// (optional, object) has the same structure as the top-level author.
  /// If not specified in an item, then the top-level author, if present, is the
  /// author of the item.
  public var author: JSONFeedAuthor?

  /// (optional, array of strings) can have any plain text values you want. Tags
  /// tend to be just one word, but they may be anything. Note: they are not the
  /// equivalent of Twitter hashtags. Some blogging systems and other feed
  /// formats call these categories.
  public var tags: [String]?

  /// (optional, array) lists related resources.
  public var attachments: [JSONFeedAttachment]?
}

// MARK: - Sendable

extension JSONFeedItem: Sendable {}

// MARK: - Equatable

extension JSONFeedItem: Equatable {}

// MARK: - Hashable

extension JSONFeedItem: Hashable {}

// MARK: - Codable

extension JSONFeedItem: Codable {
  enum CodingKeys: String, CodingKey {
    case id
    case title
    case url
    case external_url
    case content_text
    case content_html
    case summary
    case image
    case banner_image
    case date_published
    case date_modified
    case tags
    case author
    case attachments
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(id, forKey: .id)
    try container.encodeIfPresent(title, forKey: .title)
    try container.encodeIfPresent(url, forKey: .url)
    try container.encodeIfPresent(externalURL, forKey: .external_url)
    try container.encodeIfPresent(contentText, forKey: .content_text)
    try container.encodeIfPresent(contentHtml, forKey: .content_html)
    try container.encodeIfPresent(summary, forKey: .summary)
    try container.encodeIfPresent(image, forKey: .image)
    try container.encodeIfPresent(bannerImage, forKey: .banner_image)
    try container.encodeIfPresent(datePublished, forKey: .date_published)
    try container.encodeIfPresent(dateModified, forKey: .date_modified)
    try container.encodeIfPresent(tags, forKey: .tags)
    try container.encodeIfPresent(author, forKey: .author)
    try container.encodeIfPresent(attachments, forKey: .attachments)
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    do {
      id = try values.decode(String.self, forKey: .id)
    } catch DecodingError.typeMismatch {
      let idInt = try values.decode(Int.self, forKey: .id)
      id = String(describing: idInt)
    }
    title = try values.decodeIfPresent(String.self, forKey: .title)
    url = try values.decodeIfPresent(String.self, forKey: .url)
    externalURL = try values.decodeIfPresent(String.self, forKey: .external_url)
    contentText = try values.decodeIfPresent(String.self, forKey: .content_text)
    contentHtml = try values.decodeIfPresent(String.self, forKey: .content_html)
    summary = try values.decodeIfPresent(String.self, forKey: .summary)
    image = try values.decodeIfPresent(String.self, forKey: .image)
    bannerImage = try values.decodeIfPresent(String.self, forKey: .banner_image)
    datePublished = try values.decodeIfPresent(Date.self, forKey: .date_published)
    dateModified = try values.decodeIfPresent(Date.self, forKey: .date_modified)
    tags = try values.decodeIfPresent([String].self, forKey: .tags)
    author = try values.decodeIfPresent(JSONFeedAuthor.self, forKey: .author)
    attachments = try values.decodeIfPresent([JSONFeedAttachment].self, forKey: .attachments)
  }
}
