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
  private enum CodingKeys: String, CodingKey {
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

// MARK: - XML document

public extension RSSFeed {
  /// The feed as an XML document, with its document element named and the
  /// namespaces it uses declared.
  func toXmlDocument() throws -> XMLKit.XMLDocument {
    var encoder: XMLEncoder = .init()
    encoder.dateEncodingStrategy = .formatted(
      format: FeedDateFormatters.rfc822Pattern,
      timeZone: FeedDateFormatters.utc
    )

    // The engine declares each namespace it writes, under the prefix the feed
    // format uses for it, so the document is namespace-well-formed by
    // construction rather than by a list that has to be kept in step.
    encoder.namespacePrefixes = FeedNamespace.prefixesByURI

    let bytes = try encoder.encode(self, rootElementName: "rss")
    let document = try XMLDocument(bytes: bytes)
    document.root.setAttribute("version", value: "2.0")

    return document
  }

  /// The feed serialised as XML.
  ///
  /// - Parameters:
  ///   - formatted: Whether to indent the output.
  ///   - indentationLevel: Ignored; kept so that callers written against the
  ///     previous signature keep compiling.
  /// - Returns: The document as a string.
  func toXMLString(formatted: Bool, indentationLevel _: Int = 1) throws -> String {
    let configuration: XMLWriterConfiguration = .init(
      xmlDeclaration: XMLDeclaration(version: "1.0", encoding: "UTF-8"),
      prettyPrinted: formatted,
      indentation: "  "
    )
    return try toXmlDocument().serializedString(configuration: configuration)
  }
}
