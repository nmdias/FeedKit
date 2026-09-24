//
// PodloveSimpleChapters.swift
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

/// Podlove Simple Chapters tags for chapter marks embedded in a feed.
///
/// Simple Chapters is an XML format that augments an Atom `<entry>` or an RSS
/// `<item>` that references an enclosure with a linear list of chapter marks
/// for the referenced media file. Placing the chapters in the feed lets a
/// client present them before the media file has been downloaded.
///
/// See https://podlove.org/simple-chapters/
public struct PodloveSimpleChapters {
  // MARK: Lifecycle

  public init(chapters: PodloveChapters? = nil) {
    self.chapters = chapters
  }

  // MARK: Public

  /// The chapter list of the item.
  ///
  /// The specification allows only one `<psc:chapters>` element per item, and
  /// asks clients to ignore any additional ones.
  public var chapters: PodloveChapters?
}

// MARK: - XMLNamespaceCodable

extension PodloveSimpleChapters: XMLNamespaceCodable {}

// MARK: - Sendable

extension PodloveSimpleChapters: Sendable {}

// MARK: - Equatable

extension PodloveSimpleChapters: Equatable {}

// MARK: - Hashable

extension PodloveSimpleChapters: Hashable {}

// MARK: - Codable

extension PodloveSimpleChapters: Codable {
  private enum CodingKeys: String, CodingKey {
    case chapters = "psc:chapters"
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

    chapters = try container.decodeIfPresent(PodloveChapters.self, forKey: CodingKeys.chapters)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)

    try container.encodeIfPresent(chapters, forKey: CodingKeys.chapters)
  }
}

// MARK: - Chapters

/// Attributes for the `<psc:chapters>` element.
public struct PodloveChaptersAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(version: String? = nil) {
    self.version = version
  }

  // MARK: Public

  /// The version of the Simple Chapters specification the element conforms to.
  ///
  /// The attribute is optional and defaults to `1.0` when absent.
  ///
  /// Example: 1.2
  public var version: String?
}

/// The list of chapter marks for the media file referenced by an item.
///
/// Example:
/// ```xml
/// <psc:chapters version="1.2">
///   <psc:chapter start="0" title="Welcome" />
///   <psc:chapter start="3:07" title="Introducing Podlove" href="https://podlove.org/" />
/// </psc:chapters>
/// ```
///
/// See https://podlove.org/simple-chapters/
public struct PodloveChapters: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(version: String? = nil, chapters: [PodloveChapter]? = nil) {
    self.version = version
    self.chapters = chapters
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
    let attributes: PodloveChaptersAttributes? = try container.decodeIfPresent(
      PodloveChaptersAttributes.self,
      forKey: CodingKeys.attributes
    )

    version = attributes?.version
    chapters = try container.decodeIfPresent([PodloveChapter].self, forKey: CodingKeys.chapters)
  }

  // MARK: Public

  /// The version of the Simple Chapters specification, as published in the
  /// `version` attribute. Defaults to `1.0` when absent.
  public var version: String?

  /// The chapter marks, in the order they are published in the feed.
  ///
  /// The specification asks authors to publish the marks in the order of their
  /// `start` attribute, but readers must be able to resort them, so the feed
  /// order is preserved as written.
  public var chapters: [PodloveChapter]?

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)

    try container.encodeIfPresent(PodloveChaptersAttributes(version: version), forKey: CodingKeys.attributes)
    try container.encodeIfPresent(chapters, forKey: CodingKeys.chapters)
  }

  // MARK: Private

  private enum CodingKeys: String, CodingKey {
    case attributes = "@attributes"
    case chapters = "psc:chapter"
  }
}

// MARK: - Chapter

/// Attributes for the `<psc:chapter>` element.
public struct PodloveChapterAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(
    start: String? = nil,
    title: String? = nil,
    href: String? = nil,
    image: String? = nil
  ) {
    self.start = start
    self.title = title
    self.href = href
    self.image = image
  }

  // MARK: Public

  /// The point in time the chapter starts at, relative to the beginning of the
  /// media file, in Normal Play Time.
  ///
  /// The attribute is mandatory. The value is kept as published, because Normal
  /// Play Time accepts several forms: `37`, `7:48`, `35:12.250` and `01:35:52`
  /// all denote a point in time, and the fractional part is optional.
  ///
  /// Example: 8:26.250
  public var start: String?

  /// The title of the chapter.
  ///
  /// The attribute is mandatory.
  ///
  /// Example: Introducing Podlove
  public var title: String?

  /// A link to a resource with related information about the chapter.
  ///
  /// The attribute is optional, and should be presented only in the context of
  /// the chapter and its title.
  ///
  /// Example: https://podlove.org/
  public var href: String?

  /// A link to an image to associate with the chapter.
  ///
  /// The attribute is optional.
  ///
  /// Example: https://example.com/chapters/podlove.png
  public var image: String?
}

/// A single chapter mark within the media file referenced by an item.
///
/// Example:
/// ```xml
/// <psc:chapter start="8:26.250" title="Podlove WordPress Plugin" href="https://podlove.org/podlove-podcast-publisher" />
/// ```
///
/// See https://podlove.org/simple-chapters/
public typealias PodloveChapter = XMLAttributesElement<PodloveChapterAttributes>
