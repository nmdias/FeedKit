//
//  MediaHash.swift
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

/// This is the hash of the binary media file. It can appear multiple times as
/// long as each instance is a different algo. It has one optional attribute.
public struct MediaHash {
    
    /// This is the hash of the binary media file. It can appear multiple times as long as
    /// each instance is a different algo. It has one optional attribute.
    public var algo: String?
    
    /// The element's value.
    public var hash: String?
    
    public init() { }
    
}

// MARK: - Equatable

extension MediaHash: Equatable {
    
    public static func ==(lhs: MediaHash, rhs: MediaHash) -> Bool {
        return lhs.hash == rhs.hash &&
        lhs.algo == rhs.algo
    }
    
}

// MARK: - Codable

extension MediaHash: Codable {
    
    enum CodingKeys: String, CodingKey {
        case algo
        case hash
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(algo, forKey: .algo)
        try container.encode(hash, forKey: .hash)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        algo = try container.decodeIfPresent(String.self, forKey: .algo)
        hash = try container.decodeIfPresent(String.self, forKey: .hash)
    }
}

