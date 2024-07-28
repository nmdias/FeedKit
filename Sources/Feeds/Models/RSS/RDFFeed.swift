//
//  File.swift
//  
//
//  Created by Axel Martinez on 24/7/24.
//

import Foundation

/// Describes the individual path for each XML DOM element of an RDF feed
///
/// See http://www.rssboard.org/rss-0-9-0
public struct RDFFeed: Feed {
    /// Contains information about the channel (metadata) and its contents.
    public var channel: RSSFeedChannel?
    
    /// Contains information about the items
    public var items: [RSSFeedItem]?
    
    /// Contains information about the items
    public var images: [RSSFeedImage]?
    
    /// Initializes the parser with the xml or json contents encapsulated in a
    /// given data object.
    ///
    /// - Parameter data: XML or JSON data
    public init(data: Data) throws {
        let xml = try XMLDocument(data: data)
        let decoder = XMLDecoder(from: xml.rootElement()!, options: .init())
        
        try self.init(from: decoder)
    }
}

// MARK: - Equatable

extension RDFFeed: Equatable {
    
    public static func ==(lhs: RDFFeed, rhs: RDFFeed) -> Bool {
        return lhs.channel == rhs.channel &&
        lhs.items == rhs.items
    }

}

// MARK: - Codable

extension RDFFeed: Codable {
    
    enum CodingKeys: String, CodingKey {
        case channel
        case item
        case image
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(channel, forKey: .channel)
        try container.encode(items, forKey: .item)
        try container.encode(images, forKey: .image)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        channel = try container.decodeIfPresent(RSSFeedChannel.self, forKey: .channel)
        items = try container.decodeIfPresent([RSSFeedItem].self, forKey: .item)
        images = try container.decodeIfPresent([RSSFeedImage].self, forKey: .image)
    }
}

