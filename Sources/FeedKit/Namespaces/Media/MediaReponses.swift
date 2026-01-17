//
// MediaReponses.swift
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

/// Allows inclusion of a list of all media responses a media object has
/// received.
public struct MediaResponses {
  // MARK: Lifecycle

  public init(responses: [String]? = nil) {
    self.responses = responses
  }

  // MARK: Public

  /// Allows inclusion of a list of all media responses a media object has
  /// received.
  public var responses: [String]?
}

// MARK: - Sendable

extension MediaResponses: Sendable {}

// MARK: - Equatable

extension MediaResponses: Equatable {}

// MARK: - Hashable

extension MediaResponses: Hashable {}

// MARK: - Codable

extension MediaResponses: Codable {
  private enum CodingKeys: String, CodingKey {
    case response = "media:response"
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

    responses = try container.decodeIfPresent([String].self, forKey: CodingKeys.response)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)

    try container.encodeIfPresent(responses, forKey: CodingKeys.response)
  }
}
