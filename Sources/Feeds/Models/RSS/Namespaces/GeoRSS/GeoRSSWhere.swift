//
//  File.swift
//  
//
//  Created by Axel Martinez on 28/7/24.
//

import Foundation

public struct GeoRSSWhere {
    // MARK: - Namespaces
    
    public var gml: GMLNamespace?
        
    public init() { }
    
}

// MARK: - Equatable

extension GeoRSSWhere: Equatable {
    
    public static func ==(lhs: GeoRSSWhere, rhs: GeoRSSWhere) -> Bool {
        return lhs.gml == rhs.gml
    }
    
}

// MARK: - Codable

extension GeoRSSWhere: Codable {
    
    enum CodingKeys: String, CodingKey {
        case gml
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(gml, forKey: .gml)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        gml = try container.decodeIfPresent(GMLNamespace.self, forKey: .gml)
    }
}
