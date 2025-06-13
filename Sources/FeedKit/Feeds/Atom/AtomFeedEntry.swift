//
// AtomFeedEntry.swift
//
// Copyright (c) 2016 - 2025 Nuno Dias
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

/// The "atom:entry" element represents an individual entry, acting as a
/// container for metadata and data associated with the entry.  This
/// element can appear as a child of the atom:feed element, or it can
/// appear as the document (i.e., top-level) element of a stand-alone
/// Atom Entry Document.
public struct AtomFeedEntry {
  // MARK: Lifecycle

  public init(
    title: String? = nil,
    summary: AtomFeedSummary? = nil,
    authors: [AtomFeedAuthor]? = nil,
    contributors: [AtomFeedContributor]? = nil,
    links: [AtomFeedLink]? = nil,
    updated: Date? = nil,
    categories: [AtomFeedCategory]? = nil,
    id: String? = nil,
    content: AtomFeedContent? = nil,
    published: Date? = nil,
    source: AtomFeedSource? = nil,
    rights: String? = nil,
    media: Media? = nil,
    youTube: YouTube? = nil,
    dublinCore: DublinCore? = nil
  ) {
    self.title = title
    self.summary = summary
    self.authors = authors
    self.contributors = contributors
    self.links = links
    self.updated = updated
    self.categories = categories
    self.id = id
    self.content = content
    self.published = published
    self.source = source
    self.rights = rights
    self.media = media
    self.youTube = youTube
    self.dublinCore = dublinCore
  }

  // MARK: Public

  /// The "atom:title" element is a Text construct that conveys a human-
  /// readable title for an entry or feed.
  public var title: String?

  /// The "atom:summary" element is a Text construct that conveys a short
  /// summary, abstract, or excerpt of an entry.
  ///
  /// atomSummary = element atom:summary { atomTextConstruct }
  ///
  /// It is not advisable for the atom:summary element to duplicate
  /// atom:title or atom:content because Atom Processors might assume there
  /// is a useful summary when there is none.
  public var summary: AtomFeedSummary?

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

  /// The "atom:link" element defines a reference from an entry or feed to
  /// a Web resource.  This specification assigns no meaning to the content
  /// (if any) of this element.
  public var links: [AtomFeedLink]?

  /// The "atom:updated" element is a Date construct indicating the most
  /// recent instant in time when an entry or feed was modified in a way
  /// the publisher considers significant.  Therefore, not all
  /// modifications necessarily result in a changed atom:updated value.
  ///
  /// Publishers MAY change the value of this element over time.
  public var updated: Date?

  /// The "atom:category" element conveys information about a category
  /// associated with an entry or feed.  This specification assigns no
  /// meaning to the content (if any) of this element.
  public var categories: [AtomFeedCategory]?

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

  /// The "atom:content" element either contains or links to the content of
  /// the entry.  The content of atom:content is Language-Sensitive.
  public var content: AtomFeedContent?

  /// The "atom:published" element is a Date construct indicating an
  /// instant in time associated with an event early in the life cycle of
  /// the entry.
  ///
  /// Typically, atom:published will be associated with the initial
  /// creation or first availability of the resource.
  public var published: Date?

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
  public var source: AtomFeedSource?

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

  /// Media RSS is a new RSS module that supplements the <enclosure>
  /// capabilities of RSS 2.0.
  public var media: Media?

  /// YouTube metadata contains channel ID and video ID for YouTube content.
  ///
  /// See https://developers.google.com/youtube/v3/guides/push_notifications
  public var youTube: YouTube?

  /// The Dublin Core Metadata Element Set is a standard for cross-domain
  /// resource description.
  ///
  /// See https://tools.ietf.org/html/rfc5013
  public var dublinCore: DublinCore?
}

// MARK: - Sendable

extension AtomFeedEntry: Sendable {}

// MARK: - Equatable

extension AtomFeedEntry: Equatable {}

// MARK: - Hashable

extension AtomFeedEntry: Hashable {}

// MARK: - Codable

extension AtomFeedEntry: Codable {
  private enum CodingKeys: String, CodingKey {
    case title
    case summary
    case author
    case contributor
    case link
    case updated
    case category
    case id
    case content
    case published
    case source
    case rights
    case media
    case youTube = "yt"
    case dublinCore = "dc"
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

    title = try container.decodeIfPresent(String.self, forKey: CodingKeys.title)
    summary = try container.decodeIfPresent(AtomFeedSummary.self, forKey: CodingKeys.summary)
    authors = try container.decodeIfPresent([AtomFeedAuthor].self, forKey: CodingKeys.author)
    contributors = try container.decodeIfPresent([AtomFeedContributor].self, forKey: CodingKeys.contributor)
    links = try container.decodeIfPresent([AtomFeedLink].self, forKey: CodingKeys.link)
    updated = try container.decodeIfPresent(Date.self, forKey: CodingKeys.updated)
    categories = try container.decodeIfPresent([AtomFeedCategory].self, forKey: CodingKeys.category)
    id = try container.decodeIfPresent(String.self, forKey: CodingKeys.id)
    content = try container.decodeIfPresent(AtomFeedContent.self, forKey: CodingKeys.content)
    published = try container.decodeIfPresent(Date.self, forKey: CodingKeys.published)
    source = try container.decodeIfPresent(AtomFeedSource.self, forKey: CodingKeys.source)
    rights = try container.decodeIfPresent(String.self, forKey: CodingKeys.rights)
    media = try container.decodeIfPresent(Media.self, forKey: .media)
    youTube = try container.decodeIfPresent(YouTube.self, forKey: .youTube)
    dublinCore = try container.decodeIfPresent(DublinCore.self, forKey: CodingKeys.dublinCore)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)

    try container.encodeIfPresent(title, forKey: CodingKeys.title)
    try container.encodeIfPresent(summary, forKey: CodingKeys.summary)
    try container.encodeIfPresent(authors, forKey: CodingKeys.author)
    try container.encodeIfPresent(contributors, forKey: CodingKeys.contributor)
    try container.encodeIfPresent(links, forKey: CodingKeys.link)
    try container.encodeIfPresent(updated, forKey: CodingKeys.updated)
    try container.encodeIfPresent(categories, forKey: CodingKeys.category)
    try container.encodeIfPresent(id, forKey: CodingKeys.id)
    try container.encodeIfPresent(content, forKey: CodingKeys.content)
    try container.encodeIfPresent(published, forKey: CodingKeys.published)
    try container.encodeIfPresent(source, forKey: CodingKeys.source)
    try container.encodeIfPresent(rights, forKey: CodingKeys.rights)
    try container.encodeIfPresent(media, forKey: CodingKeys.media)
    try container.encodeIfPresent(youTube, forKey: CodingKeys.youTube)
    try container.encodeIfPresent(dublinCore, forKey: CodingKeys.dublinCore)
  }
}
