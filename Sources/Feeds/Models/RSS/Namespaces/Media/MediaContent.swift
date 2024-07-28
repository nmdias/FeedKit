//
//  MediaContent.swift
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

/// <media:content> is a sub-element of either <item> or <media:group>.
/// Media objects that are not the same content should not be included
/// in the same <media:group> element. The sequence of these items implies
/// the order of presentation. While many of the attributes appear to be
/// audio/video specific, this element can be used to publish any type of
/// media. It contains 14 attributes, most of which are optional.
public struct MediaContent {
    
    /// The title of the particular media object. It has one optional attribute.
    public var mediaTitle: MediaTitle?
    
    /// Short description describing the media object typically a sentence in
    /// length. It has one optional attribute.
    public var mediaDescription: MediaDescription?
    
    /// Allows the media object to be accessed through a web browser media player
    /// console. This element is required only if a direct media url attribute is
    /// not specified in the <media:content> element. It has one required attribute
    /// and two optional attributes.
    public var mediaPlayer: MediaPlayer?
    
    /// Allows particular images to be used as representative images for the
    /// media object. If multiple thumbnails are included, and time coding is not
    /// at play, it is assumed that the images are in order of importance. It has
    /// one required attribute and three optional attributes.
    public var mediaThumbnails: [MediaThumbnail]?
    
    /// Highly relevant keywords describing the media object with typically a
    /// maximum of 10 words. The keywords and phrases should be comma-delimited.
    public var mediaKeywords: [String]?
    
    /// Allows a taxonomy to be set that gives an indication of the type of media
    /// content, and its particular contents. It has two optional attributes.
    public var mediaCategory: MediaCategory?
    
    
    /// Should specify the direct URL to the media object. If not included,
    /// a <media:player> element must be specified.
    public var url: String?
    
    /// The number of bytes of the media object. It is an optional
    /// attribute.
    public var fileSize: Int?
    
    /// The standard MIME type of the object. It is an optional attribute.
    public var type: String?
    
    /// Tpe of object (image | audio | video | document | executable).
    /// While this attribute can at times seem redundant if type is supplied,
    /// it is included because it simplifies decision making on the reader
    /// side, as well as flushes out any ambiguities between MIME type and
    /// object type. It is an optional attribute.
    public var medium: String?
    
    /// Determines if this is the default object that should be used for
    /// the <media:group>. There should only be one default object per
    /// <media:group>. It is an optional attribute.
    public var isDefault: Bool?
    
    /// Determines if the object is a sample or the full version of the
    /// object, or even if it is a continuous stream (sample | full | nonstop).
    /// Default value is "full". It is an optional attribute.
    public var expression: String?
    
    /// The kilobits per second rate of media. It is an optional attribute.
    public var bitrate: Int?
    
    /// The number of frames per second for the media object. It is an
    /// optional attribute.
    public var framerate: Double?
    
    /// The number of samples per second taken to create the media object.
    /// It is expressed in thousands of samples per second (kHz).
    /// It is an optional attribute.
    public var samplingrate: Double?
    
    /// The number of audio channels in the media object. It is an
    /// optional attribute.
    public var channels: Int?
    
    /// The number of seconds the media object plays. It is an
    /// optional attribute.
    public var duration: Int?
    
    /// The height of the media object. It is an optional attribute.
    public var height: Int?
    
    /// The width of the media object. It is an optional attribute.
    public var width: Int?
    
    /// The primary language encapsulated in the media object.
    /// Language codes possible are detailed in RFC 3066. This attribute
    /// is used similar to the xml:lang attribute detailed in the
    /// XML 1.0 Specification (Third Edition). It is an optional
    /// attribute.
    public var lang: String?
    
    
    public init() { }
    
}

// MARK: - Equatable

extension MediaContent: Equatable {
    
    public static func ==(lhs: MediaContent, rhs: MediaContent) -> Bool {
        return lhs.mediaTitle == rhs.mediaTitle &&
        lhs.mediaDescription == rhs.mediaDescription &&
        lhs.mediaPlayer == rhs.mediaPlayer &&
        lhs.mediaThumbnails == rhs.mediaThumbnails &&
        lhs.mediaKeywords == rhs.mediaKeywords &&
        lhs.mediaCategory == rhs.mediaCategory &&
        lhs.bitrate == rhs.bitrate &&
        lhs.channels == rhs.channels &&
        lhs.duration == rhs.duration &&
        lhs.expression == rhs.expression &&
        lhs.isDefault == rhs.isDefault &&
        lhs.fileSize == rhs.fileSize &&
        lhs.framerate == rhs.framerate &&
        lhs.height == rhs.height &&
        lhs.lang == rhs.lang &&
        lhs.medium == rhs.medium &&
        lhs.samplingrate == rhs.samplingrate &&
        lhs.type == rhs.type &&
        lhs.url == rhs.url &&
        lhs.width == rhs.width
    }
    
}

// MARK: - Codable

extension MediaContent: Codable {
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case player
        case thumbnail
        case keywords
        case category
        case bitrate
        case channels
        case duration
        case expression
        case isDefault
        case fileSize
        case framerate
        case height
        case lang
        case medium
        case samplingrate
        case type
        case url
        case width
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mediaTitle, forKey: .title)
        try container.encode(mediaDescription, forKey: .description)
        try container.encode(mediaPlayer, forKey: .player)
        try container.encode(mediaThumbnails, forKey: .thumbnail)
        try container.encode(mediaKeywords, forKey: .keywords)
        try container.encode(mediaCategory, forKey: .category)
        try container.encode(bitrate, forKey: .bitrate)
        try container.encode(channels, forKey: .channels)
        try container.encode(duration, forKey: .duration)
        try container.encode(expression, forKey: .expression)
        try container.encode(isDefault, forKey: .isDefault)
        try container.encode(fileSize, forKey: .fileSize)
        try container.encode(framerate, forKey: .framerate)
        try container.encode(height, forKey: .height)
        try container.encode(lang, forKey: .lang)
        try container.encode(medium, forKey: .medium)
        try container.encode(samplingrate, forKey: .samplingrate)
        try container.encode(type, forKey: .type)
        try container.encode(url, forKey: .url)
        try container.encode(width, forKey: .width)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mediaTitle = try container.decodeIfPresent(MediaTitle.self, forKey: .title)
        mediaDescription = try container.decodeIfPresent(MediaDescription.self, forKey: .description)
        mediaPlayer = try container.decodeIfPresent(MediaPlayer.self, forKey: .player)
        mediaThumbnails = try container.decodeIfPresent([MediaThumbnail].self, forKey: .thumbnail)
        mediaKeywords = try container.decodeIfPresent([String].self, forKey: .keywords)
        isDefault = try container.decodeIfPresent(Bool.self, forKey: .isDefault)
        mediaCategory = try container.decodeIfPresent(MediaCategory.self, forKey: .category)
        bitrate = try container.decodeIfPresent(Int.self, forKey: .bitrate)
        channels = try container.decodeIfPresent(Int.self, forKey: .channels)
        duration = try container.decodeIfPresent(Int.self, forKey: .duration)
        expression = try container.decodeIfPresent(String.self, forKey: .expression)
        fileSize = try container.decodeIfPresent(Int.self, forKey: .fileSize)
        framerate = try container.decodeIfPresent(Double.self, forKey: .framerate)
        height = try container.decodeIfPresent(Int.self, forKey: .height)
        lang = try container.decodeIfPresent(String.self, forKey: .lang)
        medium = try container.decodeIfPresent(String.self, forKey: .medium)
        samplingrate = try container.decodeIfPresent(Double.self, forKey: .samplingrate)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        width = try container.decodeIfPresent(Int.self, forKey: .width)
    }
}
