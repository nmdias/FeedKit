//
// RSSFeedEnclosure.swift
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

public struct RSSFeedEnclosureAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(
    url: String? = nil,
    length: Int64? = nil,
    type: String? = nil
  ) {
    self.url = url
    self.length = length
    self.type = type
  }

  // MARK: Public

  /// Where the enclosure is located.
  ///
  /// Example: http://www.scripting.com/mp3s/weatherReportSuite.mp3
  public var url: String?

  /// How big the media object is in bytes.
  ///
  /// Example: 12216320
  public var length: Int64?

  /// Standard MIME type.
  ///
  /// Example: audio/mpeg
  public var type: String?
}

/// Describes a media object that is attached to the item.
///
/// <enclosure> is an optional sub-element of <item>.
///
/// It has three required attributes. url says where the enclosure is located,
/// length says how big it is in bytes, and type says what its type is, a
/// standard MIME type.
///
/// The url must be an http url.
///
/// <enclosure url="http://www.scripting.com/mp3s/weatherReportSuite.mp3"
/// length="12216320" type="audio/mpeg" />
public typealias RSSFeedEnclosure = XMLAttributesElement<RSSFeedEnclosureAttributes>
