//
//  MediaLicence.swift
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

/// Optional link to specify the machine-readable license associated with the
/// content.
public struct MediaLicence {
  /// The element's text.
  public var text: String?

  /// The element's attributes.
  public struct Attributes: Codable, Equatable {
    /// The licence type.
    public var type: String?

    /// The location of the licence.
    public var href: String?

    public init(type: String? = nil, href: String? = nil) {
      self.type = type
      self.href = href
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

extension MediaLicence: Equatable {}

// MARK: - Codable

extension MediaLicence: Codable {
  private enum CodingKeys: CodingKey {
    case text
    case attributes
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<MediaLicence.CodingKeys> = try decoder.container(keyedBy: MediaLicence.CodingKeys.self)

    text = try container.decodeIfPresent(String.self, forKey: MediaLicence.CodingKeys.text)
    attributes = try container.decodeIfPresent(MediaLicence.Attributes.self, forKey: MediaLicence.CodingKeys.attributes)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<MediaLicence.CodingKeys> = encoder.container(keyedBy: MediaLicence.CodingKeys.self)

    try container.encodeIfPresent(text, forKey: MediaLicence.CodingKeys.text)
    try container.encodeIfPresent(attributes, forKey: MediaLicence.CodingKeys.attributes)
  }
}
