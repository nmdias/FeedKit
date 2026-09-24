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

/// The Comment API namespace lets a feed publicize the URL of the feed that
/// contains an item's comments and the URL of an endpoint that accepts new
/// comments for that item.
///
/// Both elements are optional and belong to the item: `wfw:commentRss` names
/// the RSS feed of comments already submitted in response to the item, and
/// `wfw:comment` names an endpoint that receives a comment as an HTTP POST
/// request so a reader can offer a comment form in its interface.
///
/// See https://www.rssboard.org/comment-api
public struct CommentAPI {
  // MARK: Lifecycle

  public init(comment: String? = nil, commentRss: String? = nil) {
    self.comment = comment
    self.commentRss = commentRss
  }

  // MARK: Public

  /// The URL of an endpoint that can receive a comment to the item as an HTTP
  /// POST request and save the comment.
  ///
  /// Example: https://ekzemplo.com/comment?post=130
  public var comment: String?

  /// The URL of an RSS feed that contains user comments submitted in response
  /// to the item.
  ///
  /// Example: https://ekzemplo.com/news/130/comments.xml
  public var commentRss: String?
}

// MARK: - XMLNamespaceDecodable

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
    /// Some feeds spell the element with a capitalized acronym. The
    /// specification asks readers to accept both spellings, so this is read
    /// but never written.
    case commentRssCapitalized = "wfw:commentRSS"
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

    comment = try container.decodeIfPresent(String.self, forKey: CodingKeys.comment)
    commentRss = try container.decodeIfPresent(String.self, forKey: CodingKeys.commentRss)
      ?? container.decodeIfPresent(String.self, forKey: CodingKeys.commentRssCapitalized)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)

    try container.encodeIfPresent(comment, forKey: CodingKeys.comment)
    try container.encodeIfPresent(commentRss, forKey: CodingKeys.commentRss)
  }
}
