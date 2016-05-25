//
//  RSS2Channel.swift
//
//  Copyright (c) 2016 Nuno Manuel Dias
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

/**
    Subordinate to the `<rss>` element is a single `<channel>` element, which contains information about the channels (metadata) and its contents.
*/
public class RSS2FeedChannel: SyndicationProtocol, DublinCoreProtocol {
    
    // MARK: - RSS2
    
    /**
     
     The name of the channel. It's how people refer to your service. If 
     you have an HTML website that contains the same information as your 
     RSS file, the title of your channel should be the same as the title 
     of your website.
     
     Example: GoUpstate.com News Headlines
     
     */
    public var title: String?
    
    /**
     
     The URL to the HTML website corresponding to the channel.
     
     Example: http://www.goupstate.com/
     
     */
    public var link: String?
    
    /**
     
     Phrase or sentence describing the channel. 
     
     Example: The latest news from GoUpstate.com, a Spartanburg Herald-Journal
     Web site.
     
     */
    public var description: String?
    
    /**
     
     The language the channel is written in. This allows aggregators to group 
     all Italian language sites, for example, on a single page. A list of 
     allowable values for this element, as provided by Netscape, is here:
     http://cyber.law.harvard.edu/rss/languages.html
     
     You may also use values defined by the W3C:
     http://www.w3.org/TR/REC-html40/struct/dirlang.html#langcodes
     
     Example: en-us
     
     */
    public var language: String?
    
    /**
     
     Copyright notice for content in the channel.
     
     Example: Copyright 2002, Spartanburg Herald-Journal
     
     */
    public var copyright: String?
    
    /**
     
     Email address for person responsible for editorial content.
     
     Example: geo@herald.com (George Matesky)
     
     */
    public var managingEditor: String?
    
    /**
     
     Email address for person responsible for technical issues relating to 
     channel.
     
     Example: betty@herald.com (Betty Guernsey)
     
     */
    public var webMaster: String?
    
    /**
     
     The publication date for the content in the channel. For example, the 
     New York Times publishes on a daily basis, the publication date flips 
     once every 24 hours. That's when the pubDate of the channel changes. 
     All date-times in RSS conform to the Date and Time Specification of 
     RFC 822, with the exception that the year may be expressed with two 
     characters or four characters (four preferred).
     
     Example: Sat, 07 Sep 2002 00:00:01 GMT
     
     */
    public var pubDate: String?
    
    /**
     
     The last time the content of the channel changed.
     
     Example: Sat, 07 Sep 2002 09:42:31 GMT
     
     */
    public var lastBuildDate: String?
    
    /**
     
     Specify one or more categories that the channel belongs to. Follows the 
     same rules as the <item>-level category element.
     
     Example: Newspapers
     
     */
    public var categories: [RSS2FeedChannelCategory]?
    
    /**
     
     A string indicating the program used to generate the channel.
     
     Example: MightyInHouse Content System v2.3
     
     */
    public var generator: String?
    
    /**
     
     A URL that points to the documentation for the format used in the RSS 
     file. It's probably a pointer to this page. It's for people who might 
     stumble across an RSS file on a Web server 25 years from now and wonder 
     what it is.
     
     Example: http://blogs.law.harvard.edu/tech/rss
     
     */
    public var docs: String?
    
    /**
     
     Allows processes to register with a cloud to be notified of updates to 
     the channel, implementing a lightweight publish-subscribe protocol for 
     RSS feeds.
     
     Example: <cloud domain="rpc.sys.com" port="80" path="/RPC2" registerProcedure="pingMe" protocol="soap"/>
     
     <cloud> is an optional sub-element of <channel>.
     
     It specifies a web service that supports the rssCloud interface which can
     be implemented in HTTP-POST, XML-RPC or SOAP 1.1.
     
     Its purpose is to allow processes to register with a cloud to be notified
     of updates to the channel, implementing a lightweight publish-subscribe 
     protocol for RSS feeds.
     
     <cloud domain="rpc.sys.com" port="80" path="/RPC2" registerProcedure="myCloud.rssPleaseNotify" protocol="xml-rpc" />
     
     In this example, to request notification on the channel it appears in, 
     you would send an XML-RPC message to rpc.sys.com on port 80, with a path 
     of /RPC2. The procedure to call is myCloud.rssPleaseNotify.
     
     A full explanation of this element and the rssCloud interface is here:
     http://cyber.law.harvard.edu/rss/soapMeetsRss.html#rsscloudInterface
     
     */
    public var cloud: RSS2FeedChannelCloud?

    /**
     
     The PICS rating for the channel.
     
     */
    public var rating: String?
    
    /**
     
     ttl stands for time to live. It's a number of minutes that indicates how 
     long a channel can be cached before refreshing from the source. 

     Example: 60
     
     <ttl> is an optional sub-element of <channel>.
     
     ttl stands for time to live. It's a number of minutes that indicates how 
     long a channel can be cached before refreshing from the source. This makes
     it possible for RSS sources to be managed by a file-sharing network such 
     as Gnutella.
     
     */
    public var ttl: UInt?
    
    /**
     
     Specifies a GIF, JPEG or PNG image that can be displayed with the channel.

     <image> is an optional sub-element of <channel>, which contains three
     required and three optional sub-elements.
     
     <url> is the URL of a GIF, JPEG or PNG image that represents the channel.
     
     <title> describes the image, it's used in the ALT attribute of the HTML
     <img> tag when the channel is rendered in HTML.
     
     <link> is the URL of the site, when the channel is rendered, the image
     is a link to the site. (Note, in practice the image <title> and <link>
     should have the same value as the channel's <title> and <link>.
     
     Optional elements include <width> and <height>, numbers, indicating the
     width and height of the image in pixels. <description> contains text
     that is included in the TITLE attribute of the link formed around the
     image in the HTML rendering.
     
     Maximum value for width is 144, default value is 88.
     
     Maximum value for height is 400, default value is 31.
     
     */
    public var image: RSS2FeedChannelImage?
    
    /**
     
     Specifies a text input box that can be displayed with the channel.
     
     A channel may optionally contain a <textInput> sub-element, which contains
     four required sub-elements.
     
     <title> -- The label of the Submit button in the text input area.
     
     <description> -- Explains the text input area.
     
     <name> -- The name of the text object in the text input area.
     
     <link> -- The URL of the CGI script that processes text input requests.
     
     The purpose of the <textInput> element is something of a mystery. You can
     use it to specify a search engine box. Or to allow a reader to provide 
     feedback. Most aggregators ignore it.
     
     */
    public var textInput: RSS2FeedChannelTextInput?
    
    /**
     
     A hint for aggregators telling them which hours they can skip.
     
     An XML element that contains up to 24 <hour> sub-elements whose value is a
     number between 0 and 23, representing a time in GMT, when aggregators, if they
     support the feature, may not read the channel on hours listed in the skipHours
     element.
     
     The hour beginning at midnight is hour zero.
     
     */
    public var skipHours: [RSS2FeedChannelSkipHour]?
        
    /**
     
     A hint for aggregators telling them which days they can skip.
     
     An XML element that contains up to seven <day> sub-elements whose value 
     is Monday, Tuesday, Wednesday, Thursday, Friday, Saturday or Sunday. 
     Aggregators may not read the channel during days listed in the skipDays 
     element.
     
     */
    public var skipDays: [RSS2FeedChannelSkipDay]?
    
    /** 
     
     A channel may contain any number of <item>s. An item may represent a 
     "story" -- much like a story in a newspaper or magazine; if so its 
     description is a synopsis of the story, and the link points to the full 
     story. An item may also be complete in itself, if so, the description 
     contains the text (entity-encoded HTML is allowed; see examples:
     http://cyber.law.harvard.edu/rss/encodingDescriptions.html), and
     the link and title may be omitted. All elements of an item are optional, 
     however at least one of title or description must be present.
     
     */
    public var items: [RSS2FeedChannelItem]?
    
    
    // MARK: - Syndication Module
    
    /// Describes the period over which the channel format is updated. Acceptable values are: hourly, daily, weekly, monthly, yearly. If omitted, daily is assumed.
    public var syUpdatePeriod: SyndicationUpdatePeriod?
    
    /// Used to describe the frequency of updates in relation to the update period. A positive integer indicates how many times in that period the channel is updated. For example, an updatePeriod of daily, and an updateFrequency of 2 indicates the channel format is updated twice daily. If omitted a value of 1 is assumed.
    public var syUpdateFrequency: UInt?
    
    /// Defines a base date to be used in concert with updatePeriod and updateFrequency to calculate the publishing schedule. The date format takes the form: yyyy-mm-ddThh:mm
    public var syUpdateBase: String?
    
    
    // MARK: - Dublin Core Module
    /**
     
     A name given to the resource
     
     */
    public var dcTitle: String? 
    
    /**
     
     An entity primarily responsible for making the content of the resource
     
     Examples of a Creator include a person, an organization, or a service.
     Typically, the name of a Creator should be used to indicate the entity.
     
     */
    public var dcCreator: String? 
    
    /**
     
     The topic of the content of the resource
     
     Typically, the subject will be represented using keywords, key phrases,
     or classification codes. Recommended best practice is to use a controlled
     vocabulary.  To describe the spatial or temporal topic of the resource,
     use the Coverage element.
     
     */
    public var dcSubject: String? 
    
    /**
     
     An account of the content of the resource
     
     Description may include but is not limited to: an abstract, a table of
     contents, a graphical representation, or a free-text account of the
     resource.
     
     */
    public var dcDescription: String? 
    
    /**
     
     An entity responsible for making the resource available
     
     Examples of a Publisher include a person, an organization, or a service.
     Typically, the name of a Publisher should be used to indicate the entity.
     
     */
    public var dcPublisher: String? 
    
    /**
     
     An entity responsible for making contributions to the content of the
     resource
     
     Examples of a Contributor include a person, an organization, or a service.
     Typically, the name of a Contributor should be used to indicate the entity.
     
     */
    public var dcContributor: String? 
    
    /**
     
     A point or period of time associated with an event in the lifecycle of the
     resource.
     
     Date may be used to express temporal information at any level of
     granularity. Recommended best practice is to use an encoding scheme, such
     as the W3CDTF profile of ISO 8601 [W3CDTF].
     
     */
    public var dcDate: String? 
    
    /**
     
     The nature or genre of the content of the resource
     
     Recommended best practice is to use a controlled vocabulary such as the
     DCMI Type Vocabulary [DCTYPE].  To describe the file format, physical
     medium, or dimensions of the resource, use the Format element.
     
     */
    public var dcType: String? 
    
    /**
     
     The file format, physical medium, or dimensions of the resource.
     
     Examples of dimensions include size and duration. Recommended best
     practice is to use a controlled vocabulary such as the list of Internet
     Media Types [MIME].
     
     */
    public var dcFormat: String? 
    
    /**
     
     An unambiguous reference to the resource within a given context.
     
     Recommended best practice is to identify the resource by means of a string
     conforming to a formal identification system.
     
     */
    public var dcIdentifier: String? 
    
    /**
     
     A Reference to a resource from which the present resource is derived
     
     The described resource may be derived from the related resource in whole
     or in part. Recommended best practice is to identify the related resource
     by means of a string conforming to a formal identification system.
     
     */
    public var dcSource: String? 
    
    /**
     
     A language of the resource.
     
     Recommended best practice is to use a controlled vocabulary such as
     RFC 4646 [RFC4646].
     
     */
    public var dcLanguage: String? 
    
    /**
     
     A related resource.
     
     Recommended best practice is to identify the related resource by means of
     a string conforming to a formal identification system.
     
     */
    public var dcRelation: String? 
    
    /**
     
     The spatial or temporal topic of the resource, the spatial applicability
     of the resource, or the jurisdiction under which the resource is
     relevant.
     
     Spatial topic and spatial applicability may be a named place or a location
     specified by its geographic coordinates.  Temporal topic may be a named
     period, date, or date range.  A jurisdiction may be a named administrative
     entity or a geographic place to which the resource applies.  Recommended
     best practice is to use a controlled vocabulary such as the Thesaurus of
     Geographic Names [TGN].  Where appropriate, named places or time periods
     can be used in preference to numeric identifiers such as sets of
     coordinates or date ranges.
     
     */
    public var dcCoverage: String? 
    
    /**
     
     Information about rights held in and over the resource.
     
     Typically, rights information includes a statement about various property
     rights associated with the resource, including intellectual property
     rights.
     
     */
    public var dcRights: String? 

    
    // MARK: - Initializers
    
    public init() {}
    
}