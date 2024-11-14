//
//  Media.swift
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

/// Media RSS is a new RSS module that supplements the <enclosure>
/// capabilities of RSS 2.0. RSS enclosures are already being used to
/// syndicate audio files and images. Media RSS extends enclosures to
/// handle other media types, such as short films or TV, as well as
/// provide additional metadata with the media. Media RSS enables
/// content publishers and bloggers to syndicate multimedia content
/// such as TV and video clips, movies, images and audio.
public struct Media: Codable {
  /// The <media:group> element is a sub-element of <item>. It allows grouping
  /// of <media:content> elements that are effectively the same content,
  /// yet different representations. For instance: the same song recorded
  /// in both the WAV and MP3 format. It's an optional element that must
  /// only be used for this purpose.
  public var group: MediaGroup?

  /// <media:content> is a sub-element of either <item> or <media:group>.
  /// Media objects that are not the same content should not be included
  /// in the same <media:group> element. The sequence of these items implies
  /// the order of presentation. While many of the attributes appear to be
  /// audio/video specific, this element can be used to publish any type of
  /// media. It contains 14 attributes, most of which are optional.
  public var contents: [MediaContent]?

  /// This allows the permissible audience to be declared. If this element is not
  /// included, it assumes that no restrictions are necessary. It has one
  /// optional attribute.
  public var rating: MediaRating?

  /// The title of the particular media object. It has one optional attribute.
  public var title: MediaTitle?

  /// Short description describing the media object typically a sentence in
  /// length. It has one optional attribute.
  public var description: MediaDescription?

  /// Highly relevant keywords describing the media object with typically a
  /// maximum of 10 words. The keywords and phrases should be comma-delimited.
  public var keywords: [String]?

  /// Allows particular images to be used as representative images for the
  /// media object. If multiple thumbnails are included, and time coding is not
  /// at play, it is assumed that the images are in order of importance. It has
  /// one required attribute and three optional attributes.
  public var thumbnails: [MediaThumbnail]?

  /// Allows a taxonomy to be set that gives an indication of the type of media
  /// content, and its particular contents. It has two optional attributes.
  public var category: MediaCategory?

  /// This is the hash of the binary media file. It can appear multiple times as
  /// long as each instance is a different algo. It has one optional attribute.
  public var hash: MediaHash?

  /// Allows the media object to be accessed through a web browser media player
  /// console. This element is required only if a direct media url attribute is
  /// not specified in the <media:content> element. It has one required attribute
  /// and two optional attributes.
  public var player: MediaPlayer?

  /// Notable entity and the contribution to the creation of the media object.
  /// Current entities can include people, companies, locations, etc. Specific
  /// entities can have multiple roles, and several entities can have the same
  /// role. These should appear as distinct <media:credit> elements. It has two
  /// optional attributes.
  public var credits: [MediaCredit]?

  /// Copyright information for the media object. It has one optional attribute.
  public var copyright: MediaCopyright?

  /// Allows the inclusion of a text transcript, closed captioning or lyrics of
  /// the media content. Many of these elements are permitted to provide a time
  /// series of text. In such cases, it is encouraged, but not required, that the
  /// elements be grouped by language and appear in time sequence order based on
  /// the start time. Elements can have overlapping start and end times. It has
  /// four optional attributes.
  public var text: MediaText?

  /// Allows restrictions to be placed on the aggregator rendering the media in
  /// the feed. Currently, restrictions are based on distributor (URI), country
  /// codes and sharing of a media object. This element is purely informational
  /// and no obligation can be assumed or implied. Only one <media:restriction>
  /// element of the same type can be applied to a media object -- all others
  /// will be ignored. Entities in this element should be space-separated.
  /// To allow the producer to explicitly declare his/her intentions, two
  /// literals are reserved: "all", "none". These literals can only be used once.
  /// This element has one required attribute and one optional attribute (with
  /// strict requirements for its exclusion).
  public var restriction: MediaRestriction?

  /// This element stands for the community related content. This allows
  /// inclusion of the user perception about a media object in the form of view
  /// count, ratings and tags.
  public var community: MediaCommunity?

  /// Allows inclusion of all the comments a media object has received.
  public var comments: [String]?

  /// Sometimes player-specific embed code is needed for a player to play any
  /// video. <media:embed> allows inclusion of such information in the form of
  /// key-value pairs.
  public var embed: MediaEmbed?

  /// Allows inclusion of a list of all media responses a media object has
  /// received.
  public var responses: [String]?

  /// Allows inclusion of all the URLs pointing to a media object.
  public var backLinks: [String]?

  /// Optional tag to specify the status of a media object -- whether it's still
  /// active or it has been blocked/deleted.
  public var status: MediaStatus?

  /// Optional tag to include pricing information about a media object. If this
  /// tag is not present, the media object is supposed to be free. One media
  /// object can have multiple instances of this tag for including different
  /// pricing structures. The presence of this tag would mean that media object
  /// is not free.
  public var prices: [MediaPrice]?

  /// Optional link to specify the machine-readable license associated with the
  /// content.
  public var license: MediaLicence?

  /// Optional link to specify the machine-readable license associated with the
  /// content.
  public var subTitle: MediaSubTitle?

  /// Optional element for P2P link.
  public var peerLink: MediaPeerLink?

  /// Optional element to specify geographical information about various
  /// locations captured in the content of a media object. The format conforms
  /// to geoRSS.
  public var location: MediaLocation?

  /// Optional element to specify the rights information of a media object.
  public var rights: MediaRights?

  /// Optional element to specify various scenes within a media object. It can
  /// have multiple child <media:scene> elements, where each <media:scene>
  /// element contains information about a particular scene. <media:scene> has
  /// the optional sub-elements <sceneTitle>, <sceneDescription>,
  /// <sceneStartTime> and <sceneEndTime>, which contains title, description,
  /// start and end time of a particular scene in the media, respectively.
  public var scenes: [MediaScene]?

  public init(
    group: MediaGroup? = nil,
    contents: [MediaContent]? = nil,
    rating: MediaRating? = nil,
    title: MediaTitle? = nil,
    description: MediaDescription? = nil,
    keywords: [String]? = nil,
    thumbnails: [MediaThumbnail]? = nil,
    category: MediaCategory? = nil,
    hash: MediaHash? = nil,
    player: MediaPlayer? = nil,
    credits: [MediaCredit]? = nil,
    copyright: MediaCopyright? = nil,
    text: MediaText? = nil,
    restriction: MediaRestriction? = nil,
    community: MediaCommunity? = nil,
    comments: [String]? = nil,
    embed: MediaEmbed? = nil,
    responses: [String]? = nil,
    backLinks: [String]? = nil,
    status: MediaStatus? = nil,
    prices: [MediaPrice]? = nil,
    license: MediaLicence? = nil,
    subTitle: MediaSubTitle? = nil,
    peerLink: MediaPeerLink? = nil,
    location: MediaLocation? = nil,
    rights: MediaRights? = nil,
    scenes: [MediaScene]? = nil) {
    self.group = group
    self.contents = contents
    self.rating = rating
    self.title = title
    self.description = description
    self.keywords = keywords
    self.thumbnails = thumbnails
    self.category = category
    self.hash = hash
    self.player = player
    self.credits = credits
    self.copyright = copyright
    self.text = text
    self.restriction = restriction
    self.community = community
    self.comments = comments
    self.embed = embed
    self.responses = responses
    self.backLinks = backLinks
    self.status = status
    self.prices = prices
    self.license = license
    self.subTitle = subTitle
    self.peerLink = peerLink
    self.location = location
    self.rights = rights
    self.scenes = scenes
  }
}