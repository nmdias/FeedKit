//
//  SyndicationUpdatePeriod.swift
//  FeedParser
//
//  Created by Nuno Dias on 26/05/16.
//
//

import Foundation

/**
 
 Describes the period over which the channel format is updated. Acceptable
 values are: hourly, daily, weekly, monthly, yearly. If omitted, daily is
 assumed.
 
 */
public enum SyndicationUpdatePeriod: String {
    
    case Hourly     = "hourly"
    case Daily      = "daily"
    case Weekly     = "weekly"
    case Monthly    = "monthly"
    case Yearly     = "yearly"
    
}