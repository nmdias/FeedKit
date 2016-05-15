//
//  RSS2ChannelItemSource.swift
//  Iris
//
//  Created by Nuno Dias on 01/07/15.
//  Copyright © 2015 Iris. All rights reserved.
//

import Foundation

/**
    The source of an `<item>`. An item's source element indicates the fact that the item has been republished from another RSS feed.
*/
public class RSS2FeedChannelItemSource {
    
    /**
        The attributes of the `<item>`'s `<source>` element
    */
    public class Attributes {
        
        /// Required attribute of the `Source` element, which links to the XMLization of the source. e.g. "http://www.tomalak.org/links2.xml"
        public var url: String?
        
    }
    
    // The element's attributes
    public var attributes: Attributes?
    
    /// The actual `<source>` value
    public var value: String?
    
    public init() {}
    
}