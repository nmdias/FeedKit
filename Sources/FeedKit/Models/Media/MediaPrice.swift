//
//  MediaPrice.swift
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

/// Optional tag to include pricing information about a media object. If this
/// tag is not present, the media object is supposed to be free. One media
/// object can have multiple instances of this tag for including different
/// pricing structures. The presence of this tag would mean that media object
/// is not free.
public struct MediaPrice {
  /// The element's text.
  public var text: String?

  /// The element's attributes.
  public struct Attributes: Codable, Equatable {
    /// Valid values are "rent", "purchase", "package" or "subscription". If
    /// nothing is specified, then the media is free.
    public var type: String?

    /// The price of the media object. This is an optional attribute.
    public var price: Double?

    /// If the type is "package" or "subscription", then info is a URL pointing
    /// to package or subscription information. This is an optional attribute.
    public var info: String?

    /// Use [ISO 4217] for currency codes. This is an optional attribute.
    public var currency: String?

    public init(
      type: String? = nil,
      price: Double? = nil,
      info: String? = nil,
      currency: String? = nil) {
      self.type = type
      self.price = price
      self.info = info
      self.currency = currency
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

extension MediaPrice: Equatable {}

// MARK: - Codable

extension MediaPrice: Codable {
  private enum CodingKeys: CodingKey {
    case text
    case attributes
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<MediaPrice.CodingKeys> = try decoder.container(keyedBy: MediaPrice.CodingKeys.self)

    text = try container.decodeIfPresent(String.self, forKey: MediaPrice.CodingKeys.text)
    attributes = try container.decodeIfPresent(MediaPrice.Attributes.self, forKey: MediaPrice.CodingKeys.attributes)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<MediaPrice.CodingKeys> = encoder.container(keyedBy: MediaPrice.CodingKeys.self)

    try container.encodeIfPresent(text, forKey: MediaPrice.CodingKeys.text)
    try container.encodeIfPresent(attributes, forKey: MediaPrice.CodingKeys.attributes)
  }
}
