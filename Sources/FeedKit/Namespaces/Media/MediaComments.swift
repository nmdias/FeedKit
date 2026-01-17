//
// MediaComments.swift
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

/// Allows inclusion of all the comments a media object has received.
public struct MediaComments {
  // MARK: Lifecycle

  public init(comments: [String]? = nil) {
    self.comments = comments
  }

  // MARK: Public

  /// Allows inclusion of all the comments a media object has received.
  public var comments: [String]?
}

// MARK: - Sendable

extension MediaComments: Sendable {}

// MARK: - Equatable

extension MediaComments: Equatable {}

// MARK: - Hashable

extension MediaComments: Hashable {}

// MARK: - Codable

extension MediaComments: Codable {
  private enum CodingKeys: String, CodingKey {
    case comment = "media:comment"
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

    comments = try container.decodeIfPresent([String].self, forKey: CodingKeys.comment)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)

    try container.encodeIfPresent(comments, forKey: CodingKeys.comment)
  }
}
