//
//  Content.swift
//  FeedParser
//
//  Created by Nuno Dias on 23/07/15.
//  Copyright © 2015 FeedParser. All rights reserved.
//

import Foundation

/**
TODO: - Add description
See: http://dublincore.org/documents/1999/07/02/dces/
*/
protocol ContentProtocol {
    
    /// TODO: - Add description
    var contentEncoded: String? { get set }
    
}

// http://web.resource.org/rss/1.0/modules/content/

public enum ContentElement: String {
    
    public static let namespace = [ "xmlns:content" : "http://purl.org/rss/1.0/modules/content/" ]
    
    case RSSChannelItemContent = "/rss/channel/item/content:encoded"
    
}