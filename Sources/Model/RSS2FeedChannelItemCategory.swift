//
//  RSS2ChannelItemCategory.swift
//  Iris
//
//  Created by Nuno Dias on 01/07/15.
//  Copyright © 2015 Iris. All rights reserved.
//

import Foundation

/**
    The category of an item. Identifies a category or tag to which the `<item>` belongs.
*/
public class RSS2FeedChannelItemCategory {
    
    /**
        The attributes of the `<item>`'s `<category>` element
    */
    public class Attributes {
        
        /// A string that identifies a categorization taxonomy. It's an optional attribute of `<category>`. e.g. "http://www.fool.com/cusips"
        public var domain: String?
        
    }
    
    // The element's attributes
    public var attributes: Attributes?
    
    /// The actual `<category>` value
    public var value: String?
    
    public init() {}
    
}
