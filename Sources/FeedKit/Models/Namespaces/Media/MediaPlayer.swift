//
//  MediaPlayer.swift
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

/// Allows the media object to be accessed through a web browser media player
/// console. This element is required only if a direct media url attribute is
/// not specified in the <media:content> element. It has one required attribute
/// and two optional attributes.
public class MediaPlayer {
    
    /// The element's attributes.
    public class Attributes {
        
        /// The URL of the player console that plays the media. It is a required attribute.
        public var url: String?
        
        /// The width of the browser window that the URL should be opened in. It is 
        /// an optional attribute.
        public var width: Int?
        
        /// The height of the browser window that the URL should be opened in. It is an 
        /// optional attribute.
        public var height: Int?
        
    }
    
    /// The element's attributes.
    public var attributes: Attributes?
    
    /// The element's value.
    public var value: String?
    
    public init() { }

}

// MARK: - Initializers

extension MediaPlayer {
    
    convenience init(attributes attributeDict: [String : String]) {
        self.init()
        self.attributes = MediaPlayer.Attributes(attributes: attributeDict)
    }
    
}


extension MediaPlayer.Attributes {
    
    convenience init?(attributes attributeDict: [String : String]) {
        
        if attributeDict.isEmpty {
            return nil
        }
        
        self.init()
        
        self.url = attributeDict["url"]
        self.height = Int(attributeDict["height"] ?? "")
        self.width = Int(attributeDict["width"] ?? "")
        
    }
    
}

// MARK: - Equatable

extension MediaPlayer: Equatable {
    
    public static func ==(lhs: MediaPlayer, rhs: MediaPlayer) -> Bool {
        return
            lhs.value == rhs.value &&
            lhs.attributes == rhs.attributes
    }
    
}

extension MediaPlayer.Attributes: Equatable {
    
    public static func ==(lhs: MediaPlayer.Attributes, rhs: MediaPlayer.Attributes) -> Bool {
        return
            lhs.width == rhs.width &&
            lhs.height == rhs.height &&
            lhs.url == rhs.url
    }
    
}
