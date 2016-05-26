//
//  SyndicationUpdatePeriod.swift
//  FeedParser
//
//  Created by Nuno Dias on 26/05/16.
//
//

import Foundation

/**
 
 Update periods as described by the `<sy:updatePeriod>` element of the Syndication Module specification.
 
 See: http://cyber.law.harvard.edu/rss/skipHoursDays.html#skiphours
 
 */
public enum SyndicationUpdatePeriod: String {
    
    case Hourly     = "hourly"
    case Daily      = "daily"
    case Weekly     = "weekly"
    case Monthly    = "monthly"
    case Yearly     = "yearly"
    
}

//extension SyndicationUpdatePeriod {
//    
//    /**
//     Lowercase the incoming `rawValue` string to try and match the `SyndicationUpdatePeriod`'s `rawValue`
//     */
//    public init?(rawValue: String) {
//        
//        switch rawValue.lowercaseString {
//            
//        case "hourly":      self = .Hourly
//        case "daily":       self = .Daily
//        case "weekly":      self = .Weekly
//        case "monthly":     self = .Monthly
//        case "yearly":      self = .Yearly
//            
//        default: return nil
//            
//        }
//        
//    }
//    
//}