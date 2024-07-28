//
//  AtomFeedGenerator.swift
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

/// The "atom:generator" element's content identifies the agent used to
/// generate a feed, for debugging and other purposes.
///
/// The content of this element, when present, MUST be a string that is a
/// human-readable name for the generating agent.  Entities such as
/// "&amp;" and "&lt;" represent their corresponding characters ("&" and
/// "<" respectively), not markup.
///
/// The atom:generator element MAY have a "uri" attribute whose value
/// MUST be an IRI reference [RFC3987].  When dereferenced, the resulting
/// URI (mapped from an IRI, if necessary) SHOULD produce a
/// representation that is relevant to that agent.
///
/// The atom:generator element MAY have a "version" attribute that
/// indicates the version of the generating agent.
public struct AtomFeedGenerator {
    /// The atom:generator element MAY have a "uri" attribute whose value
    /// MUST be an IRI reference [RFC3987].  When dereferenced, the resulting
    /// URI (mapped from an IRI, if necessary) SHOULD produce a
    /// representation that is relevant to that agent.
    public var uri: String?
    
    /// The atom:generator element MAY have a "version" attribute that
    /// indicates the version of the generating agent.
    public var version: String?
    
    /// The element's value.
    public var generator: String?
    
    public init() { }
}

// MARK: - Equatable

extension AtomFeedGenerator: Equatable {
    public static func ==(lhs: AtomFeedGenerator, rhs: AtomFeedGenerator) -> Bool {
        return lhs.uri == rhs.uri &&
            lhs.version == rhs.version &&
            lhs.generator == rhs.generator
    }
}

// MARK: - Codable

extension AtomFeedGenerator: Codable {
    
    enum CodingKeys: String, CodingKey {
        case uri
        case version
        case generator
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uri, forKey: .uri)
        try container.encode(version, forKey: .version)
        try container.encode(generator, forKey: .generator)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uri = try container.decodeIfPresent(String.self, forKey: .uri)
        version = try container.decodeIfPresent(String.self, forKey: .version)
        generator = try container.decodeIfPresent(String.self, forKey: .generator)
    }
}

