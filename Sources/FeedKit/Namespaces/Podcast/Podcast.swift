//
// Podcast.swift
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

/// Podcast namespace tags for podcast-specific metadata and extensions.
///
/// The Podcast namespace is a comprehensive RSS namespace for podcasting that
/// provides additional metadata and functionality for podcast feeds. The same
/// container carries both the `<channel>`-level and the `<item>`-level tags,
/// because a given element is only valid in one of the two places.
///
/// See https://github.com/Podcastindex-org/podcast-namespace
public struct Podcast {
  // MARK: Lifecycle

  public init(
    guid: String? = nil,
    locked: PodcastLocked? = nil,
    funding: [PodcastFunding]? = nil,
    medium: String? = nil,
    block: [PodcastBlock]? = nil,
    complete: PodcastComplete? = nil,
    txt: [PodcastText]? = nil,
    updateFrequency: PodcastUpdateFrequency? = nil,
    podroll: PodcastPodroll? = nil,
    publisher: PodcastPublisher? = nil,
    podping: PodcastPodping? = nil,
    liveItems: [PodcastLiveItem]? = nil,
    license: PodcastLicense? = nil,
    trailer: [PodcastTrailer]? = nil,
    chat: PodcastChat? = nil,
    socialInteract: [PodcastSocialInteract]? = nil,
    image: [PodcastImage]? = nil,
    images: PodcastImages? = nil,
    value: [PodcastValue]? = nil,
    location: [PodcastLocation]? = nil,
    person: [PodcastPerson]? = nil,
    transcripts: [PodcastTranscript]? = nil,
    chapters: PodcastChapters? = nil,
    soundbite: [PodcastSoundbite]? = nil,
    season: PodcastSeason? = nil,
    episode: PodcastEpisode? = nil,
    alternateEnclosures: [PodcastAlternateEnclosure]? = nil,
    contentLinks: [PodcastContentLink]? = nil,
    remoteItems: [PodcastRemoteItem]? = nil
  ) {
    self.guid = guid
    self.locked = locked
    self.funding = funding
    self.medium = medium
    self.block = block
    self.complete = complete
    self.txt = txt
    self.updateFrequency = updateFrequency
    self.podroll = podroll
    self.publisher = publisher
    self.podping = podping
    self.liveItems = liveItems
    self.license = license
    self.trailer = trailer
    self.chat = chat
    self.socialInteract = socialInteract
    self.image = image
    self.images = images
    self.value = value
    self.location = location
    self.person = person
    self.transcripts = transcripts
    self.chapters = chapters
    self.soundbite = soundbite
    self.season = season
    self.episode = episode
    self.alternateEnclosures = alternateEnclosures
    self.contentLinks = contentLinks
    self.remoteItems = remoteItems
  }

  // MARK: Public

  /// This element is used to declare a unique, global identifier for a podcast.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/guid.md
  public var guid: String?

  /// Tells other podcast hosting platforms whether they are allowed to import
  /// this feed.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/locked.md
  public var locked: PodcastLocked?

  /// Possible donation/funding links for the podcast.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/funding.md
  public var funding: [PodcastFunding]?

  /// Tells an application what the content contained within the feed IS.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/medium.md
  public var medium: String?

  /// Expresses which platforms are allowed to publicly display this feed and
  /// its contents.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/block.md
  public var block: [PodcastBlock]?

  /// Signals that a podcast has no intention of releasing further episodes.
  public var complete: PodcastComplete?

  /// Free-form text modeled after the DNS "TXT" record.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/txt.md
  public var txt: [PodcastText]?

  /// The intended release schedule, as structured data and text.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/update-frequency.md
  public var updateFrequency: PodcastUpdateFrequency?

  /// References to one or more podcasts, as a way of recommending other
  /// podcasts to the listener.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/podroll.md
  public var podroll: PodcastPodroll?

  /// A link to this feed's "publisher feed" parent.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/publisher.md
  public var publisher: PodcastPublisher?

  /// Signals to aggregators that the feed sends out Podping notifications when
  /// changes are made to it.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/podping.md
  public var podping: PodcastPodping?

  /// Live audio or video streams delivered to podcast apps.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/live-item.md
  public var liveItems: [PodcastLiveItem]?

  /// A license applied to the audio/video content.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/license.md
  public var license: PodcastLicense?

  /// Audio or video files to be used as trailers for the podcast or a season.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/trailer.md
  public var trailer: [PodcastTrailer]?

  /// Where the "official" chat for the podcast or a specific episode is to be
  /// found.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/chat.md
  public var chat: PodcastChat?

  /// The url of a "root post" of a comment thread for the episode or the
  /// podcast as a whole.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/social-interact.md
  public var socialInteract: [PodcastSocialInteract]?

  /// Images of various sizes and use cases.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/image.md
  public var image: [PodcastImage]?

  /// Many different image sizes in a compact way. Deprecated in favour of
  /// `image`.
  public var images: PodcastImages?

  /// The cryptocurrency or payment layer that will be used.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/value.md
  public var value: [PodcastValue]?

  /// The location of editorial focus, or the source of production, for the
  /// content.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/location.md
  public var location: [PodcastLocation]?

  /// A person of interest to the podcast, such as a host, co-host or guest.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/person.md
  public var person: [PodcastPerson]?

  /// Links to transcript or closed captions files for a podcast episode.
  ///
  /// Multiple transcripts can be provided for different languages or formats.
  ///
  /// Example:
  /// ```xml
  /// <podcast:transcript url="https://example.com/episode1/transcript.txt" type="text/plain" language="en" />
  /// <podcast:transcript url="https://example.com/episode1/transcript.vtt" type="text/vtt" language="en" rel="captions" />
  /// ```
  public var transcripts: [PodcastTranscript]?

  /// Links to an external file containing chapter data for the episode.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/chapters.md
  public var chapters: PodcastChapters?

  /// Points to one or more soundbites within a podcast episode.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/soundbite.md
  public var soundbite: [PodcastSoundbite]?

  /// Identifies which episodes are part of a particular season.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/season.md
  public var season: PodcastSeason?

  /// The episode number.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/episode.md
  public var episode: PodcastEpisode?

  /// Different versions of, or companion media to, the main enclosure file.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/alternate-enclosure.md
  public var alternateEnclosures: [PodcastAlternateEnclosure]?

  /// External locations where the content being delivered can be found.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/content-link.md
  public var contentLinks: [PodcastContentLink]?

  /// Pointers to another feed, or an item in another feed.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/remote-item.md
  public var remoteItems: [PodcastRemoteItem]?
}

// MARK: - XMLNamespaceCodable

extension Podcast: XMLNamespaceCodable {}

// MARK: - Sendable

extension Podcast: Sendable {}

// MARK: - Equatable

extension Podcast: Equatable {}

// MARK: - Hashable

extension Podcast: Hashable {}

// MARK: - Codable

extension Podcast: Codable {
  private enum CodingKeys: String, CodingKey {
    case guid = "podcast:guid"
    case locked = "podcast:locked"
    case funding = "podcast:funding"
    case medium = "podcast:medium"
    case block = "podcast:block"
    case complete = "podcast:complete"
    case txt = "podcast:txt"
    case updateFrequency = "podcast:updateFrequency"
    case podroll = "podcast:podroll"
    case publisher = "podcast:publisher"
    case podping = "podcast:podping"
    case liveItems = "podcast:liveItem"
    case license = "podcast:license"
    case trailer = "podcast:trailer"
    case chat = "podcast:chat"
    case socialInteract = "podcast:socialInteract"
    case image = "podcast:image"
    case images = "podcast:images"
    case value = "podcast:value"
    case location = "podcast:location"
    case person = "podcast:person"
    case transcripts = "podcast:transcript"
    case chapters = "podcast:chapters"
    case soundbite = "podcast:soundbite"
    case season = "podcast:season"
    case episode = "podcast:episode"
    case alternateEnclosures = "podcast:alternateEnclosure"
    case contentLinks = "podcast:contentLink"
    case remoteItems = "podcast:remoteItem"
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

    guid = try container.decodeIfPresent(String.self, forKey: CodingKeys.guid)
    locked = try container.decodeIfPresent(PodcastLocked.self, forKey: CodingKeys.locked)
    funding = try container.decodeIfPresent([PodcastFunding].self, forKey: CodingKeys.funding)
    medium = try container.decodeIfPresent(String.self, forKey: CodingKeys.medium)
    block = try container.decodeIfPresent([PodcastBlock].self, forKey: CodingKeys.block)
    complete = try container.decodeIfPresent(PodcastComplete.self, forKey: CodingKeys.complete)
    txt = try container.decodeIfPresent([PodcastText].self, forKey: CodingKeys.txt)
    updateFrequency = try container.decodeIfPresent(PodcastUpdateFrequency.self, forKey: CodingKeys.updateFrequency)
    podroll = try container.decodeIfPresent(PodcastPodroll.self, forKey: CodingKeys.podroll)
    publisher = try container.decodeIfPresent(PodcastPublisher.self, forKey: CodingKeys.publisher)
    podping = try container.decodeIfPresent(PodcastPodping.self, forKey: CodingKeys.podping)
    liveItems = try container.decodeIfPresent([PodcastLiveItem].self, forKey: CodingKeys.liveItems)
    license = try container.decodeIfPresent(PodcastLicense.self, forKey: CodingKeys.license)
    trailer = try container.decodeIfPresent([PodcastTrailer].self, forKey: CodingKeys.trailer)
    chat = try container.decodeIfPresent(PodcastChat.self, forKey: CodingKeys.chat)
    socialInteract = try container.decodeIfPresent([PodcastSocialInteract].self, forKey: CodingKeys.socialInteract)
    image = try container.decodeIfPresent([PodcastImage].self, forKey: CodingKeys.image)
    images = try container.decodeIfPresent(PodcastImages.self, forKey: CodingKeys.images)
    value = try container.decodeIfPresent([PodcastValue].self, forKey: CodingKeys.value)
    location = try container.decodeIfPresent([PodcastLocation].self, forKey: CodingKeys.location)
    person = try container.decodeIfPresent([PodcastPerson].self, forKey: CodingKeys.person)
    transcripts = try container.decodeIfPresent([PodcastTranscript].self, forKey: CodingKeys.transcripts)
    chapters = try container.decodeIfPresent(PodcastChapters.self, forKey: CodingKeys.chapters)
    soundbite = try container.decodeIfPresent([PodcastSoundbite].self, forKey: CodingKeys.soundbite)
    season = try container.decodeIfPresent(PodcastSeason.self, forKey: CodingKeys.season)
    episode = try container.decodeIfPresent(PodcastEpisode.self, forKey: CodingKeys.episode)
    alternateEnclosures = try container.decodeIfPresent(
      [PodcastAlternateEnclosure].self,
      forKey: CodingKeys.alternateEnclosures
    )
    contentLinks = try container.decodeIfPresent([PodcastContentLink].self, forKey: CodingKeys.contentLinks)
    remoteItems = try container.decodeIfPresent([PodcastRemoteItem].self, forKey: CodingKeys.remoteItems)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)

    try container.encodeIfPresent(guid, forKey: CodingKeys.guid)
    try container.encodeIfPresent(locked, forKey: CodingKeys.locked)
    try container.encodeIfPresent(funding, forKey: CodingKeys.funding)
    try container.encodeIfPresent(medium, forKey: CodingKeys.medium)
    try container.encodeIfPresent(block, forKey: CodingKeys.block)
    try container.encodeIfPresent(complete, forKey: CodingKeys.complete)
    try container.encodeIfPresent(txt, forKey: CodingKeys.txt)
    try container.encodeIfPresent(updateFrequency, forKey: CodingKeys.updateFrequency)
    try container.encodeIfPresent(podroll, forKey: CodingKeys.podroll)
    try container.encodeIfPresent(publisher, forKey: CodingKeys.publisher)
    try container.encodeIfPresent(podping, forKey: CodingKeys.podping)
    try container.encodeIfPresent(liveItems, forKey: CodingKeys.liveItems)
    try container.encodeIfPresent(license, forKey: CodingKeys.license)
    try container.encodeIfPresent(trailer, forKey: CodingKeys.trailer)
    try container.encodeIfPresent(chat, forKey: CodingKeys.chat)
    try container.encodeIfPresent(socialInteract, forKey: CodingKeys.socialInteract)
    try container.encodeIfPresent(image, forKey: CodingKeys.image)
    try container.encodeIfPresent(images, forKey: CodingKeys.images)
    try container.encodeIfPresent(value, forKey: CodingKeys.value)
    try container.encodeIfPresent(location, forKey: CodingKeys.location)
    try container.encodeIfPresent(person, forKey: CodingKeys.person)
    try container.encodeIfPresent(transcripts, forKey: CodingKeys.transcripts)
    try container.encodeIfPresent(chapters, forKey: CodingKeys.chapters)
    try container.encodeIfPresent(soundbite, forKey: CodingKeys.soundbite)
    try container.encodeIfPresent(season, forKey: CodingKeys.season)
    try container.encodeIfPresent(episode, forKey: CodingKeys.episode)
    try container.encodeIfPresent(alternateEnclosures, forKey: CodingKeys.alternateEnclosures)
    try container.encodeIfPresent(contentLinks, forKey: CodingKeys.contentLinks)
    try container.encodeIfPresent(remoteItems, forKey: CodingKeys.remoteItems)
  }
}
