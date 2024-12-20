//
//  iTunes.swift
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

/// iTunes Podcasting Tags are de facto standard for podcast syndication. For more
/// information see https://help.apple.com/itc/podcasts_connect/#/itcb54353390
public struct iTunes {
  /// The content you specify in the <itunes:author> tag appears in the Artist
  /// column on the iTunes Store. If the tag is not present, the iTunes Store
  /// uses the contents of the <author> tag. If <itunes:author> is not present
  /// at the RSS feed level, the iTunes Store uses the contents of the
  /// <managingEditor> tag.
  public var author: String?

  /// Specifying the <itunes:block> tag with a Yes value in:
  ///
  /// - A <channel> tag (podcast), prevents the entire podcast from appearing on
  /// the iTunes Store podcast directory
  ///
  /// - An <item> tag (episode), prevents that episode from appearing on the
  /// iTunes Store podcast directory
  ///
  /// For example, you might want to block a specific episode if you know that
  /// its content would otherwise cause the entire podcast to be removed from
  /// the iTunes Store. Specifying any value other than Yes has no effect.
  public var block: String?

  /// Users can browse podcast subject categories in the iTunes Store by choosing
  /// a category from the Podcasts pop-up menu in the navigation bar. Use the
  /// <itunes:category> tag to specify the browsing category for your podcast.
  ///
  /// You can also define a subcategory if one is available within your category.
  /// Although you can specify more than one category and subcategory in your
  /// feed, the iTunes Store only recognizes the first category and subcategory.
  /// For a complete list of categories and subcategories, see Podcasts Connect
  /// categories.
  ///
  /// Note: When specifying categories and subcategories, be sure to properly
  /// escape ampersands:
  ///
  /// Single category:
  /// <itunes:category text="Music" />
  ///
  /// Category with ampersand:
  /// <itunes:category text="TV &amp; Film" />
  ///
  /// Category with subcategory:
  /// <itunes:category text="Society &amp; Culture">
  /// <itunes:category text="History" />
  /// </itunes:category>
  ///
  /// Multiple categories:
  /// <itunes:category text="Society &amp; Culture">
  /// <itunes:category text="History" />
  /// </itunes:category>
  /// <itunes:category text="Technology">
  /// <itunes:category text="Gadgets" />
  /// </itunes:category>
  public var categories: [iTunesCategory]?

  /// Specify your podcast artwork using the <a href> attribute in the
  /// <itunes:image> tag. If you do not specify the <itunes:image> tag, the
  /// iTunes Store uses the content specified in the RSS feed image tag and Apple
  /// does not consider your podcast for feature placement on the iTunes Store or
  /// Podcasts.
  ///
  /// Depending on their device, subscribers see your podcast artwork in varying
  /// sizes. Therefore, make sure your design is effective at both its original
  /// size and at thumbnail size. Apple recommends including a title, brand, or
  /// source name as part of your podcast artwork. For examples of podcast
  /// artwork, see the Top Podcasts. To avoid technical issues when you update
  /// your podcast artwork, be sure to:
  ///
  /// Change the artwork file name and URL at the same time
  /// Verify the web server hosting your artwork allows HTTP head requests
  /// The <itunes:image> tag is also supported at the <item> (episode) level.
  /// For best results, Apple recommends embedding the same artwork within the
  /// metadata for that episode's media file prior to uploading to your host
  /// server; using Garageband or another content-creation tool to edit your
  /// media file if needed.
  ///
  /// Note: Artwork must be a minimum size of 1400 x 1400 pixels and a maximum
  /// size of 3000 x 3000 pixels, in JPEG or PNG format, 72 dpi, with appropriate
  /// file extensions (.jpg, .png), and in the RGB colorspace. These requirements
  /// are different from the standard RSS image tag specifications.
  public var image: iTunesImage?

  /// The content you specify in the <itunes:duration> tag appears in the Time
  /// column in the List View on the iTunes Store.
  ///
  /// Specify one of the following formats for the <itunes:duration> tag value:
  ///
  /// HH:MM:SS
  /// H:MM:SS
  /// MM:SS
  /// M:SS
  ///
  /// Where H = hours, M = minutes, and S = seconds.
  ///
  /// If you specify a single number as a value (without colons), the iTunes
  /// Store displays the value as seconds. If you specify one colon, the iTunes
  /// Store displays the number to the left as minutes and the number to the
  /// right as seconds. If you specify more then two colons, the iTunes Store
  /// ignores the numbers farthest to the right.
  public var duration: TimeInterval?

  /// The <itunes:explicit> tag indicates whether your podcast contains explicit
  /// material. You can specify the following values:
  ///
  /// Yes | Explicit | True. If you specify yes, explicit, or true, indicating
  /// the presence of explicit content, the iTunes Store displays an Explicit
  /// parental advisory graphic for your podcast.
  /// Clean | No | False. If you specify clean, no, or false, indicating that
  /// none of your podcast episodes contain explicit language or adult content,
  /// the iTunes Store displays a Clean parental advisory graphic for your
  /// podcast.
  ///
  /// Note: Podcasts containing explicit material are not available in some
  /// iTunes Store territories.
  public var explicit: String?

  /// Specifying the <itunes:isClosedCaptioned> tag with a Yes value indicates
  /// that the video podcast episode is embedded with closed captioning and the
  /// iTunes Store should display a closed-caption icon next to the corresponding
  /// episode. This tag is only supported at the <item> level (episode).
  ///
  /// Note: If you specify a value other than Yes, no closed-caption indicator
  /// appears.
  public var isClosedCaptioned: String?

  /// Use the <itunes:order> tag to specify the number value in which you would
  /// like the episode to appear and override the default ordering of episodes
  /// on the iTunes Store.
  ///
  /// For example, if you want an <item> to appear as the first episode of your
  /// podcast, specify the <itunes:order> tag with 1. If conflicting order
  /// values are present in multiple episodes, the iTunes Store uses <pubDate>.
  public var order: Int?

  /// Specifying the <itunes:complete> tag with a Yes value indicates that a
  /// podcast is complete and you will not post any more episodes in the future.
  /// This tag is only supported at the <channel> level (podcast).
  ///
  /// Note: If you specify a value other than Yes, nothing happens.
  public var complete: String?

  /// Use the <itunes:new-feed-url> tag to manually change the URL where your
  /// podcast is located. This tag is only supported at a <channel>level
  /// (podcast).
  ///
  /// <itunes:new-feed-url>http://newlocation.com/example.rss</itunes:new-feed-url>
  /// Note: You should maintain your old feed until you have migrated your e
  /// xisting subscribers. For more information, see Update your RSS feed URL.
  public var newFeedURL: String?

  /// Use the <itunes:owner> tag to specify contact information for the podcast
  /// owner. Include the email address of the owner in a nested <itunes:email>
  /// tag and the name of the owner in a nested <itunes:name> tag.
  ///
  /// The <itunes:owner> tag information is for administrative communication
  /// about the podcast and is not displayed on the iTunes Store.
  public var owner: iTunesOwner?

  /// The content you specify in the <itunes:subtitle> tag appears in the
  /// Description column on the iTunes Store. For best results, choose a subtitle
  /// that is only a few words long.
  public var title: String?

  /// The content you specify in the <itunes:subtitle> tag appears in the
  /// Description column on the iTunes Store. For best results, choose a subtitle
  /// that is only a few words long.
  public var subtitle: String?

  /// The content you specify in the <itunes:summary> tag appears on the iTunes
  /// Store page for your podcast. You can specify up to 4000 characters. The
  /// information also appears in a separate window if a users clicks the
  /// Information icon (Information icon) in the Description column. If you do
  /// not specify a <itunes:summary> tag, the iTunes Store uses the information
  /// in the <description> tag.
  public var summary: String?

  /// Note: The keywords tag is deprecated by Apple and no longer documented in
  /// the official list of tags. However many podcasts still use the tags and it
  /// may be of use for developers building directory or search functionality so
  /// it is included.
  ///
  /// <itunes:keywords>
  /// This tag allows users to search on text keywords.
  /// Limited to 255 characters or less, plain text, no HTML, words must be
  /// separated by spaces.
  /// This tag is applicable to the Item element only.
  public var keywords: String?

  /// Use the <itunes:type> tag to indicate how you intend for episodes to be
  /// presented. You can specify the following values:
  ///
  /// episodic | serial. If you specify episodic it means you intend for
  /// episodes to be presented newest-to-oldest. This is the default behavior
  /// in the iTunes Store if the tag is excluded. If you specify serial it
  /// means you intend for episodes to be presented oldest-to-newest.
  public var type: String?

  /// Use the <itunes:episodeType> tag to indicate what type of show item the
  /// entry is. You can specify the following values:
  ///
  /// full | trailer | bonus. If you specify full, it means this is the full
  /// content of a show. Trailer means this is a preview of the show. Bonus
  /// means it is extra content for a show.
  public var episodeType: String?

  /// Use the <itunes:season> tag to indicate which season the item is part of.
  ///
  /// Note: The iTunes Store & Apple Podcasts does not show the season number
  /// until a feed contains at least two seasons.
  public var season: Int?

  /// Use the <itunes:episode> tag in conjunction with the <itunes:season> tag
  /// to indicate the order an episode should be presented within a season.
  public var episode: Int?

  public init(
    author: String? = nil,
    block: String? = nil,
    categories: [iTunesCategory]? = nil,
    image: iTunesImage? = nil,
    duration: TimeInterval? = nil,
    explicit: String? = nil,
    isClosedCaptioned: String? = nil,
    order: Int? = nil,
    complete: String? = nil,
    newFeedURL: String? = nil,
    owner: iTunesOwner? = nil,
    title: String? = nil,
    subtitle: String? = nil,
    summary: String? = nil,
    keywords: String? = nil,
    type: String? = nil,
    episodeType: String? = nil,
    season: Int? = nil,
    episode: Int? = nil) {
    self.author = author
    self.block = block
    self.categories = categories
    self.image = image
    self.duration = duration
    self.explicit = explicit
    self.isClosedCaptioned = isClosedCaptioned
    self.order = order
    self.complete = complete
    self.newFeedURL = newFeedURL
    self.owner = owner
    self.title = title
    self.subtitle = subtitle
    self.summary = summary
    self.keywords = keywords
    self.type = type
    self.episodeType = episodeType
    self.season = season
    self.episode = episode
  }
}

// MARK: - Equatable

extension iTunes: Equatable {}

// MARK: - Hashable

extension iTunes: Hashable {}

// MARK: - Codable

extension iTunes: Codable {
  private enum CodingKeys: CodingKey {
    case author
    case block
    case categories
    case image
    case duration
    case explicit
    case isClosedCaptioned
    case order
    case complete
    case newFeedURL
    case owner
    case title
    case subtitle
    case summary
    case keywords
    case type
    case episodeType
    case season
    case episode
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<iTunes.CodingKeys> = try decoder.container(keyedBy: iTunes.CodingKeys.self)

    author = try container.decodeIfPresent(String.self, forKey: iTunes.CodingKeys.author)
    block = try container.decodeIfPresent(String.self, forKey: iTunes.CodingKeys.block)
    categories = try container.decodeIfPresent([iTunesCategory].self, forKey: iTunes.CodingKeys.categories)
    image = try container.decodeIfPresent(iTunesImage.self, forKey: iTunes.CodingKeys.image)
    duration = try container.decodeIfPresent(TimeInterval.self, forKey: iTunes.CodingKeys.duration)
    explicit = try container.decodeIfPresent(String.self, forKey: iTunes.CodingKeys.explicit)
    isClosedCaptioned = try container.decodeIfPresent(String.self, forKey: iTunes.CodingKeys.isClosedCaptioned)
    order = try container.decodeIfPresent(Int.self, forKey: iTunes.CodingKeys.order)
    complete = try container.decodeIfPresent(String.self, forKey: iTunes.CodingKeys.complete)
    newFeedURL = try container.decodeIfPresent(String.self, forKey: iTunes.CodingKeys.newFeedURL)
    owner = try container.decodeIfPresent(iTunesOwner.self, forKey: iTunes.CodingKeys.owner)
    title = try container.decodeIfPresent(String.self, forKey: iTunes.CodingKeys.title)
    subtitle = try container.decodeIfPresent(String.self, forKey: iTunes.CodingKeys.subtitle)
    summary = try container.decodeIfPresent(String.self, forKey: iTunes.CodingKeys.summary)
    keywords = try container.decodeIfPresent(String.self, forKey: iTunes.CodingKeys.keywords)
    type = try container.decodeIfPresent(String.self, forKey: iTunes.CodingKeys.type)
    episodeType = try container.decodeIfPresent(String.self, forKey: iTunes.CodingKeys.episodeType)
    season = try container.decodeIfPresent(Int.self, forKey: iTunes.CodingKeys.season)
    episode = try container.decodeIfPresent(Int.self, forKey: iTunes.CodingKeys.episode)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<iTunes.CodingKeys> = encoder.container(keyedBy: iTunes.CodingKeys.self)

    try container.encodeIfPresent(author, forKey: iTunes.CodingKeys.author)
    try container.encodeIfPresent(block, forKey: iTunes.CodingKeys.block)
    try container.encodeIfPresent(categories, forKey: iTunes.CodingKeys.categories)
    try container.encodeIfPresent(image, forKey: iTunes.CodingKeys.image)
    try container.encodeIfPresent(duration, forKey: iTunes.CodingKeys.duration)
    try container.encodeIfPresent(explicit, forKey: iTunes.CodingKeys.explicit)
    try container.encodeIfPresent(isClosedCaptioned, forKey: iTunes.CodingKeys.isClosedCaptioned)
    try container.encodeIfPresent(order, forKey: iTunes.CodingKeys.order)
    try container.encodeIfPresent(complete, forKey: iTunes.CodingKeys.complete)
    try container.encodeIfPresent(newFeedURL, forKey: iTunes.CodingKeys.newFeedURL)
    try container.encodeIfPresent(owner, forKey: iTunes.CodingKeys.owner)
    try container.encodeIfPresent(title, forKey: iTunes.CodingKeys.title)
    try container.encodeIfPresent(subtitle, forKey: iTunes.CodingKeys.subtitle)
    try container.encodeIfPresent(summary, forKey: iTunes.CodingKeys.summary)
    try container.encodeIfPresent(keywords, forKey: iTunes.CodingKeys.keywords)
    try container.encodeIfPresent(type, forKey: iTunes.CodingKeys.type)
    try container.encodeIfPresent(episodeType, forKey: iTunes.CodingKeys.episodeType)
    try container.encodeIfPresent(season, forKey: iTunes.CodingKeys.season)
    try container.encodeIfPresent(episode, forKey: iTunes.CodingKeys.episode)
  }
}
