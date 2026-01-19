//
// DublinCore.swift
//
// Copyright (c) 2016 - 2026 Nuno Dias
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
import XMLKit

/// The Dublin Core Metadata Element Set is a standard for cross-domain
/// resource description.
///
/// See https://tools.ietf.org/html/rfc5013
public struct DublinCore {
  // MARK: Lifecycle

  public init(
    title: String? = nil,
    creator: String? = nil,
    subject: String? = nil,
    description: String? = nil,
    publisher: String? = nil,
    contributor: String? = nil,
    date: Date? = nil,
    type: String? = nil,
    format: String? = nil,
    identifier: String? = nil,
    source: String? = nil,
    language: String? = nil,
    relation: String? = nil,
    coverage: String? = nil,
    rights: String? = nil
  ) {
    self.title = title
    self.creator = creator
    self.subject = subject
    self.description = description
    self.publisher = publisher
    self.contributor = contributor
    self.date = date
    self.type = type
    self.format = format
    self.identifier = identifier
    self.source = source
    self.language = language
    self.relation = relation
    self.coverage = coverage
    self.rights = rights
  }

  // MARK: Public

  /// A name given to the resource.
  public var title: String?

  /// An entity primarily responsible for making the content of the resource
  ///
  /// Examples of a Creator include a person, an organization, or a service.
  /// Typically, the name of a Creator should be used to indicate the entity.
  public var creator: String?

  /// The topic of the content of the resource
  ///
  /// Typically, the subject will be represented using keywords, key phrases,
  /// or classification codes. Recommended best practice is to use a controlled
  /// vocabulary.  To describe the spatial or temporal topic of the resource,
  /// use the Coverage element.
  public var subject: String?

  /// An account of the content of the resource
  ///
  /// Description may include but is not limited to: an abstract, a table of
  /// contents, a graphical representation, or a free-text account of the
  /// resource.
  public var description: String?

  /// An entity responsible for making the resource available
  ///
  /// Examples of a Publisher include a person, an organization, or a service.
  /// Typically, the name of a Publisher should be used to indicate the entity.
  public var publisher: String?

  /// An entity responsible for making contributions to the content of the
  /// resource
  ///
  /// Examples of a Contributor include a person, an organization, or a service.
  /// Typically, the name of a Contributor should be used to indicate the entity.
  public var contributor: String?

  /// A point or period of time associated with an event in the lifecycle of the
  /// resource.
  ///
  /// Date may be used to express temporal information at any level of
  /// granularity. Recommended best practice is to use an encoding scheme, such
  /// as the W3CDTF profile of ISO 8601 [W3CDTF].
  public var date: Date?

  /// The nature or genre of the content of the resource
  ///
  /// Recommended best practice is to use a controlled vocabulary such as the
  /// DCMI Type Vocabulary [DCTYPE].  To describe the file format, physical
  /// medium, or dimensions of the resource, use the Format element.
  public var type: String?

  /// The file format, physical medium, or dimensions of the resource.
  ///
  /// Examples of dimensions include size and duration. Recommended best
  /// practice is to use a controlled vocabulary such as the list of Internet
  /// Media Types [MIME].
  public var format: String?

  /// An unambiguous reference to the resource within a given context.
  ///
  /// Recommended best practice is to identify the resource by means of a string
  /// conforming to a formal identification system.
  public var identifier: String?

  /// A Reference to a resource from which the present resource is derived
  ///
  /// The described resource may be derived from the related resource in whole
  /// or in part. Recommended best practice is to identify the related resource
  /// by means of a string conforming to a formal identification system.
  public var source: String?

  /// A language of the resource.
  ///
  /// Recommended best practice is to use a controlled vocabulary such as
  /// RFC 4646 [RFC4646].
  public var language: String?

  /// A related resource.
  ///
  /// Recommended best practice is to identify the related resource by means of
  /// a string conforming to a formal identification system.
  public var relation: String?

  /// The spatial or temporal topic of the resource, the spatial applicability
  /// of the resource, or the jurisdiction under which the resource is
  /// relevant.
  ///
  /// Spatial topic and spatial applicability may be a named place or a location
  /// specified by its geographic coordinates.  Temporal topic may be a named
  /// period, date, or date range.  A jurisdiction may be a named administrative
  /// entity or a geographic place to which the resource applies.  Recommended
  /// best practice is to use a controlled vocabulary such as the Thesaurus of
  /// Geographic Names [TGN].  Where appropriate, named places or time periods
  /// can be used in preference to numeric identifiers such as sets of
  /// coordinates or date ranges.
  public var coverage: String?

  /// Information about rights held in and over the resource.
  ///
  /// Typically, rights information includes a statement about various property
  /// rights associated with the resource, including intellectual property
  /// rights.
  public var rights: String?
}

// MARK: - XMLNamespaceDecodable

extension DublinCore: XMLNamespaceCodable {}

// MARK: - Sendable

extension DublinCore: Sendable {}

// MARK: - Equatable

extension DublinCore: Equatable {}

// MARK: - Hashable

extension DublinCore: Hashable {}

// MARK: - Codable

extension DublinCore: Codable {
  private enum CodingKeys: String, CodingKey {
    case title = "dc:title"
    case creator = "dc:creator"
    case subject = "dc:subject"
    case description = "dc:description"
    case publisher = "dc:publisher"
    case contributor = "dc:contributor"
    case date = "dc:date"
    case type = "dc:type"
    case format = "dc:format"
    case identifier = "dc:identifier"
    case source = "dc:source"
    case language = "dc:language"
    case relation = "dc:relation"
    case coverage = "dc:coverage"
    case rights = "dc:rights"
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

    title = try container.decodeIfPresent(String.self, forKey: CodingKeys.title)
    creator = try container.decodeIfPresent(String.self, forKey: CodingKeys.creator)
    subject = try container.decodeIfPresent(String.self, forKey: CodingKeys.subject)
    description = try container.decodeIfPresent(String.self, forKey: CodingKeys.description)
    publisher = try container.decodeIfPresent(String.self, forKey: CodingKeys.publisher)
    contributor = try container.decodeIfPresent(String.self, forKey: CodingKeys.contributor)
    date = try container.decodeIfPresent(Date.self, forKey: CodingKeys.date)
    type = try container.decodeIfPresent(String.self, forKey: CodingKeys.type)
    format = try container.decodeIfPresent(String.self, forKey: CodingKeys.format)
    identifier = try container.decodeIfPresent(String.self, forKey: CodingKeys.identifier)
    source = try container.decodeIfPresent(String.self, forKey: CodingKeys.source)
    language = try container.decodeIfPresent(String.self, forKey: CodingKeys.language)
    relation = try container.decodeIfPresent(String.self, forKey: CodingKeys.relation)
    coverage = try container.decodeIfPresent(String.self, forKey: CodingKeys.coverage)
    rights = try container.decodeIfPresent(String.self, forKey: CodingKeys.rights)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)

    try container.encodeIfPresent(title, forKey: CodingKeys.title)
    try container.encodeIfPresent(creator, forKey: CodingKeys.creator)
    try container.encodeIfPresent(subject, forKey: CodingKeys.subject)
    try container.encodeIfPresent(description, forKey: CodingKeys.description)
    try container.encodeIfPresent(publisher, forKey: CodingKeys.publisher)
    try container.encodeIfPresent(contributor, forKey: CodingKeys.contributor)
    try container.encodeIfPresent(date, forKey: CodingKeys.date)
    try container.encodeIfPresent(type, forKey: CodingKeys.type)
    try container.encodeIfPresent(format, forKey: CodingKeys.format)
    try container.encodeIfPresent(identifier, forKey: CodingKeys.identifier)
    try container.encodeIfPresent(source, forKey: CodingKeys.source)
    try container.encodeIfPresent(language, forKey: CodingKeys.language)
    try container.encodeIfPresent(relation, forKey: CodingKeys.relation)
    try container.encodeIfPresent(coverage, forKey: CodingKeys.coverage)
    try container.encodeIfPresent(rights, forKey: CodingKeys.rights)
  }
}
