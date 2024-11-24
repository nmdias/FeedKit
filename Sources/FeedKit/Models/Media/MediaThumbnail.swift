//
//  MediaThumbnail.swift
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

/// Allows particular images to be used as representative images for the
/// media object. If multiple thumbnails are included, and time coding is not
/// at play, it is assumed that the images are in order of importance. It has
/// one required attribute and three optional attributes.
public struct MediaThumbnail {
  /// The element's text.
  public var text: String?

  /// The element's attributes.
  public struct Attributes: Codable, Equatable {
    /// Specifies the url of the thumbnail. It is a required attribute.
    public var url: String?

    /// Specifies the height of the thumbnail. It is an optional attribute.
    public var width: String?

    /// Specifies the width of the thumbnail. It is an optional attribute.
    public var height: String?

    /// Specifies the time offset in relation to the media object. Typically this
    /// is used when creating multiple keyframes within a single video. The format
    /// for this attribute should be in the DSM-CC's Normal Play Time (NTP) as used in
    /// RTSP [RFC 2326 3.6 Normal Play Time]. It is an optional attribute.
    public var time: String?

    public init(
      url: String? = nil,
      width: String? = nil,
      height: String? = nil,
      time: String? = nil) {
      self.url = url
      self.width = width
      self.height = height
      self.time = time
    }
  }

  /// The element's attributes.
  public var attributes: Attributes?

  public init(
    text: String? = nil,
    attributes: Attributes? = nil) {
    self.text = text
    self.attributes = attributes
  }
}

// MARK: - Equatable

extension MediaThumbnail: Equatable {}

// MARK: - Codable

extension MediaThumbnail: Codable {
  private enum CodingKeys: CodingKey {
    case text
    case attributes
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<MediaThumbnail.CodingKeys> = try decoder.container(keyedBy: MediaThumbnail.CodingKeys.self)

    text = try container.decodeIfPresent(String.self, forKey: MediaThumbnail.CodingKeys.text)
    attributes = try container.decodeIfPresent(MediaThumbnail.Attributes.self, forKey: MediaThumbnail.CodingKeys.attributes)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<MediaThumbnail.CodingKeys> = encoder.container(keyedBy: MediaThumbnail.CodingKeys.self)

    try container.encodeIfPresent(text, forKey: MediaThumbnail.CodingKeys.text)
    try container.encodeIfPresent(attributes, forKey: MediaThumbnail.CodingKeys.attributes)
  }
}
