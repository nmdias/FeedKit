//
//  MediaStarRating.swift
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

/// This element specifies the rating-related information about a media object.
/// Valid attributes are average, count, min and max.
public class MediaStarRating {
    
    /// The element's attributes.
    public class Attributes {
        
        /// The star rating's average.
        public var average: Double?
        
        /// The star rating's total count.
        public var count: Int?
        
        /// The star rating's minimum value.
        public var min: Int?
        
        /// The star rating's maximum value.
        public var max: Int?
        
    }
    
    /// The element's attributes.
    public var attributes: Attributes?
    
}

// MARK: - Initializers

extension MediaStarRating {
    
    convenience init(attributes attributeDict: [String : String]) {
        self.init()
        self.attributes = MediaStarRating.Attributes(attributes: attributeDict)
    }
    
}

extension MediaStarRating.Attributes {
    
    convenience init?(attributes attributeDict: [String : String]) {
        
        if attributeDict.isEmpty {
            return nil
        }
        
        self.init()
        
        self.average = Double(attributeDict["average"] ?? "")
        self.count = Int(attributeDict["count"] ?? "")
        self.min = Int(attributeDict["min"] ?? "")
        self.max = Int(attributeDict["max"] ?? "")
        
    }
    
}

// MARK: - Equatable

extension MediaStarRating: Equatable {
    
    public static func ==(lhs: MediaStarRating, rhs: MediaStarRating) -> Bool {
        return lhs.attributes == rhs.attributes
    }
    
}

extension MediaStarRating.Attributes: Equatable {
    
    public static func ==(lhs: MediaStarRating.Attributes, rhs: MediaStarRating.Attributes) -> Bool {
        return
            lhs.average == rhs.average &&
            lhs.count == rhs.count &&
            lhs.min == rhs.min &&
            lhs.max == rhs.max
    }
    
}

