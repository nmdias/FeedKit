//
//  RSS2ChannelCategory.swift
//  FeedParser
//
//  Created by Nuno Dias on 01/07/15.
//  Copyright © 2015 FeedParser. All rights reserved.
//

import Foundation

/**
    The category of `<channel>`. Identifies a category or tag to which the feed belongs.
*/
public class RSS2FeedChannelCategory {
    
    /**
        The attributes of the `<channel>`'s `<category>` element
    */
    public class Attributes {
        
        /// A string that identifies a categorization taxonomy. It's an optional attribute of `<category>`. e.g. "http://www.fool.com/cusips"
        public var domain: String?
        
    }
    
    /// The element's attributes
    public var attributes: Attributes?
    
    /// The actual `<category>` value
    public var value: String?

    public init() {}
    
}
