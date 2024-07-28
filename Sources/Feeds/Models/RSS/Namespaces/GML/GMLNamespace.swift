//
//  File.swift
//
//
//  Created by Axel Martinez on 28/7/24.
//

import Foundation

public struct GMLNamespace {
    /// The image's url.
    public var points: [GMLPoint]?
        
    public init() { }
    
}

// MARK: - Equatable

extension GMLNamespace: Equatable {
    
    public static func ==(lhs: GMLNamespace, rhs: GMLNamespace) -> Bool {
        return lhs.points == rhs.points
    }
    
}

// MARK: - Codable

extension GMLNamespace: Codable {
    
    enum CodingKeys: String, CodingKey {
        case Point
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(points, forKey: .Point)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        points = try container.decodeIfPresent([GMLPoint].self, forKey: .Point)
    }
}
