//
// MediaLocation.swift
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

/// Optional element to specify geographical information about various
/// locations captured in the content of a media object. The format conforms
/// to geoRSS.
public struct MediaLocation {
  // MARK: Lifecycle

  public init(
    attributes: Attributes? = nil,
    geoRSS: GeoRSS? = nil
  ) {
    self.attributes = attributes
    self.geoRSS = geoRSS
  }

  // MARK: Public

  /// The element's attributes.
  public struct Attributes: Codable, Equatable, Hashable, Sendable {
    // MARK: Lifecycle

    public init(description: String? = nil, start: TimeInterval? = nil, end: TimeInterval? = nil) {
      self.description = description
      self.start = start
      self.end = end
    }

    public init(from decoder: any Decoder) throws {
      let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

      description = try container.decodeIfPresent(String.self, forKey: CodingKeys.description)
      start = try container.decodeIfPresent(String.self, forKey: CodingKeys.start)?.toDuration()
      end = try container.decodeIfPresent(String.self, forKey: CodingKeys.end)?.toDuration()
    }

    // MARK: Public

    /// Description of the place whose location is being specified.
    public var description: String?

    /// Time at which the reference to a particular location starts in the
    /// media object.
    public var start: TimeInterval?

    /// Time at which the reference to a particular location ends in the media
    /// object.
    public var end: TimeInterval?

    public func encode(to encoder: any Encoder) throws {
      var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)

      try container.encodeIfPresent(description, forKey: CodingKeys.description)
      try container.encodeIfPresent(start, forKey: CodingKeys.start)
      try container.encodeIfPresent(end, forKey: CodingKeys.end)
    }

    // MARK: Private

    private enum CodingKeys: CodingKey {
      case description
      case start
      case end
    }
  }

  /// The element's attributes
  public var attributes: Attributes?

  /// GeoRSS is designed as a lightweight, community driven way to extend existing
  /// RSS feeds with simple geographic information. The GeoRSS standard provides for
  /// encoding location in an interoperable manner so that applications can request,
  /// aggregate, share and map geographically tag feeds.
  public var geoRSS: GeoRSS?
}

// MARK: - Sendable

extension MediaLocation: Sendable {}

// MARK: - Equatable

extension MediaLocation: Equatable {}

// MARK: - Hashable

extension MediaLocation: Hashable {}

// MARK: - Codable

extension MediaLocation: Codable {
  private enum CodingKeys: String, CodingKey {
    case attributes = "@attributes"
    case geoRSS = "georss:where"
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

    attributes = try container.decodeIfPresent(Attributes.self, forKey: CodingKeys.attributes)
    geoRSS = try container.decodeIfPresent(GeoRSS.self, forKey: CodingKeys.geoRSS)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)

    try container.encodeIfPresent(attributes, forKey: CodingKeys.attributes)
    try container.encodeIfPresent(geoRSS, forKey: CodingKeys.geoRSS)
  }
}
