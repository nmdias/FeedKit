//
// MediaScene.swift
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
public struct MediaScene {
  // MARK: Lifecycle

  public init(
    title: String? = nil,
    description: String? = nil,
    startTime: TimeInterval? = nil,
    endTime: TimeInterval? = nil
  ) {
    self.title = title
    self.description = description
    self.startTime = startTime
    self.endTime = endTime
  }

  // MARK: Public

  /// The scene's title.
  public var title: String?

  /// The scene's description.
  public var description: String?

  /// The scene's start time.
  public var startTime: TimeInterval?

  /// The scene's end time.
  public var endTime: TimeInterval?
}

// MARK: - Sendable

extension MediaScene: Sendable {}

// MARK: - Equatable

extension MediaScene: Equatable {}

// MARK: - Hashable

extension MediaScene: Hashable {}

// MARK: - Codable

extension MediaScene: Codable {
  private enum CodingKeys: String, CodingKey {
    case title = "sceneTitle"
    case description = "sceneDescription"
    case startTime = "sceneStartTime"
    case endTime = "sceneEndTime"
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<MediaScene.CodingKeys> = try decoder.container(keyedBy: MediaScene.CodingKeys.self)

    title = try container.decodeIfPresent(String.self, forKey: MediaScene.CodingKeys.title)
    description = try container.decodeIfPresent(String.self, forKey: MediaScene.CodingKeys.description)
    startTime = try container.decodeIfPresent(String.self, forKey: MediaScene.CodingKeys.startTime)?.toDuration()
    endTime = try container.decodeIfPresent(String.self, forKey: MediaScene.CodingKeys.endTime)?.toDuration()
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<MediaScene.CodingKeys> = encoder.container(keyedBy: MediaScene.CodingKeys.self)

    try container.encodeIfPresent(title, forKey: MediaScene.CodingKeys.title)
    try container.encodeIfPresent(description, forKey: MediaScene.CodingKeys.description)
    try container.encodeIfPresent(startTime, forKey: MediaScene.CodingKeys.startTime)
    try container.encodeIfPresent(endTime, forKey: MediaScene.CodingKeys.endTime)
  }
}
