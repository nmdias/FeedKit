//
//  MediaCommunity.swift
//
//  Copyright (c) 2017 Nuno Manuel Dias
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

/// This element stands for the community related content. This allows
/// inclusion of the user perception about a media object in the form of view
/// count, ratings and tags.
public class MediaCommunity {
    
    /// This element specifies the rating-related information about a media object.
    /// Valid attributes are average, count, min and max.
    public var mediaStarRating: MediaStarRating?
    
    /// This element specifies various statistics about a media object like the 
    /// view count and the favorite count. Valid attributes are views and favorites.
    public var mediaStatistics: MediaStatistics?
    
    /// This element contains user-generated tags separated by commas in the 
    /// decreasing order of each tag's weight. Each tag can be assigned an integer 
    /// weight in tag_name:weight format. It's up to the provider to choose the way
    /// weight is determined for a tag; for example, number of occurences can be 
    /// one way to decide weight of a particular tag. Default weight is 1.
    public var mediaTags: [MediaTag]?
    
}

// MARK: - Equatable

extension MediaCommunity: Equatable {
    
    public static func ==(lhs: MediaCommunity, rhs: MediaCommunity) -> Bool {
        return
            lhs.mediaStarRating == rhs.mediaStarRating &&
            lhs.mediaStatistics == rhs.mediaStatistics &&
            lhs.mediaTags == rhs.mediaTags
    }
    
}
