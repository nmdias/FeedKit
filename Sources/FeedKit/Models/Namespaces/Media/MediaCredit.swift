//
//  MediaCredit.swift
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

/// Notable entity and the contribution to the creation of the media object.
/// Current entities can include people, companies, locations, etc. Specific
/// entities can have multiple roles, and several entities can have the same
/// role. These should appear as distinct <media:credit> elements. It has two
/// optional attributes.
public class MediaCredit {
    
    /// The element's attributes.
    public class Attributes {
        
        /// Specifies the role the entity played. Must be lowercase. It is an 
        /// optional attribute.
        public var role: String?
        
        /// The URI that identifies the role scheme. It is an optional attribute 
        /// and possible values for this attribute are ( urn:ebu | urn:yvs ) . The 
        /// default scheme is "urn:ebu". The list of roles supported under urn:ebu 
        /// scheme can be found at European Broadcasting Union Role Codes. The 
        /// roles supported under urn:yvs scheme are ( uploader | owner ).
        public var scheme: String?
        
    }
    
    /// The element's attributes.
    public var attributes: Attributes?
    
    /// The element's value.
    public var value: String?
    
}

// MARK: - Initializers

extension MediaCredit {

    convenience init(attributes attributeDict: [String : String]) {
        self.init()
        self.attributes = MediaCredit.Attributes(attributes: attributeDict)
    }
    
}

extension MediaCredit.Attributes {
    
    convenience init?(attributes attributeDict: [String : String]) {
        
        if attributeDict.isEmpty {
            return nil
        }
        
        self.init()
        
        self.role = attributeDict["role"]
        self.scheme = attributeDict["scheme"]
        
    }
    
}

// MARK: - Equatable

extension MediaCredit: Equatable {
    
    public static func ==(lhs: MediaCredit, rhs: MediaCredit) -> Bool {
        return
            lhs.value == rhs.value &&
                lhs.attributes == rhs.attributes
    }
    
}

extension MediaCredit.Attributes: Equatable {
    
    public static func ==(lhs: MediaCredit.Attributes, rhs: MediaCredit.Attributes) -> Bool {
        return
            lhs.role == rhs.role &&
            lhs.scheme == rhs.scheme
    }
    
}

