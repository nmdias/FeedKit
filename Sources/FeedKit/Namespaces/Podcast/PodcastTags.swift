//
// PodcastTags.swift
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

// MARK: - Locked

/// Attributes for the `<podcast:locked>` element.
public struct PodcastLockedAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(owner: String? = nil) {
    self.owner = owner
  }

  // MARK: Public

  /// An email address that can be used to verify ownership of this feed
  /// during move and import operations.
  public var owner: String?
}

/// Tells other podcast hosting platforms whether they are allowed to import
/// this feed. A value of `yes` means that any attempt to import this feed into
/// a new platform should be rejected.
///
/// Example:
/// ```xml
/// <podcast:locked owner="email@example.com">no</podcast:locked>
/// ```
///
/// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/locked.md
public struct PodcastLocked: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(locked: String? = nil, owner: String? = nil) {
    self.locked = locked
    self.owner = owner
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
    let attributes: PodcastLockedAttributes? = try container.decodeIfPresent(
      PodcastLockedAttributes.self,
      forKey: CodingKeys.attributes
    )

    locked = try container.decodeIfPresent(String.self, forKey: CodingKeys.locked)
    owner = attributes?.owner
  }

  // MARK: Public

  /// Whether this feed may be imported into another platform. Either `yes` or
  /// `no`.
  public var locked: String?

  /// An email address that can be used to verify ownership of this feed
  /// during move and import operations.
  public var owner: String?

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)

    try container.encodeIfPresent(locked, forKey: CodingKeys.locked)
    try container.encodeIfPresent(PodcastLockedAttributes(owner: owner), forKey: CodingKeys.attributes)
  }

  // MARK: Private

  private enum CodingKeys: String, CodingKey {
    case locked = "@text"
    case attributes = "@attributes"
  }
}

// MARK: - Block

/// Attributes for the `<podcast:block>` element.
public struct PodcastBlockAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(id: String? = nil) {
    self.id = id
  }

  // MARK: Public

  /// A single entry from the podcast namespace service slug list.
  ///
  /// Example: `google`
  public var id: String?
}

/// Expresses which platforms are allowed to publicly display this feed and
/// its contents.
///
/// Example:
/// ```xml
/// <podcast:block id="google">yes</podcast:block>
/// ```
///
/// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/block.md
public struct PodcastBlock: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(block: String? = nil, id: String? = nil) {
    self.block = block
    self.id = id
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
    let attributes: PodcastBlockAttributes? = try container.decodeIfPresent(
      PodcastBlockAttributes.self,
      forKey: CodingKeys.attributes
    )

    block = try container.decodeIfPresent(String.self, forKey: CodingKeys.block)
    id = attributes?.id
  }

  // MARK: Public

  /// Whether the platform identified by `id`, or every platform when `id` is
  /// absent, is allowed to ingest this feed. Either `yes` or `no`.
  public var block: String?

  /// A single entry from the podcast namespace service slug list.
  public var id: String?

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)

    try container.encodeIfPresent(block, forKey: CodingKeys.block)
    try container.encodeIfPresent(PodcastBlockAttributes(id: id), forKey: CodingKeys.attributes)
  }

  // MARK: Private

  private enum CodingKeys: String, CodingKey {
    case block = "@text"
    case attributes = "@attributes"
  }
}

// MARK: - Complete

/// Attributes for the legacy `<podcast:complete>` element.
public struct PodcastCompleteAttributes: Codable, Equatable, Hashable, Sendable {
  public init() {}
}

/// Signals that a podcast has no intention of releasing further episodes.
///
/// Example:
/// ```xml
/// <podcast:complete />
/// ```
///
/// See https://github.com/Podcastindex-org/podcast-namespace
public typealias PodcastComplete = XMLAttributesElement<PodcastCompleteAttributes>

// MARK: - Text

/// Attributes for the `<podcast:txt>` element.
public struct PodcastTextAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(purpose: String? = nil) {
    self.purpose = purpose
  }

  // MARK: Public

  /// A service specific string that denotes what purpose this tag serves.
  ///
  /// Known values include `verify`, `applepodcastsverify` and `ai-content`.
  public var purpose: String?
}

/// Free-form text modeled after the DNS "TXT" record.
///
/// Example:
/// ```xml
/// <podcast:txt purpose="verify">S6lpp-7ZCn8-dZfGc-OoyaG</podcast:txt>
/// ```
///
/// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/txt.md
public typealias PodcastText = XMLKit.XMLElement<PodcastTextAttributes>

// MARK: - Person

/// Attributes for the `<podcast:person>` element.
public struct PodcastPersonAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(
    role: String? = nil,
    group: String? = nil,
    img: String? = nil,
    href: String? = nil
  ) {
    self.role = role
    self.group = group
    self.img = img
    self.href = href
  }

  // MARK: Public

  /// What role the person serves on the show or episode.
  ///
  /// References an official role within the Podcast Taxonomy Project list.
  /// Defaults to `host` when absent.
  public var role: String?

  /// A reference to an official group within the Podcast Taxonomy Project list.
  ///
  /// Defaults to `cast` when absent.
  public var group: String?

  /// The url of a picture or avatar of the person.
  public var img: String?

  /// The url to a relevant resource of information about the person, such as a
  /// homepage or third-party profile platform.
  public var href: String?
}

/// A person of interest to the podcast, such as a host, co-host or guest.
///
/// Example:
/// ```xml
/// <podcast:person role="guest" href="https://example.com/dave" img="https://example.com/dave.jpg">Dave Jones</podcast:person>
/// ```
///
/// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/person.md
public typealias PodcastPerson = XMLKit.XMLElement<PodcastPersonAttributes>

// MARK: - Location

/// Attributes for the `<podcast:location>` element.
public struct PodcastLocationAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(
    rel: String? = nil,
    geo: String? = nil,
    osm: String? = nil,
    country: String? = nil
  ) {
    self.rel = rel
    self.geo = geo
    self.osm = osm
    self.country = country
  }

  // MARK: Public

  /// Whether the location refers to what the content is about or where it was
  /// produced. Either `subject` (the default) or `creator`.
  public var rel: String?

  /// A latitude and longitude in geoURI form, following RFC 5870.
  ///
  /// Example: `geo:30.2672,97.7431`
  public var geo: String?

  /// The OpenStreetMap identifier of this place.
  ///
  /// Example: `R113314`
  public var osm: String?

  /// A two-letter code for the country, following ISO 3166-1 alpha-2.
  public var country: String?
}

/// The location of editorial focus, or the source of production, for a
/// podcast's content.
///
/// Example:
/// ```xml
/// <podcast:location rel="creator" geo="geo:30.2672,97.7431" osm="R113314" country="US">Austin</podcast:location>
/// ```
///
/// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/location.md
public typealias PodcastLocation = XMLKit.XMLElement<PodcastLocationAttributes>

// MARK: - Season

/// Attributes for the `<podcast:season>` element.
public struct PodcastSeasonAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(name: String? = nil) {
    self.name = name
  }

  // MARK: Public

  /// The "name" of the season. When present, applications are free not to show
  /// the season number and may use it only for sorting and grouping.
  public var name: String?
}

/// Identifies which episodes in a podcast are part of a particular season.
///
/// Example:
/// ```xml
/// <podcast:season name="Race for the Whitehouse 2020">3</podcast:season>
/// ```
///
/// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/season.md
public struct PodcastSeason: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(number: Int? = nil, name: String? = nil) {
    self.number = number
    self.name = name
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
    let attributes: PodcastSeasonAttributes? = try container.decodeIfPresent(
      PodcastSeasonAttributes.self,
      forKey: CodingKeys.attributes
    )

    number = try container.decodeIfPresent(String.self, forKey: CodingKeys.number).flatMap(Int.init)
    name = attributes?.name
  }

  // MARK: Public

  /// The season "number".
  public var number: Int?

  /// The "name" of the season.
  public var name: String?

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)

    try container.encodeIfPresent(number.map(String.init), forKey: CodingKeys.number)
    try container.encodeIfPresent(PodcastSeasonAttributes(name: name), forKey: CodingKeys.attributes)
  }

  // MARK: Private

  private enum CodingKeys: String, CodingKey {
    case number = "@text"
    case attributes = "@attributes"
  }
}

// MARK: - Episode

/// Attributes for the `<podcast:episode>` element.
public struct PodcastEpisodeAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(display: String? = nil) {
    self.display = display
  }

  // MARK: Public

  /// A value that apps are encouraged to show instead of the numerical node
  /// value.
  ///
  /// Example: `Ch.3`
  public var display: String?
}

/// The episode number, which exists largely for compatibility with the
/// `<podcast:season>` element.
///
/// Episode numbering is decimal, so `100.5` is acceptable for a special
/// mini-episode published between two other episodes.
///
/// Example:
/// ```xml
/// <podcast:episode display="Ch.3">204</podcast:episode>
/// ```
///
/// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/episode.md
public struct PodcastEpisode: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(number: Double? = nil, display: String? = nil) {
    self.number = number
    self.display = display
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
    let attributes: PodcastEpisodeAttributes? = try container.decodeIfPresent(
      PodcastEpisodeAttributes.self,
      forKey: CodingKeys.attributes
    )

    number = try container.decodeIfPresent(String.self, forKey: CodingKeys.number).flatMap(Double.init)
    display = attributes?.display
  }

  // MARK: Public

  /// The episode number.
  public var number: Double?

  /// A value that apps are encouraged to show instead of the numerical value.
  public var display: String?

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)

    try container.encodeIfPresent(number.map { "\($0)" }, forKey: CodingKeys.number)
    try container.encodeIfPresent(PodcastEpisodeAttributes(display: display), forKey: CodingKeys.attributes)
  }

  // MARK: Private

  private enum CodingKeys: String, CodingKey {
    case number = "@text"
    case attributes = "@attributes"
  }
}

// MARK: - Funding

/// Attributes for the `<podcast:funding>` element.
public struct PodcastFundingAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(url: String? = nil) {
    self.url = url
  }

  // MARK: Public

  /// The URL to be followed to fund the podcast.
  public var url: String?
}

/// A possible donation or funding link for the podcast.
///
/// The content of the tag is the recommended string to be displayed in the app
/// next to the link.
///
/// Example:
/// ```xml
/// <podcast:funding url="https://example.com/donations">Support the show!</podcast:funding>
/// ```
///
/// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/funding.md
public typealias PodcastFunding = XMLKit.XMLElement<PodcastFundingAttributes>

// MARK: - Chapters

/// Attributes for the `<podcast:chapters>` element.
public struct PodcastChaptersAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(url: String? = nil, type: String? = nil) {
    self.url = url
    self.type = type
  }

  // MARK: Public

  /// The URL where the chapters file is located.
  public var url: String?

  /// The mime type of the chapters file.
  ///
  /// Example: `application/json+chapters`
  public var type: String?
}

/// Links to an external file containing chapter data for the episode.
///
/// Example:
/// ```xml
/// <podcast:chapters url="https://example.com/episode1/chapters.json" type="application/json+chapters" />
/// ```
///
/// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/chapters.md
public typealias PodcastChapters = XMLAttributesElement<PodcastChaptersAttributes>

// MARK: - Soundbite

/// Attributes for the `<podcast:soundbite>` element.
public struct PodcastSoundbiteAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(startTime: TimeInterval? = nil, duration: TimeInterval? = nil) {
    self.startTime = startTime
    self.duration = duration
  }

  // MARK: Public

  /// The time where the soundbite begins.
  public var startTime: TimeInterval?

  /// How long the soundbite is, recommended between 15 and 120 seconds.
  public var duration: TimeInterval?
}

/// Points to a soundbite within a podcast episode.
///
/// The content of the tag is a free-form title for the soundbite.
///
/// Example:
/// ```xml
/// <podcast:soundbite startTime="1234.5" duration="42.25">Why the Podcast Namespace Matters</podcast:soundbite>
/// ```
///
/// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/soundbite.md
public typealias PodcastSoundbite = XMLKit.XMLElement<PodcastSoundbiteAttributes>

// MARK: - Trailer

/// Attributes for the `<podcast:trailer>` element.
public struct PodcastTrailerAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(
    url: String? = nil,
    pubdate: String? = nil,
    length: Int64? = nil,
    type: String? = nil,
    season: Int? = nil
  ) {
    self.url = url
    self.pubdate = pubdate
    self.length = length
    self.type = type
    self.season = season
  }

  // MARK: Public

  /// A url that points to the audio or video file to be played.
  public var url: String?

  /// The date the trailer was published, as an RFC 2822 formatted string.
  public var pubdate: String?

  /// The length of the file in bytes.
  public var length: Int64?

  /// The mime type of the file.
  public var type: String?

  /// The season number this trailer is for.
  public var season: Int?
}

/// The location of an audio or video file to be used as a trailer for the
/// entire podcast or a specific season.
///
/// The content of the tag is the title of the trailer.
///
/// Example:
/// ```xml
/// <podcast:trailer pubdate="Thu, 01 Apr 2021 08:00:00 EST" url="https://example.org/teaser.mp3">Coming April 1st, 2021</podcast:trailer>
/// ```
///
/// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/trailer.md
public typealias PodcastTrailer = XMLKit.XMLElement<PodcastTrailerAttributes>

// MARK: - License

/// Attributes for the `<podcast:license>` element.
public struct PodcastLicenseAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(url: String? = nil) {
    self.url = url
  }

  // MARK: Public

  /// A URL that points to the full, legal language of the license.
  ///
  /// Optional for well-known public licenses, required for custom ones.
  public var url: String?
}

/// A license applied to the audio/video content of a single episode or of the
/// podcast as a whole.
///
/// The content of the tag is a lower-cased license identifier, or a free-form
/// abbreviation for a custom license.
///
/// Example:
/// ```xml
/// <podcast:license url="https://example.org/full.pdf">my-podcast-license-v1</podcast:license>
/// ```
///
/// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/license.md
public typealias PodcastLicense = XMLKit.XMLElement<PodcastLicenseAttributes>

// MARK: - Update Frequency

/// Attributes for the `<podcast:updateFrequency>` element.
public struct PodcastUpdateFrequencyAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(complete: Bool? = nil, dtstart: String? = nil, rrule: String? = nil) {
    self.complete = complete
    self.dtstart = dtstart
    self.rrule = rrule
  }

  // MARK: Public

  /// Whether the podcast has no intention of releasing further episodes.
  public var complete: Bool?

  /// The date or datetime the recurrence rule begins, as an ISO 8601 string.
  public var dtstart: String?

  /// A recurrence rule as defined in RFC 5545 Section 3.3.10.
  ///
  /// Example: `FREQ=WEEKLY;INTERVAL=2`
  public var rrule: String?
}

/// The intended release schedule, as structured data and text.
///
/// Example:
/// ```xml
/// <podcast:updateFrequency rrule="FREQ=WEEKLY">Weekly</podcast:updateFrequency>
/// ```
///
/// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/update-frequency.md
public typealias PodcastUpdateFrequency = XMLKit.XMLElement<PodcastUpdateFrequencyAttributes>

// MARK: - Podping

/// Attributes for the `<podcast:podping>` element.
public struct PodcastPodpingAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(usesPodping: Bool? = nil) {
    self.usesPodping = usesPodping
  }

  // MARK: Public

  /// Whether the feed owner sends out Podping notifications when the feed
  /// changes.
  public var usesPodping: Bool?
}

/// Signals to aggregators that the feed sends out Podping notifications when
/// changes are made to it.
///
/// Example:
/// ```xml
/// <podcast:podping usesPodping="true"/>
/// ```
///
/// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/podping.md
public typealias PodcastPodping = XMLAttributesElement<PodcastPodpingAttributes>

// MARK: - Content Link

/// Attributes for the `<podcast:contentLink>` element.
public struct PodcastContentLinkAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(href: String? = nil) {
    self.href = href
  }

  // MARK: Public

  /// The uri pointing to content outside of the application.
  public var href: String?
}

/// Indicates that the content being delivered can be found at an external
/// location instead of, or in addition to, the tag itself within an app.
///
/// The content of the tag explains to the user where this content link points.
///
/// Example:
/// ```xml
/// <podcast:contentLink href="https://www.youtube.com/watch?v=example">Watch this episode on YouTube!</podcast:contentLink>
/// ```
///
/// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/content-link.md
public typealias PodcastContentLink = XMLKit.XMLElement<PodcastContentLinkAttributes>

// MARK: - Social Interact

/// Attributes for the `<podcast:socialInteract>` element.
public struct PodcastSocialInteractAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(
    protocol: String? = nil,
    uri: String? = nil,
    accountID: String? = nil,
    accountURL: String? = nil,
    priority: Int? = nil
  ) {
    self.protocol = `protocol`
    self.uri = uri
    self.accountID = accountID
    self.accountURL = accountURL
    self.priority = priority
  }

  // MARK: Public

  /// The protocol in use for interacting with the comment root post.
  ///
  /// A value of `disabled` signals that the podcaster does not want public
  /// comments shown alongside the episode or podcast.
  public var `protocol`: String?

  /// The uri of the root post comment.
  public var uri: String?

  /// The account id on the commenting platform that created this root post.
  public var accountID: String?

  /// The public url on the commenting platform of the account that created
  /// this root post.
  public var accountURL: String?

  /// When multiple tags are present, a lower number means higher priority.
  public var priority: Int?

  // MARK: Private

  /// The attribute spellings of the specification differ from the Swift names
  /// for the account, so they are pinned explicitly.
  private enum CodingKeys: String, CodingKey {
    case `protocol`
    case uri
    case accountID = "accountId"
    case accountURL = "accountUrl"
    case priority
  }
}

/// Attaches the url of a "root post" of a comment thread to an episode, or to
/// the podcast as a whole.
///
/// Example:
/// ```xml
/// <podcast:socialInteract protocol="activitypub" uri="https://example.social/@dave/105079274766075912" accountId="@dave" />
/// ```
///
/// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/social-interact.md
public typealias PodcastSocialInteract = XMLAttributesElement<PodcastSocialInteractAttributes>

// MARK: - Chat

/// Attributes for the `<podcast:chat>` element.
public struct PodcastChatAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(server: String? = nil, protocol: String? = nil, accountID: String? = nil, space: String? = nil) {
    self.server = server
    self.protocol = `protocol`
    self.accountID = accountID
    self.space = space
  }

  // MARK: Public

  /// The fqdn of a chat server that serves as the "bootstrap" server to
  /// connect to.
  public var server: String?

  /// The protocol in use on the server.
  ///
  /// Example: `irc`, `xmpp`, `matrix`, `nostr`
  public var `protocol`: String?

  /// The account id of the podcaster on the server or platform being connected
  /// to.
  public var accountID: String?

  /// A chat "space", "room" or "topic", for chat systems that have one.
  public var space: String?

  // MARK: Private

  /// The attribute spelling of the specification differs from the Swift name
  /// for the account, so it is pinned explicitly.
  private enum CodingKeys: String, CodingKey {
    case server
    case `protocol`
    case accountID = "accountId"
    case space
  }
}

/// Where the "official" chat for either the podcast or a specific episode is
/// to be found.
///
/// Example:
/// ```xml
/// <podcast:chat server="irc.zeronode.net" protocol="irc" accountId="@jsmith" space="#myawesomepodcast" />
/// ```
///
/// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/chat.md
public typealias PodcastChat = XMLAttributesElement<PodcastChatAttributes>
