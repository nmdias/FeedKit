//
//  MediaNamespace.swift
//
//  Copyright (c) 2016 - 2018 Nuno Manuel Dias
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
public class MediaNamespace {
    
    /// The <media:group> element is a sub-element of <item>. It allows grouping
    /// of <media:content> elements that are effectively the same content, 
    /// yet different representations. For instance: the same song recorded
    /// in both the WAV and MP3 format. It's an optional element that must 
    /// only be used for this purpose.
    public var mediaGroup: MediaGroup?
    
    /// <media:content> is a sub-element of either <item> or <media:group>. 
    /// Media objects that are not the same content should not be included 
    /// in the same <media:group> element. The sequence of these items implies 
    /// the order of presentation. While many of the attributes appear to be 
    /// audio/video specific, this element can be used to publish any type of 
    /// media. It contains 14 attributes, most of which are optional.
    public var mediaContents: [MediaContent]?
    
    /// This allows the permissible audience to be declared. If this element is not
    /// included, it assumes that no restrictions are necessary. It has one 
    /// optional attribute.
    public var mediaRating: MediaRating?
    
    /// The title of the particular media object. It has one optional attribute.
    public var mediaTitle: MediaTitle?
    
    /// Short description describing the media object typically a sentence in 
    /// length. It has one optional attribute.
    public var mediaDescription: MediaDescription?
    
    /// Highly relevant keywords describing the media object with typically a 
    /// maximum of 10 words. The keywords and phrases should be comma-delimited.
    public var mediaKeywords: [String]?
    
    /// Allows particular images to be used as representative images for the 
    /// media object. If multiple thumbnails are included, and time coding is not 
    /// at play, it is assumed that the images are in order of importance. It has 
    /// one required attribute and three optional attributes.
    public var mediaThumbnails: [MediaThumbnail]?
    
    /// Allows a taxonomy to be set that gives an indication of the type of media 
    /// content, and its particular contents. It has two optional attributes.
    public var mediaCategory: MediaCategory?
    
    /// This is the hash of the binary media file. It can appear multiple times as 
    /// long as each instance is a different algo. It has one optional attribute.
    public var mediaHash: MediaHash?
    
    /// Allows the media object to be accessed through a web browser media player 
    /// console. This element is required only if a direct media url attribute is 
    /// not specified in the <media:content> element. It has one required attribute 
    /// and two optional attributes.
    public var mediaPlayer: MediaPlayer?
    
    /// Notable entity and the contribution to the creation of the media object. 
    /// Current entities can include people, companies, locations, etc. Specific 
    /// entities can have multiple roles, and several entities can have the same 
    /// role. These should appear as distinct <media:credit> elements. It has two 
    /// optional attributes.
    public var mediaCredits: [MediaCredit]?
    
    /// Copyright information for the media object. It has one optional attribute.
    public var mediaCopyright: MediaCopyright?
    
    /// Allows the inclusion of a text transcript, closed captioning or lyrics of 
    /// the media content. Many of these elements are permitted to provide a time 
    /// series of text. In such cases, it is encouraged, but not required, that the
    /// elements be grouped by language and appear in time sequence order based on 
    /// the start time. Elements can have overlapping start and end times. It has 
    /// four optional attributes.
    public var mediaText: MediaText?
    
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
    public var mediaRestriction: MediaRestriction?
    
    /// This element stands for the community related content. This allows 
    /// inclusion of the user perception about a media object in the form of view 
    /// count, ratings and tags.
    public var mediaCommunity: MediaCommunity?
    
    /// Allows inclusion of all the comments a media object has received.
    public var mediaComments: [String]?
    
    /// Sometimes player-specific embed code is needed for a player to play any 
    /// video. <media:embed> allows inclusion of such information in the form of 
    /// key-value pairs.
    public var mediaEmbed: MediaEmbed?
    
    /// Allows inclusion of a list of all media responses a media object has 
    /// received.
    public var mediaResponses: [String]?
    
    /// Allows inclusion of all the URLs pointing to a media object.
    public var mediaBackLinks: [String]?
    
    /// Optional tag to specify the status of a media object -- whether it's still 
    /// active or it has been blocked/deleted.
    public var mediaStatus: MediaStatus?
    
    /// Optional tag to include pricing information about a media object. If this 
    /// tag is not present, the media object is supposed to be free. One media 
    /// object can have multiple instances of this tag for including different 
    /// pricing structures. The presence of this tag would mean that media object 
    /// is not free.
    public var mediaPrices: [MediaPrice]?
    
    /// Optional link to specify the machine-readable license associated with the 
    /// content.
    public var mediaLicense: MediaLicence?
    
    /// Optional link to specify the machine-readable license associated with the 
    /// content.
    public var mediaSubTitle: MediaSubTitle?
    
    /// Optional element for P2P link.
    public var mediaPeerLink: MediaPeerLink?
    
    /// Optional element to specify geographical information about various 
    /// locations captured in the content of a media object. The format conforms
    /// to geoRSS.
    public var mediaLocation: MediaLocation?
    
    /// Optional element to specify the rights information of a media object.
    public var mediaRights: MediaRights?
    
    /// Optional element to specify various scenes within a media object. It can 
    /// have multiple child <media:scene> elements, where each <media:scene> 
    /// element contains information about a particular scene. <media:scene> has 
    /// the optional sub-elements <sceneTitle>, <sceneDescription>, 
    /// <sceneStartTime> and <sceneEndTime>, which contains title, description, 
    /// start and end time of a particular scene in the media, respectively.
    public var mediaScenes: [MediaScene]?
    
    
}

// MARK: - Equatable

extension MediaNamespace: Equatable {
    
    public static func ==(lhs: MediaNamespace, rhs: MediaNamespace) -> Bool {
        return
            lhs.mediaGroup == rhs.mediaGroup &&
            lhs.mediaContents == rhs.mediaContents &&
            lhs.mediaRating == rhs.mediaRating &&
            lhs.mediaTitle == rhs.mediaTitle &&
            lhs.mediaDescription == rhs.mediaDescription &&
            lhs.mediaKeywords == rhs.mediaKeywords &&
            lhs.mediaThumbnails == rhs.mediaThumbnails &&
            lhs.mediaCategory == rhs.mediaCategory &&
            lhs.mediaHash == rhs.mediaHash &&
            lhs.mediaPlayer == rhs.mediaPlayer &&
            lhs.mediaCredits == rhs.mediaCredits &&
            lhs.mediaCopyright == rhs.mediaCopyright &&
            lhs.mediaText == rhs.mediaText &&
            lhs.mediaRestriction == rhs.mediaRestriction &&
            lhs.mediaCommunity == rhs.mediaCommunity &&
            lhs.mediaComments == rhs.mediaComments &&
            lhs.mediaEmbed == rhs.mediaEmbed &&
            lhs.mediaResponses == rhs.mediaResponses &&
            lhs.mediaBackLinks == rhs.mediaBackLinks &&
            lhs.mediaStatus == rhs.mediaStatus &&
            lhs.mediaPrices == rhs.mediaPrices &&
            lhs.mediaLicense == rhs.mediaLicense &&
            lhs.mediaSubTitle == rhs.mediaSubTitle &&
            lhs.mediaPeerLink == rhs.mediaPeerLink &&
            lhs.mediaLocation == rhs.mediaLocation &&
            lhs.mediaRights == rhs.mediaRights &&
            lhs.mediaScenes == rhs.mediaScenes
    }
    
}


