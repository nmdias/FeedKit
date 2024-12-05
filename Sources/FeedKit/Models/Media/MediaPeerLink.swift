//
//  MediaPeerLink.swift
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

/// Optional element for P2P link.
public struct MediaPeerLink {
  /// The element's text.
  public var text: String?

  /// The element's attributes.
  public struct Attributes: Codable, Equatable, Hashable {
    /// The peer link's type.
    public var type: String?

    /// The location of the peer link provider.
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

extension MediaPeerLink: Equatable {}

// MARK: - Hashable

extension MediaPeerLink: Hashable {}

// MARK: - Codable

extension MediaPeerLink: Codable {
  private enum CodingKeys: CodingKey {
    case text
    case attributes
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<MediaPeerLink.CodingKeys> = try decoder.container(keyedBy: MediaPeerLink.CodingKeys.self)

    text = try container.decodeIfPresent(String.self, forKey: MediaPeerLink.CodingKeys.text)
    attributes = try container.decodeIfPresent(MediaPeerLink.Attributes.self, forKey: MediaPeerLink.CodingKeys.attributes)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<MediaPeerLink.CodingKeys> = encoder.container(keyedBy: MediaPeerLink.CodingKeys.self)

    try container.encodeIfPresent(text, forKey: MediaPeerLink.CodingKeys.text)
    try container.encodeIfPresent(attributes, forKey: MediaPeerLink.CodingKeys.attributes)
  }
}
