//
// RSSFeed.swift
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

/// Data model for the XML DOM of the RSS 2.0 Specification
/// See http://cyber.law.harvard.edu/rss/rss.html
///
/// At the top level, a RSS document is a <rss> element, with a mandatory
/// attribute called version, that specifies the version of RSS that the
/// document conforms to. If it conforms to this specification, the version
/// attribute must be 2.0.
///
/// Subordinate to the <rss> element is a single <channel> element, which
/// contains information about the channel (metadata) and its contents.
public struct RSSFeed {
  // MARK: Lifecycle

  public init(channel: RSSFeedChannel? = nil) {
    self.channel = channel
  }

  // MARK: Public

  /// Represents the <channel> element in an RSS 2.0 document.
  ///
  /// The <channel> element provides metadata about the feed, such as the
  /// title, link, and description, along with the list of items that the
  /// feed contains. This property is optional, as an RSS document may not
  /// always include a valid <channel> element.
  public var channel: RSSFeedChannel?
}

// MARK: - Sendable

extension RSSFeed: Sendable {}

// MARK: - Equatable

extension RSSFeed: Equatable {}

// MARK: - Hashable

extension RSSFeed: Hashable {}

// MARK: - Codable

extension RSSFeed: Codable {
  private enum CodingKeys: CodingKey {
    case channel
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<RSSFeed.CodingKeys> = try decoder.container(keyedBy: RSSFeed.CodingKeys.self)

    channel = try container.decodeIfPresent(RSSFeedChannel.self, forKey: RSSFeed.CodingKeys.channel)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<RSSFeed.CodingKeys> = encoder.container(keyedBy: RSSFeed.CodingKeys.self)

    try container.encodeIfPresent(channel, forKey: RSSFeed.CodingKeys.channel)
  }
}

// MARK: - FeedInitializable

extension RSSFeed: FeedInitializable {}

// MARK: - XMLDocumentConvertible

extension RSSFeed: XMLDocumentConvertible {
  public func toXmlDocument() throws -> XMLKit.XMLDocument {
    let encoder: XMLEncoder = .init()
    encoder.dateEncodingStrategy = .formatter(FeedDateFormatter(spec: .rfc822))

    let document = try encoder.encode(value: self)
    document.setRootName(name: "rss")
    document.setRootAttribute(name: "version", value: "2.0")

    for namespace in FeedNamespace.allCases {
      if namespace.shouldInclude(in: self) {
        document.setRootAttribute(name: namespace.prefix, value: namespace.url)
      }
    }

    return document
  }
}

// MARK: - XMLStringConvertible

extension RSSFeed: XMLStringConvertible {
  public func toXMLString(formatted _: Bool, indentationLevel _: Int = 1) throws -> String {
    try toXmlDocument().toXMLString(formatted: true)
  }
}
