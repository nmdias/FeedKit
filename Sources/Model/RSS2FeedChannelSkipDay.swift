//
//  RSS2ChannelSkipDay.swift
//  FeedParser
//
//  Created by Nuno Dias on 01/07/15.
//  Copyright © 2015 FeedParser. All rights reserved.
//

import Foundation

/**
    Days of the week as described by the `skipDays` element of the RSS 2.0 specification.
    See: http://cyber.law.harvard.edu/rss/skipHoursDays.html#skiphours
*/
public enum RSS2FeedChannelSkipDay: String {
    
    case Monday     = "monday"
    case Tuesday    = "tuesday"
    case Wednesday  = "wednesday"
    case Thursday   = "thursday"
    case Friday     = "friday"
    case Saturday   = "saturday"
    case Sunday     = "sunday"
    
}

extension RSS2FeedChannelSkipDay {
    
    /**
        Lowercase the incoming `rawValue` string to try and match the `RSS2FeedChannelSkipDay`'s `rawValue`
    */
    public init?(rawValue: String) {
        
        switch rawValue.lowercaseString {
            
        case "monday":     self = .Monday
        case "tuesday":    self = .Tuesday
        case "wednesday":  self = .Wednesday
        case "thursday":   self = .Thursday
        case "friday":     self = .Friday
        case "saturday":   self = .Saturday
        case "sunday":     self = .Sunday
            
        default: return nil
            
        }
        
    }
    
}