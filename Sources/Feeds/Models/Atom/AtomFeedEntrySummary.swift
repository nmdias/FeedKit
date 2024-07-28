//
//  AtomFeedEntrySummary.swift
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

/// The "atom:summary" element is a Text construct that conveys a short
/// summary, abstract, or excerpt of an enactry.
/// 
/// atomSummary = element atom:summary { atomTextConstruct }
/// 
/// It is not advisable for the atom:summary element to duplicate
/// atom:title or atom:content because Atom Processors might assume there
/// is a useful summary when there is none.
public struct AtomFeedEntrySummary {
    /// Text constructs MAY have a "type" attribute.  When present, the value
    /// MUST be one of "text", "html", or "xhtml".  If the "type" attribute
    /// is not provided, Atom Processors MUST behave as though it were
    /// present with a value of "text".
    public var type: String?
        
    /// The element's value.
    public var summary: String?
    
    public init() { }
    
}

// MARK: - Equatable

extension AtomFeedEntrySummary: Equatable {
    
    public static func ==(lhs: AtomFeedEntrySummary, rhs: AtomFeedEntrySummary) -> Bool {
        return
            lhs.type == rhs.type &&
            lhs.summary == rhs.summary
    }
    
}


extension AtomFeedEntrySummary: Codable {
    
    enum CodingKeys: String, CodingKey {
        case type
        case summary
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(summary, forKey: .summary)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        summary = try container.decodeIfPresent(String.self, forKey: .summary)
    }
}
