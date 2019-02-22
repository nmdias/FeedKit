//
//  RSSFeedItem.swift
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

/// A channel may contain any number of <item>s. An item may represent a
/// "story" -- much like a story in a newspaper or magazine; if so its
/// description is a synopsis of the story, and the link points to the full
/// story. An item may also be complete in itself, if so, the description
/// contains the text (entity-encoded HTML is allowed; see examples:
/// http://cyber.law.harvard.edu/rss/encodingDescriptions.html), and
/// the link and title may be omitted. All elements of an item are optional,
/// however at least one of title or description must be present.
public class RSSFeedItem {
    
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
    public var categories: [RSSFeedItemCategory]?
    
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
    public var enclosure: RSSFeedItemEnclosure?
    
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
    public var guid: RSSFeedItemGUID?
    
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
    public var source: RSSFeedItemSource?
    
    
    // MARK: - Namespaces
    
    /// The Dublin Core Metadata Element Set is a standard for cross-domain
    /// resource description.
    /// 
    /// See https://tools.ietf.org/html/rfc5013
    public var dublinCore: DublinCoreNamespace?
    
    /// A module for the actual content of websites, in multiple formats.
    /// 
    /// See http://web.resource.org/rss/1.0/modules/content/
    public var content: ContentNamespace?

    /// iTunes Podcasting Tags are de facto standard for podcast syndication. 
    /// see https://help.apple.com/itc/podcasts_connect/#/itcb54353390
    public var iTunes: ITunesNamespace?
    
    /// Media RSS is a new RSS module that supplements the <enclosure>
    /// capabilities of RSS 2.0.
    public var media: MediaNamespace?
    
    public init() { }
    
}

// MARK: - Equatable

extension RSSFeedItem: Equatable {
    
    public static func ==(lhs: RSSFeedItem, rhs: RSSFeedItem) -> Bool {
        return
            lhs.author == rhs.author &&
            lhs.categories == rhs.categories &&
            lhs.comments == rhs.comments &&
            lhs.content == rhs.content &&
            lhs.description == rhs.description &&
            lhs.dublinCore == rhs.dublinCore &&
            lhs.enclosure == rhs.enclosure &&
            lhs.guid == rhs.guid &&
            lhs.iTunes == rhs.iTunes &&
            lhs.media == rhs.media &&
            lhs.pubDate == rhs.pubDate &&
            lhs.source == rhs.source &&
            lhs.title == rhs.title
    }
    
}
