//
//  MediaRating.swift
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

/// This allows the permissible audience to be declared. If this element is not 
/// included, it assumes that no restrictions are necessary. It has one optional 
/// attribute.
public struct MediaRating {
        
    /// The URI that identifies the rating scheme. It is an optional attribute.
    /// If this attribute is not included, the default scheme is urn:simple (adult | nonadult).
    public var scheme: String?
        
    /// The element's value.
    public var rating: String?
    
    public init() { }

}

// MARK: - Equatable

extension MediaRating: Equatable {
    
    public static func ==(lhs: MediaRating, rhs: MediaRating) -> Bool {
        return lhs.rating == rhs.rating &&
            lhs.scheme == rhs.scheme
    }
    
}

// MARK: - Codable

extension MediaRating: Codable {
    
    enum CodingKeys: String, CodingKey {
        case scheme
        case rating
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(scheme, forKey: .scheme)
        try container.encode(rating, forKey: .rating)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        scheme = try container.decodeIfPresent(String.self, forKey: .scheme)
        rating = try container.decodeIfPresent(String.self, forKey: .rating)
    }
}