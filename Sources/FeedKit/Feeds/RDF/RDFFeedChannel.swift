//
// RDFFeedChannel.swift
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

/// Data model for the `<channel>` element of the RDF Site Summary (RSS 1.0)
/// Specification.
/// See https://www.rssboard.org/rss-1-0
///
/// The channel provides the feed's metadata. In RSS 1.0 it also references the
/// `<image>`, `<items>` and `<textinput>` resources that appear as its siblings:
/// the `<items>` element holds an `<rdf:Seq>` of resource references and does not
/// contain the items themselves.
public struct RDFFeedChannel {
  // MARK: Lifecycle

  public init(
    title: String? = nil,
    link: String? = nil,
    description: String? = nil,
    dublinCore: DublinCore? = nil,
    syndication: Syndication? = nil
  ) {
    self.title = title
    self.link = link
    self.description = description
    self.dublinCore = dublinCore
    self.syndication = syndication
  }

  // MARK: Public

  /// The name of the channel. It's how people refer to your service.
  ///
  /// Example: XML.com
  public var title: String?

  /// The URL to the HTML website corresponding to the channel.
  ///
  /// Example: http://xml.com/pub
  public var link: String?

  /// Phrase or sentence describing the channel.
  ///
  /// Example: XML.com features a rich mix of information and services for the
  /// XML community.
  public var description: String?

  // MARK: - Namespaces

  /// The Dublin Core Metadata Element Set is a standard for cross-domain
  /// resource description.
  ///
  /// See https://tools.ietf.org/html/rfc5013
  public var dublinCore: DublinCore?

  /// Provides syndication hints to aggregators and others picking up this RDF
  /// Site Summary (RSS) feed regarding how often it is updated.
  ///
  /// See http://web.resource.org/rss/1.0/modules/syndication/
  public var syndication: Syndication?
}

// MARK: - Sendable

extension RDFFeedChannel: Sendable {}

// MARK: - Equatable

extension RDFFeedChannel: Equatable {}

// MARK: - Hashable

extension RDFFeedChannel: Hashable {}

// MARK: - Codable

extension RDFFeedChannel: Codable {
  private enum CodingKeys: String, CodingKey {
    case title
    case link
    case description
    case dublinCore = "dc"
    case syndication = "sy"
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<RDFFeedChannel.CodingKeys> = try decoder.container(keyedBy: RDFFeedChannel.CodingKeys.self)

    title = try container.decodeIfPresent(String.self, forKey: CodingKeys.title)
    link = try container.decodeIfPresent(String.self, forKey: CodingKeys.link)
    description = try container.decodeIfPresent(String.self, forKey: CodingKeys.description)
    dublinCore = try container.decodeIfPresent(DublinCore.self, forKey: CodingKeys.dublinCore)
    syndication = try container.decodeIfPresent(Syndication.self, forKey: CodingKeys.syndication)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<RDFFeedChannel.CodingKeys> = encoder.container(keyedBy: RDFFeedChannel.CodingKeys.self)

    try container.encodeIfPresent(title, forKey: CodingKeys.title)
    try container.encodeIfPresent(link, forKey: CodingKeys.link)
    try container.encodeIfPresent(description, forKey: CodingKeys.description)
    try container.encodeIfPresent(dublinCore, forKey: CodingKeys.dublinCore)
    try container.encodeIfPresent(syndication, forKey: CodingKeys.syndication)
  }
}
