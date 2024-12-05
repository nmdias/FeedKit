//
//  MediaCategory.swift
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

/// Allows a taxonomy to be set that gives an indication of the type of media
/// content, and its particular contents. It has two optional attributes.
public struct MediaCategory {
  /// The element's text.
  public var text: String?

  /// The element's attributes.
  public struct Attributes: Codable, Equatable, Hashable {
    /// The URI that identifies the categorization scheme. It is an optional
    /// attribute. If this attribute is not included, the default scheme
    /// is "http://search.yahoo.com/mrss/category_schema".
    public var scheme: String?

    /// The human readable label that can be displayed in end user
    /// applications. It is an optional attribute.
    public var label: String?

    public init(
      scheme: String? = nil,
      label: String? = nil) {
      self.scheme = scheme
      self.label = label
    }
  }

  /// The element's attributes.
  public var attributes: Attributes?

  public init(
    text: String? = nil,
    attributes: Attributes? = nil) {
    self.attributes = attributes
    self.text = text
  }
}

// MARK: - Equatable

extension MediaCategory: Equatable {}

// MARK: - Hashable

extension MediaCategory: Hashable {}

// MARK: - Codable

extension MediaCategory: Codable {
  private enum CodingKeys: CodingKey {
    case text
    case attributes
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<MediaCategory.CodingKeys> = try decoder.container(keyedBy: MediaCategory.CodingKeys.self)

    text = try container.decodeIfPresent(String.self, forKey: MediaCategory.CodingKeys.text)
    attributes = try container.decodeIfPresent(MediaCategory.Attributes.self, forKey: MediaCategory.CodingKeys.attributes)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<MediaCategory.CodingKeys> = encoder.container(keyedBy: MediaCategory.CodingKeys.self)

    try container.encodeIfPresent(text, forKey: MediaCategory.CodingKeys.text)
    try container.encodeIfPresent(attributes, forKey: MediaCategory.CodingKeys.attributes)
  }
}
