//
//  MediaPrice.swift
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

/// Optional tag to include pricing information about a media object. If this
/// tag is not present, the media object is supposed to be free. One media
/// object can have multiple instances of this tag for including different
/// pricing structures. The presence of this tag would mean that media object
/// is not free.
public struct MediaPrice {
    
    /// Valid values are "rent", "purchase", "package" or "subscription". If
    /// nothing is specified, then the media is free.
    public var type: String?
    
    /// The price of the media object. This is an optional attribute.
    public var price: Double?
    
    /// If the type is "package" or "subscription", then info is a URL pointing
    /// to package or subscription information. This is an optional attribute.
    public var info: String?
    
    /// Use [ISO 4217] for currency codes. This is an optional attribute.
    public var currency: String?
    
    /// The element's value.
    public var value: String?
    
    public init() { }
    
}

// MARK: - Equatable

extension MediaPrice: Equatable {
    
    public static func ==(lhs: MediaPrice, rhs: MediaPrice) -> Bool {
        return lhs.value == rhs.value &&
        lhs.currency == rhs.currency &&
        lhs.info == rhs.info &&
        lhs.price == rhs.price &&
        lhs.type == rhs.type
    }
}

// MARK: - Codable

extension MediaPrice: Codable {
    
    enum CodingKeys: String, CodingKey {
        case type
        case price
        case info
        case currency
        case value
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(price, forKey: .price)
        try container.encode(info, forKey: .info)
        try container.encode(currency, forKey: .currency)
        try container.encode(value, forKey: .value)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        price = try container.decodeIfPresent(Double.self, forKey: .price)
        info = try container.decodeIfPresent(String.self, forKey: .info)
        currency = try container.decodeIfPresent(String.self, forKey: .currency)
        value = try container.decodeIfPresent(String.self, forKey: .value)
    }
}
