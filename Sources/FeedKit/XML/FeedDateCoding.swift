//
// FeedDateCoding.swift
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

/// Feed documents have no fixed date format: RSS 2.0 says RFC 822, Atom says
/// RFC 3339, RSS 1.0 says W3CDTF, and publishers use all of them plus their own
/// variations. `FeedDateCoder` accepts every format FeedKit has seen in the
/// wild, and this conformance is what puts it on XMLKit's decoding path so that
/// a `Date` decoded straight from an element is read with it.
extension Date: XMLScalarDecodable {
  /// Creates a date from an element's text.
  ///
  /// - Parameter xmlText: The element's text, already trimmed.
  /// - Returns: The date, or `nil` when no known format matches.
  public init?(xmlText: String) {
    guard let date = FeedDateCoder.date(from: xmlText) else {
      return nil
    }
    self = date
  }
}

// MARK: - Encoding

/// The patterns and time zone FeedKit writes dates with.
///
/// Reading is `FeedDateCoder`'s job; these describe only what the feed
/// vocabularies require on the way out.
enum FeedDateFormatters {
  /// The RFC 822 pattern RSS 2.0 documents are written with.
  static let rfc822Pattern = "EEE, d MMM yyyy HH:mm:ss zzz"

  /// The RFC 3339 pattern Atom documents are written with.
  static let rfc3339Pattern = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

  /// The time zone every feed date is written in, as the specifications require.
  static let utc: TimeZone = .init(secondsFromGMT: 0)
    ?? TimeZone(identifier: "UTC")
    ?? .current
}
