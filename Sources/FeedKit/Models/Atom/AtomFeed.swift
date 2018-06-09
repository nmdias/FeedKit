//
//  AtomFeed.swift
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

/// Data model for the XML DOM of the Atom Specification
/// See https://tools.ietf.org/html/rfc4287
/// 
/// The "atom:feed" element is the document (i.e., top-level) element of
/// an Atom Feed Document, acting as a container for metadata and data
/// associated with the feed.  Its element children consist of metadata
/// elements followed by zero or more atom:entry child elements.
open class AtomFeed {
    
    /// The "atom:title" element is a Text construct that conveys a human-
    /// readable title for an entry or feed.
    public var title: String?
    
    /// The "atom:subtitle" element is a Text construct that conveys a human-
    /// readable description or subtitle for a feed.
    public var subtitle: AtomFeedSubtitle?
    
    /// The "atom:link" element defines a reference from an entry or feed to
    /// a Web resource.  This specification assigns no meaning to the content
    /// (if any) of this element.
    public var links: [AtomFeedLink]?

    /// The "atom:updated" element is a Date construct indicating the most
    /// recent instant in time when an entry or feed was modified in a way
    /// the publisher considers significant.  Therefore, not all
    /// modifications necessarily result in a changed atom:updated value.
    public var updated: Date?
    
    /// The "atom:category" element conveys information about a category
    /// associated with an entry or feed.  This specification assigns no
    /// meaning to the content (if any) of this element.
    public var categories: [AtomFeedCategory]?
    
    /// The "atom:author" element is a Person construct that indicates the
    /// author of the entry or feed.
    /// 
    /// If an atom:entry element does not contain atom:author elements, then
    /// the atom:author elements of the contained atom:source element are
    /// considered to apply.  In an Atom Feed Document, the atom:author
    /// elements of the containing atom:feed element are considered to apply
    /// to the entry if there are no atom:author elements in the locations
    /// described above.
    public var authors: [AtomFeedAuthor]?
    
    /// The "atom:contributor" element is a Person construct that indicates a
    /// person or other entity who contributed to the entry or feed.
    public var contributors: [AtomFeedContributor]?
    
    /// The "atom:id" element conveys a permanent, universally unique
    /// identifier for an entry or feed.
    /// 
    /// Its content MUST be an IRI, as defined by [RFC3987].  Note that the
    /// definition of "IRI" excludes relative references.  Though the IRI
    /// might use a dereferencable scheme, Atom Processors MUST NOT assume it
    /// can be dereferenced.
    /// 
    /// When an Atom Document is relocated, migrated, syndicated,
    /// republished, exported, or imported, the content of its atom:id
    /// element MUST NOT change.  Put another way, an atom:id element
    /// pertains to all instantiations of a particular Atom entry or feed;
    /// revisions retain the same content in their atom:id elements.  It is
    /// suggested that the atom:id element be stored along with the
    /// associated resource.
    /// 
    /// The content of an atom:id element MUST be created in a way that
    /// assures uniqueness.
    /// 
    /// Because of the risk of confusion between IRIs that would be
    /// equivalent if they were mapped to URIs and dereferenced, the
    /// following normalization strategy SHOULD be applied when generating
    /// atom:id elements:
    /// 
    /// -  Provide the scheme in lowercase characters.
    /// -  Provide the host, if any, in lowercase characters.
    /// -  Only perform percent-encoding where it is essential.
    /// -  Use uppercase A through F characters when percent-encoding.
    /// -  Prevent dot-segments from appearing in paths.
    /// -  For schemes that define a default authority, use an empty
    /// authority if the default is desired.
    /// -  For schemes that define an empty path to be equivalent to a path
    /// of "/", use "/".
    /// -  For schemes that define a port, use an empty port if the default
    /// is desired.
    /// -  Preserve empty fragment identifiers and queries.
    /// -  Ensure that all components of the IRI are appropriately character
    /// normalized, e.g., by using NFC or NFKC.
    public var id: String?
    
    /// The "atom:generator" element's content identifies the agent used to
    /// generate a feed, for debugging and other purposes.
    /// 
    /// The content of this element, when present, MUST be a string that is a
    /// human-readable name for the generating agent.  Entities such as
    /// "&amp;" and "&lt;" represent their corresponding characters ("&" and
    /// "<" respectively), not markup.
    /// 
    /// The atom:generator element MAY have a "uri" attribute whose value
    /// MUST be an IRI reference [RFC3987].  When dereferenced, the resulting
    /// URI (mapped from an IRI, if necessary) SHOULD produce a
    /// representation that is relevant to that agent.
    /// 
    /// The atom:generator element MAY have a "version" attribute that
    /// indicates the version of the generating agent.
    public var generator: AtomFeedGenerator?
    
    /// The "atom:icon" element's content is an IRI reference [RFC3987] that
    /// identifies an image that provides iconic visual identification for a
    /// feed.
    ///
    /// The image SHOULD have an aspect ratio of one (horizontal) to one
    /// (vertical) and SHOULD be suitable for presentation at a small size.
    public var icon: String?
    
    /// The "atom:logo" element's content is an IRI reference [RFC3987] that
    /// identifies an image that provides visual identification for a feed.
    /// 
    /// The image SHOULD have an aspect ratio of 2 (horizontal) to 1
    /// (vertical).
    public var logo: String?
    
    /// The "atom:rights" element is a Text construct that conveys
    /// information about rights held in and over an entry or feed.
    /// 
    /// The atom:rights element SHOULD NOT be used to convey machine-readable
    /// licensing information.
    /// 
    /// If an atom:entry element does not contain an atom:rights element,
    /// then the atom:rights element of the containing atom:feed element, if
    /// present, is considered to apply to the entry.
    public var rights: String?
    
    /// The "atom:entry" element represents an individual entry, acting as a
    /// container for metadata and data associated with the entry.  This
    /// element can appear as a child of the atom:feed element, or it can
    /// appear as the document (i.e., top-level) element of a stand-alone
    /// Atom Entry Document.
    public var entries: [AtomFeedEntry]?
    
}

// MARK: - Equatable

extension AtomFeed: Equatable {
    
    public static func ==(lhs: AtomFeed, rhs: AtomFeed) -> Bool {
        return
            lhs.title == rhs.title &&
            lhs.subtitle == rhs.subtitle &&
            lhs.links == rhs.links &&
            lhs.updated == rhs.updated &&
            lhs.categories == rhs.categories &&
            lhs.authors == rhs.authors &&
            lhs.contributors == rhs.contributors &&
            lhs.id == rhs.id &&
            lhs.generator == rhs.generator &&
            lhs.icon == rhs.icon &&
            lhs.logo == rhs.logo &&
            lhs.rights == rhs.rights &&
            lhs.entries == rhs.entries
    }
    
}
