//
// MediaScenes.swift
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

/// Optional element to specify various scenes within a media object. It can
/// have multiple child <media:scene> elements, where each <media:scene>
/// element contains information about a particular scene. <media:scene> has
/// the optional sub-elements <sceneTitle>, <sceneDescription>,
/// <sceneStartTime> and <sceneEndTime>, which contains title, description,
/// start and end time of a particular scene in the media, respectively.
public struct MediaScenes {
  /// Optional element to specify various scenes within a media object. It can
  /// have multiple child <media:scene> elements, where each <media:scene>
  /// element contains information about a particular scene. <media:scene> has
  /// the optional sub-elements <sceneTitle>, <sceneDescription>,
  /// <sceneStartTime> and <sceneEndTime>, which contains title, description,
  /// start and end time of a particular scene in the media, respectively.
  public var scenes: [MediaScene]?
}

// MARK: - Sendable

extension MediaScenes: Sendable {}

// MARK: - Equatable

extension MediaScenes: Equatable {}

// MARK: - Hashable

extension MediaScenes: Hashable {}

// MARK: - Codable

extension MediaScenes: Codable {
  private enum CodingKeys: String, CodingKey {
    case scenes = "media:scene"
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

    scenes = try container.decodeIfPresent([MediaScene].self, forKey: CodingKeys.scenes)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)

    try container.encodeIfPresent(scenes, forKey: CodingKeys.scenes)
  }
}
