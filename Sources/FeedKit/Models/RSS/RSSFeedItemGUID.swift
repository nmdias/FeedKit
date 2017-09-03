//
//  RSSFeedItemGUID.swift
//
//  Copyright (c) 2017 Nuno Manuel Dias
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

/// A string that uniquely identifies the item.
/// 
/// Example: http://inessential.com/2002/09/01.php#a2
/// 
/// <guid> is an optional sub-element of <item>.
/// 
/// guid stands for globally unique identifier. It's a string that uniquely
/// identifies the item. When present, an aggregator may choose to use this
/// string to determine if an item is new.
/// 
/// <guid>http://some.server.com/weblogItem3207</guid>
/// 
/// There are no rules for the syntax of a guid. Aggregators must view them
/// as a string. It's up to the source of the feed to establish the
/// uniqueness of the string.
/// 
/// If the guid element has an attribute named "isPermaLink" with a value of
/// true, the reader may assume that it is a permalink to the item, that is,
/// a url that can be opened in a Web browser, that points to the full item
/// described by the <item> element. An example:
/// 
/// <guid isPermaLink="true">http://inessential.com/2002/09/01.php#a2</guid>
/// 
/// isPermaLink is optional, its default value is true. If its value is false,
/// the guid may not be assumed to be a url, or a url to anything in
/// particular.
public class RSSFeedItemGUID {
    
    /// The element's attributes.
    public class Attributes {
        
        /// If the guid element has an attribute named "isPermaLink" with a value of
        /// true, the reader may assume that it is a permalink to the item, that is,
        /// a url that can be opened in a Web browser, that points to the full item
        /// described by the <item> element. An example:
        /// 
        /// <guid isPermaLink="true">http://inessential.com/2002/09/01.php#a2</guid>
        /// 
        /// isPermaLink is optional, its default value is true. If its value is false,
        /// the guid may not be assumed to be a url, or a url to anything in
        /// particular.
        public var isPermaLink: Bool?
        
    }
    
    /// The element's attributes.
    public var attributes: Attributes?
    
    /// The element's value.
    public var value: String?
    
}

// MARK: - Initializers

extension RSSFeedItemGUID {
    
    convenience init(attributes attributeDict: [String : String]) {
        self.init()
        self.attributes = RSSFeedItemGUID.Attributes(attributes: attributeDict)
    }
    
}

extension RSSFeedItemGUID.Attributes {
    
    convenience init?(attributes attributeDict: [String : String]) {
        
        if attributeDict.isEmpty {
            return nil
        }
        
        self.init()
        
        self.isPermaLink = attributeDict["isPermaLink"]?.toBool()
        
    }
    
}

// MARK: - Equatable

extension RSSFeedItemGUID: Equatable {
    
    public static func ==(lhs: RSSFeedItemGUID, rhs: RSSFeedItemGUID) -> Bool {
        return
            lhs.value == rhs.value &&
            lhs.attributes == rhs.attributes
    }
    
}

extension RSSFeedItemGUID.Attributes: Equatable {
    
    public static func ==(lhs: RSSFeedItemGUID.Attributes, rhs: RSSFeedItemGUID.Attributes) -> Bool {
        return lhs.isPermaLink == rhs.isPermaLink
    }
    
}
