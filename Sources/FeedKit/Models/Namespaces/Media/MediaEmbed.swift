//
//  MediaEmbed.swift
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

/// Sometimes player-specific embed code is needed for a player to play any
/// video. <media:embed> allows inclusion of such information in the form of
/// key-value pairs.
public class MediaEmbed {
    
    /// The element's attributes.
    public class Attributes {
        
        /// The location of the embeded media.
        public var url: String?
        
        /// The width size for the embeded Media.
        public var width: Int?
        
        /// The height size for the embeded Media.
        public var height: Int?
        
    }
    
    /// The element's attributes.
    public var attributes: Attributes?
    
    /// Key-Value pairs with aditional parameters for the embeded Media.
    public var mediaParams: [MediaParam]?
    
    public init() { }

}

// MARK: - Initializers

extension MediaEmbed {

    convenience init(attributes attributeDict: [String : String]) {
        self.init()
        self.attributes = MediaEmbed.Attributes(attributes: attributeDict)
    }
    
}

extension MediaEmbed.Attributes {
    
    convenience init?(attributes attributeDict: [String : String]) {
        
        if attributeDict.isEmpty {
            return nil
        }
        
        self.init()
        
        self.url = attributeDict["url"]
        self.width = Int(attributeDict["width"] ?? "")
        self.height = Int(attributeDict["height"] ?? "")
        
    }
    
}

// MARK: - Equatable

extension MediaEmbed: Equatable {
    
    public static func ==(lhs: MediaEmbed, rhs: MediaEmbed) -> Bool {
        return
            lhs.mediaParams == rhs.mediaParams &&
            lhs.attributes == rhs.attributes
    }
    
}

extension MediaEmbed.Attributes: Equatable {
    
    public static func ==(lhs: MediaEmbed.Attributes, rhs: MediaEmbed.Attributes) -> Bool {
        return
            lhs.url == rhs.url &&
            lhs.width == rhs.width &&
            lhs.height == rhs.height
    }
    
}
