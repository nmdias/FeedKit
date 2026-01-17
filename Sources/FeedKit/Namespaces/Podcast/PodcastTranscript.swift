//
// PodcastTranscript.swift
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

/// Attributes for the `<podcast:transcript>` element.
///
/// The `<podcast:transcript>` tag links to a transcript or closed captions file
/// for a podcast episode, enhancing accessibility and searchability.
///
/// See https://github.com/Podcastindex-org/podcast-namespace
public struct PodcastTranscriptAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(
    url: String? = nil,
    type: String? = nil,
    language: String? = nil,
    rel: String? = nil
  ) {
    self.url = url
    self.type = type
    self.language = language
    self.rel = rel
  }

  // MARK: Public

  /// The URL of the transcript file (required).
  ///
  /// Example: https://example.com/episode1/transcript.txt
  public var url: String?

  /// The MIME type of the transcript file (required).
  ///
  /// Common values: text/plain, text/html, text/vtt, application/json, application/x-subrip
  ///
  /// Example: text/vtt
  public var type: String?

  /// The language of the transcript (optional).
  ///
  /// Example: en, es, fr
  public var language: String?

  /// Indicates if the transcript is a closed captions file (optional).
  ///
  /// Use "captions" to indicate this is a closed captions file.
  ///
  /// Example: captions
  public var rel: String?
}

/// Represents a transcript or closed captions file for a podcast episode.
///
/// The `<podcast:transcript>` tag links to a transcript or closed captions file
/// for a podcast episode, enhancing accessibility and searchability.
///
/// Example:
/// ```xml
/// <podcast:transcript url="https://example.com/episode1/transcript.txt" type="text/plain" language="en" />
/// <podcast:transcript url="https://example.com/episode1/transcript.vtt" type="text/vtt" language="en" rel="captions" />
/// ```
///
/// See https://github.com/Podcastindex-org/podcast-namespace
public typealias PodcastTranscript = XMLAttributesElement<PodcastTranscriptAttributes>
