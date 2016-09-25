//
//  RSSFeedSkipDay.swift
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

/**
 
 A hint for aggregators telling them which days they can skip.
 
 An XML element that contains up to seven <day> sub-elements whose value
 is Monday, Tuesday, Wednesday, Thursday, Friday, Saturday or Sunday.
 Aggregators may not read the channel during days listed in the skipDays
 element.
 
 */
public enum RSSFeedSkipDay: String {
    
    /**
     
     Aggregator hint to skip parsing on `Monday`
     
     */
    case Monday = "monday"
    
    /**
     
     Aggregator hint to skip parsing on `Tuesday`
     
     */
    case Tuesday = "tuesday"
    
    /**
     
     Aggregator hint to skip parsing on `Wednesday`
     
     */
    case Wednesday = "wednesday"
    
    /**
     
     Aggregator hint to skip parsing on `Thursday`
     
     */
    case Thursday = "thursday"
    
    /**
     
     Aggregator hint to skip parsing on `Friday`
     
     */
    case Friday = "friday"
    
    /**
     
     Aggregator hint to skip parsing on `Saturday`
     
     */
    case Saturday = "saturday"
    
    /**
     
     Aggregator hint to skip parsing on `Sunday`
     
     */
    case Sunday = "sunday"

}

extension RSSFeedSkipDay {
    
    /**
     
     Lowercase the incoming `rawValue` string to try and match the 
     `RSSFeedSkipDay`'s `rawValue`
     
    */
    public init?(rawValue: String) {
        
        switch rawValue.lowercased() {
            
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
