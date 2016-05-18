//
//  FeedType.swift
//  FeedParser
//
//  Created by Nuno Dias on 01/07/15.
//  Copyright © 2015 FeedParser. All rights reserved.
//

import Foundation

public enum FeedType: String {
    
    case Atom = "feed"
    case RSS1 = "rdf:RDF"
    case RSS2 = "rss"
    
    var path: String {
        return self.rawValue
    }
    
}