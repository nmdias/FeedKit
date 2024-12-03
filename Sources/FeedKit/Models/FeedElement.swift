//
//  AtomTextElement.swift
//  FeedKit
//
//  Created by Nuno Dias on 03/12/2024.
//


/// A generic text-based element with attributes.
public struct Attributed<Attributes: Codable & Equatable>: Codable, Equatable {
    /// The element's text.
    public var text: String?

    /// The element's attributes.
    public var attributes: Attributes?

    public init(text: String? = nil, attributes: Attributes? = nil) {
        self.text = text
        self.attributes = attributes
    }

    private enum CodingKeys: String, CodingKey {
        case text = "@text"
        case attributes = "@attributes"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        attributes = try container.decodeIfPresent(Attributes.self, forKey: .attributes)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(attributes, forKey: .attributes)
    }
}
