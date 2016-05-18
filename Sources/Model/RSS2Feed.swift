//
//  Feed.swift
//  FeedParser
//
//  Created by Nuno Dias on 27/06/15.
//  Copyright © 2015 FeedParser. All rights reserved.
//

import Foundation

/**
    Data model for the XML DOM of the RSS 2.0 Specification
    See http://cyber.law.harvard.edu/rss/rss.html
*/
public class RSS2Feed {
    
    /// The feed's `<channel>` element
    public var channel: RSS2FeedChannel?
    
    public init() {}
    
}
