//
//  RSS2ChannelItemEnclosure.swift
//  FeedParser
//
//  Created by Nuno Dias on 01/07/15.
//  Copyright © 2015 FeedParser. All rights reserved.
//

import Foundation

/**
    The enclosure of an `<item>`. It's an optional element. Associates a media object such as an audio or video file with the item.
*/
public class RSS2FeedChannelItemEnclosure {
    
    /**
        The attributes of the `<item>`'s `<enclosure>` element
    */
    public class Attributes {
        
        /// Where the enclosure is located. It's an attribute of the `<enclosure>` element. e.g. "http://www.scripting.com/mp3s/weatherReportSuite.mp3"
        public var url: String?
        
        /// How big it is in bytes. It's an attribute of the `<enclosure>` element. e.g."12216320"
        public var length: UInt64?
        
        /// Standard MIME type. It's an attribute of the `<enclosure>` element. e.g. "audio/mpeg"
        public var type: String?
        
    }
    
    // The element's attributes
    public var attributes: Attributes?
    
    public init() {}
    
}
