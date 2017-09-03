//
//  iTunesCategory.swift
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

/// Users can browse podcast subject categories in the iTunes Store by choosing 
/// a category from the Podcasts pop-up menu in the navigation bar. Use the 
/// <itunes:category> tag to specify the browsing category for your podcast.
///
/// You can also define a subcategory if one is available within your category. 
/// Although you can specify more than one category and subcategory in your 
/// feed, the iTunes Store only recognizes the first category and subcategory. 
/// For a complete list of categories and subcategories, see Podcasts Connect 
/// categories.
///
/// Note: When specifying categories and subcategories, be sure to properly 
/// escape ampersands:
///
/// Single category:
/// <itunes:category text="Music" />
/// 
/// Category with ampersand:
/// <itunes:category text="TV &amp; Film" />
/// 
/// Category with subcategory:
/// <itunes:category text="Society &amp; Culture">
///    <itunes:category text="History" />
/// </itunes:category>
/// 
/// Multiple categories:
/// <itunes:category text="Society &amp; Culture">
///    <itunes:category text="History" />
/// </itunes:category>
/// <itunes:category text="Technology">
///    <itunes:category text="Gadgets" />
/// </itunes:category>
public class ITunesCategory {

    /// The attributes of the element.
    public class Attributes {
        
        /// The primary iTunes Category.
        public var text: String?
        
    }
    
    /// The element's attributes.
    public var attributes: Attributes?
    
    /// The iTunes SubCategory.
    public var subcategory: ITunesSubCategory?
    
}

// MARK: - Initializers

extension ITunesCategory {
    
    convenience init(attributes attributesDict: [String: String]) {
        self.init()
        self.attributes = ITunesCategory.Attributes(attributes: attributesDict)
    }
}

extension ITunesCategory.Attributes {
    
    convenience init?(attributes attributeDict: [String : String]) {
        
        if attributeDict.isEmpty {
            return nil
        }
        
        self.init()
        
        self.text = attributeDict["text"]
        
    }
    
}

// MARK: - Equatable

extension ITunesCategory: Equatable {
    
    public static func ==(lhs: ITunesCategory, rhs: ITunesCategory) -> Bool {
        return lhs.attributes == rhs.attributes
    }
    
}

extension ITunesCategory.Attributes: Equatable {
    
    public static func ==(lhs: ITunesCategory.Attributes, rhs: ITunesCategory.Attributes) -> Bool {
        return lhs.text == rhs.text
    }
    
}

