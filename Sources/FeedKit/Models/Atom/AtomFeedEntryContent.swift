//
//  AtomFeedEntryContent.swift
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

/// The "atom:content" element either contains or links to the content of
/// the entry.  The content of atom:content is Language-Sensitive.
public class AtomFeedEntryContent {
    
    /// The element's attributes.
    public class Attributes {
        
        /// On the atom:content element, the value of the "type" attribute MAY be
        /// one of "text", "html", or "xhtml".  Failing that, it MUST conform to
        /// the syntax of a MIME media type, but MUST NOT be a composite type
        /// (see Section 4.2.6 of [MIMEREG]).  If neither the type attribute nor
        /// the src attribute is provided, Atom Processors MUST behave as though
        /// the type attribute were present with a value of "text".
        public var type: String?
        
        /// The atom:content MAY have a "src" attribute, whose value MUST be an IRI
        /// reference [RFC3987].  If the "src" attribute is present, atom:content
        /// MUST be empty.  Atom Processors MAY use the IRI to retrieve the
        /// content and MAY choose to ignore remote content or to present it in a
        /// different manner than local content.
        /// 
        /// If the "src" attribute is present, the "type" attribute SHOULD be
        /// provided and MUST be a MIME media type [MIMEREG], rather than "text",
        /// "html", or "xhtml".  The value is advisory; that is to say, when the
        /// corresponding URI (mapped from an IRI, if necessary) is dereferenced,
        /// if the server providing that content also provides a media type, the
        /// server-provided media type is authoritative.
        public var src: String?
        
    }
    
    /// The element's attributes.
    public var attributes: Attributes?
    
    /// The element's value.
    public var value: String?
    
    public init() { }
    
}

// MARK: - Initializers

extension AtomFeedEntryContent {
    
    convenience init(attributes attributeDict: [String : String]) {
        self.init()
        self.attributes = AtomFeedEntryContent.Attributes(attributes: attributeDict)
    }
    
}

extension AtomFeedEntryContent.Attributes {
    
    convenience init?(attributes attributeDict: [String : String]) {
        
        if attributeDict.isEmpty {
            return nil
        }
        
        self.init()
        
        self.type   = attributeDict["type"]
        self.src    = attributeDict["src"]
        
    }
    
}

// MARK: - Equatable

extension AtomFeedEntryContent: Equatable {
    
    public static func ==(lhs: AtomFeedEntryContent, rhs: AtomFeedEntryContent) -> Bool {
        return
            lhs.value == rhs.value &&
            lhs.attributes == rhs.attributes
    }
    
}

extension AtomFeedEntryContent.Attributes: Equatable {
    
    public static func ==(lhs: AtomFeedEntryContent.Attributes, rhs: AtomFeedEntryContent.Attributes) -> Bool {
        return
            lhs.type == rhs.type &&
            lhs.src == rhs.src
    }
    
}
