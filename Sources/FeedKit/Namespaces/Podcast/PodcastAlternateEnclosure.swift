//
// PodcastAlternateEnclosure.swift
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

// MARK: - Source

/// Attributes for the `<podcast:source>` element.
public struct PodcastSourceAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(uri: String? = nil, contentType: String? = nil) {
    self.uri = uri
    self.contentType = contentType
  }

  // MARK: Public

  /// The uri where the media file resides.
  public var uri: String?

  /// The mime-type of the file, useful when the transport mechanism differs
  /// from the file being delivered, as is the case with torrents.
  public var contentType: String?
}

/// A uri location for a `<podcast:alternateEnclosure>` media file.
///
/// Example:
/// ```xml
/// <podcast:source uri="https://example.com/file-720.mp4" />
/// ```
///
/// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/source.md
public typealias PodcastSource = XMLAttributesElement<PodcastSourceAttributes>

// MARK: - Integrity

/// Attributes for the `<podcast:integrity>` element.
public struct PodcastIntegrityAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(type: String? = nil, value: String? = nil) {
    self.type = type
    self.value = value
  }

  // MARK: Public

  /// The type of integrity, either `sri` or `pgp-signature`.
  public var type: String?

  /// The SRI string, or the base64 encoded PGP signature.
  public var value: String?
}

/// A method of verifying the integrity of the media given either an
/// SRI-compliant integrity string or a base64 encoded PGP signature.
///
/// Example:
/// ```xml
/// <podcast:integrity type="sri" value="sha384-ExVqijgYHm15PqQq..." />
/// ```
///
/// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/integrity.md
public typealias PodcastIntegrity = XMLAttributesElement<PodcastIntegrityAttributes>

// MARK: - Alternate Enclosure

/// Attributes for the `<podcast:alternateEnclosure>` element.
public struct PodcastAlternateEnclosureAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(
    type: String? = nil,
    length: Int64? = nil,
    bitrate: Double? = nil,
    height: Int? = nil,
    lang: String? = nil,
    title: String? = nil,
    rel: String? = nil,
    codecs: String? = nil,
    isDefault: Bool? = nil
  ) {
    self.type = type
    self.length = length
    self.bitrate = bitrate
    self.height = height
    self.lang = lang
    self.title = title
    self.rel = rel
    self.codecs = codecs
    self.isDefault = isDefault
  }

  // MARK: Public

  /// Mime type of the media asset.
  public var type: String?

  /// Length of the file in bytes.
  public var length: Int64?

  /// Average encoding bitrate of the media asset, in bits per second.
  public var bitrate: Double?

  /// Height of the media asset for video formats.
  public var height: Int?

  /// An IETF language tag (BCP 47) identifying the language of this media.
  public var lang: String?

  /// A human-readable string identifying the name of the media asset.
  public var title: String?

  /// A method of offering and/or grouping together different media elements.
  public var rel: String?

  /// An RFC 6381 string specifying the codecs available in this media.
  public var codecs: String?

  /// Whether this media is the same as the file from the enclosure element and
  /// should be the preferred media element. Assumed to be false when absent.
  public var isDefault: Bool?

  // MARK: Private

  private enum CodingKeys: String, CodingKey {
    case type
    case length
    case bitrate
    case height
    case lang
    case title
    case rel
    case codecs
    case isDefault = "default"
  }
}

/// Different versions of, or companion media to, the main `<enclosure>` file.
///
/// Example:
/// ```xml
/// <podcast:alternateEnclosure type="audio/mpeg" length="43200000" bitrate="128000" default="true" title="Standard">
///   <podcast:source uri="https://example.com/file-0.mp3" />
/// </podcast:alternateEnclosure>
/// ```
///
/// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/alternate-enclosure.md
public struct PodcastAlternateEnclosure: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(
    type: String? = nil,
    length: Int64? = nil,
    bitrate: Double? = nil,
    height: Int? = nil,
    lang: String? = nil,
    title: String? = nil,
    rel: String? = nil,
    codecs: String? = nil,
    isDefault: Bool? = nil,
    sources: [PodcastSource]? = nil,
    integrity: PodcastIntegrity? = nil
  ) {
    self.type = type
    self.length = length
    self.bitrate = bitrate
    self.height = height
    self.lang = lang
    self.title = title
    self.rel = rel
    self.codecs = codecs
    self.isDefault = isDefault
    self.sources = sources
    self.integrity = integrity
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
    let attributes: PodcastAlternateEnclosureAttributes? = try container.decodeIfPresent(
      PodcastAlternateEnclosureAttributes.self,
      forKey: CodingKeys.attributes
    )

    type = attributes?.type
    length = attributes?.length
    bitrate = attributes?.bitrate
    height = attributes?.height
    lang = attributes?.lang
    title = attributes?.title
    rel = attributes?.rel
    codecs = attributes?.codecs
    isDefault = attributes?.isDefault

    sources = try container.decodeIfPresent([PodcastSource].self, forKey: CodingKeys.sources)
    integrity = try container.decodeIfPresent(PodcastIntegrity.self, forKey: CodingKeys.integrity)
  }

  // MARK: Public

  /// Mime type of the media asset.
  public var type: String?

  /// Length of the file in bytes.
  public var length: Int64?

  /// Average encoding bitrate of the media asset, in bits per second.
  public var bitrate: Double?

  /// Height of the media asset for video formats.
  public var height: Int?

  /// An IETF language tag (BCP 47) identifying the language of this media.
  public var lang: String?

  /// A human-readable string identifying the name of the media asset.
  public var title: String?

  /// A method of offering and/or grouping together different media elements.
  public var rel: String?

  /// An RFC 6381 string specifying the codecs available in this media.
  public var codecs: String?

  /// Whether this media should be the preferred media element.
  public var isDefault: Bool?

  /// One or more uris where the media file can be downloaded or streamed.
  public var sources: [PodcastSource]?

  /// An optional method of verifying the integrity of the media.
  public var integrity: PodcastIntegrity?

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)

    try container.encodeIfPresent(PodcastAlternateEnclosureAttributes(
      type: type,
      length: length,
      bitrate: bitrate,
      height: height,
      lang: lang,
      title: title,
      rel: rel,
      codecs: codecs,
      isDefault: isDefault
    ), forKey: CodingKeys.attributes)
    try container.encodeIfPresent(sources, forKey: CodingKeys.sources)
    try container.encodeIfPresent(integrity, forKey: CodingKeys.integrity)
  }

  // MARK: Private

  private enum CodingKeys: String, CodingKey {
    case attributes = "@attributes"
    case sources = "podcast:source"
    case integrity = "podcast:integrity"
  }
}
