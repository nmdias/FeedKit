//
// RSSFeedSkipHours.swift
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

/// A hint for aggregators telling them which hours they can skip.
///
/// An XML element that contains up to 24 <hour> sub-elements whose value is a
/// number between 0 and 23, representing a time in GMT, when aggregators, if they
/// support the feature, may not read the channel on hours listed in the skipHours
/// element.
///
/// The hour beginning at midnight is hour zero.
public struct RSSFeedSkipHours {
  public var hours: [Int]?
}

// MARK: - Sendable

extension RSSFeedSkipHours: Sendable {}

// MARK: - Equatable

extension RSSFeedSkipHours: Equatable {}

// MARK: - Hashable

extension RSSFeedSkipHours: Hashable {}

// MARK: - Codable

extension RSSFeedSkipHours: Codable {
  private enum CodingKeys: CodingKey {
    case hour
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<RSSFeedSkipHours.CodingKeys> = try decoder.container(keyedBy: RSSFeedSkipHours.CodingKeys.self)

    hours = try container.decodeIfPresent([Int].self, forKey: RSSFeedSkipHours.CodingKeys.hour)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<RSSFeedSkipHours.CodingKeys> = encoder.container(keyedBy: RSSFeedSkipHours.CodingKeys.self)

    try container.encodeIfPresent(hours, forKey: RSSFeedSkipHours.CodingKeys.hour)
  }
}
