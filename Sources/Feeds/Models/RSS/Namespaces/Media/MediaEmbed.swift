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
public struct MediaEmbed {
    
    /// The location of the embeded media.
    public var url: String?
    
    /// The width size for the embeded Media.
    public var width: Int?
    
    /// The height size for the embeded Media.
    public var height: Int?
    
    /// Key-Value pairs with aditional parameters for the embeded Media.
    public var mediaParams: [MediaParam]?
    
    public init() { }
    
}

// MARK: - Equatable

extension MediaEmbed: Equatable {
    
    public static func ==(lhs: MediaEmbed, rhs: MediaEmbed) -> Bool {
        return lhs.mediaParams == rhs.mediaParams &&
        lhs.url == rhs.url &&
        lhs.width == rhs.width &&
        lhs.height == rhs.height
    }
    
}

// MARK: - Codable

extension MediaEmbed: Codable {
    
    enum CodingKeys: String, CodingKey {
        case url
        case width
        case height
        case param
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(url, forKey: .url)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
        try container.encode(mediaParams, forKey: .param)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        width = try container.decodeIfPresent(Int.self, forKey: .width)
        height = try container.decodeIfPresent(Int.self, forKey: .height)
        mediaParams = try container.decodeIfPresent([MediaParam].self, forKey: .param)
    }
}
