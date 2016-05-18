//
//  RSS2FeedChannelItemGUID.swift
//  FeedParser
//
//  Created by Nuno Dias on 07/07/15.
//  Copyright © 2015 FeedParser. All rights reserved.
//

import Foundation

/**
    Uniquely identifies the `<item>`. When present, an aggregator may choose to use this string to determine if an item is new.
*/
public class RSS2FeedChannelItemGUID {
    
    /**
        The attributes of the `<item>`'s `<guid>` element
    */
    public class Attributes {
        
        /// isPermaLink is an optional attribute. The default value is true. If the value is false, the guid may not be assumed to be a url, or a url to anything in particular.
        public var isPermaLink: Bool?
        
    }
    
    // The element's attributes
    public var attributes: Attributes?
    
    /// The actual `<guid>` value.
    public var value: String?
    
    public init() {}
    
}
