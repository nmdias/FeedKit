//
// Content.swift
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

/// A module for the actual content of websites, in multiple formats.
/// See http://web.resource.org/rss/1.0/modules/content/
public struct Content {
  // MARK: Lifecycle

  public init(encoded: String? = nil) {
    self.encoded = encoded
  }

  // MARK: Public

  /// An element whose contents are the entity-encoded or CDATA-escaped version
  /// of the content of the item.
  ///
  /// Example:
  /// <content:encoded><![CDATA[<p>What a <em>beautiful</em> day!</p>]]>
  /// </content:encoded>
  public var encoded: String?
}

// MARK: - XMLNamespaceDecodable

extension Content: XMLNamespaceCodable {}

// MARK: - Sendable

extension Content: Sendable {}

// MARK: - Equatable

extension Content: Equatable {}

// MARK: - Hashable

extension Content: Hashable {}

// MARK: - Codable

extension Content: Codable {
  private enum CodingKeys: String, CodingKey {
    case encoded = "content:encoded"
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

    encoded = try container.decodeIfPresent(String.self, forKey: CodingKeys.encoded)
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encodeIfPresent(encoded, forKey: CodingKeys.encoded)
  }
}
