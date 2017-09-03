//
//  JSONFeedItem.swift
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

/// An individual item of a JSON Feed, acting as a container for metadata and data 
/// associated with the item.
public class JSONFeedItem {
    
    /// (required, string) is unique for that item for that feed over time. If an 
    /// item is ever updated, the id should be unchanged. New items should never 
    /// use a previously-used id. If an id is presented as a number or other type, 
    /// a JSON Feed reader must coerce it to a string. Ideally, the id is the full
    /// URL of the resource described by the item, since URLs make great unique 
    /// identifiers.
    public var id: String?
     
    /// (optional, string) is the URL of the resource described by the item. It's 
    /// the permalink. This may be the same as the id - but should be present 
    /// regardless.
    public var url: String?

    /// (very optional, string) is the URL of a page elsewhere. This is especially
    /// useful for linkblogs. If url links to where you're talking about a thing,
    /// then external_url links to the thing you're talking about.
    public var externalUrl: String?

    /// (optional, string) is plain text. Microblog items in particular may omit 
    /// titles.
    public var title: String?

    /// content_html and content_text are each optional strings - but one or both 
    /// must be present. This is the HTML or plain text of the item. Important: 
    /// the only place HTML is allowed in this format is in content_html. A 
    /// Twitter-like service might use content_text, while a blog might use 
    /// content_html. Use whichever makes sense for your resource. (It doesn't 
    /// even have to be the same for each item in a feed.)
    public var contentText: String?
    
    /// content_html and content_text are each optional strings - but one or both
    /// must be present. This is the HTML or plain text of the item. Important:
    /// the only place HTML is allowed in this format is in content_html. A
    /// Twitter-like service might use content_text, while a blog might use
    /// content_html. Use whichever makes sense for your resource. (It doesn't
    /// even have to be the same for each item in a feed.)
    public var contentHtml: String?
    
    /// (optional, string) is a plain text sentence or two describing the item. 
    /// This might be presented in a timeline, for instance, where a detail view 
    /// would display all of content_html or content_text.
    public var summary: String?
    
    /// (optional, string) is the URL of the main image for the item. This image
    /// may also appear in the content_html - if so, it's a hint to the feed reader
    /// that this is the main, featured image. Feed readers may use the image as a
    /// preview (probably resized as a thumbnail and placed in a timeline).
    public var image: String?
    
    /// (optional, string) is the URL of an image to use as a banner. Some blogging
    /// systems (such as Medium) display a different banner image chosen to go with
    /// each post, but that image wouldn't otherwise appear in the content_html. 
    /// A feed reader with a detail view may choose to show this banner image at 
    /// the top of the detail view, possibly with the title overlaid.
    public var bannerImage: String?

    /// (optional, string) specifies the date in RFC 3339 format. 
    /// (Example: 2010-02-07T14:04:00-05:00.)
    public var datePublished: Date?
    
    /// (optional, string) specifies the modification date in RFC 3339 format.
    public var dateModified: Date?

    /// (optional, object) has the same structure as the top-level author.
    /// If not specified in an item, then the top-level author, if present, is the
    /// author of the item.
    public var author: JSONFeedAuthor?

    /// (optional, array of strings) can have any plain text values you want. Tags 
    /// tend to be just one word, but they may be anything. Note: they are not the 
    /// equivalent of Twitter hashtags. Some blogging systems and other feed 
    /// formats call these categories.
    public var tags: [String]?
    
    /// (optional, array) lists related resources.
    public var attachments: [JSONFeedAttachment]?
    
    /// Publisher's custom objects. 
    /// 
    /// If you find the need to use these extensions please do so as a temporary
    /// solution and open an issue on github so that direct support can be added
    /// through a strongly typed model.
    public var extensions: [String: Any?]?
    
}

// MARK: - Initializers

extension JSONFeedItem {
    
    convenience init?(dictionary: [String : Any?]) {
        
        if dictionary.isEmpty {
            return nil
        }
        
        self.init()
        
        self.id             = dictionary["id"] as? String
        self.title          = dictionary["title"] as? String
        self.url            = dictionary["url"] as? String
        self.externalUrl    = dictionary["external_url"] as? String
        self.contentText    = dictionary["content_text"] as? String
        self.contentHtml    = dictionary["content_html"] as? String
        self.summary        = dictionary["summary"] as? String
        self.image          = dictionary["image"] as? String
        self.bannerImage    = dictionary["banner_image"] as? String
        self.datePublished  = (dictionary["date_published"] as? String)?.toDate(from: .rfc3999)
        self.dateModified   = (dictionary["date_modified"] as? String)?.toDate(from: .rfc3999)
        self.tags           = dictionary["tags"] as? [String]
        
        if let authorDictionary = dictionary["author"] as? [String: Any] {
            self.author = JSONFeedAuthor(dictionary: authorDictionary)
        }
        
        if let attachments = dictionary["attachments"] as? [[String: Any?]] {
            self.attachments = attachments.flatMap({ (attachment) -> JSONFeedAttachment? in
                return JSONFeedAttachment(dictionary: attachment)
            })
        }
        
        let privateExtensionKeys = dictionary.keys.flatMap { (key) -> String? in
            return key.hasPrefix("_") ? key : nil
        }
        
        if !privateExtensionKeys.isEmpty {
            extensions = [:]
            privateExtensionKeys.forEach { (key) in
                extensions?[key] = dictionary[key]
            }
        }
        
    }
    
}

// MARK: - Equatable

extension JSONFeedItem: Equatable {
    
    public static func ==(lhs: JSONFeedItem, rhs: JSONFeedItem) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.url == rhs.url &&
            lhs.externalUrl == rhs.externalUrl &&
            lhs.contentText == rhs.contentText &&
            lhs.contentHtml == rhs.contentHtml &&
            lhs.summary == rhs.summary &&
            lhs.image == rhs.image &&
            lhs.bannerImage == rhs.bannerImage &&
            lhs.datePublished == rhs.datePublished &&
            lhs.dateModified == rhs.dateModified &&
            lhs.tags == rhs.tags &&
            lhs.author == rhs.author &&
            lhs.attachments == rhs.attachments
    }
    
}
