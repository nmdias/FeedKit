//
//  MediaLicence.swift
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

/// Optional link to specify the machine-readable license associated with the
/// content.
public class MediaLicence {
    
    /// The element's attributes.
    public class Attributes {
        
        /// The licence type.
        public var type: String?
        
        /// The location of the licence.
        public var href: String?
        
    }
    
    /// The element's attributes.
    public var attributes: Attributes?
    
    /// The element's value.
    public var value: String?
    
}

// MARK: - Initializers

extension MediaLicence {

    convenience init(attributes attributeDict: [String : String]) {
        self.init()
        self.attributes = MediaLicence.Attributes(attributes: attributeDict)
    }
    
}

extension MediaLicence.Attributes {
    
    convenience init?(attributes attributeDict: [String : String]) {
        
        if attributeDict.isEmpty {
            return nil
        }
        
        self.init()
        
        self.type = attributeDict["type"]
        self.href = attributeDict["href"]
        
    }
    
}

// MARK: - Equatable

extension MediaLicence: Equatable {
    
    public static func ==(lhs: MediaLicence, rhs: MediaLicence) -> Bool {
        return
            lhs.value == rhs.value &&
            lhs.attributes == rhs.attributes
    }
    
}

extension MediaLicence.Attributes: Equatable {
    
    public static func ==(lhs: MediaLicence.Attributes, rhs: MediaLicence.Attributes) -> Bool {
        return
            lhs.type == rhs.type &&
            lhs.href == rhs.href
    }
    
}

