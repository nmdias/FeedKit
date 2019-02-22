//
//  MediaHash.swift
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

/// This is the hash of the binary media file. It can appear multiple times as
/// long as each instance is a different algo. It has one optional attribute.
public class MediaHash {
    
    /// The element's attributes.
    public class Attributes {
        
        /// This is the hash of the binary media file. It can appear multiple times as long as 
        /// each instance is a different algo. It has one optional attribute.
        public var algo: String?
        
    }
    
    /// The element's attributes.
    public var attributes: Attributes?
    
    /// The element's value.
    public var value: String?
    
    public init() { }

}

// MARK: - Initializers

extension MediaHash {
    
    convenience init(attributes attributeDict: [String : String]) {
        self.init()
        self.attributes = MediaHash.Attributes(attributes: attributeDict)
    }
    
}


extension MediaHash.Attributes {
    
    convenience init?(attributes attributeDict: [String : String]) {
        
        if attributeDict.isEmpty {
            return nil
        }
        
        self.init()
        
        self.algo = attributeDict["algo"]
        
    }
    
}

// MARK: - Equatable

extension MediaHash: Equatable {
    
    public static func ==(lhs: MediaHash, rhs: MediaHash) -> Bool {
        return
            lhs.value == rhs.value &&
            lhs.attributes == rhs.attributes
    }
    
}

extension MediaHash.Attributes: Equatable {
    
    public static func ==(lhs: MediaHash.Attributes, rhs: MediaHash.Attributes) -> Bool {
        return lhs.algo == rhs.algo
    }
    
}

