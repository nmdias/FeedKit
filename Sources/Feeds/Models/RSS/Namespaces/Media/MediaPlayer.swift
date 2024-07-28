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
public struct MediaPlayer {
        
    /// The URL of the player console that plays the media. It is a required attribute.
    public var url: String?
        
    /// The width of the browser window that the URL should be opened in. It is
    /// an optional attribute.
    public var width: Int?
        
    /// The height of the browser window that the URL should be opened in. It is an
    /// optional attribute.
    public var height: Int?
        
    /// The element's value.
    public var value: String?
    
    public init() { }

}

// MARK: - Equatable

extension MediaPlayer: Equatable {
    
    public static func ==(lhs: MediaPlayer, rhs: MediaPlayer) -> Bool {
        return lhs.value == rhs.value &&
            lhs.height == rhs.height &&
            lhs.width == rhs.width &&
            lhs.url == rhs.url
    }
    
}

// MARK: - Codable

extension MediaPlayer: Codable {
    
    enum CodingKeys: String, CodingKey {
        case url
        case width
        case height
        case value
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(url, forKey: .url)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
        try container.encode(value, forKey: .value)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        width = try container.decodeIfPresent(Int.self, forKey: .width)
        height = try container.decodeIfPresent(Int.self, forKey: .height)
        value = try container.decodeIfPresent(String.self, forKey: .value)
    }
}
