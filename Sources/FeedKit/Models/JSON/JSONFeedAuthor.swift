//
//  JSONFeedAuthor.swift
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

/// (optional, object) specifies the feed author. The author object has several 
/// members. These are all optional - but if you provide an author object, then at 
/// least one is required:
public struct JSONFeedAuthor {
    
    /// (optional, string) is the author's name.
    public var name: String?
    
    /// (optional, string) is the URL of a site owned by the author. It could be a 
    /// blog, micro-blog, Twitter account, and so on. Ideally the linked-to page 
    /// provides a way to contact the author, but that's not required. The URL 
    /// could be a mailto: link, though we suspect that will be rare.
    public var url: String?
    
    /// (optional, string) is the URL for an image for the author. As with icon, 
    /// it should be square and relatively large - such as 512 x 512 - and should 
    /// use transparency where appropriate, since it may be rendered on a non-white 
    /// background.
    public var avatar: String?

}

// MARK: - Equatable

extension JSONFeedAuthor: Equatable {}

// MARK: - Codable

extension JSONFeedAuthor: Codable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
        case avatar
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(url, forKey: .url)
        try container.encode(avatar, forKey: .avatar)
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        avatar = try values.decodeIfPresent(String.self, forKey: .avatar)
    }
    
}
