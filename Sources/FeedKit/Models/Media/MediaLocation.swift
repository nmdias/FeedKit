//
//  MediaLocation.swift
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

/// Optional element to specify geographical information about various
/// locations captured in the content of a media object. The format conforms
/// to geoRSS.
public struct MediaLocation {
  /// The element's attributes.
  public struct Attributes: Codable, Equatable {
    /// Description of the place whose location is being specified.
    public var description: String?

    /// Time at which the reference to a particular location starts in the
    /// media object.
    public var start: TimeInterval?

    /// Time at which the reference to a particular location ends in the media
    /// object.
    public var end: TimeInterval?

    public init(description: String? = nil, start: TimeInterval? = nil, end: TimeInterval? = nil) {
      self.description = description
      self.start = start
      self.end = end
    }
  }

  /// The element's attributes.
  public var attributes: Attributes?

  public init(attributes: Attributes? = nil) {
    self.attributes = attributes
  }
}

// MARK: - Equatable

extension MediaLocation: Equatable {}

// MARK: - Codable

extension MediaLocation: Codable {
  private enum CodingKeys: CodingKey {
    case attributes
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<MediaLocation.CodingKeys> = try decoder.container(keyedBy: MediaLocation.CodingKeys.self)

    attributes = try container.decodeIfPresent(MediaLocation.Attributes.self, forKey: MediaLocation.CodingKeys.attributes)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<MediaLocation.CodingKeys> = encoder.container(keyedBy: MediaLocation.CodingKeys.self)

    try container.encodeIfPresent(attributes, forKey: MediaLocation.CodingKeys.attributes)
  }
}
