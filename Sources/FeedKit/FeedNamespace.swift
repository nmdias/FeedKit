//
//  FeedNamespace.swift
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

/// Represents feed namespaces.
enum FeedNamespace: CaseIterable {
  case dublinCore
  case itunes
  case syndication
  case media
  case content
  case georss
  case gml

  /// The namespace prefix.
  var prefix: String {
    switch self {
    case .dublinCore:
      return "xmlns:dc"
    case .itunes:
      return "xmlns:itunes"
    case .syndication:
      return "xmlns:sy"
    case .media:
      return "xmlns:media"
    case .content:
      return "xmlns:content"
    case .georss:
      return "xmlns:georss"
    case .gml:
      return "xmlns:gml"
    }
  }

  /// The URL associated with the namespace.
  var url: String {
    switch self {
    case .dublinCore:
      return "http://purl.org/dc/elements/1.1/"
    case .itunes:
      return "http://www.itunes.com/dtds/podcast-1.0.dtd"
    case .syndication:
      return "http://purl.org/rss/1.0/modules/syndication/"
    case .media:
      return "http://search.yahoo.com/mrss/"
    case .content:
      return "http://purl.org/rss/1.0/modules/content/"
    case .georss:
      return "http://www.georss.org/georss"
    case .gml:
      return "http://www.opengis.net/gml"
    }
  }
}

// MARK: - Should Include in Feed

extension FeedNamespace {
  /// Determines whether the namespace should be included in an XML document.
  /// - Parameter feed: The RSS feed being converted.
  /// - Returns: A Boolean indicating whether the namespace should be included.
  func shouldInclude(in feed: RSSFeed) -> Bool {
    switch self {
    case .dublinCore:
      return
        feed.channel?.dublinCore != nil ||
        feed.channel?.items?.contains(where: { $0.dublinCore != nil }) ?? false
    case .itunes:
      return
        feed.channel?.iTunes != nil ||
        feed.channel?.items?.contains(where: { $0.iTunes != nil }) ?? false
    case .syndication:
      return feed.channel?.syndication != nil
    case .media:
      return feed.channel?.items?.contains(where: { $0.media != nil }) ?? false
    case .content:
      return feed.channel?.items?.contains(where: { $0.content != nil }) ?? false
    case .georss:
      return feed.channel?.items?.contains(where: { $0.media?.location?.geoRSS != nil }) ?? false
    case .gml:
      return feed.channel?.items?.contains(where: { $0.media?.location?.geoRSS?.gmlPoint != nil }) ?? false
    }
  }
}
