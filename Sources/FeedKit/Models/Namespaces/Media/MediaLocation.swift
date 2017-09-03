//
//  MediaLocation.swift
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

/// Optional element to specify geographical information about various
/// locations captured in the content of a media object. The format conforms
/// to geoRSS.
public class MediaLocation {
    
    /// The element's attributes.
    public class Attributes {
        
        /// Description of the place whose location is being specified.
        public var description: String?
        
        /// Time at which the reference to a particular location starts in the 
        /// media object.
        public var start: TimeInterval?
        
        /// Time at which the reference to a particular location ends in the media 
        /// object.
        public var end: TimeInterval?
        
    }
    
    /// The element's attributes.
    public var attributes: Attributes?
    
    /// The geoRSS's location latitude.
    public var latitude: Double?
    
    /// The geoRSS's location longitude.
    public var longitude: Double?
    
}

// MARK: - Initializers

extension MediaLocation {
    
    convenience init(attributes attributeDict: [String : String]) {
        self.init()
        self.attributes = MediaLocation.Attributes(attributes: attributeDict)
    }
    
}

extension MediaLocation.Attributes {
    
    convenience init?(attributes attributeDict: [String : String]) {
        
        if attributeDict.isEmpty {
            return nil
        }
        
        self.init()
        
        self.description = attributeDict["description"]
        self.start = attributeDict["start"]?.toDuration()
        self.end = attributeDict["end"]?.toDuration()
        
    }
    
}

// MARK: - Equatable

extension MediaLocation: Equatable {
    
    public static func ==(lhs: MediaLocation, rhs: MediaLocation) -> Bool {
        return
            lhs.latitude == rhs.latitude &&
            lhs.longitude == rhs.longitude &&
            lhs.attributes == rhs.attributes
    }
    
}

extension MediaLocation.Attributes: Equatable {
    
    public static func ==(lhs: MediaLocation.Attributes, rhs: MediaLocation.Attributes) -> Bool {
        return
            lhs.description == rhs.description &&
            lhs.start == rhs.start &&
            lhs.end == rhs.end
    }
    
}

// MARK: - Helpers

extension MediaLocation {
    
    func mapFrom(latLng: String) {

        let components = latLng.components(separatedBy: " ")
        if  components.count == 2 {
            self.latitude = Double(components.first ?? "")
            self.longitude = Double(components.last ?? "")
        }
        
    }
    
}
