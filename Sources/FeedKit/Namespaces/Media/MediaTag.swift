//
// MediaTag.swift
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

/// This element contains user-generated tags separated by commas in the decreasing
/// order of each tag's weight. Each tag can be assigned an integer weight in
/// tag_name:weight format. It's up to the provider to choose the way weight is
/// determined for a tag; for example, number of occurrences can be one way to
/// decide weight of a particular tag. Default weight is 1.
public struct MediaTag {
  // MARK: Lifecycle

  public init(
    tag: String? = nil,
    weight: Int = 1
  ) {
    self.tag = tag
    self.weight = weight
  }

  // MARK: Public

  /// The tag name.
  public var tag: String?

  /// The tag weight. Default to 1 if not specified.
  public var weight: Int = 1
}

// MARK: - Sendable

extension MediaTag: Sendable {}

// MARK: - Equatable

extension MediaTag: Equatable {}

// MARK: - Hashable

extension MediaTag: Hashable {}

// MARK: - Codable

extension MediaTag: Codable {
  private enum CodingKeys: CodingKey {
    case tag
    case weight
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<MediaTag.CodingKeys> = try decoder.container(keyedBy: MediaTag.CodingKeys.self)

    tag = try container.decodeIfPresent(String.self, forKey: MediaTag.CodingKeys.tag)
    weight = try container.decode(Int.self, forKey: MediaTag.CodingKeys.weight)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<MediaTag.CodingKeys> = encoder.container(keyedBy: MediaTag.CodingKeys.self)

    try container.encodeIfPresent(tag, forKey: MediaTag.CodingKeys.tag)
    try container.encode(weight, forKey: MediaTag.CodingKeys.weight)
  }
}
