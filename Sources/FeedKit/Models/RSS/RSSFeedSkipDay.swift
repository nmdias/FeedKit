//
//  RSSFeedSkipDay.swift
//
//  Copyright (c) 2016 - 2024 Nuno Dias
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

/// A hint for aggregators telling them which days they can skip.
///
/// An XML element that contains up to seven <day> sub-elements whose value
/// is Monday, Tuesday, Wednesday, Thursday, Friday, Saturday or Sunday.
/// Aggregators may not read the channel during days listed in the skipDays
/// element.
///
/// - monday: Aggregator hint to skip parsing on `Monday`.
/// - tuesday: Aggregator hint to skip parsing on `Tuesday`.
/// - wednesday: Aggregator hint to skip parsing on `Wednesday`.
/// - thursday: Aggregator hint to skip parsing on `Thursday`.
/// - friday: Aggregator hint to skip parsing on `Friday`.
/// - saturday: Aggregator hint to skip parsing on `Saturday`.
/// - sunday: Aggregator hint to skip parsing on `Sunday`.
public enum RSSFeedSkipDay: String, Equatable, Hashable, Codable {
  case monday
  case tuesday
  case wednesday
  case thursday
  case friday
  case saturday
  case sunday
}

extension RSSFeedSkipDay {
  /// Lowercase the incoming `rawValue` string to try and match the
  /// `SkipDay`'s `rawValue`
  ///
  /// - Parameter rawValue: The raw value
  public init?(rawValue: String) {
    switch rawValue.lowercased() {
    case "monday": self = .monday
    case "tuesday": self = .tuesday
    case "wednesday": self = .wednesday
    case "thursday": self = .thursday
    case "friday": self = .friday
    case "saturday": self = .saturday
    case "sunday": self = .sunday
    default: return nil
    }
  }
}

public struct RSSFeedSkipDays {
  public var days: [RSSFeedSkipDay]?
}

// MARK: - Equatable

extension RSSFeedSkipDays: Equatable {}

// MARK: - Hashable

extension RSSFeedSkipDays: Hashable {}

// MARK: - Codable

extension RSSFeedSkipDays: Codable {
  private enum CodingKeys: CodingKey {
    case day
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<RSSFeedSkipDays.CodingKeys> = try decoder.container(keyedBy: RSSFeedSkipDays.CodingKeys.self)

    days = try container.decodeIfPresent([RSSFeedSkipDay].self, forKey: RSSFeedSkipDays.CodingKeys.day)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<RSSFeedSkipDays.CodingKeys> = encoder.container(keyedBy: RSSFeedSkipDays.CodingKeys.self)

    try container.encodeIfPresent(days, forKey: RSSFeedSkipDays.CodingKeys.day)
  }
}
