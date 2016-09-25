//
//  RSSFeedCategory.swift
//
//  Copyright (c) 2016 Nuno Manuel Dias
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

/**
    The category of `<channel>`. Identifies a category or tag to which the feed belongs.
*/
open class RSSFeedCategory {
    
    /**
     
     The element's attributes
     
     */
    open class Attributes {
        
        /// A string that identifies a categorization taxonomy. It's an optional attribute of `<category>`. e.g. "http://www.fool.com/cusips"
        open var domain: String?
        
    }
    
    /**
     
     The element's attributes
     
     */
    open var attributes: Attributes?
    
    /**
     
     The element's value
     
     */
    open var value: String?
    
}

// MARK: - Initializers

extension RSSFeedCategory {
    
    /**
     
     Initializes the `RSSFeedCategory` with the attributes of the `<category>` element
     
     - parameter attributeDict: A dictionary with the attributes of the `<category>` element
     
     - returns: A `RSSFeedCategory` instance
     
     */
    convenience init(attributes attributeDict: [String : String]) {
        self.init()
        self.attributes = RSSFeedCategory.Attributes(attributes: attributeDict)
    }
    
}

extension RSSFeedCategory.Attributes {
    
    /**
     
     Initializes the `Attributes` of the `RSSFeedCategory`
     
     - parameter: A dictionary with the attributes of the `<category>` element
     
     - returns: A `RSSFeedCategory.Attributes` instance
     
     */
    convenience init?(attributes attributeDict: [String : String]) {
        
        if attributeDict.isEmpty {
            return nil
        }
        
        self.init()
        
        self.domain = attributeDict["domain"]
        
    }
    
}
