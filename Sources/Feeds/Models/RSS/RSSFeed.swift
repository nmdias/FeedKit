//
//  File.swift
//  
//
//  Created by Axel Martinez on 18/7/24.
//

import Foundation

/// Data model for the XML DOM of the RSS 2.0 Specification
/// See http://cyber.law.harvard.edu/rss/rss.html
///
/// At the top level, a RSS document is a <rss> element, with a mandatory
/// attribute called version, that specifies the version of RSS that the
/// document conforms to. If it conforms to this specification, the version
/// attribute must be 2.0.
///
public struct RSSFeed: Feed {
    /// Contains information about the channel (metadata) and its contents.
    public var channel: RSSFeedChannel?
    
    /// Initializes the parser with the xml or json contents encapsulated in a
    /// given data object.
    ///
    /// - Parameter data: XML or JSON data
    public init(data: Data) throws {
        let xml = try XMLDocument(data: data, options: .documentValidate)
        let decoder = XMLDecoder(from: xml.rootElement()!, options: .init())
        
        try self.init(from: decoder)
    }
}

// MARK: - Equatable

extension RSSFeed: Equatable {
    
    public static func ==(lhs: RSSFeed, rhs: RSSFeed) -> Bool {
        return lhs.channel == rhs.channel
    }

}

// MARK: - Codable

extension RSSFeed: Codable {
    
    enum CodingKeys: String, CodingKey {
        case channel
        case item
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(channel, forKey: .channel)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        channel = try container.decodeIfPresent(RSSFeedChannel.self, forKey: .channel)
    }
}
