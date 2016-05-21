//
//  Content.swift
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
 
    The Content namespace offers a means of defining item content with more precision
    than the description element.
 
    See: http://www.rssboard.org/rss-profile#namespace-elements-content
 
*/
protocol ContentProtocol {
    
    /// The content:encoded element defines the full content of an item (OPTIONAL). This element has a more precise purpose than the description element, which can be the full content, a summary or some other form of excerpt at the publisher's discretion. The content MUST be suitable for presentation as HTML and be encoded as character data in the same manner as the description element.
    var contentEncoded: String? { get set }
    
}

// http://web.resource.org/rss/1.0/modules/content/

public enum ContentElement: String {
    
    public static let namespace = [ "xmlns:content" : "http://purl.org/rss/1.0/modules/content/" ]
    
    case RSSChannelItemContent = "/rss/channel/item/content:encoded"
    
}