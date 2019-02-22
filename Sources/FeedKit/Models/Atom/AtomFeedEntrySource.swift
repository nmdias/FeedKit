//
//  AtomFeedEntrySource.swift
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

/// If an atom:entry is copied from one feed into another feed, then the
/// source atom:feed's metadata (all child elements of atom:feed other
/// than the atom:entry elements) MAY be preserved within the copied
/// entry by adding an atom:source child element, if it is not already
/// present in the entry, and including some or all of the source feed's
/// Metadata elements as the atom:source element's children.  Such
/// metadata SHOULD be preserved if the source atom:feed contains any of
/// the child elements atom:author, atom:contributor, atom:rights, or
/// atom:category and those child elements are not present in the source
/// atom:entry.
/// 
/// The atom:source element is designed to allow the aggregation of
/// entries from different feeds while retaining information about an 
/// entry's source feed. For this reason, Atom Processors that are
/// performing such aggregation SHOULD include at least the required
/// feed-level Metadata elements (atom:id, atom:title, and atom:updated) 
/// in the atom:source element.
public class AtomFeedEntrySource {
    
    /// The "atom:id" element conveys a permanent, universally unique
    /// identifier for an entry or feed.
    public var id: String?

    /// The "atom:title" element is a Text construct that conveys a human-
    /// readable title for an entry or feed.
    public var title: String?
    
    /// The "atom:updated" element is a Date construct indicating the most
    /// recent instant in time when an entry or feed was modified in a way
    /// the publisher considers significant.  Therefore, not all
    /// modifications necessarily result in a changed atom:updated value.
    public var updated: Date?
    
    public init() { }
    
}

// MARK: - Equatable

extension AtomFeedEntrySource: Equatable {
    
    public static func ==(lhs: AtomFeedEntrySource, rhs: AtomFeedEntrySource) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.updated == rhs.updated
    }
    
}
