//
//  MediaCopyright.swift
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

/// Copyright information for the media object. It has one optional attribute.
public class MediaCopyright {
    
    /// The element's attributes.
    public class Attributes {
        
        /// The URL for a terms of use page or additional copyright information. 
        /// If the media is operating under a Creative Commons license, the 
        /// Creative Commons module should be used instead. It is an optional 
        /// attribute.
        public var url: String?
        
    }
    
    /// The element's attributes.
    public var attributes: Attributes?
    
    /// The element's value.
    public var value: String?
    
}

// MARK: - Initializers

extension MediaCopyright {
    
    convenience init(attributes attributeDict: [String : String]) {
        self.init()
        self.attributes = MediaCopyright.Attributes(attributes: attributeDict)
    }
    
}


extension MediaCopyright.Attributes {
    
    convenience init?(attributes attributeDict: [String : String]) {
        
        if attributeDict.isEmpty {
            return nil
        }
        
        self.init()
        
        self.url = attributeDict["url"]
        
    }
    
}

// MARK: - Equatable

extension MediaCopyright: Equatable {
    
    public static func ==(lhs: MediaCopyright, rhs: MediaCopyright) -> Bool {
        return
            lhs.value == rhs.value &&
                lhs.attributes == rhs.attributes
    }
    
}

extension MediaCopyright.Attributes: Equatable {
    
    public static func ==(lhs: MediaCopyright.Attributes, rhs: MediaCopyright.Attributes) -> Bool {
        return lhs.url == rhs.url
    }
    
}
