//
//  MediaLicence.swift
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

/// Optional link to specify the machine-readable license associated with the
/// content.
public struct MediaLicence {

    /// The licence type.
    public var type: String?
    
    /// The location of the licence.
    public var href: String?
    
    /// The element's value.
    public var license: String?
    
    public init() { }
    
}

// MARK: - Equatable

extension MediaLicence: Equatable {
    
    public static func ==(lhs: MediaLicence, rhs: MediaLicence) -> Bool {
        return lhs.license == rhs.license &&
        lhs.type == rhs.type &&
        lhs.href == rhs.href
    }
    
}

// MARK: - Codable

extension MediaLicence: Codable {
    
    enum CodingKeys: String, CodingKey {
        case type
        case href
        case license
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(href, forKey: .href)
        try container.encode(license, forKey: .license)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        href = try container.decodeIfPresent(String.self, forKey: .href)
        license = try container.decodeIfPresent(String.self, forKey: .license)
    }
}
