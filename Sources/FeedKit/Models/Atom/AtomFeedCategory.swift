//
//  AtomFeedCategory.swift
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

/// The "atom:category" element conveys information about a category
/// associated with an entry or feed.  This specification assigns no
/// meaning to the content (if any) of this element.
public class AtomFeedCategory {
    
    /// The element's attributes.
    public class Attributes {
        
        /// The "term" attribute is a string that identifies the category to
        /// which the entry or feed belongs.  Category elements MUST have a
        /// "term" attribute.
        public var term: String?

        /// The "scheme" attribute is an IRI that identifies a categorization
        /// scheme.  Category elements MAY have a "scheme" attribute.
        public var scheme: String?
        
        /// The "label" attribute provides a human-readable label for display in
        /// end-user applications.  The content of the "label" attribute is
        /// Language-Sensitive.  Entities such as "&amp;" and "&lt;" represent
        /// their corresponding characters ("&" and "<", respectively), not
        /// markup.  Category elements MAY have a "label" attribute.
        public var label: String?
        
    }
    
    /// The element's attributes.
    public var attributes: Attributes?
    
}

// MARK: - Initializers

extension AtomFeedCategory {

    convenience init(attributes attributeDict: [String : String]) {
        self.init()
        self.attributes = AtomFeedCategory.Attributes(attributes: attributeDict)
    }
    
}

extension AtomFeedCategory.Attributes {
    
    convenience init?(attributes attributeDict: [String : String]) {
        
        if attributeDict.isEmpty {
            return nil
        }
        
        self.init()
        
        self.term   = attributeDict["term"]
        self.scheme = attributeDict["scheme"]
        self.label  = attributeDict["label"]
        
    }
    
}

// MARK: - Equatable

extension AtomFeedCategory: Equatable {
    
    public static func ==(lhs: AtomFeedCategory, rhs: AtomFeedCategory) -> Bool {
        return lhs.attributes == rhs.attributes
    }
    
}

extension AtomFeedCategory.Attributes: Equatable {
    
    public static func ==(lhs: AtomFeedCategory.Attributes, rhs: AtomFeedCategory.Attributes) -> Bool {
        return
            lhs.term == rhs.term &&
            lhs.scheme == rhs.scheme &&
            lhs.label == rhs.label
    }
    
}

