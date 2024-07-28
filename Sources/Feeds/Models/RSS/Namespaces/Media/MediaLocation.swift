//
//  MediaLocation.swift
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

/// Optional element to specify geographical information about various
/// locations captured in the content of a media object. The format conforms
/// to geoRSS.
public struct MediaLocation {
    
    /// Description of the place whose location is being specified.
    public var description: String?
    
    /// Time at which the reference to a particular location starts in the
    /// media object.
    public var start: TimeInterval?
    
    /// Time at which the reference to a particular location ends in the media
    /// object.
    public var end: TimeInterval?
    
    // MARK: - Namespaces
    
    public var georss : GeoRSSNamespace?
    
    public init() { }
    
}

// MARK: - Equatable

extension MediaLocation: Equatable {
    
    public static func ==(lhs: MediaLocation, rhs: MediaLocation) -> Bool {
        return lhs.georss == rhs.georss &&
        lhs.start == rhs.start &&
        lhs.end == rhs.end &&
        lhs.description == rhs.description
    }
    
}

// MARK: - Codable

extension MediaLocation: Codable {
    
    enum CodingKeys: String, CodingKey {
        case description
        case start
        case end
        case latitude
        case longitude
        case georss
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(description, forKey: .description)
        try container.encode(start, forKey: .start)
        try container.encode(end, forKey: .end)
        try container.encode(georss, forKey: .georss)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        start = try container.decodeIfPresent(String.self, forKey: .start)?.toDuration()
        end = try container.decodeIfPresent(String.self, forKey: .end)?.toDuration()
        georss = try container.decodeIfPresent(GeoRSSNamespace.self, forKey: .georss)
    }
}
