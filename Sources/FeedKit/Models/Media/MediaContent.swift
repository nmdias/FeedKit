//
//  MediaContent.swift
//
//  Copyright (c) 2016 - 2024 Nuno Dias
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

/// <media:content> is a sub-element of either <item> or <media:group>.
/// Media objects that are not the same content should not be included
/// in the same <media:group> element. The sequence of these items implies
/// the order of presentation. While many of the attributes appear to be
/// audio/video specific, this element can be used to publish any type of
/// media. It contains 14 attributes, most of which are optional.
public struct MediaContent {
  /// The element's attributes.
  public struct Attributes: Codable, Equatable {
    /// Should specify the direct URL to the media object. If not included,
    /// a <media:player> element must be specified.
    public var url: String?

    /// The number of bytes of the media object. It is an optional
    /// attribute.
    public var fileSize: Int?

    /// The standard MIME type of the object. It is an optional attribute.
    public var type: String?

    /// Tpe of object (image | audio | video | document | executable).
    /// While this attribute can at times seem redundant if type is supplied,
    /// it is included because it simplifies decision making on the reader
    /// side, as well as flushes out any ambiguities between MIME type and
    /// object type. It is an optional attribute.
    public var medium: String?

    /// Determines if this is the default object that should be used for
    /// the <media:group>. There should only be one default object per
    /// <media:group>. It is an optional attribute.
    public var isDefault: Bool?

    /// Determines if the object is a sample or the full version of the
    /// object, or even if it is a continuous stream (sample | full | nonstop).
    /// Default value is "full". It is an optional attribute.
    public var expression: String?

    /// The kilobits per second rate of media. It is an optional attribute.
    public var bitrate: Int?

    /// The number of frames per second for the media object. It is an
    /// optional attribute.
    public var framerate: Double?

    /// The number of samples per second taken to create the media object.
    /// It is expressed in thousands of samples per second (kHz).
    /// It is an optional attribute.
    public var samplingrate: Double?

    /// The number of audio channels in the media object. It is an
    /// optional attribute.
    public var channels: Int?

    /// The number of seconds the media object plays. It is an
    /// optional attribute.
    public var duration: Int?

    /// The height of the media object. It is an optional attribute.
    public var height: Int?

    /// The width of the media object. It is an optional attribute.
    public var width: Int?

    /// The primary language encapsulated in the media object.
    /// Language codes possible are detailed in RFC 3066. This attribute
    /// is used similar to the xml:lang attribute detailed in the
    /// XML 1.0 Specification (Third Edition). It is an optional
    /// attribute.
    public var lang: String?

    public init(
      url: String? = nil,
      fileSize: Int? = nil,
      type: String? = nil,
      medium: String? = nil,
      isDefault: Bool? = nil,
      expression: String? = nil,
      bitrate: Int? = nil,
      framerate: Double? = nil,
      samplingrate: Double? = nil,
      channels: Int? = nil,
      duration: Int? = nil,
      height: Int? = nil,
      width: Int? = nil,
      lang: String? = nil) {
      self.url = url
      self.fileSize = fileSize
      self.type = type
      self.medium = medium
      self.isDefault = isDefault
      self.expression = expression
      self.bitrate = bitrate
      self.framerate = framerate
      self.samplingrate = samplingrate
      self.channels = channels
      self.duration = duration
      self.height = height
      self.width = width
      self.lang = lang
    }
  }

  /// The element's attributes
  public var attributes: Attributes?

  /// The title of the particular media object. It has one optional attribute.
  public var title: MediaTitle?

  /// Short description describing the media object typically a sentence in
  /// length. It has one optional attribute.
  public var description: MediaDescription?

  /// Allows the media object to be accessed through a web browser media player
  /// console. This element is required only if a direct media url attribute is
  /// not specified in the <media:content> element. It has one required attribute
  /// and two optional attributes.
  public var player: MediaPlayer?

  /// Allows particular images to be used as representative images for the
  /// media object. If multiple thumbnails are included, and time coding is not
  /// at play, it is assumed that the images are in order of importance. It has
  /// one required attribute and three optional attributes.
  public var thumbnails: [MediaThumbnail]?

  /// Highly relevant keywords describing the media object with typically a
  /// maximum of 10 words. The keywords and phrases should be comma-delimited.
  public var keywords: [String]?

  /// Allows a taxonomy to be set that gives an indication of the type of media
  /// content, and its particular contents. It has two optional attributes.
  public var category: MediaCategory?

  public init(
    attributes: Attributes? = nil,
    title: MediaTitle? = nil,
    description: MediaDescription? = nil,
    player: MediaPlayer? = nil,
    thumbnails: [MediaThumbnail]? = nil,
    keywords: [String]? = nil,
    category: MediaCategory? = nil) {
    self.title = title
    self.description = description
    self.player = player
    self.thumbnails = thumbnails
    self.keywords = keywords
    self.category = category
    self.attributes = attributes
  }
}

// MARK: - Equatable

extension MediaContent: Equatable {}

// MARK: - Codable

extension MediaContent: Codable {
  private enum CodingKeys: CodingKey {
    case attributes
    case title
    case description
    case player
    case thumbnails
    case keywords
    case category
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<MediaContent.CodingKeys> = try decoder.container(keyedBy: MediaContent.CodingKeys.self)

    attributes = try container.decodeIfPresent(MediaContent.Attributes.self, forKey: MediaContent.CodingKeys.attributes)
    title = try container.decodeIfPresent(MediaTitle.self, forKey: MediaContent.CodingKeys.title)
    description = try container.decodeIfPresent(MediaDescription.self, forKey: MediaContent.CodingKeys.description)
    player = try container.decodeIfPresent(MediaPlayer.self, forKey: MediaContent.CodingKeys.player)
    thumbnails = try container.decodeIfPresent([MediaThumbnail].self, forKey: MediaContent.CodingKeys.thumbnails)
    keywords = try container.decodeIfPresent([String].self, forKey: MediaContent.CodingKeys.keywords)
    category = try container.decodeIfPresent(MediaCategory.self, forKey: MediaContent.CodingKeys.category)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<MediaContent.CodingKeys> = encoder.container(keyedBy: MediaContent.CodingKeys.self)

    try container.encodeIfPresent(attributes, forKey: MediaContent.CodingKeys.attributes)
    try container.encodeIfPresent(title, forKey: MediaContent.CodingKeys.title)
    try container.encodeIfPresent(description, forKey: MediaContent.CodingKeys.description)
    try container.encodeIfPresent(player, forKey: MediaContent.CodingKeys.player)
    try container.encodeIfPresent(thumbnails, forKey: MediaContent.CodingKeys.thumbnails)
    try container.encodeIfPresent(keywords, forKey: MediaContent.CodingKeys.keywords)
    try container.encodeIfPresent(category, forKey: MediaContent.CodingKeys.category)
  }
}
