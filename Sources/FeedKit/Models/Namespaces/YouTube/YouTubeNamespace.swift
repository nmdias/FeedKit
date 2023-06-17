//
//  YouTubeNamespace.swift
//
//  Copyright (c) 2023 Naufal Fachrian
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

/// YouTube metadata contains channel ID and video ID for YouTube content.
///
/// See https://developers.google.com/youtube/v3/guides/push_notifications
public class YouTubeNamespace {
    
    /// The <yt:channelId> element's value to identify the channel that owns that video.
    public var channelID: String?
    
    /// The <yt:videoId> element's value to identify the newly added or updated video.
    public var videoID: String?
    
    public init() { }
    
}


// MARK: - Equatable

extension YouTubeNamespace: Equatable {
    
    public static func ==(lhs: YouTubeNamespace, rhs: YouTubeNamespace) -> Bool {
        return
            lhs.channelID == rhs.channelID &&
            lhs.videoID == rhs.videoID
    }
    
}
