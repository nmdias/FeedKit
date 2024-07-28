//
//  File.swift
//  
//
//  Created by Axel Martinez on 28/7/24.
//

import Foundation

public struct GMLPoint {
    public var position: String?
    
    public init() { }
    
}

// MARK: - Equatable

extension GMLPoint: Equatable {
    
    public static func ==(lhs: GMLPoint, rhs: GMLPoint) -> Bool {
        return lhs.position == rhs.position
    }
    
}

// MARK: - Codable

extension GMLPoint: Codable {
    
    enum CodingKeys: String, CodingKey {
        case pos
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(position, forKey: .pos)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        position = try container.decodeIfPresent(String.self, forKey: .pos)
    }
}
