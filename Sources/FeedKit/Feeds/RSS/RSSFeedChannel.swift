//
// RSSFeedChannel.swift
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
public struct RSSFeedChannel {
  // MARK: Lifecycle

  public init(
    title: String? = nil,
    link: String? = nil,
    description: String? = nil,
    language: String? = nil,
    copyright: String? = nil,
    managingEditor: String? = nil,
    webMaster: String? = nil,
    pubDate: Date? = nil,
    lastBuildDate: Date? = nil,
    categories: [RSSFeedCategory]? = nil,
    generator: String? = nil,
    docs: String? = nil,
    cloud: RSSFeedCloud? = nil,
    rating: String? = nil,
    ttl: Int? = nil,
    image: RSSFeedImage? = nil,
    textInput: RSSFeedTextInput? = nil,
    skipHours: RSSFeedSkipHours? = nil,
    skipDays: RSSFeedSkipDays? = nil,
    items: [RSSFeedItem]? = nil,
    dublinCore: DublinCore? = nil,
    iTunes: ITunes? = nil,
    syndication: Syndication? = nil,
    atom: Atom? = nil,
    podcast: Podcast? = nil
  ) {
    self.title = title
    self.link = link
    self.description = description
    self.language = language
    self.copyright = copyright
    self.managingEditor = managingEditor
    self.webMaster = webMaster
    self.pubDate = pubDate
    self.lastBuildDate = lastBuildDate
    self.categories = categories
    self.generator = generator
    self.docs = docs
    self.cloud = cloud
    self.rating = rating
    self.ttl = ttl
    self.image = image
    self.textInput = textInput
    self.skipHours = skipHours
    self.skipDays = skipDays
    self.items = items
    self.dublinCore = dublinCore
    self.iTunes = iTunes
    self.syndication = syndication
    self.atom = atom
    self.podcast = podcast
  }

  // MARK: Public

  /// The name of the channel. It's how people refer to your service. If
  /// you have an HTML website that contains the same information as your
  /// RSS file, the title of your channel should be the same as the title
  /// of your website.
  ///
  /// Example: GoUpstate.com News Headlines
  public var title: String?

  /// The URL to the HTML website corresponding to the channel.
  ///
  /// Example: http://www.goupstate.com/
  public var link: String?

  /// Phrase or sentence describing the channel.
  ///
  /// Example: The latest news from GoUpstate.com, a Spartanburg Herald-Journal
  /// Web site.
  public var description: String?

  /// The language the channel is written in. This allows aggregators to group
  /// all Italian language sites, for example, on a single page. A list of
  /// allowable values for this element, as provided by Netscape, is here:
  /// http://cyber.law.harvard.edu/rss/languages.html
  ///
  /// You may also use values defined by the W3C:
  /// http://www.w3.org/TR/REC-html40/struct/dirlang.html#langcodes
  ///
  /// Example: en-us
  public var language: String?

  /// Copyright notice for content in the channel.
  ///
  /// Example: Copyright 2002, Spartanburg Herald-Journal
  public var copyright: String?

  /// Email address for person responsible for editorial content.
  ///
  /// Example: geo@herald.com (George Matesky)
  public var managingEditor: String?

  /// Email address for person responsible for technical issues relating to
  /// channel.
  ///
  /// Example: betty@herald.com (Betty Guernsey)
  public var webMaster: String?

  /// The publication date for the content in the channel. For example, the
  /// New York Times publishes on a daily basis, the publication date flips
  /// once every 24 hours. That's when the pubDate of the channel changes.
  /// All date-times in RSS conform to the Date and Time Specification of
  /// RFC 822, with the exception that the year may be expressed with two
  /// characters or four characters (four preferred).
  ///
  /// Example: Sat, 07 Sep 2002 00:00:01 GMT
  public var pubDate: Date?

  /// The last time the content of the channel changed.
  ///
  /// Example: Sat, 07 Sep 2002 09:42:31 GMT
  public var lastBuildDate: Date?

  /// Specify one or more categories that the channel belongs to. Follows the
  /// same rules as the <item>-level category element.
  ///
  /// Example: Newspapers
  public var categories: [RSSFeedCategory]?

  /// A string indicating the program used to generate the channel.
  ///
  /// Example: MightyInHouse Content System v2.3
  public var generator: String?

  /// A URL that points to the documentation for the format used in the RSS
  /// file. It's probably a pointer to this page. It's for people who might
  /// stumble across an RSS file on a Web server 25 years from now and wonder
  /// what it is.
  ///
  /// Example: http://blogs.law.harvard.edu/tech/rss
  public var docs: String?

  /// Allows processes to register with a cloud to be notified of updates to
  /// the channel, implementing a lightweight publish-subscribe protocol for
  /// RSS feeds.
  ///
  /// Example: <cloud domain="rpc.sys.com" port="80" path="/RPC2" registerProcedure="pingMe" protocol="soap"/>
  ///
  /// <cloud> is an optional sub-element of <channel>.
  ///
  /// It specifies a web service that supports the rssCloud interface which can
  /// be implemented in HTTP-POST, XML-RPC or SOAP 1.1.
  ///
  /// Its purpose is to allow processes to register with a cloud to be notified
  /// of updates to the channel, implementing a lightweight publish-subscribe
  /// protocol for RSS feeds.
  ///
  /// <cloud domain="rpc.sys.com" port="80" path="/RPC2" registerProcedure="myCloud.rssPleaseNotify" protocol="xml-rpc" />
  ///
  /// In this example, to request notification on the channel it appears in,
  /// you would send an XML-RPC message to rpc.sys.com on port 80, with a path
  /// of /RPC2. The procedure to call is myCloud.rssPleaseNotify.
  ///
  /// A full explanation of this element and the rssCloud interface is here:
  /// http://cyber.law.harvard.edu/rss/soapMeetsRss.html#rsscloudInterface
  public var cloud: RSSFeedCloud?

  /// The PICS rating for the channel.
  public var rating: String?

  /// ttl stands for time to live. It's a number of minutes that indicates how
  /// long a channel can be cached before refreshing from the source.
  ///
  /// Example: 60
  ///
  /// <ttl> is an optional sub-element of <channel>.
  ///
  /// ttl stands for time to live. It's a number of minutes that indicates how
  /// long a channel can be cached before refreshing from the source. This makes
  /// it possible for RSS sources to be managed by a file-sharing network such
  /// as Gnutella.
  public var ttl: Int?

  /// Specifies a GIF, JPEG or PNG image that can be displayed with the channel.
  ///
  /// <image> is an optional sub-element of <channel>, which contains three
  /// required and three optional sub-elements.
  ///
  /// <url> is the URL of a GIF, JPEG or PNG image that represents the channel.
  ///
  /// <title> describes the image, it's used in the ALT attribute of the HTML
  /// <img> tag when the channel is rendered in HTML.
  ///
  /// <link> is the URL of the site, when the channel is rendered, the image
  /// is a link to the site. (Note, in practice the image <title> and <link>
  /// should have the same value as the channel's <title> and <link>.
  ///
  /// Optional elements include <width> and <height>, numbers, indicating the
  /// width and height of the image in pixels. <description> contains text
  /// that is included in the TITLE attribute of the link formed around the
  /// image in the HTML rendering.
  ///
  /// Maximum value for width is 144, default value is 88.
  ///
  /// Maximum value for height is 400, default value is 31.
  public var image: RSSFeedImage?

  /// Specifies a text input box that can be displayed with the channel.
  ///
  /// A channel may optionally contain a <textInput> sub-element, which contains
  /// four required sub-elements.
  ///
  /// <title> -- The label of the Submit button in the text input area.
  ///
  /// <description> -- Explains the text input area.
  ///
  /// <name> -- The name of the text object in the text input area.
  ///
  /// <link> -- The URL of the CGI script that processes text input requests.
  ///
  /// The purpose of the <textInput> element is something of a mystery. You can
  /// use it to specify a search engine box. Or to allow a reader to provide
  /// feedback. Most aggregators ignore it.
  public var textInput: RSSFeedTextInput?

  /// A hint for aggregators telling them which hours they can skip.
  ///
  /// An XML element that contains up to 24 <hour> sub-elements whose value is a
  /// number between 0 and 23, representing a time in GMT, when aggregators, if they
  /// support the feature, may not read the channel on hours listed in the skipHours
  /// element.
  ///
  /// The hour beginning at midnight is hour zero.
  public var skipHours: RSSFeedSkipHours?

  /// A hint for aggregators telling them which days they can skip.
  ///
  /// An XML element that contains up to seven <day> sub-elements whose value
  /// is Monday, Tuesday, Wednesday, Thursday, Friday, Saturday or Sunday.
  /// Aggregators may not read the channel during days listed in the skipDays
  /// element.
  public var skipDays: RSSFeedSkipDays?

  /// A channel may contain any number of <item>s. An item may represent a
  /// "story" -- much like a story in a newspaper or magazine; if so its
  /// description is a synopsis of the story, and the link points to the full
  /// story. An item may also be complete in itself, if so, the description
  /// contains the text (entity-encoded HTML is allowed; see examples:
  /// http://cyber.law.harvard.edu/rss/encodingDescriptions.html), and
  /// the link and title may be omitted. All elements of an item are optional,
  /// however at least one of title or description must be present.
  public var items: [RSSFeedItem]?

  // MARK: - Namespaces

  /// The Dublin Core Metadata Element Set is a standard for cross-domain
  /// resource description.
  ///
  /// See https://tools.ietf.org/html/rfc5013
  public var dublinCore: DublinCore?

  /// iTunes Podcasting Tags are de facto standard for podcast syndication.
  /// See https://help.apple.com/itc/podcasts_connect/#/itcb54353390
  public var iTunes: ITunes?

  /// Provides syndication hints to aggregators and others picking up this RDF Site
  /// Summary (RSS) feed regarding how often it is updated. For example, if you
  /// updated your file twice an hour, updatePeriod would be "hourly" and
  /// updateFrequency would be "2". The syndication module borrows from Ian Davis's
  /// Open Content Syndication (OCS) directory format. It supercedes the RSS 0.91
  /// skipDay and skipHour elements.
  ///
  /// See http://web.resource.org/rss/1.0/modules/syndication/
  public var syndication: Syndication?

  /// Atom namespace in an RSS feed helps WebSub subscribers discover the topic
  /// and hub information.
  /// See https://www.w3.org/TR/websub/#discovery
  public var atom: Atom?

  /// Podcast namespace provides podcast-specific metadata and extensions.
  /// See https://github.com/Podcastindex-org/podcast-namespace
  public var podcast: Podcast?
}

// MARK: - Sendable

extension RSSFeedChannel: Sendable {}

// MARK: - Equatable

extension RSSFeedChannel: Equatable {}

// MARK: - Hashable

extension RSSFeedChannel: Hashable {}

// MARK: - Codable

extension RSSFeedChannel: Codable {
  private enum CodingKeys: String, CodingKey {
    case title
    case link
    case description
    case language
    case copyright
    case managingEditor
    case webMaster
    case pubDate
    case lastBuildDate
    case category
    case generator
    case docs
    case cloud
    case rating
    case ttl
    case image
    case textInput
    case skipHours
    case skipDays
    case item
    case dublinCore = "dc"
    case iTunes = "itunes"
    case syndication = "sy"
    case atom
    case podcast
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<RSSFeedChannel.CodingKeys> = try decoder.container(keyedBy: RSSFeedChannel.CodingKeys.self)

    title = try container.decodeIfPresent(String.self, forKey: CodingKeys.title)
    link = try container.decodeIfPresent(String.self, forKey: CodingKeys.link)
    description = try container.decodeIfPresent(String.self, forKey: CodingKeys.description)
    language = try container.decodeIfPresent(String.self, forKey: CodingKeys.language)
    copyright = try container.decodeIfPresent(String.self, forKey: CodingKeys.copyright)
    managingEditor = try container.decodeIfPresent(String.self, forKey: CodingKeys.managingEditor)
    webMaster = try container.decodeIfPresent(String.self, forKey: CodingKeys.webMaster)
    pubDate = try container.decodeIfPresent(Date.self, forKey: CodingKeys.pubDate)
    lastBuildDate = try container.decodeIfPresent(Date.self, forKey: CodingKeys.lastBuildDate)
    categories = try container.decodeIfPresent([RSSFeedCategory].self, forKey: CodingKeys.category)
    generator = try container.decodeIfPresent(String.self, forKey: CodingKeys.generator)
    docs = try container.decodeIfPresent(String.self, forKey: CodingKeys.docs)
    cloud = try container.decodeIfPresent(RSSFeedCloud.self, forKey: CodingKeys.cloud)
    rating = try container.decodeIfPresent(String.self, forKey: CodingKeys.rating)
    ttl = try container.decodeIfPresent(Int.self, forKey: CodingKeys.ttl)
    image = try container.decodeIfPresent(RSSFeedImage.self, forKey: CodingKeys.image)
    textInput = try container.decodeIfPresent(RSSFeedTextInput.self, forKey: CodingKeys.textInput)
    skipHours = try container.decodeIfPresent(RSSFeedSkipHours.self, forKey: CodingKeys.skipHours)
    skipDays = try container.decodeIfPresent(RSSFeedSkipDays.self, forKey: CodingKeys.skipDays)
    items = try container.decodeIfPresent([RSSFeedItem].self, forKey: CodingKeys.item)
    dublinCore = try container.decodeIfPresent(DublinCore.self, forKey: CodingKeys.dublinCore)
    iTunes = try container.decodeIfPresent(ITunes.self, forKey: CodingKeys.iTunes)
    syndication = try container.decodeIfPresent(Syndication.self, forKey: CodingKeys.syndication)
    atom = try container.decodeIfPresent(Atom.self, forKey: CodingKeys.atom)
    podcast = try container.decodeIfPresent(Podcast.self, forKey: CodingKeys.podcast)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<RSSFeedChannel.CodingKeys> = encoder.container(keyedBy: RSSFeedChannel.CodingKeys.self)

    try container.encodeIfPresent(title, forKey: CodingKeys.title)
    try container.encodeIfPresent(link, forKey: CodingKeys.link)
    try container.encodeIfPresent(description, forKey: CodingKeys.description)
    try container.encodeIfPresent(language, forKey: CodingKeys.language)
    try container.encodeIfPresent(copyright, forKey: CodingKeys.copyright)
    try container.encodeIfPresent(managingEditor, forKey: CodingKeys.managingEditor)
    try container.encodeIfPresent(webMaster, forKey: CodingKeys.webMaster)
    try container.encodeIfPresent(pubDate, forKey: CodingKeys.pubDate)
    try container.encodeIfPresent(lastBuildDate, forKey: CodingKeys.lastBuildDate)
    try container.encodeIfPresent(categories, forKey: CodingKeys.category)
    try container.encodeIfPresent(generator, forKey: CodingKeys.generator)
    try container.encodeIfPresent(docs, forKey: CodingKeys.docs)
    try container.encodeIfPresent(cloud, forKey: CodingKeys.cloud)
    try container.encodeIfPresent(rating, forKey: CodingKeys.rating)
    try container.encodeIfPresent(ttl, forKey: CodingKeys.ttl)
    try container.encodeIfPresent(image, forKey: CodingKeys.image)
    try container.encodeIfPresent(textInput, forKey: CodingKeys.textInput)
    try container.encodeIfPresent(skipHours, forKey: CodingKeys.skipHours)
    try container.encodeIfPresent(skipDays, forKey: CodingKeys.skipDays)
    try container.encodeIfPresent(items, forKey: CodingKeys.item)
    try container.encodeIfPresent(dublinCore, forKey: CodingKeys.dublinCore)
    try container.encodeIfPresent(iTunes, forKey: CodingKeys.iTunes)
    try container.encodeIfPresent(syndication, forKey: CodingKeys.syndication)
    try container.encodeIfPresent(atom, forKey: CodingKeys.atom)
    try container.encodeIfPresent(podcast, forKey: CodingKeys.podcast)
  }
}
