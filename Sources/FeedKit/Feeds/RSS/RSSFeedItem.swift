//
// RSSFeedItem.swift
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

/// A channel may contain any number of <item>s. An item may represent a
/// "story" -- much like a story in a newspaper or magazine; if so its
/// description is a synopsis of the story, and the link points to the full
/// story. An item may also be complete in itself, if so, the description
/// contains the text (entity-encoded HTML is allowed; see examples:
/// http://cyber.law.harvard.edu/rss/encodingDescriptions.html), and
/// the link and title may be omitted. All elements of an item are optional,
/// however at least one of title or description must be present.
public struct RSSFeedItem {
  // MARK: Lifecycle

  public init(
    title: String? = nil,
    link: String? = nil,
    description: String? = nil,
    markdown: String? = nil,
    author: String? = nil,
    categories: [RSSFeedCategory]? = nil,
    comments: String? = nil,
    enclosure: RSSFeedEnclosure? = nil,
    guid: RSSFeedGUID? = nil,
    pubDate: Date? = nil,
    source: RSSFeedSource? = nil,
    dublinCore: DublinCore? = nil,
    content: Content? = nil,
    iTunes: ITunes? = nil,
    media: Media? = nil,
    podcast: Podcast? = nil,
    geoRSS: GeoRSSSimple? = nil
  ) {
    self.title = title
    self.link = link
    self.description = description
    self.markdown = markdown
    self.author = author
    self.categories = categories
    self.comments = comments
    self.enclosure = enclosure
    self.guid = guid
    self.pubDate = pubDate
    self.source = source
    self.dublinCore = dublinCore
    self.content = content
    self.iTunes = iTunes
    self.media = media
    self.podcast = podcast
    self.geoRSS = geoRSS
  }

  // MARK: Public

  /// The title of the item.
  ///
  /// Example: Venice Film Festival Tries to Quit Sinking
  public var title: String?

  /// The URL of the item.
  ///
  /// Example: http://nytimes.com/2004/12/07FEST.html
  public var link: String?

  /// The item synopsis.
  ///
  /// Example: Some of the most heated chatter at the Venice Film Festival this
  /// week was about the way that the arrival of the stars at the Palazzo del
  /// Cinema was being staged.
  public var description: String?

  /// The markdown content for the item.
  ///
  /// Example: ## Highlights
  public var markdown: String?

  /// Email address of the author of the item.
  ///
  /// Example: oprah\@oxygen.net
  ///
  /// <author> is an optional sub-element of <item>.
  ///
  /// It's the email address of the author of the item. For newspapers and
  /// magazines syndicating via RSS, the author is the person who wrote the
  /// article that the <item> describes. For collaborative weblogs, the author
  /// of the item might be different from the managing editor or webmaster.
  /// For a weblog authored by a single individual it would make sense to omit
  /// the <author> element.
  ///
  /// <author>lawyer@boyer.net (Lawyer Boyer)</author>
  public var author: String?

  /// Includes the item in one or more categories.
  ///
  /// <category> is an optional sub-element of <item>.
  ///
  /// It has one optional attribute, domain, a string that identifies a
  /// categorization taxonomy.
  ///
  /// The value of the element is a forward-slash-separated string that
  /// identifies a hierarchic location in the indicated taxonomy. Processors
  /// may establish conventions for the interpretation of categories.
  ///
  /// Two examples are provided below:
  ///
  /// <category>Grateful Dead</category>
  /// <category domain="http://www.fool.com/cusips">MSFT</category>
  ///
  /// You may include as many category elements as you need to, for different
  /// domains, and to have an item cross-referenced in different parts of the
  /// same domain.
  public var categories: [RSSFeedCategory]?

  /// URL of a page for comments relating to the item.
  ///
  /// Example: http://www.myblog.org/cgi-local/mt/mt-comments.cgi?entry_id=290
  ///
  /// <comments> is an optional sub-element of <item>.
  ///
  /// If present, it is the url of the comments page for the item.
  ///
  /// <comments>http://ekzemplo.com/entry/4403/comments</comments>
  ///
  /// More about comments here:
  /// http://cyber.law.harvard.edu/rss/weblogComments.html
  public var comments: String?

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
  public var enclosure: RSSFeedEnclosure?

  /// A string that uniquely identifies the item.
  ///
  /// Example: http://inessential.com/2002/09/01.php#a2
  ///
  /// <guid> is an optional sub-element of <item>.
  ///
  /// guid stands for globally unique identifier. It's a string that uniquely
  /// identifies the item. When present, an aggregator may choose to use this
  /// string to determine if an item is new.
  ///
  /// <guid>http://some.server.com/weblogItem3207</guid>
  ///
  /// There are no rules for the syntax of a guid. Aggregators must view them
  /// as a string. It's up to the source of the feed to establish the
  /// uniqueness of the string.
  ///
  /// If the guid element has an attribute named "isPermaLink" with a value of
  /// true, the reader may assume that it is a permalink to the item, that is,
  /// a url that can be opened in a Web browser, that points to the full item
  /// described by the <item> element. An example:
  ///
  /// <guid isPermaLink="true">http://inessential.com/2002/09/01.php#a2</guid>
  ///
  /// isPermaLink is optional, its default value is true. If its value is false,
  /// the guid may not be assumed to be a url, or a url to anything in
  /// particular.
  public var guid: RSSFeedGUID?

  /// Indicates when the item was published.
  ///
  /// Example: Sun, 19 May 2002 15:21:36 GMT
  ///
  /// <pubDate> is an optional sub-element of <item>.
  ///
  /// Its value is a date, indicating when the item was published. If it's a
  /// date in the future, aggregators may choose to not display the item until
  /// that date.
  public var pubDate: Date?

  /// The RSS channel that the item came from.
  ///
  /// <source> is an optional sub-element of <item>.
  ///
  /// Its value is the name of the RSS channel that the item came from, derived
  /// from its <title>. It has one required attribute, url, which links to the
  /// XMLization of the source.
  ///
  /// <source url="http://www.tomalak.org/links2.xml">Tomalak's Realm</source>
  ///
  /// The purpose of this element is to propagate credit for links, to
  /// publicize the sources of news items. It can be used in the Post command
  /// of an aggregator. It should be generated automatically when forwarding
  /// an item from an aggregator to a weblog authoring tool.
  public var source: RSSFeedSource?

  /// The Dublin Core Metadata Element Set is a standard for cross-domain
  /// resource description.
  ///
  /// See https://tools.ietf.org/html/rfc5013
  public var dublinCore: DublinCore?

  /// A module for the actual content of websites, in multiple formats.
  ///
  /// See http://web.resource.org/rss/1.0/modules/content/
  public var content: Content?

  /// iTunes Podcasting Tags are de facto standard for podcast syndication.
  /// See https://help.apple.com/itc/podcasts_connect/#/itcb54353390
  public var iTunes: ITunes?

  /// Media RSS is a new RSS module that supplements the <enclosure>
  /// capabilities of RSS 2.0.
  public var media: Media?

  /// Podcast namespace provides podcast-specific metadata and extensions.
  /// See https://github.com/Podcastindex-org/podcast-namespace
  public var podcast: Podcast?

  public var geoRSS: GeoRSSSimple?
}

// MARK: - Sendable

extension RSSFeedItem: Sendable {}

// MARK: - Equatable

extension RSSFeedItem: Equatable {}

// MARK: - Hashable

extension RSSFeedItem: Hashable {}

// MARK: - Codable

extension RSSFeedItem: Codable {
  private enum CodingKeys: String, CodingKey {
    case title
    case link
    case description
    case markdown = "source:markdown"
    case author
    case category
    case comments
    case enclosure
    case guid
    case pubDate
    case source
    case dublinCore = "dc"
    case content
    case iTunes = "itunes"
    case media
    case podcast
    case geoRSS = "georss"
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<RSSFeedItem.CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

    title = try container.decodeIfPresent(String.self, forKey: CodingKeys.title)
    link = try container.decodeIfPresent(String.self, forKey: CodingKeys.link)
    description = try container.decodeIfPresent(String.self, forKey: CodingKeys.description)
    markdown = try container.decodeIfPresent(String.self, forKey: CodingKeys.markdown)
    author = try container.decodeIfPresent(String.self, forKey: CodingKeys.author)
    categories = try container.decodeIfPresent([RSSFeedCategory].self, forKey: CodingKeys.category)
    comments = try container.decodeIfPresent(String.self, forKey: CodingKeys.comments)
    enclosure = try container.decodeIfPresent(RSSFeedEnclosure.self, forKey: CodingKeys.enclosure)
    guid = try container.decodeIfPresent(RSSFeedGUID.self, forKey: CodingKeys.guid)
    pubDate = try container.decodeIfPresent(Date.self, forKey: CodingKeys.pubDate)
    source = try container.decodeIfPresent(RSSFeedSource.self, forKey: CodingKeys.source)
    dublinCore = try container.decodeIfPresent(DublinCore.self, forKey: CodingKeys.dublinCore)
    content = try container.decodeIfPresent(Content.self, forKey: CodingKeys.content)
    iTunes = try container.decodeIfPresent(ITunes.self, forKey: CodingKeys.iTunes)
    media = try container.decodeIfPresent(Media.self, forKey: CodingKeys.media)
    podcast = try container.decodeIfPresent(Podcast.self, forKey: CodingKeys.podcast)
    geoRSS = try container.decodeIfPresent(GeoRSSSimple.self, forKey: CodingKeys.geoRSS)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<RSSFeedItem.CodingKeys> = encoder.container(keyedBy: CodingKeys.self)

    try container.encodeIfPresent(title, forKey: CodingKeys.title)
    try container.encodeIfPresent(link, forKey: CodingKeys.link)
    try container.encodeIfPresent(description, forKey: CodingKeys.description)
    try container.encodeIfPresent(markdown, forKey: CodingKeys.markdown)
    try container.encodeIfPresent(author, forKey: CodingKeys.author)
    try container.encodeIfPresent(categories, forKey: CodingKeys.category)
    try container.encodeIfPresent(comments, forKey: CodingKeys.comments)
    try container.encodeIfPresent(enclosure, forKey: CodingKeys.enclosure)
    try container.encodeIfPresent(guid, forKey: CodingKeys.guid)
    try container.encodeIfPresent(pubDate, forKey: CodingKeys.pubDate)
    try container.encodeIfPresent(source, forKey: CodingKeys.source)
    try container.encodeIfPresent(dublinCore, forKey: CodingKeys.dublinCore)
    try container.encodeIfPresent(content, forKey: CodingKeys.content)
    try container.encodeIfPresent(iTunes, forKey: CodingKeys.iTunes)
    try container.encodeIfPresent(media, forKey: CodingKeys.media)
    try container.encodeIfPresent(podcast, forKey: CodingKeys.podcast)
    try container.encodeIfPresent(geoRSS, forKey: CodingKeys.geoRSS)
  }
}
