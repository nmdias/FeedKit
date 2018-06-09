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
public class MediaContent {
    
    /// The element's attributes.
    public class Attributes {
        
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
        
    }
    
    /// The element's attributes
    public var attributes: Attributes?
    
}

// MARK: - Initializers

extension MediaContent {
    
    convenience init(attributes attributeDict: [String : String]) {
        self.init()
        self.attributes = MediaContent.Attributes(attributes: attributeDict)
    }
    
}

extension MediaContent.Attributes {
    
    convenience init?(attributes attributeDict: [String : String]) {
        
        if attributeDict.isEmpty {
            return nil
        }
        
        self.init()
        
        self.url = attributeDict["url"]
        self.fileSize = Int(attributeDict["fileSize"] ?? "")
        self.type = attributeDict["type"]
        self.medium = attributeDict["medium"]
        self.isDefault = attributeDict["isDefault"]?.toBool()
        self.expression = attributeDict["expression"]
        self.bitrate = Int(attributeDict["bitrate"] ?? "")
        self.framerate = Double(attributeDict["framerate"] ?? "")
        self.samplingrate = Double(attributeDict["samplingrate"] ?? "")
        self.channels = Int(attributeDict["channels"] ?? "")
        self.duration = Int(attributeDict["duration"] ?? "")
        self.height = Int(attributeDict["height"] ?? "")
        self.width = Int(attributeDict["width"] ?? "")
        self.lang = attributeDict["lang"]
        
    }
    
}

// MARK: - Equatable

extension MediaContent: Equatable {
    
    public static func ==(lhs: MediaContent, rhs: MediaContent) -> Bool {
        return lhs.attributes == rhs.attributes
    }
    
}

extension MediaContent.Attributes: Equatable {
    
    public static func ==(lhs: MediaContent.Attributes, rhs: MediaContent.Attributes) -> Bool {
        return
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
