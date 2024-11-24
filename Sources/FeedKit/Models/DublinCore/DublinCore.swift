//
//  DublinCore.swift
//
//  Copyright (c) 2016 - 2024 Nuno Dias
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

/// The Dublin Core Metadata Element Set is a standard for cross-domain
/// resource description.
///
/// See https://tools.ietf.org/html/rfc5013
public struct DublinCore {
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
    rights: String? = nil) {
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
}

// MARK: - Equatable

extension DublinCore: Equatable {}

// MARK: - Codable

extension DublinCore: Codable {
  private enum CodingKeys: CodingKey {
    case title
    case creator
    case subject
    case description
    case publisher
    case contributor
    case date
    case type
    case format
    case identifier
    case source
    case language
    case relation
    case coverage
    case rights
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<DublinCore.CodingKeys> = try decoder.container(keyedBy: DublinCore.CodingKeys.self)

    title = try container.decodeIfPresent(String.self, forKey: DublinCore.CodingKeys.title)
    creator = try container.decodeIfPresent(String.self, forKey: DublinCore.CodingKeys.creator)
    subject = try container.decodeIfPresent(String.self, forKey: DublinCore.CodingKeys.subject)
    description = try container.decodeIfPresent(String.self, forKey: DublinCore.CodingKeys.description)
    publisher = try container.decodeIfPresent(String.self, forKey: DublinCore.CodingKeys.publisher)
    contributor = try container.decodeIfPresent(String.self, forKey: DublinCore.CodingKeys.contributor)
    date = try container.decodeIfPresent(Date.self, forKey: DublinCore.CodingKeys.date)
    type = try container.decodeIfPresent(String.self, forKey: DublinCore.CodingKeys.type)
    format = try container.decodeIfPresent(String.self, forKey: DublinCore.CodingKeys.format)
    identifier = try container.decodeIfPresent(String.self, forKey: DublinCore.CodingKeys.identifier)
    source = try container.decodeIfPresent(String.self, forKey: DublinCore.CodingKeys.source)
    language = try container.decodeIfPresent(String.self, forKey: DublinCore.CodingKeys.language)
    relation = try container.decodeIfPresent(String.self, forKey: DublinCore.CodingKeys.relation)
    coverage = try container.decodeIfPresent(String.self, forKey: DublinCore.CodingKeys.coverage)
    rights = try container.decodeIfPresent(String.self, forKey: DublinCore.CodingKeys.rights)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<DublinCore.CodingKeys> = encoder.container(keyedBy: DublinCore.CodingKeys.self)

    try container.encodeIfPresent(title, forKey: DublinCore.CodingKeys.title)
    try container.encodeIfPresent(creator, forKey: DublinCore.CodingKeys.creator)
    try container.encodeIfPresent(subject, forKey: DublinCore.CodingKeys.subject)
    try container.encodeIfPresent(description, forKey: DublinCore.CodingKeys.description)
    try container.encodeIfPresent(publisher, forKey: DublinCore.CodingKeys.publisher)
    try container.encodeIfPresent(contributor, forKey: DublinCore.CodingKeys.contributor)
    try container.encodeIfPresent(date, forKey: DublinCore.CodingKeys.date)
    try container.encodeIfPresent(type, forKey: DublinCore.CodingKeys.type)
    try container.encodeIfPresent(format, forKey: DublinCore.CodingKeys.format)
    try container.encodeIfPresent(identifier, forKey: DublinCore.CodingKeys.identifier)
    try container.encodeIfPresent(source, forKey: DublinCore.CodingKeys.source)
    try container.encodeIfPresent(language, forKey: DublinCore.CodingKeys.language)
    try container.encodeIfPresent(relation, forKey: DublinCore.CodingKeys.relation)
    try container.encodeIfPresent(coverage, forKey: DublinCore.CodingKeys.coverage)
    try container.encodeIfPresent(rights, forKey: DublinCore.CodingKeys.rights)
  }
}
