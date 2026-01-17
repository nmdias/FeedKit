//
// MediaEmbed.swift
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

/// Sometimes player-specific embed code is needed for a player to play any
/// video. <media:embed> allows inclusion of such information in the form of
/// key-value pairs.
public struct MediaEmbed {
  // MARK: Lifecycle

  public init(
    attributes: Attributes? = nil,
    params: [MediaParam]? = nil
  ) {
    self.attributes = attributes
    self.params = params
  }

  // MARK: Public

  /// The element's attributes.
  public struct Attributes: Codable, Equatable, Hashable, Sendable {
    // MARK: Lifecycle

    public init(
      url: String? = nil,
      width: Int? = nil,
      height: Int? = nil
    ) {
      self.url = url
      self.width = width
      self.height = height
    }

    // MARK: Public

    /// The location of the embeded media.
    public var url: String?

    /// The width size for the embeded Media.
    public var width: Int?

    /// The height size for the embeded Media.
    public var height: Int?
  }

  /// The element's attributes.
  public var attributes: Attributes?

  /// Key-Value pairs with aditional parameters for the embeded Media.
  public var params: [MediaParam]?
}

// MARK: - Sendable

extension MediaEmbed: Sendable {}

// MARK: - Equatable

extension MediaEmbed: Equatable {}

// MARK: - Hashable

extension MediaEmbed: Hashable {}

// MARK: - Codable

extension MediaEmbed: Codable {
  private enum CodingKeys: String, CodingKey {
    case attributes = "@attributes"
    case params = "media:param"
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<MediaEmbed.CodingKeys> = try decoder.container(keyedBy: MediaEmbed.CodingKeys.self)

    attributes = try container.decodeIfPresent(MediaEmbed.Attributes.self, forKey: MediaEmbed.CodingKeys.attributes)
    params = try container.decodeIfPresent([MediaParam].self, forKey: MediaEmbed.CodingKeys.params)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<MediaEmbed.CodingKeys> = encoder.container(keyedBy: MediaEmbed.CodingKeys.self)

    try container.encodeIfPresent(attributes, forKey: MediaEmbed.CodingKeys.attributes)
    try container.encodeIfPresent(params, forKey: MediaEmbed.CodingKeys.params)
  }
}
