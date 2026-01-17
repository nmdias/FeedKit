//
// Podcast.swift
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

/// Podcast namespace tags for podcast-specific metadata and extensions.
///
/// The Podcast namespace is a comprehensive RSS namespace for podcasting that
/// provides additional metadata and functionality for podcast feeds.
///
/// See https://github.com/Podcastindex-org/podcast-namespace
public struct Podcast {
  // MARK: Lifecycle

  public init(
    guid: String? = nil,
    transcripts: [PodcastTranscript]? = nil

  ) {
    self.guid = guid
    self.transcripts = transcripts
  }

  // MARK: Public

  /// This element is used to declare a unique, global identifier for a podcast.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/guid.md
  public var guid: String?

  /// Links to transcript or closed captions files for a podcast episode.
  ///
  /// Multiple transcripts can be provided for different languages or formats.
  ///
  /// Example:
  /// ```xml
  /// <podcast:transcript url="https://example.com/episode1/transcript.txt" type="text/plain" language="en" />
  /// <podcast:transcript url="https://example.com/episode1/transcript.vtt" type="text/vtt" language="en" rel="captions" />
  /// ```
  public var transcripts: [PodcastTranscript]?
}

// MARK: - XMLNamespaceCodable

extension Podcast: XMLNamespaceCodable {}

// MARK: - Sendable

extension Podcast: Sendable {}

// MARK: - Equatable

extension Podcast: Equatable {}

// MARK: - Hashable

extension Podcast: Hashable {}

// MARK: - Codable

extension Podcast: Codable {
  private enum CodingKeys: String, CodingKey {
    case guid = "podcast:guid"
    case transcripts = "podcast:transcript"
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

    guid = try container.decodeIfPresent(String.self, forKey: CodingKeys.guid)
    transcripts = try container.decodeIfPresent([PodcastTranscript].self, forKey: CodingKeys.transcripts)
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encodeIfPresent(guid, forKey: CodingKeys.guid)
    try container.encodeIfPresent(transcripts, forKey: CodingKeys.transcripts)
  }
}
