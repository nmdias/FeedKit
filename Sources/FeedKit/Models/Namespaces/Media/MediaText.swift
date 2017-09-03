//
//  MediaText.swift
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

/// Allows the inclusion of a text transcript, closed captioning or lyrics of
/// the media content. Many of these elements are permitted to provide a time
/// series of text. In such cases, it is encouraged, but not required, that the
/// elements be grouped by language and appear in time sequence order based on
/// the start time. Elements can have overlapping start and end times. It has
/// four optional attributes.
public class MediaText {
    
    /// The element's attributes.
    public class Attributes {
        
        /// Specifies the type of text embedded. Possible values are either "plain"
        /// or "html". Default value is "plain". All HTML must be entity-encoded. 
        /// It is an optional attribute.
        public var type: String?
        
        /// The primary language encapsulated in the media object. Language codes 
        /// possible are detailed in RFC 3066. This attribute is used similar to 
        /// the xml:lang attribute detailed in the XML 1.0 Specification (Third 
        /// Edition). It is an optional attribute.
        public var lang: String?
        
        /// Specifies the start time offset that the text starts being relevant to 
        /// the media object. An example of this would be for closed captioning. 
        /// It uses the NTP time code format (see: the time attribute used in 
        /// <media:thumbnail>). It is an optional attribute.
        public var start: String?
        
        /// Specifies the end time that the text is relevant. If this attribute is 
        /// not provided, and a start time is used, it is expected that the end 
        /// time is either the end of the clip or the start of the next 
        /// <media:text> element.
        public var end: String?
        
    }
    
    /// The element's attributes.
    public var attributes: Attributes?
    
    /// The element's value.
    public var value: String?
    
}

// MARK: - Initializers

extension MediaText {

    convenience init(attributes attributeDict: [String : String]) {
        self.init()
        self.attributes = MediaText.Attributes(attributes: attributeDict)
    }
    
}


extension MediaText.Attributes {
    
    convenience init?(attributes attributeDict: [String : String]) {
        
        if attributeDict.isEmpty {
            return nil
        }
        
        self.init()
        
        self.type = attributeDict["type"]
        self.lang = attributeDict["lang"]
        self.start = attributeDict["start"]
        self.end = attributeDict["end"]
        
    }
    
}

// MARK: - Equatable

extension MediaText: Equatable {
    
    public static func ==(lhs: MediaText, rhs: MediaText) -> Bool {
        return
            lhs.value == rhs.value &&
            lhs.attributes == rhs.attributes
    }
    
}

extension MediaText.Attributes: Equatable {
    
    public static func ==(lhs: MediaText.Attributes, rhs: MediaText.Attributes) -> Bool {
        return
            lhs.type == rhs.type &&
            lhs.lang == rhs.lang &&
            lhs.start == rhs.start &&
            lhs.end == rhs.end
    }
    
}
