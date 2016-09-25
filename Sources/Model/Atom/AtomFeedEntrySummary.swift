//
//  AtomFeedEntrySummary.swift
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
 
 The "atom:summary" element is a Text construct that conveys a short
 summary, abstract, or excerpt of an entry.
 
 atomSummary = element atom:summary { atomTextConstruct }
 
 It is not advisable for the atom:summary element to duplicate
 atom:title or atom:content because Atom Processors might assume there
 is a useful summary when there is none.
 
 */
open class AtomFeedEntrySummary {
    
    /**
     
     The element's attributes
     
     */
    open class Attributes {
        
        /**
         
         Text constructs MAY have a "type" attribute.  When present, the value
         MUST be one of "text", "html", or "xhtml".  If the "type" attribute
         is not provided, Atom Processors MUST behave as though it were
         present with a value of "text".
         
         */
        open var type: String?
        
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

extension AtomFeedEntrySummary {
    
    /**
     
     Initializes the `AtomFeedEntrySummary` with the attributes of the "atom:summary" element
     
     - parameter attributeDict: A dictionary with the attributes of the "atom:summary" element
     
     - returns: An `AtomFeedEntrySummary` instance
     
     */
    convenience init(attributes attributeDict: [String : String]) {
        self.init()
        self.attributes = AtomFeedEntrySummary.Attributes(attributes: attributeDict)
    }
    
}

extension AtomFeedEntrySummary.Attributes {
    
    /**
     
     Initializes the `Attributes` of the `AtomFeedEntrySummary`
     
     - parameter: A dictionary with the attributes of the "atom:summary" element
     
     - returns: An `AtomFeedEntrySummary.Attributes` instance
     
     */
    convenience init?(attributes attributeDict: [String : String]) {
        
        if attributeDict.isEmpty {
            return nil
        }
        
        self.init()
        
        self.type = attributeDict["type"]
        
    }
    
}
