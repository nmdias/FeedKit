//
//  RSS2FeedChannelItemGUID.swift
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
    Uniquely identifies the `<item>`. When present, an aggregator may choose to use this string to determine if an item is new.
*/
public class RSS2FeedChannelItemGUID {
    
    /**
        The attributes of the `<item>`'s `<guid>` element
    */
    public class Attributes {
        
        /// isPermaLink is an optional attribute. The default value is true. If the value is false, the guid may not be assumed to be a url, or a url to anything in particular.
        public var isPermaLink: Bool?
        
    }
    
    // The element's attributes
    public var attributes: Attributes?
    
    /// The actual `<guid>` value.
    public var value: String?
    
    public init() {}
    
}
