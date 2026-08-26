//
// CommentAPI.swift
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
import XMLKit

/// The Well-Formed Web Comment API module, commonly used by WordPress and
/// other blogging platforms to associate comment-related URLs with a feed
/// item.
/// See http://wellformedweb.org/CommentAPI/
public struct CommentAPI {
  // MARK: Lifecycle

  public init(comment: String? = nil, commentRss: String? = nil) {
    self.comment = comment
    self.commentRss = commentRss
  }

  // MARK: Public

  /// The URL to use for posting a comment on the item via the CommentAPI
  /// protocol.
  ///
  /// Example:
  /// <wfw:comment>http://example.com/wp-comments-post.php?p=1</wfw:comment>
  public var comment: String?

  /// The URL of the RSS feed of comments for the item.
  ///
  /// Example:
  /// <wfw:commentRss>http://example.com/2024/01/01/hello-world/feed/</wfw:commentRss>
  public var commentRss: String?
}

// MARK: - XMLNamespaceCodable

extension CommentAPI: XMLNamespaceCodable {}

// MARK: - Sendable

extension CommentAPI: Sendable {}

// MARK: - Equatable

extension CommentAPI: Equatable {}

// MARK: - Hashable

extension CommentAPI: Hashable {}

// MARK: - Codable

extension CommentAPI: Codable {
  private enum CodingKeys: String, CodingKey {
    case comment = "wfw:comment"
    case commentRss = "wfw:commentRss"
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

    comment = try container.decodeIfPresent(String.self, forKey: CodingKeys.comment)
    commentRss = try container.decodeIfPresent(String.self, forKey: CodingKeys.commentRss)
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encodeIfPresent(comment, forKey: CodingKeys.comment)
    try container.encodeIfPresent(commentRss, forKey: CodingKeys.commentRss)
  }
}
