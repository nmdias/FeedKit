//
//  GeoRSSNamespace.swift
//  
//
//  Created by Axel Martinez on 28/7/24.
//

import Foundation

public struct GeoRSSNamespace {
    /// The image's url.
    public var geoRSSWhere: GeoRSSWhere?
        
    public init() { }
    
}

// MARK: - Equatable

extension GeoRSSNamespace: Equatable {
    
    public static func ==(lhs: GeoRSSNamespace, rhs: GeoRSSNamespace) -> Bool {
        return lhs.geoRSSWhere == rhs.geoRSSWhere
    }
    
}

// MARK: - Codable

extension GeoRSSNamespace: Codable {
    
    enum CodingKeys: String, CodingKey {
        case `where`
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(geoRSSWhere, forKey: .where)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        geoRSSWhere = try container.decodeIfPresent(GeoRSSWhere.self, forKey: .where)
    }
}
