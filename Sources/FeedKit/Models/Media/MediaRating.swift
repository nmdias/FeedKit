//
//  MediaRating.swift
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

/// This allows the permissible audience to be declared. If this element is not
/// included, it assumes that no restrictions are necessary. It has one optional
/// attribute.
public struct MediaRating {
  /// The element's text.
  public var text: String?

  /// The element's attributes.
  public struct Attributes: Codable, Equatable {
    /// The URI that identifies the rating scheme. It is an optional attribute.
    /// If this attribute is not included, the default scheme is urn:simple (adult | nonadult).
    public var scheme: String?

    public init(scheme: String? = nil) {
      self.scheme = scheme
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

extension MediaRating: Equatable {}

// MARK: - Codable

extension MediaRating: Codable {
  private enum CodingKeys: CodingKey {
    case text
    case attributes
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<MediaRating.CodingKeys> = try decoder.container(keyedBy: MediaRating.CodingKeys.self)

    text = try container.decodeIfPresent(String.self, forKey: MediaRating.CodingKeys.text)
    attributes = try container.decodeIfPresent(MediaRating.Attributes.self, forKey: MediaRating.CodingKeys.attributes)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<MediaRating.CodingKeys> = encoder.container(keyedBy: MediaRating.CodingKeys.self)

    try container.encodeIfPresent(text, forKey: MediaRating.CodingKeys.text)
    try container.encodeIfPresent(attributes, forKey: MediaRating.CodingKeys.attributes)
  }
}
