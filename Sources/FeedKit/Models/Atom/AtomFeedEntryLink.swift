//
//  AtomFeedEntryLink.swift
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

/// The "atom:link" element defines a reference from an entry or feed to
/// a Web resource.  This specification assigns no meaning to the content
/// (if any) of this element.
public class AtomFeedEntryLink {
    
    /// The element's attributes
    public class Attributes {
        
        /// The "href" attribute contains the link's IRI. atom:link elements MUST
        /// have an href attribute, whose value MUST be a IRI reference
        /// [RFC3987].
        public var href: String?
        
        /// The atom:link elements MAY have a "rel" attribute that indicates the link
        /// relation type.  If the "rel" attribute is not present, the link
        /// element MUST be interpreted as if the link relation type is
        /// "alternate".
        /// 
        /// The value of "rel" MUST be a string that is non-empty and matches
        /// either the "isegment-nz-nc" or the "IRI" production in [RFC3987].
        /// Note that use of a relative reference other than a simple name is not
        /// allowed.  If a name is given, implementations MUST consider the link
        /// relation type equivalent to the same name registered within the IANA
        /// Registry of Link Relations (Section 7), and thus to the IRI that
        /// would be obtained by appending the value of the rel attribute to the
        /// string "http://www.iana.org/assignments/relation/".  The value of
        /// "rel" describes the meaning of the link, but does not impose any
        /// behavioral requirements on Atom Processors.
        /// 
        /// This document defines five initial values for the Registry of Link
        /// Relations:
        /// 
        /// 1.  The value "alternate" signifies that the IRI in the value of the
        /// href attribute identifies an alternate version of the resource
        /// described by the containing element.
        /// 
        /// 2.  The value "related" signifies that the IRI in the value of the
        /// href attribute identifies a resource related to the resource
        /// described by the containing element.  For example, the feed for a
        /// site that discusses the performance of the search engine at
        /// "http://search.example.com" might contain, as a child of
        /// atom:feed:
        /// 
        /// <link rel="related" href="http://search.example.com/"/>
        /// 
        /// An identical link might appear as a child of any atom:entry whose
        /// content contains a discussion of that same search engine.
        /// 
        /// 3.  The value "self" signifies that the IRI in the value of the href
        /// attribute identifies a resource equivalent to the containing
        /// element.
        /// 
        /// 4.  The value "enclosure" signifies that the IRI in the value of the
        /// href attribute identifies a related resource that is potentially
        /// large in size and might require special handling.  For atom:link
        /// elements with rel="enclosure", the length attribute SHOULD be
        /// provided.
        /// 
        /// 5.  The value "via" signifies that the IRI in the value of the href
        /// attribute identifies a resource that is the source of the
        /// information provided in the containing element.
        public var rel: String?
        
        /// On the link element, the "type" attribute's value is an advisory
        /// media type: it is a hint about the type of the representation that is
        /// expected to be returned when the value of the href attribute is
        /// dereferenced.  Note that the type attribute does not override the
        /// actual media type returned with the representation.  Link elements
        /// MAY have a type attribute, whose value MUST conform to the syntax of
        /// a MIME media type [MIMEREG].
        public var type: String?
        
        /// The "hreflang" attribute's content describes the language of the
        /// resource pointed to by the href attribute.  When used together with
        /// the rel="alternate", it implies a translated version of the entry.
        /// Link elements MAY have an hreflang attribute, whose value MUST be a
        /// language tag [RFC3066].
        public var hreflang: String?
        
        /// The "title" attribute conveys human-readable information about the
        /// link.  The content of the "title" attribute is Language-Sensitive.
        /// Entities such as "&amp;" and "&lt;" represent their corresponding
        /// characters ("&" and "<", respectively), not markup.  Link elements
        /// MAY have a title attribute.
        public var title: String?
        
        /// The "length" attribute indicates an advisory length of the linked
        /// content in octets; it is a hint about the content length of the
        /// representation returned when the IRI in the href attribute is mapped
        /// to a URI and dereferenced.  Note that the length attribute does not
        /// override the actual content length of the representation as reported
        /// by the underlying protocol.  Link elements MAY have a length
        /// attribute.
        public var length: Int64?
        
    }
    
    /// The element's attributes.
    public var attributes: Attributes?
    
}

// MARK: - Initializers

extension AtomFeedEntryLink {
    
    convenience init(attributes attributeDict: [String : String]) {
        self.init()
        self.attributes = AtomFeedEntryLink.Attributes(attributes: attributeDict)
    }
    
}

extension AtomFeedEntryLink.Attributes {
    
    convenience init?(attributes attributeDict: [String : String]) {
        
        if attributeDict.isEmpty {
            return nil
        }
        
        self.init()
        
        self.href       = attributeDict["href"]
        self.hreflang   = attributeDict["hreflang"]
        self.type       = attributeDict["type"]
        self.rel        = attributeDict["rel"]
        self.title      = attributeDict["title"]
        self.length     = Int64(attributeDict["length"] ?? "")
        
    }
    
}

// MARK: - Equatable

extension AtomFeedEntryLink: Equatable {
    
    public static func ==(lhs: AtomFeedEntryLink, rhs: AtomFeedEntryLink) -> Bool {
        return lhs.attributes == rhs.attributes
    }
    
}

extension AtomFeedEntryLink.Attributes: Equatable {
    
    public static func ==(lhs: AtomFeedEntryLink.Attributes, rhs: AtomFeedEntryLink.Attributes) -> Bool {
        return
            lhs.href == rhs.href &&
            lhs.hreflang == rhs.hreflang &&
            lhs.type == rhs.type &&
            lhs.rel == rhs.rel &&
            lhs.title == rhs.title &&
            lhs.length == rhs.length
    }
    
}
