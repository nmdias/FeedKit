//
//  AtomFeedSubtitle.swift
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

/// The "atom:subtitle" element is a Text construct that conveys a human-
/// readable description or subtitle for a feed.
public struct AtomFeedSubtitle {

    /// Text constructs MAY have a "type" attribute.  When present, the value
    /// MUST be one of "text", "html", or "xhtml".  If the "type" attribute
    /// is not provided, Atom Processors MUST behave as though it were
    /// present with a value of "text".
    public var type: String?

    /// The element's value.
    public var subtitle: String?
    
    public init() { }

}

// MARK: - Equatable
extension AtomFeedSubtitle: Equatable {
    
    public static func ==(lhs: AtomFeedSubtitle, rhs: AtomFeedSubtitle) -> Bool {
        return lhs.type == rhs.type && 
        lhs.subtitle == rhs.subtitle
    }
    
}

// MARK: - Codable

extension AtomFeedSubtitle: Codable {
    
    enum CodingKeys: String, CodingKey {
        case type
        case subtitle
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(subtitle, forKey: .subtitle)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
    }
}
