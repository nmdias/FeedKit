//
//  AtomFeedSubtitle.swift
//
//  Copyright (c) 2016 - 2018 Nuno Manuel Dias
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

/// The "atom:subtitle" element is a Text construct that conveys a human-
/// readable description or subtitle for a feed.
public class AtomFeedSubtitle {
    
    /// The element's attributes.
    public class Attributes {
        
        /// Text constructs MAY have a "type" attribute.  When present, the value
        /// MUST be one of "text", "html", or "xhtml".  If the "type" attribute
        /// is not provided, Atom Processors MUST behave as though it were
        /// present with a value of "text".
        public var type: String?
        
    }
    
    /// The element's attributes.
    public var attributes: Attributes?
    
    /// The element's value.
    public var value: String?
    
    public init() { }
    
}

// MARK: - Initializers

extension AtomFeedSubtitle {
    
    convenience init(attributes attributeDict: [String : String]) {
        self.init()
        self.attributes = AtomFeedSubtitle.Attributes(attributes: attributeDict)
    }
    
}

extension AtomFeedSubtitle.Attributes {
    
    convenience init?(attributes attributeDict: [String : String]) {
        
        if attributeDict.isEmpty {
            return nil
        }
        
        self.init()
        
        self.type = attributeDict["type"]
        
    }
    
}

// MARK: - Equatable

extension AtomFeedSubtitle: Equatable {
    
    public static func ==(lhs: AtomFeedSubtitle, rhs: AtomFeedSubtitle) -> Bool {
        return
            lhs.attributes == rhs.attributes &&
            lhs.value == rhs.value
    }
    
}

extension AtomFeedSubtitle.Attributes: Equatable {
    
    public static func ==(lhs: AtomFeedSubtitle.Attributes, rhs: AtomFeedSubtitle.Attributes) -> Bool {
        return lhs.type == rhs.type
    }
    
}
