//
//  MediaCopyright.swift
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

/// Copyright information for the media object. It has one optional attribute.
public struct MediaCopyright {
  /// The element's text.
  public var text: String?

  /// The element's attributes.
  public struct Attributes: Codable, Equatable {
    /// The URL for a terms of use page or additional copyright information.
    /// If the media is operating under a Creative Commons license, the
    /// Creative Commons module should be used instead. It is an optional
    /// attribute.
    public var url: String?

    public init(url: String? = nil) {
      self.url = url
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

extension MediaCopyright: Equatable {}

// MARK: - Codable

extension MediaCopyright: Codable {
  private enum CodingKeys: CodingKey {
    case text
    case attributes
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<MediaCopyright.CodingKeys> = try decoder.container(keyedBy: MediaCopyright.CodingKeys.self)

    text = try container.decodeIfPresent(String.self, forKey: MediaCopyright.CodingKeys.text)
    attributes = try container.decodeIfPresent(MediaCopyright.Attributes.self, forKey: MediaCopyright.CodingKeys.attributes)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<MediaCopyright.CodingKeys> = encoder.container(keyedBy: MediaCopyright.CodingKeys.self)

    try container.encodeIfPresent(text, forKey: MediaCopyright.CodingKeys.text)
    try container.encodeIfPresent(attributes, forKey: MediaCopyright.CodingKeys.attributes)
  }
}
