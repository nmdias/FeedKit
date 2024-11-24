//
//  MediaRestriction.swift
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

/// Allows restrictions to be placed on the aggregator rendering the media in
/// the feed. Currently, restrictions are based on distributor (URI), country
/// codes and sharing of a media object. This element is purely informational
/// and no obligation can be assumed or implied. Only one <media:restriction>
/// element of the same type can be applied to a media object -- all others
/// will be ignored. Entities in this element should be space-separated.
/// To allow the producer to explicitly declare his/her intentions, two
/// literals are reserved: "all", "none". These literals can only be used once.
/// This element has one required attribute and one optional attribute (with
/// strict requirements for its exclusion).
public struct MediaRestriction {
  /// The element's text.
  public var text: String?

  /// The element's attributes.
  public struct Attributes: Codable, Equatable {
    /// Indicates the type of relationship that the restriction represents
    /// (allow | deny). In the example above, the media object should only be
    /// syndicated in Australia and the United States. It is a required
    /// attribute.
    ///
    /// Note: If the "allow" element is empty and the type of relationship is
    /// "allow", it is assumed that the empty list means "allow nobody" and
    /// the media should not be syndicated.
    public var relationship: String?

    /// Specifies the type of restriction (country | uri | sharing ) that the
    /// media can be syndicated. It is an optional attribute; however can only
    /// be excluded when using one of the literal values "all" or "none".
    public var type: String?

    public init(
      relationship: String? = nil,
      type: String? = nil) {
      self.relationship = relationship
      self.type = type
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

extension MediaRestriction: Equatable {}

// MARK: - Codable

extension MediaRestriction: Codable {
  private enum CodingKeys: CodingKey {
    case text
    case attributes
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<MediaRestriction.CodingKeys> = try decoder.container(keyedBy: MediaRestriction.CodingKeys.self)

    text = try container.decodeIfPresent(String.self, forKey: MediaRestriction.CodingKeys.text)
    attributes = try container.decodeIfPresent(MediaRestriction.Attributes.self, forKey: MediaRestriction.CodingKeys.attributes)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<MediaRestriction.CodingKeys> = encoder.container(keyedBy: MediaRestriction.CodingKeys.self)

    try container.encodeIfPresent(text, forKey: MediaRestriction.CodingKeys.text)
    try container.encodeIfPresent(attributes, forKey: MediaRestriction.CodingKeys.attributes)
  }
}
