//
//  ITunesImage.swift
//
//  Copyright (c) 2017 Ben Murphy
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

/// Specify your podcast artwork using the <a href> attribute in the
/// <itunes:image> tag. If you do not specify the <itunes:image> tag, the
/// iTunes Store uses the content specified in the RSS feed image tag and Apple
/// does not consider your podcast for feature placement on the iTunes Store or
/// Podcasts.
/// 
/// Depending on their device, subscribers see your podcast artwork in varying
/// sizes. Therefore, make sure your design is effective at both its original
/// size and at thumbnail size. Apple recommends including a title, brand, or
/// source name as part of your podcast artwork. For examples of podcast
/// artwork, see the Top Podcasts. To avoid technical issues when you update
/// your podcast artwork, be sure to:
/// 
/// Change the artwork file name and URL at the same time
/// Verify the web server hosting your artwork allows HTTP head requests
/// The <itunes:image> tag is also supported at the <item> (episode) level.
/// For best results, Apple recommends embedding the same artwork within the
/// metadata for that episode's media file prior to uploading to your host
/// server; using Garageband or another content-creation tool to edit your
/// media file if needed.
/// 
/// Note: Artwork must be a minimum size of 1400 x 1400 pixels and a maximum
/// size of 3000 x 3000 pixels, in JPEG or PNG format, 72 dpi, with appropriate
/// file extensions (.jpg, .png), and in the RGB colorspace. These requirements
/// are different from the standard RSS image tag specifications.
public class ITunesImage {
    
    /// The attributes of the element.
    public class Attributes {
        
        /// The image's url.
        public var href: String?
        
    }

    /// The element's attributes.
    public var attributes: Attributes?
    
    public init() { }
    
}

// MARK: - Initializers

extension ITunesImage {
    
    convenience init(attributes attributesDict: [String: String]) {
        self.init()
        self.attributes = ITunesImage.Attributes(attributes: attributesDict)
    }
}

extension ITunesImage.Attributes {
    
    convenience init?(attributes attributeDict: [String : String]) {
        
        if attributeDict.isEmpty {
            return nil
        }
        
        self.init()
        
        self.href = attributeDict["href"]
        
    }
    
}

// MARK: - Equatable

extension ITunesImage: Equatable {
    
    public static func ==(lhs: ITunesImage, rhs: ITunesImage) -> Bool {
        return lhs.attributes == rhs.attributes
    }
    
}

extension ITunesImage.Attributes: Equatable {
    
    public static func ==(lhs: ITunesImage.Attributes, rhs: ITunesImage.Attributes) -> Bool {
        return lhs.href == rhs.href
    }
    
}

