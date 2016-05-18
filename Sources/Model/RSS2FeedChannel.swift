//
//  RSS2Channel.swift
//  FeedParser
//
//  Created by Nuno Dias on 01/07/15.
//  Copyright © 2015 FeedParser. All rights reserved.
//

import Foundation

/**
    Subordinate to the `<rss>` element is a single `<channel>` element, which contains information about the channels (metadata) and its contents.
*/
public class RSS2FeedChannel: SyndicationProtocol, DublinCoreProtocol {
    
    // MARK: - RSS2
    
    /// The name of the channel. It's how people refer to your service. If you have an HTML website that contains the same information as your RSS file, the title of your channel should be the same as the title of your website. e.g. "GoUpstate.com News Headlines"
    public var title: String?
    
    /// The URL to the HTML website corresponding to the channel. e.g. "http://www.goupstate.com/"
    public var link: String?
    
    /// Phrase or sentence describing the channel. e.g. "The latest news from GoUpstate.com, a Spartanburg Herald-Journal Web site."
    public var description: String?
    
    /// The language the channel is written in. This allows aggregators to group all Italian language sites, for example, on a single page. A list of allowable values for this element, as provided by Netscape, is here http://cyber.law.harvard.edu/rss/languages.html You may also use values defined by the W3C http://www.w3.org/TR/REC-html40/struct/dirlang.html#langcodes e.g. "en-us"
    public var language: String?
    
    /// Copyright notice for content in the channel. e.g. "Copyright 2002, Spartanburg Herald-Journal"
    public var copyright: String?
    
    /// Email address for person responsible for editorial content.	e.g. "geo@herald.com (George Matesky)"
    public var managingEditor: String?
    
    /// Email address for person responsible for technical issues relating to channel. e.g. "betty@herald.com (Betty Guernsey)"
    public var webMaster: String?
    
    /// The publication date for the content in the channel. For example, the New York Times publishes on a daily basis, the publication date flips once every 24 hours. That's when the pubDate of the channel changes. All date-times in RSS conform to the Date and Time Specification of RFC 822: http://asg.web.cmu.edu/rfc/rfc822.html, with the exception that the year may be expressed with two characters or four characters (four preferred). e.g. "Sat, 07 Sep 2002 00:00:01 GMT"
    public var pubDate: String?
    
    /// The last time the content of the channel changed. e.g. "Sat, 07 Sep 2002 09:42:31 GMT"
    public var lastBuildDate: String?
    
    /// Specify one or more categories that the channel belongs to. Follows the same rules as the <item> level category element. More info.
    public var categories: [RSS2FeedChannelCategory]?
    
    /// A string indicating the program used to generate the channel. e.g. "MightyInHouse Content System v2.3"
    public var generator: String?
    
    /// A URL that points to the documentation for the format used in the RSS file. It's probably a pointer to http://blogs.law.harvard.edu/tech/rss. It's for people who might stumble across an RSS file on a Web server 25 years from now and wonder what it is.
    public var docs: String?
    
    /// It specifies a web service that supports the rssCloud interface which can be implemented in HTTP-POST, XML-RPC or SOAP 1.1. It's an optional sub-element of `channel`.
    public var cloud: RSS2FeedChannelCloud?

    /// The PICS rating for the channel. See http://www.w3.org/PICS/
    public var rating: String?
    
    /// ttl stands for time to live. It's a number of minutes that indicates how long a channel can be cached before refreshing from the source. This makes it possible for RSS sources to be managed by a file-sharing network such as Gnutella e.g. "60"
    public var ttl: UInt?
    
    /// Specifies a GIF, JPEG or PNG image that can be displayed with the channel. `<image>` is an optional element of the channel.
    public var image: RSS2FeedChannelImage?
    
    /// Specifies a text input box that can be displayed with the channel.
    public var textInput: RSS2FeedChannelTextInput?
    
    /// A hint for aggregators telling them which hours they can skip. Contains up to 24 `<hour>` elements whose value is a number between 0 and 23, representing a time in GMT, when aggregators, if they support the feature, may not read the channel on hours listed in the skipHours element.
    public var skipHours: [RSS2FeedChannelSkipHour]?
        
    /// A hint for aggregators telling them which days they can skip. Contains up to seven `<day>` sub-elements whose value is Monday, Tuesday, Wednesday, Thursday, Friday, Saturday or Sunday. Aggregators may not read the channel during days listed in the skipDays element.
    public var skipDays: [RSS2FeedChannelSkipDay]?
    
    /// An item element represents distinct content published in the feed such as a news article, weblog entry or some other form of discrete update. A channel MAY contain any number of items (or no items at all).
    public var items: [RSS2FeedChannelItem]?
    
    
    // MARK: - Syndication Module
    
    /// Describes the period over which the channel format is updated. Acceptable values are: hourly, daily, weekly, monthly, yearly. If omitted, daily is assumed.
    public var syUpdatePeriod: SyndicationUpdatePeriod?
    
    /// Used to describe the frequency of updates in relation to the update period. A positive integer indicates how many times in that period the channel is updated. For example, an updatePeriod of daily, and an updateFrequency of 2 indicates the channel format is updated twice daily. If omitted a value of 1 is assumed.
    public var syUpdateFrequency: UInt?
    
    /// Defines a base date to be used in concert with updatePeriod and updateFrequency to calculate the publishing schedule. The date format takes the form: yyyy-mm-ddThh:mm
    public var syUpdateBase: String?
    
    
    // MARK: - Dublin Core Module
    
    /// A name given to the resource.
    public var dcTitle: String?
    
    /// An entity primarily responsible for making the content of the resource.
    public var dcCreator: String?
    
    /// The topic of the content of the resource.
    public var dcSubject: String?
    
    /// An account of the content of the resource.
    public var dcDescription: String?
    
    /// An entity responsible for making the resource available.
    public var dcPublisher: String?
    
    /// An entity responsible for making contributions to the content of the resource.
    public var dcContributor: String?
    
    /// A date associated with an event in the life cycle of the resource.
    public var dcDate: String?
    
    /// The nature or genre of the content of the resource.
    public var dcType: String?
    
    /// The physical or digital manifestation of the resource.
    public var dcFormat: String?
    
    /// An unambiguous reference to the resource within a given context.
    public var dcIdentifier: String?
    
    /// A Reference to a resource from which the present resource is derived.
    public var dcSource: String?
    
    /// A language of the intellectual content of the resource.
    public var dcLanguage: String?
    
    /// A reference to a related resource.
    public var dcRelation: String?
    
    /// The extent or scope of the content of the resource.
    public var dcCoverage: String?
    
    /// Information about rights held in and over the resource.
    public var dcRights: String?

    
    // MARK: - Initializers
    
    public init() {}
    
}