//
// MediaStatistics.swift
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

public struct MediaStatisticsAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(
    views: Int? = nil,
    favorites: Int? = nil
  ) {
    self.views = views
    self.favorites = favorites
  }

  // MARK: Public

  /// The number of views.
  public var views: Int?

  /// The number fo favorites.
  public var favorites: Int?
}

/// This element specifies various statistics about a media object like the
/// view count and the favorite count. Valid attributes are views and favorites.
public typealias MediaStatistics = XMLAttributesElement<MediaStatisticsAttributes>
