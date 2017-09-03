//
//  MediaStatistics.swift
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

/// This element specifies various statistics about a media object like the
/// view count and the favorite count. Valid attributes are views and favorites.
public class MediaStatistics {
    
    /// The element's attributes.
    public class Attributes {
        
        /// The number of views.
        public var views: Int?

        /// The number fo favorites.
        public var favorites: Int?
        
    }
    
    /// The element's attributes.
    public var attributes: Attributes?
    
}

// MARK: - Initializers

extension MediaStatistics {
    
    convenience init(attributes attributeDict: [String : String]) {
        self.init()
        self.attributes = MediaStatistics.Attributes(attributes: attributeDict)
    }
    
}

extension MediaStatistics.Attributes {
    
    convenience init?(attributes attributeDict: [String : String]) {
        
        if attributeDict.isEmpty {
            return nil
        }
        
        self.init()
        
        self.views = Int(attributeDict["views"] ?? "")
        self.favorites = Int(attributeDict["favorites"] ?? "")
        
    }
    
}

// MARK: - Equatable

extension MediaStatistics: Equatable {
    
    public static func ==(lhs: MediaStatistics, rhs: MediaStatistics) -> Bool {
        return lhs.attributes == rhs.attributes
    }
    
}

extension MediaStatistics.Attributes: Equatable {
    
    public static func ==(lhs: MediaStatistics.Attributes, rhs: MediaStatistics.Attributes) -> Bool {
        return
            lhs.views == rhs.views &&
            lhs.favorites == rhs.favorites
    }
    
}

