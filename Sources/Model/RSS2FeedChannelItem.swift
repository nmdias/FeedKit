//
//  RSS2ChannelItem.swift
//  Iris
//
//  Created by Nuno Dias on 01/07/15.
//  Copyright © 2015 Iris. All rights reserved.
//

import Foundation

/**
    The channel's item. A channel may contain any number of `<item>`s. An item may represent a "story" -- much like a story in
    a newspaper or magazine;  if so its description is a synopsis of the story, and the link points to the full story.
    An item may also be complete in itself, if so, the description contains the text (entity-encoded HTML is allowed;
    see examples: http://cyber.law.harvard.edu/rss/encodingDescriptions.html), and the link and title may be omitted.
    All elements of an item are optional, however at least one of title or description must be present.
*/
public class RSS2FeedChannelItem: DublinCoreProtocol, ContentProtocol {
    
    /// The title of the item. e.g. "Venice Film Festival Tries to Quit Sinking"
    public var title: String?
    
    /// The URL of the item. e.g. "http://nytimes.com/2004/12/07FEST.html"
    public var link: String?
    
    /// The item synopsis. e.g. "Some of the most heated chatter at the Venice Film Festival this week was about the way that the arrival of the stars at the Palazzo del Cinema was being staged."
    public var description: String?
    
    /// Email address of the author of the item. e.g. "lawyer@boyer.net (Lawyer Boyer)"
    public var author: String?
    
    /// Includes the item in one or more categories. It's an optional sub-element of `<item>`.
    public var categories: [RSS2FeedChannelItemCategory]?
    
    /// URL of a page for comments relating to the item. It's an optional sub-element of `<item>` e.g. "http://ekzemplo.com/entry/4403/comments"
    public var comments: String?
    
    /// Describes a media object that is attached to the item. It's an optional sub-element of `<item>`.
    public var enclosure: RSS2FeedChannelItemEnclosure?
    
    /// Globally Unique Identifier. It's a string that uniquely identifies the item. It's an optional sub-element of `<item>`.
    public var guid: RSS2FeedChannelItemGUID?
    
    /// Indicates when the item was published. e.g. "Sun, 19 May 2002 15:21:36 GMT"
    public var pubDate: String?
    
    /// The name of the RSS channel that the item came from, derived from its `<title>`. It has one required attribute, "url", which links to the XMLization of the source. It's an optional sub-element of `<item>`.
    public var source: RSS2FeedChannelItemSource?
    
    
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
    
    
    // MARK: - Content Module
    
    // TODO: - Add description
    var contentEncoded: String?
    
    // TODO: Uncomment?
//    public init() {}
    
}