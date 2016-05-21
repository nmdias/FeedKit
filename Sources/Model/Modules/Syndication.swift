//
//  Syndication.swift
//
//  Copyright (c) 2016 Nuno Manuel Dias
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

protocol SyndicationProtocol {
    
    var syUpdatePeriod:       SyndicationUpdatePeriod? { get set }
    var syUpdateFrequency:    UInt? { get set }
    var syUpdateBase:         String? { get set }
    
}

enum SyndicationElement: String {
    
    case UpdatePeriod         = "sy:updatePeriod"
    case UpdateFrequency      = "sy:updateFrequency"
    case UpdateBase           = "sy:updateBase"
    
}

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

extension SyndicationUpdatePeriod {
    
    /**
        Lowercase the incoming `rawValue` string to try and match the `SyndicationUpdatePeriod`'s `rawValue`
    */
    public init?(rawValue: String) {
        
        switch rawValue.lowercaseString {
            
        case "hourly":      self = .Hourly
        case "daily":       self = .Daily
        case "weekly":      self = .Weekly
        case "monthly":     self = .Monthly
        case "yearly":      self = .Yearly
            
        default: return nil
            
        }
        
    }
    
}