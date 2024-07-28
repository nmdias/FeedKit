//
//  RSSFeedCategory.swift
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

/// The category of `<channel>`. Identifies a category or tag to which the feed 
/// belongs.
public struct RSSFeedCategory {
    /// A string that identifies a categorization taxonomy. It's an optional
    /// attribute of `<category>`. e.g. "http://www.fool.com/cusips"
    public var domain: String?

    /// The element's value.
    public var category: String?
    
    public init() { }
    
}

// MARK: - Equatable

extension RSSFeedCategory: Equatable {
    
    public static func ==(lhs: RSSFeedCategory, rhs: RSSFeedCategory) -> Bool {
        return
            lhs.category == rhs.category &&
            lhs.domain == rhs.domain
    }
    
}

// MARK: - Codable

extension RSSFeedCategory: Codable {
    
    enum CodingKeys: String, CodingKey {
        case domain
        case category
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(domain, forKey: .domain)
        try container.encode(category, forKey: .category)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        domain = try container.decodeIfPresent(String.self, forKey: .domain)
        category = try container.decodeIfPresent(String.self, forKey: .category)
    }
}
