//
//  MediaCredit.swift
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

/// Notable entity and the contribution to the creation of the media object.
/// Current entities can include people, companies, locations, etc. Specific
/// entities can have multiple roles, and several entities can have the same
/// role. These should appear as distinct <media:credit> elements. It has two
/// optional attributes.
public struct MediaCredit {
    /// Specifies the role the entity played. Must be lowercase. It is an
    /// optional attribute.
    public var role: String?
    
    /// The URI that identifies the role scheme. It is an optional attribute
    /// and possible values for this attribute are ( urn:ebu | urn:yvs ) . The
    /// default scheme is "urn:ebu". The list of roles supported under urn:ebu
    /// scheme can be found at European Broadcasting Union Role Codes. The
    /// roles supported under urn:yvs scheme are ( uploader | owner ).
    public var scheme: String?
    
    /// The element's value.
    public var credit: String?
    
    public init() { }
}

// MARK: - Equatable

extension MediaCredit: Equatable {
    
    public static func ==(lhs: MediaCredit, rhs: MediaCredit) -> Bool {
        return lhs.credit == rhs.credit &&
        lhs.scheme == rhs.scheme &&
        lhs.role == rhs.role
    }
    
}

// MARK: - Codable

extension MediaCredit: Codable {
    
    enum CodingKeys: String, CodingKey {
        case role
        case scheme
        case credit
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(role, forKey: .role)
        try container.encode(scheme, forKey: .scheme)
        try container.encode(credit, forKey: .credit)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        role = try container.decodeIfPresent(String.self, forKey: .role)
        scheme = try container.decodeIfPresent(String.self, forKey: .scheme)
        credit = try container.decodeIfPresent(String.self, forKey: .credit)
    }
}

