//
//  MediaNamespace.swift
//
//  Copyright (c) 2017 Nuno Manuel Dias
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

/**
 
 Media RSS is a new RSS module that supplements the <enclosure> 
 capabilities of RSS 2.0. RSS enclosures are already being used to 
 syndicate audio files and images. Media RSS extends enclosures to 
 handle other media types, such as short films or TV, as well as 
 provide additional metadata with the media. Media RSS enables 
 content publishers and bloggers to syndicate multimedia content 
 such as TV and video clips, movies, images and audio.
 
 */
open class MediaNamespace {
    
    /**
     
     The <media:group> element is a sub-element of <item>. It allows grouping
     of <media:content> elements that are effectively the same content, 
     yet different representations. For instance: the same song recorded
     in both the WAV and MP3 format. It's an optional element that must 
     only be used for this purpose.
     
     */
    open var mediaGroup: MediaGroup?
    
    /**
     
     <media:content> is a sub-element of either <item> or <media:group>. 
     Media objects that are not the same content should not be included 
     in the same <media:group> element. The sequence of these items implies 
     the order of presentation. While many of the attributes appear to be 
     audio/video specific, this element can be used to publish any type of 
     media. It contains 14 attributes, most of which are optional.
     
     */
    open var mediaContents: [MediaContent]?
    
    /**
     
     This allows the permissible audience to be declared. If this element is not
     included, it assumes that no restrictions are necessary. It has one 
     optional attribute.
     
     */
    open var mediaRating: MediaRating?
    
    /**
     
     The title of the particular media object. It has one optional attribute.
     
     */
    open var mediaTitle: MediaTitle?
    
    /**
     
     Short description describing the media object typically a sentence in 
     length. It has one optional attribute.
     
     */
    open var mediaDescription: MediaDescription?
    
    /**
     
     Highly relevant keywords describing the media object with typically a 
     maximum of 10 words. The keywords and phrases should be comma-delimited.
     
     */
    open var mediaKeywords: [String]?
    
    /**
     
     Allows particular images to be used as representative images for the 
     media object. If multiple thumbnails are included, and time coding is not 
     at play, it is assumed that the images are in order of importance. It has 
     one required attribute and three optional attributes.
     
     */
    open var mediaThumbnails: [MediaThumbnail]?
    
    /**
     
     Allows a taxonomy to be set that gives an indication of the type of media 
     content, and its particular contents. It has two optional attributes.
     
     */
    open var mediaCategory: MediaCategory?
    
    /**
     
     This is the hash of the binary media file. It can appear multiple times as 
     long as each instance is a different algo. It has one optional attribute.
     
     */
    open var mediaHash: MediaHash?
    
    /**
     
     Allows the media object to be accessed through a web browser media player 
     console. This element is required only if a direct media url attribute is 
     not specified in the <media:content> element. It has one required attribute 
     and two optional attributes.
     
     */
    open var mediaPlayer: MediaPlayer?
    
    /**
     
     Notable entity and the contribution to the creation of the media object. 
     Current entities can include people, companies, locations, etc. Specific 
     entities can have multiple roles, and several entities can have the same 
     role. These should appear as distinct <media:credit> elements. It has two 
     optional attributes.
     
     */
    open var mediaCredits: [MediaCredit]?
    
    /**
     
     Copyright information for the media object. It has one optional attribute.
     
     */
    open var mediaCopyright: MediaCopyright?
    
    /**
     
     Allows the inclusion of a text transcript, closed captioning or lyrics of 
     the media content. Many of these elements are permitted to provide a time 
     series of text. In such cases, it is encouraged, but not required, that the
     elements be grouped by language and appear in time sequence order based on 
     the start time. Elements can have overlapping start and end times. It has 
     four optional attributes.
     
     */
    open var mediaText: MediaText?
    
    /**
     
     Allows restrictions to be placed on the aggregator rendering the media in 
     the feed. Currently, restrictions are based on distributor (URI), country 
     codes and sharing of a media object. This element is purely informational 
     and no obligation can be assumed or implied. Only one <media:restriction> 
     element of the same type can be applied to a media object -- all others 
     will be ignored. Entities in this element should be space-separated. 
     To allow the producer to explicitly declare his/her intentions, two 
     literals are reserved: "all", "none". These literals can only be used once.
     This element has one required attribute and one optional attribute (with 
     strict requirements for its exclusion).
     
     */
    open var mediaRestriction: MediaRestriction?
    
    /**
     
     This element stands for the community related content. This allows 
     inclusion of the user perception about a media object in the form of view 
     count, ratings and tags.
     
     */
    open var mediaCommunity: MediaCommunity?
    
    /**
     
     Allows inclusion of all the comments a media object has received.
     
     */
    open var mediaComments: [String]?
    
    /**
     
     Sometimes player-specific embed code is needed for a player to play any 
     video. <media:embed> allows inclusion of such information in the form of 
     key-value pairs.
     
     */
    open var mediaEmbed: MediaEmbed?
    
    /**
     
     Allows inclusion of a list of all media responses a media object has 
     received.
     
     */
    open var mediaResponses: [String]?
    
    /**
     
     Allows inclusion of all the URLs pointing to a media object.
     
     */
    open var mediaBackLinks: [String]?
    
    /**
     
     Optional tag to specify the status of a media object -- whether it's still 
     active or it has been blocked/deleted.
     
     */
    open var mediaStatus: MediaStatus?
    
    /**
     
     Optional tag to include pricing information about a media object. If this 
     tag is not present, the media object is supposed to be free. One media 
     object can have multiple instances of this tag for including different 
     pricing structures. The presence of this tag would mean that media object 
     is not free.
     
     */
    open var mediaPrices: [MediaPrice]?
    
    /**
     
     Optional link to specify the machine-readable license associated with the 
     content.
     
     */
    open var mediaLicense: MediaLicence?
    
    /**
     
     Optional link to specify the machine-readable license associated with the 
     content.
     
     */
    open var mediaSubTitle: MediaSubTitle?
    
    /**
     
     Optional element for P2P link.
     
     */
    open var mediaPeerLink: MediaPeerLink?
    
    /**
     
     Optional element to specify geographical information about various 
     locations captured in the content of a media object. The format conforms
     to geoRSS.
     
     */
    open var mediaLocation: MediaLocation?
    
    /**
     
     Optional element to specify the rights information of a media object.
     
     */
    open var mediaRights: MediaRights?
    
    /**
     
     Optional element to specify various scenes within a media object. It can 
     have multiple child <media:scene> elements, where each <media:scene> 
     element contains information about a particular scene. <media:scene> has 
     the optional sub-elements <sceneTitle>, <sceneDescription>, 
     <sceneStartTime> and <sceneEndTime>, which contains title, description, 
     start and end time of a particular scene in the media, respectively.
     
     */
    open var mediaScenes: [MediaScene]?
    
    
}

