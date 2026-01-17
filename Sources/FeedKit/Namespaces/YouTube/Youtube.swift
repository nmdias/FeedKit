//
// Youtube.swift
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

/// YouTube metadata contains channel ID and video ID for YouTube content.
///
/// See https://developers.google.com/youtube/v3/guides/push_notifications
public struct YouTube {
  // MARK: Lifecycle

  public init(
    channelID: String? = nil,
    videoID: String? = nil
  ) {
    self.channelID = channelID
    self.videoID = videoID
  }

  // MARK: Public

  /// The <yt:channelId> element's value to identify the channel that owns that video.
  public var channelID: String?

  /// The <yt:videoId> element's value to identify the newly added or updated video.
  public var videoID: String?
}

// MARK: - XMLNamespaceDecodable

extension YouTube: XMLNamespaceCodable {}

// MARK: - Sendable

extension YouTube: Sendable {}

// MARK: - Equatable

extension YouTube: Equatable {}

// MARK: - Hashable

extension YouTube: Hashable {}

// MARK: - Codable

extension YouTube: Codable {
  private enum CodingKeys: String, CodingKey {
    case channelID = "yt:channelId"
    case videoID = "yt:videoId"
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<YouTube.CodingKeys> = try decoder.container(keyedBy: YouTube.CodingKeys.self)

    channelID = try container.decodeIfPresent(String.self, forKey: YouTube.CodingKeys.channelID)
    videoID = try container.decodeIfPresent(String.self, forKey: YouTube.CodingKeys.videoID)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<YouTube.CodingKeys> = encoder.container(keyedBy: YouTube.CodingKeys.self)

    try container.encodeIfPresent(channelID, forKey: YouTube.CodingKeys.channelID)
    try container.encodeIfPresent(videoID, forKey: YouTube.CodingKeys.videoID)
  }
}
