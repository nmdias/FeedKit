//
//  MediaPeerLink.swift
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

/// Optional element for P2P link.
public struct MediaPeerLink {
        
    /// The peer link's type.
    public var type: String?
        
    /// The location of the peer link provider.
    public var href: String?
    
    /// The element's value.
    public var value: String?
    
    public init() { }

}

// MARK: - Equatable

extension MediaPeerLink: Equatable {
    
    public static func ==(lhs: MediaPeerLink, rhs: MediaPeerLink) -> Bool {
        return
            lhs.value == rhs.value &&
            lhs.type == rhs.type &&
            lhs.href == rhs.href
    }
    
}

// MARK: - Codable

extension MediaPeerLink: Codable {
    
    enum CodingKeys: String, CodingKey {
        case type
        case href
        case value
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(href, forKey: .href)
        try container.encode(value, forKey: .value)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        href = try container.decodeIfPresent(String.self, forKey: .href)
        value = try container.decodeIfPresent(String.self, forKey: .value)
    }
}

