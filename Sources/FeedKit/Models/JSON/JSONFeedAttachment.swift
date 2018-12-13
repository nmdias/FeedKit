//
//  JSONFeedAttachment.swift
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

/// Describes optional attatchments of a JSON Feed item.
public struct JSONFeedAttachment {
    
    /// (required, string) specifies the location of the attachment.
    public var url: String?
    
    /// (required, string) specifies the type of the attachment, such as 
    /// "audio/mpeg."
    public var mimeType: String?
    
    /// (optional, string) is a name for the attachment. Important: if there are 
    /// multiple attachments, and two or more have the exact same title (when title 
    /// is present), then they are considered as alternate representations of the 
    /// same thing. In this way a podcaster, for instance, might provide an audio 
    /// recording in different formats.
    public var title: String?
    
    /// (optional, number) specifies how large the file is.
    public var sizeInBytes: Int?
    
    /// (optional, number) specifies how long it takes to listen to or watch, when 
    /// played at normal speed.
    public var durationInSeconds: TimeInterval?
    
}

// MARK: - Equatable

extension JSONFeedAttachment: Equatable {}

// MARK: - Codable

extension JSONFeedAttachment: Codable {
    
    enum CodingKeys: String, CodingKey {
        case title
        case url
        case mime_type
        case size_in_bytes
        case duration_in_seconds
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(url, forKey: .url)
        try container.encode(mimeType, forKey: .mime_type)
        try container.encode(sizeInBytes, forKey: .size_in_bytes)
        try container.encode(durationInSeconds, forKey: .duration_in_seconds)
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        mimeType = try values.decodeIfPresent(String.self, forKey: .mime_type)
        sizeInBytes = try values.decodeIfPresent(Int.self, forKey: .size_in_bytes)
        durationInSeconds = try values.decodeIfPresent(TimeInterval.self, forKey: .duration_in_seconds)
    }
    
}
