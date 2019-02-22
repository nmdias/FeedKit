//
//  MediaRights.swift
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

/// Optional element to specify the rights information of a media object.
public class MediaRights {
    
    /// The element's attributes.
    public class Attributes {
        
        /// Is the status of the media object saying whether a media object has 
        /// been created by the publisher or they have rights to circulate it. 
        /// Supported values are "userCreated" and "official".
        public var status: String?
        
    }
    
    /// The element's attributes.
    public var attributes: Attributes?

    public init() { }

}

// MARK: - Initializers

extension MediaRights {
    
    convenience init(attributes attributeDict: [String : String]) {
        self.init()
        self.attributes = MediaRights.Attributes(attributes: attributeDict)
    }
    
}

extension MediaRights.Attributes {
    
    convenience init?(attributes attributeDict: [String : String]) {
        
        if attributeDict.isEmpty {
            return nil
        }
        
        self.init()
        
        self.status = attributeDict["status"]
        
    }
    
}

// MARK: - Equatable

extension MediaRights: Equatable {
    
    public static func ==(lhs: MediaRights, rhs: MediaRights) -> Bool {
        return lhs.attributes == rhs.attributes
    }
    
}

extension MediaRights.Attributes: Equatable {
    
    public static func ==(lhs: MediaRights.Attributes, rhs: MediaRights.Attributes) -> Bool {
        return lhs.status == rhs.status
    }
    
}
