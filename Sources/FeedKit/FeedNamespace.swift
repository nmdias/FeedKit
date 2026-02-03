//
// FeedNamespace.swift
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

/// Represents various feed namespaces used in syndication feeds.
///
/// The `FeedNamespace` enum defines different namespaces that are commonly used
/// in syndication feeds (e.g., RSS, Atom) to represent metadata and extensions.
/// Each case corresponds to a specific namespace that can be used in feed parsing
/// and handling. These namespaces provide additional information and functionality
/// for feeds beyond the core elements.
enum FeedNamespace: CaseIterable {
  /// Represents the Dublin Core metadata terms used for describing
  /// resources in a standardized way.
  case dublinCore
  /// Represents the iTunes namespace, typically used in podcasts and
  /// media feeds.
  case itunes
  /// Represents the syndication namespace, used for feed metadata
  /// related to syndication functionality.
  case syndication
  /// Represents the media namespace, used for media-related content
  /// (e.g., images, audio, and video) in feeds.
  case media
  /// Represents the content namespace, used for providing additional
  /// content metadata.
  case content
  /// Represents the GeoRSS namespace, used for geographic data in feeds.
  case georss
  /// Represents the Geography Markup Language (GML) namespace, used
  /// for encoding geographic information.
  case gml
  /// Represents the YouTube namespace, used for YouTube-specific metadata
  /// in video feeds.
  case youTube
  /// Represents the Atom feed namespace, typically used for syndication
  /// in the Atom format.
  case atom
  /// Represents the Podcast namespace, used for podcast-specific metadata
  /// and extensions in podcast feeds.
  case podcast
  /// Represents the source namespace, used for Source-specific metadata
  /// like markdown content.
  case source

  // MARK: Internal

  /// The namespace prefix.
  var prefix: String {
    switch self {
    case .dublinCore:
      "xmlns:dc"
    case .itunes:
      "xmlns:itunes"
    case .syndication:
      "xmlns:sy"
    case .media:
      "xmlns:media"
    case .content:
      "xmlns:content"
    case .georss:
      "xmlns:georss"
    case .gml:
      "xmlns:gml"
    case .youTube:
      "xmlns:yt"
    case .atom:
      "xmlns:atom"
    case .podcast:
      "xmlns:podcast"
    case .source:
      "xmlns:source"
    }
  }

  /// The URL associated with the namespace.
  var url: String {
    switch self {
    case .dublinCore:
      "http://purl.org/dc/elements/1.1/"
    case .itunes:
      "http://www.itunes.com/dtds/podcast-1.0.dtd"
    case .syndication:
      "http://purl.org/rss/1.0/modules/syndication/"
    case .media:
      "http://search.yahoo.com/mrss/"
    case .content:
      "http://purl.org/rss/1.0/modules/content/"
    case .georss:
      "http://www.georss.org/georss"
    case .gml:
      "http://www.opengis.net/gml"
    case .youTube:
      "http://www.youtube.com/xml/schemas/2015"
    case .atom:
      "http://www.w3.org/2005/Atom"
    case .podcast:
      "https://podcastindex.org/namespace/1.0"
    case .source:
      "http://source.scripting.com/"
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
      feed.channel?.dublinCore != nil ||
        feed.channel?.items?.contains(where: { $0.dublinCore != nil }) ?? false

    case .itunes:
      feed.channel?.iTunes != nil ||
        feed.channel?.items?.contains(where: { $0.iTunes != nil }) ?? false

    case .syndication:
      feed.channel?.syndication != nil

    case .media:
      feed.channel?.items?.contains(where: { $0.media != nil }) ?? false

    case .content:
      feed.channel?.items?.contains(where: { $0.content != nil }) ?? false

    case .georss:
      feed.channel?.items?.contains(where: { $0.media?.location?.geoRSS != nil || $0.geoRSS != nil }) ?? false

    case .gml:
      feed.channel?.items?.contains(where: { $0.media?.location?.geoRSS?.gmlPoint != nil }) ?? false

    case .youTube:
      false

    case .atom:
      feed.channel?.atom != nil

    case .podcast:
      feed.channel?.podcast != nil ||
        feed.channel?.items?.contains(where: { $0.podcast != nil }) ?? false

    case .source:
      feed.channel?.items?.contains(where: { $0.markdown != nil }) ?? false
    }
  }

  /// Determines whether the namespace should be included in an XML document.
  /// - Parameter feed: The RSS feed being converted.
  /// - Returns: A Boolean indicating whether the namespace should be included.
  func shouldInclude(in feed: AtomFeed) -> Bool {
    switch self {
    case .youTube:
      feed.entries?.contains(where: { $0.youTube != nil }) ?? false
    case .georss:
      feed.entries?.contains(where: { $0.geoRSS != nil }) ?? false
    default:
      false
    }
  }
}
