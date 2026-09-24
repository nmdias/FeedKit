//
// PodcastTests.swift
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

@testable import FeedKit
import Foundation
import Testing

/// Covers the Podcast Index namespace tags.
///
/// See https://github.com/nmdias/FeedKit/issues/198
struct PodcastTests: FeedKitTestable {
  // MARK: Internal

  // MARK: Channel

  @Test
  func channelIdentityAndAccess() throws {
    // Given
    let data = data(resource: "Podcast", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let channel = try #require(feed.channel)
    let podcast = try #require(channel.podcast)

    // Then
    #expect(podcast.guid == "y0ur-gu1d-g035-h3r3")
    #expect(podcast.locked?.locked == "yes")
    #expect(podcast.locked?.owner == "podcastowner@example.com")
    #expect(podcast.medium == "podcast")
  }

  /// The block tag may be repeated, with a service slug identifying the
  /// platform the answer applies to.
  @Test
  func channelBlockList() throws {
    // Given
    let data = data(resource: "Podcast", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let blocks = try #require(feed.channel?.podcast?.block)

    // Then
    #expect(blocks.count == 3)
    #expect(blocks[0].block == "yes")
    #expect(blocks[0].id == nil)
    #expect(blocks[1].block == "no")
    #expect(blocks[1].id == "google")
    #expect(blocks[2].id == "amazon")
  }

  @Test
  func channelFundingLinks() throws {
    // Given
    let data = data(resource: "Podcast", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let funding = try #require(feed.channel?.podcast?.funding)

    // Then
    #expect(funding.count == 2)
    #expect(funding[0].attributes?.url == "https://example.com/donate")
    #expect(funding[0].text == "Support the show!")
    #expect(funding[1].text == "Become a member!")
  }

  @Test
  func channelLicenseTextAndURL() throws {
    // Given
    let data = data(resource: "Podcast", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let license = try #require(feed.channel?.podcast?.license)

    // Then
    #expect(license.text == "my-podcast-license-v1")
    #expect(license.attributes?.url == "https://example.org/mypodcastlicense/full.pdf")
  }

  @Test
  func channelTextPurposes() throws {
    // Given
    let data = data(resource: "Podcast", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let txt = try #require(feed.channel?.podcast?.txt)

    // Then
    #expect(txt.count == 2)
    #expect(txt[0].attributes?.purpose == "verify")
    #expect(txt[0].text == "S6lpp-7ZCn8-dZfGc-OoyaG")
    #expect(txt[1].attributes?.purpose == "ai-content")
    #expect(txt[1].text == "false")
  }

  @Test
  func channelUpdateFrequency() throws {
    // Given
    let data = data(resource: "Podcast", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let frequency = try #require(feed.channel?.podcast?.updateFrequency)

    // Then
    #expect(frequency.text == "Biweekly")
    #expect(frequency.attributes?.complete == false)
    #expect(frequency.attributes?.dtstart == "2021-01-01T00:00:00.000Z")
    #expect(frequency.attributes?.rrule == "FREQ=WEEKLY;INTERVAL=2")
  }

  /// The location tag is allowed at the channel level as well as the item
  /// level.
  @Test
  func channelLocation() throws {
    // Given
    let data = data(resource: "Podcast", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let locations = try #require(feed.channel?.podcast?.location)
    let location = try #require(locations.first)

    // Then
    #expect(locations.count == 1)
    #expect(location.text == "Austin, TX")
    #expect(location.attributes?.rel == "creator")
    #expect(location.attributes?.geo == "geo:30.2672,97.7431")
    #expect(location.attributes?.osm == "R113314")
    #expect(location.attributes?.country == "US")
  }

  @Test
  func channelImages() throws {
    // Given
    let data = data(resource: "Podcast", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let images = try #require(feed.channel?.podcast?.image)

    // Then
    #expect(images.count == 2)

    let artwork = try #require(images.first?.attributes)
    #expect(artwork.href == "https://example.com/images/show/pci_avatar-massive.png")
    #expect(artwork.alt == "An antenna emanating signal waves")
    #expect(artwork.purpose == "artwork")
    #expect(artwork.aspectRatio == "1/1")
    #expect(artwork.width == 3000)
    #expect(artwork.height == nil)
    #expect(artwork.type == "image/png")

    let social = try #require(images.last?.attributes)
    #expect(social.purpose == "social")
    #expect(social.aspectRatio == "1.9")
    #expect(social.width == 1200)
    #expect(social.height == 630)
    #expect(social.type == "image/webp")
  }

  /// The deprecated `podcast:images` tag carries a compact `srcset` list.
  @Test
  func channelDeprecatedImages() throws {
    // Given
    let data = data(resource: "Podcast", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let images = try #require(feed.channel?.podcast?.images)

    // Then
    #expect(images.attributes?.srcset == "https://example.com/images/pci_avatar-massive.jpg 1500w, https://example.com/images/pci_avatar-tiny.jpg 150w")
  }

  @Test
  func channelPerson() throws {
    // Given
    let data = data(resource: "Podcast", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let people = try #require(feed.channel?.podcast?.person)
    let person = try #require(people.first)

    // Then
    #expect(people.count == 1)
    #expect(person.text == "Adam Curry")
    #expect(person.attributes?.role == "host")
    #expect(person.attributes?.group == "cast")
    #expect(person.attributes?.img == "https://example.com/images/adamcurry.jpg")
    #expect(person.attributes?.href == "https://www.podchaser.com/creators/adam-curry")
  }

  @Test
  func channelTrailer() throws {
    // Given
    let data = data(resource: "Podcast", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let trailers = try #require(feed.channel?.podcast?.trailer)
    let trailer = try #require(trailers.first)

    // Then
    #expect(trailers.count == 1)
    #expect(trailer.text == "Coming April 1st, 2021")
    #expect(trailer.attributes?.url == "https://example.org/trailers/teaser")
    #expect(trailer.attributes?.pubdate == "Thu, 01 Apr 2021 08:00:00 EST")
    #expect(trailer.attributes?.length == 12_345_678)
    #expect(trailer.attributes?.type == "audio/mp3")
    #expect(trailer.attributes?.season == nil)
  }

  @Test
  func channelChat() throws {
    // Given
    let data = data(resource: "Podcast", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let chat = try #require(feed.channel?.podcast?.chat)

    // Then
    #expect(chat.attributes?.server == "example.com")
    #expect(chat.attributes?.protocol == "matrix")
    #expect(chat.attributes?.accountID == "@bob:example.com")
    #expect(chat.attributes?.space == "#general:example.com")
  }

  @Test
  func channelPodping() throws {
    // Given
    let data = data(resource: "Podcast", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let podping = try #require(feed.channel?.podcast?.podping)

    // Then
    #expect(podping.attributes?.usesPodping == true)
  }

  /// The complete tag signals that no further episodes are planned.
  @Test
  func channelComplete() throws {
    // Given
    let data: Data = .init(Self.completeFeed.utf8)

    // When
    let feed = try RSSFeed(data: data)

    // Then
    #expect(feed.channel?.podcast?.complete != nil)
  }

  /// Funding and location are also allowed at the item level.
  @Test
  func itemFundingAndLocation() throws {
    // Given
    let data: Data = .init(Self.itemFundingFeed.utf8)

    // When
    let feed = try RSSFeed(data: data)
    let podcast = try #require(feed.channel?.items?.first?.podcast)

    // Then
    #expect(podcast.funding?.first?.attributes?.url == "https://example.com/donate")
    #expect(podcast.funding?.first?.text == "Support the show!")
    #expect(podcast.location?.first?.text == "Marlow")
    #expect(podcast.location?.first?.attributes?.rel == "creator")
    #expect(podcast.location?.first?.attributes?.country == "GB")
  }

  /// The podroll recommends other podcasts through remote item references.
  @Test
  func channelPodroll() throws {
    // Given
    let data = data(resource: "Podcast", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let remoteItems = try #require(feed.channel?.podcast?.podroll?.remoteItems)

    // Then
    #expect(remoteItems.count == 2)
    #expect(remoteItems[0].attributes?.feedGuid == "917393e3-1b1e-5cef-ace4-edaa54e1f810")
    #expect(remoteItems[0].attributes?.feedURL == "https://feeds.podcastindex.org/pc20.xml")
    #expect(remoteItems[0].attributes?.title == "Podcasting 2.0")
    #expect(remoteItems[1].attributes?.feedGuid == "396d9ae0-da7e-5557-b894-b606231fa3ea")
  }

  /// The publisher element points at the publisher feed with exactly one
  /// remote item.
  @Test
  func channelPublisher() throws {
    // Given
    let data = data(resource: "Podcast", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let remoteItem = try #require(feed.channel?.podcast?.publisher?.remoteItem)

    // Then
    #expect(remoteItem.attributes?.medium == "publisher")
    #expect(remoteItem.attributes?.feedGuid == "000000a0-aaa5-bbbf-b765-6333d449661a")
    #expect(remoteItem.attributes?.feedURL == "https://publisherexample.xml")
  }

  // MARK: Live Item

  /// A live item takes the same format as a standard item, with the stream
  /// state carried in its attributes.
  @Test
  func channelLiveItem() throws {
    // Given
    let data = data(resource: "Podcast", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let liveItems = try #require(feed.channel?.podcast?.liveItems)
    let liveItem = try #require(liveItems.first)

    // Then
    #expect(liveItems.count == 1)
    #expect(liveItem.status == "live")
    #expect(liveItem.start == "2021-09-26T07:30:00.000-0600")
    #expect(liveItem.end == "2021-09-26T09:30:00.000-0600")

    let item = try #require(liveItem.item)
    #expect(item.title == "Podcasting 2.0 Live Show")
    #expect(item.link == "https://example.com/podcast/live")
    #expect(item.guid?.text == "https://example.com/live")
    #expect(item.guid?.attributes?.isPermaLink == true)
    #expect(item.enclosure?.attributes?.url == "https://example.com/pc20/livestream?format=.mp3")
    #expect(item.enclosure?.attributes?.length == 312)
    #expect(item.podcast?.alternateEnclosures?.count == 1)
    #expect(item.podcast?.contentLinks?.first?.attributes?.href == "https://www.youtube.com/pc20/livestream")
  }

  // MARK: Item

  @Test
  func itemSeasonAndEpisode() throws {
    // Given
    let data = data(resource: "Podcast", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let items = try #require(feed.channel?.items)

    // Then
    let first = try #require(items.first?.podcast)
    #expect(first.season?.number == 1)
    #expect(first.season?.name == "Podcasting 2.0")
    #expect(first.episode?.number == 204)
    #expect(first.episode?.display == "Ch.3")

    // Elements without attributes still carry their text.
    let second = try #require(items.last?.podcast)
    #expect(second.season?.number == 2)
    #expect(second.season?.name == nil)
    #expect(second.episode?.number == 2)
    #expect(second.episode?.display == nil)
  }

  @Test
  func itemChapters() throws {
    // Given
    let data = data(resource: "Podcast", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let chapters = try #require(feed.channel?.items?.first?.podcast?.chapters)

    // Then
    #expect(chapters.attributes?.url == "https://example.com/ep3_chapters.json")
    #expect(chapters.attributes?.type == "application/json+chapters")
  }

  /// Soundbites are repeatable and may carry a title.
  @Test
  func itemSoundbites() throws {
    // Given
    let data = data(resource: "Podcast", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let soundbites = try #require(feed.channel?.items?.first?.podcast?.soundbite)

    // Then
    #expect(soundbites.count == 2)
    #expect(soundbites[0].text == nil)
    #expect(soundbites[0].attributes?.startTime == 33.833)
    #expect(soundbites[0].attributes?.duration == 60.0)
    #expect(soundbites[1].text == "Why the Podcast Namespace Matters")
    #expect(soundbites[1].attributes?.startTime == 1234.5)
    #expect(soundbites[1].attributes?.duration == 42.25)
  }

  @Test
  func itemTranscripts() throws {
    // Given
    let data = data(resource: "Podcast", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let transcripts = try #require(feed.channel?.items?.first?.podcast?.transcripts)

    // Then
    #expect(transcripts.count == 2)
    #expect(transcripts[0].attributes?.url == "https://example.com/ep3/transcript.txt")
    #expect(transcripts[0].attributes?.type == "text/plain")
    #expect(transcripts[0].attributes?.language == nil)
    #expect(transcripts[1].attributes?.language == "es")
    #expect(transcripts[1].attributes?.rel == "captions")
  }

  @Test
  func itemPeople() throws {
    // Given
    let data = data(resource: "Podcast", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let people = try #require(feed.channel?.items?.first?.podcast?.person)

    // Then
    #expect(people.count == 3)
    #expect(people[0].text == "Adam Curry")
    #expect(people[0].attributes?.role == nil)
    #expect(people[1].text == "Dave Jones")
    #expect(people[1].attributes?.role == "guest")
    #expect(people[2].text == "Becky Smith")
    #expect(people[2].attributes?.group == "visuals")
    #expect(people[2].attributes?.role == "cover art designer")
  }

  @Test
  func itemLocation() throws {
    // Given
    let data = data(resource: "Podcast", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let location = try #require(feed.channel?.items?.first?.podcast?.location?.first)

    // Then
    #expect(location.text == "Birmingham Civil Rights Museum")
    #expect(location.attributes?.rel == "subject")
    #expect(location.attributes?.geo == "geo:33.5159981,-86.8146098")
    #expect(location.attributes?.osm == "R6930627")
    #expect(location.attributes?.country == "US")
  }

  @Test
  func itemImage() throws {
    // Given
    let data = data(resource: "Podcast", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let image = try #require(feed.channel?.items?.first?.podcast?.image?.first)

    // Then
    #expect(image.attributes?.href == "https://example.com/images/ep3/pci_avatar-massive.png")
    #expect(image.attributes?.alt == "Episode 3 artwork")
    #expect(image.attributes?.width == 3000)
  }

  @Test
  func itemContentLink() throws {
    // Given
    let data = data(resource: "Podcast", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let contentLinks = try #require(feed.channel?.items?.first?.podcast?.contentLinks)

    // Then
    #expect(contentLinks.count == 1)
    #expect(contentLinks[0].text == "Watch this episode on YouTube!")
    #expect(contentLinks[0].attributes?.href == "https://www.youtube.com/watch?v=example")
  }

  @Test
  func itemSocialInteract() throws {
    // Given
    let data = data(resource: "Podcast", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let interactions = try #require(feed.channel?.items?.first?.podcast?.socialInteract)

    // Then
    #expect(interactions.count == 2)

    let first = try #require(interactions.first?.attributes)
    #expect(first.protocol == "activitypub")
    #expect(first.uri == "https://podcastindex.social/@dave/105079274766075912")
    #expect(first.accountID == "@dave")
    #expect(first.accountURL == "https://podcastindex.social/@dave")
    #expect(first.priority == 1)

    #expect(interactions.last?.attributes?.protocol == "twitter")
    #expect(interactions.last?.attributes?.priority == 2)
  }

  @Test
  func itemRemoteItem() throws {
    // Given
    let data = data(resource: "Podcast", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let remoteItems = try #require(feed.channel?.items?.first?.podcast?.remoteItems)

    // Then
    #expect(remoteItems.count == 1)
    #expect(remoteItems[0].attributes?.feedGuid == "917393e3-1b1e-5cef-ace4-edaa54e1f810")
    #expect(remoteItems[0].attributes?.itemGuid == "asdf089j0-ep240-20230510")
  }

  @Test
  func itemChat() throws {
    // Given
    let data = data(resource: "Podcast", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let chat = try #require(feed.channel?.items?.last?.podcast?.chat)

    // Then
    #expect(chat.attributes?.server == "irc.zeronode.net")
    #expect(chat.attributes?.protocol == "irc")
  }

  // MARK: Alternate Enclosure

  @Test
  func itemAlternateEnclosures() throws {
    // Given
    let data = data(resource: "Podcast", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let enclosures = try #require(feed.channel?.items?.first?.podcast?.alternateEnclosures)

    // Then
    #expect(enclosures.count == 2)

    let standard = try #require(enclosures.first)
    #expect(standard.type == "audio/mpeg")
    #expect(standard.length == 43_200_000)
    #expect(standard.bitrate == 128_000)
    #expect(standard.title == "Standard")
    #expect(standard.isDefault == true)
    #expect(standard.height == nil)
    #expect(standard.sources?.count == 2)
    #expect(standard.sources?[0].attributes?.uri == "https://example.com/file-03.mp3")
    #expect(standard.sources?[1].attributes?.uri == "ipfs://someRandomMpegFile03")
    #expect(standard.integrity == nil)

    let video = try #require(enclosures.last)
    #expect(video.type == "video/mp4")
    #expect(video.bitrate == 511_276.52)
    #expect(video.height == 720)
    #expect(video.lang == "en")
    #expect(video.codecs == "avc1.640028,mp4a.40.2")
    #expect(video.isDefault == nil)
    #expect(video.sources?[1].attributes?.contentType == "application/x-bittorrent")
    #expect(video.integrity?.attributes?.type == "sri")
    #expect(video.integrity?.attributes?.value == "sha384-ExVqijgYHm15PqQqdXfW95x+Rs6C+d6E/ICxyQOeFevnxNLR/wtJNrNYTjIysUBo")
  }

  // MARK: Value

  @Test
  func channelValue() throws {
    // Given
    let data = data(resource: "Podcast", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let values = try #require(feed.channel?.podcast?.value)
    let value = try #require(values.first)

    // Then
    #expect(values.count == 1)
    #expect(value.type == "lightning")
    #expect(value.method == "keysend")
    #expect(value.suggested == 0.00000005)

    let recipients = try #require(value.recipients)
    #expect(recipients.count == 2)
    #expect(recipients[0].attributes?.name == "podcaster")
    #expect(recipients[0].attributes?.type == "node")
    #expect(recipients[0].attributes?.address == "036557ea56b3b86f08be31bcd2557cae8021b0e3a9413f0c0e52625c6696972e57")
    #expect(recipients[0].attributes?.split == 99)
    #expect(recipients[0].attributes?.fee == nil)
    #expect(recipients[1].attributes?.split == 1)
    #expect(recipients[1].attributes?.fee == true)
  }

  /// Item level value tags override whatever the channel defines.
  @Test
  func itemValueOverridesChannelValue() throws {
    // Given
    let data = data(resource: "Podcast", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let value = try #require(feed.channel?.items?.first?.podcast?.value?.first)
    let recipients = try #require(value.recipients)

    // Then
    #expect(recipients.count == 3)
    #expect(recipients[0].attributes?.split == 49)

    let guest = try #require(recipients.last?.attributes)
    #expect(guest.type == "lnaddress")
    #expect(guest.address == "gigi@example.com")
    #expect(guest.customKey == "112111100")
    #expect(guest.customValue == "somevalue")
  }

  /// A value time split either carries recipients of its own or exactly one
  /// remote item whose value block supplies them.
  @Test
  func channelValueTimeSplitWithRemoteItem() throws {
    // Given
    let data = data(resource: "Podcast", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)
    let value = try #require(feed.channel?.podcast?.value?.first)
    let timeSplits = try #require(value.timeSplits)
    let split = try #require(timeSplits.first)

    // Then
    #expect(timeSplits.count == 1)
    #expect(split.startTime == 60)
    #expect(split.duration == 237)
    #expect(split.remoteStartTime == 30)
    #expect(split.remotePercentage == 95)
    #expect(split.recipients == nil)
    #expect(split.remoteItem?.attributes?.feedGuid == "a94f5cc9-8c58-55fc-91fe-a324087a655b")
    #expect(split.remoteItem?.attributes?.itemGuid == "https://podcastindex.org/podcast/4148683#1")
    #expect(split.remoteItem?.attributes?.medium == "music")
  }

  /// A value time split that carries its own recipients is decoded into them
  /// instead of into a remote item.
  @Test
  func valueTimeSplitWithRecipients() throws {
    // Given
    let data: Data = .init(Self.valueTimeSplitWithRecipients.utf8)

    // When
    let feed = try RSSFeed(data: data)
    let split = try #require(feed.channel?.podcast?.value?.first?.timeSplits?.first)

    // Then
    #expect(split.startTime == 60)
    #expect(split.duration == 237)
    #expect(split.remoteItem == nil)
    #expect(split.recipients?.count == 1)
    #expect(split.recipients?.first?.attributes?.name == "Alice (Podcaster)")
    #expect(split.recipients?.first?.attributes?.split == 95)
  }

  // MARK: Integration

  @Test
  func feedEntryPointCarriesPodcastNamespace() throws {
    // Given
    let data = data(resource: "Podcast", withExtension: "xml")

    // When
    let feed = try Feed(data: data)

    // Then
    #expect(feed.rss?.channel?.podcast?.guid == "y0ur-gu1d-g035-h3r3")
    #expect(feed.rss?.channel?.items?.first?.podcast?.person?.count == 3)
  }

  /// A feed that does not use the namespace reports no podcast tags, rather
  /// than empty placeholders.
  @Test
  func feedWithoutPodcastNamespaceHasNone() throws {
    // Given
    let data = data(resource: "RSS", withExtension: "xml")

    // When
    let feed = try RSSFeed(data: data)

    // Then
    #expect(feed.channel?.podcast == nil)
    #expect(feed.channel?.items?.allSatisfy { $0.podcast == nil } == true)
  }

  /// The namespace is declared on the RSS root only when a podcast element is
  /// present, and a decoded document still round-trips a channel level tag.
  @Test
  func encodingDeclaresNamespaceOnlyWhenUsed() throws {
    // Given
    let withoutPodcast: RSSFeed = .init(channel: .init(title: "Example Feed"))
    let withPodcast: RSSFeed = .init(channel: .init(
      title: "Example Feed",
      podcast: .init(guid: "917393e3-1b1e-5cef-ace4-edaa54e1f810")
    ))

    // When
    let plainXML = try withoutPodcast.toXMLString(formatted: true)
    let podcastXML = try withPodcast.toXMLString(formatted: true)

    // Then
    #expect(plainXML.contains("xmlns:podcast") == false)
    #expect(podcastXML.contains("xmlns:podcast=\"https://podcastindex.org/namespace/1.0\""))

    let decoded = try RSSFeed(string: podcastXML)
    #expect(decoded.channel?.podcast?.guid == "917393e3-1b1e-5cef-ace4-edaa54e1f810")
  }

  // MARK: Private

  /// A feed whose channel is marked as complete.
  private static let completeFeed = """
  <?xml version="1.0" encoding="UTF-8"?>
  <rss version="2.0" xmlns:podcast="https://podcastindex.org/namespace/1.0">
    <channel>
      <title>Example Feed</title>
      <link>https://example.com/</link>
      <description>An example feed.</description>
      <podcast:complete>yes</podcast:complete>
    </channel>
  </rss>
  """

  /// A feed carrying funding and location at the item level.
  private static let itemFundingFeed = """
  <?xml version="1.0" encoding="UTF-8"?>
  <rss version="2.0" xmlns:podcast="https://podcastindex.org/namespace/1.0">
    <channel>
      <title>Example Feed</title>
      <link>https://example.com/</link>
      <description>An example feed.</description>
      <item>
        <title>Episode 2</title>
        <podcast:funding url="https://example.com/donate">Support the show!</podcast:funding>
        <podcast:location rel="creator" geo="geo:51.5718706,-0.7769654" osm="R3727240" country="GB">Marlow</podcast:location>
      </item>
    </channel>
  </rss>
  """

  /// A value block whose time split carries its own recipients.
  private static let valueTimeSplitWithRecipients = """
  <?xml version="1.0" encoding="UTF-8"?>
  <rss version="2.0" xmlns:podcast="https://podcastindex.org/namespace/1.0">
    <channel>
      <title>Example Feed</title>
      <link>https://example.com/</link>
      <description>An example feed.</description>
      <podcast:value type="lightning" method="keysend">
        <podcast:valueTimeSplit startTime="60" duration="237">
          <podcast:valueRecipient name="Alice (Podcaster)" type="node" address="02d5c1bf8b940dc9cadca86d1b0a3c37fbe39cee4c7e839e33bef9174531d27f52" split="95" />
        </podcast:valueTimeSplit>
      </podcast:value>
    </channel>
  </rss>
  """
}
