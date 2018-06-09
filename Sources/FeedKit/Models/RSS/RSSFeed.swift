//
//  RSSFeed.swift
//
//  Copyright (c) 2016 - 2018 Nuno Manuel Dias
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
public class RSSFeed {

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
    public var skipHours: [RSSFeedSkipHour]?
    
    /// A hint for aggregators telling them which days they can skip.
    /// 
    /// An XML element that contains up to seven <day> sub-elements whose value 
    /// is Monday, Tuesday, Wednesday, Thursday, Friday, Saturday or Sunday. 
    /// Aggregators may not read the channel during days listed in the skipDays 
    /// element.
    public var skipDays: [RSSFeedSkipDay]?
    
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
    public var dublinCore: DublinCoreNamespace?
    
    /// Provides syndication hints to aggregators and others picking up this RDF Site
    /// Summary (RSS) feed regarding how often it is updated. For example, if you
    /// updated your file twice an hour, updatePeriod would be "hourly" and
    /// updateFrequency would be "2". The syndication module borrows from Ian Davis's
    /// Open Content Syndication (OCS) directory format. It supercedes the RSS 0.91
    /// skipDay and skipHour elements.
    /// 
    /// See http://web.resource.org/rss/1.0/modules/syndication/
    public var syndication: SyndicationNamespace?

    /// iTunes Podcasting Tags are de facto standard for podcast syndication.
    /// See https://help.apple.com/itc/podcasts_connect/#/itcb54353390
    public var iTunes: ITunesNamespace?
    
    
}

// MARK: - Equatable

extension RSSFeed: Equatable {
    
    public static func ==(lhs: RSSFeed, rhs: RSSFeed) -> Bool {
        return
            lhs.categories == rhs.categories &&
            lhs.cloud == rhs.cloud &&
            lhs.copyright == rhs.copyright &&
            lhs.description == rhs.description &&
            lhs.docs == rhs.docs &&
            lhs.dublinCore == rhs.dublinCore &&
            lhs.generator == rhs.generator &&
            lhs.items == rhs.items &&
            lhs.iTunes == rhs.iTunes &&
            lhs.language == rhs.language &&
            lhs.lastBuildDate == rhs.lastBuildDate &&
            lhs.link == rhs.link &&
            lhs.managingEditor == rhs.managingEditor &&
            lhs.pubDate == rhs.pubDate &&
            lhs.rating == rhs.rating &&
            lhs.skipDays == rhs.skipDays &&
            lhs.skipHours == rhs.skipHours &&
            lhs.syndication == rhs.syndication &&
            lhs.textInput == rhs.textInput &&
            lhs.title == rhs.title &&
            lhs.ttl == rhs.ttl &&
            lhs.webMaster == rhs.webMaster
    }
    
}
