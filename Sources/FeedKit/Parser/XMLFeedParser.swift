//
//  XMLFeedParser.swift
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

/**
 
 The actual engine behind the `FeedKit` framework. `Parser` handles
 the parsing of RSS and Atom feeds. It is an `XMLParserDelegate` of
 itself.
 
 */
class XMLFeedParser: NSObject, XMLParserDelegate, FeedParserProtocol {
    
    
    /**
     
     The Feed Type currently being parsed. The Initial value of this variable
     is unknown until a recognizable element that matches a feed type is
     found.
     
     */
    var feedType: XMLFeedType?
    
    
    
    /**
     
     The RSS feed model
     
     */
    var rssFeed: RSSFeed?
    
    
    
    /**
     
     The Atom feed model
     
     */
    var atomFeed: AtomFeed?
    
    
    /**
     
     The XML Parser
     
     */
    let xmlParser: XMLParser
    
    
    // MARK: - Initializers
    
    required init(data: Data) {
        self.xmlParser = XMLParser(data: data)
        super.init()
        self.xmlParser.delegate = self
    }
    
    /**
     
     The current path along the XML's DOM elements. Path components are
     updated to reflect the current XML element being parsed.
     e.g. "/rss/channel/title" mean it's currently parsing the channels
     `<title>` element.
     
     */
    fileprivate var currentXMLDOMPath: URL = URL(string: "/")!
    
    /**

     Some feed content can be XML itself, this flag allows for the accumulation
     of those values instead of discarding that data. This is Listing 6 on
     https://www.xml.com/pub/a/2005/12/07/handling-atom-text-and-content-constructs.html

     */
    fileprivate var parsingInnerXMLTag: String? = nil
    fileprivate var parsingInnerXMLNamespaceFound = false
    fileprivate var innerXMLContentsAccumulator = ""

    /**
     
     Starts parsing the feed.
     
     */
    func parse() -> Result {
        
        let _ = self.xmlParser.parse()
        
        if let error = parsingError {
            return Result.failure(error)
        }
        
        guard let feedType = self.feedType else {
            return Result.failure(ParserError.feedNotFound.value)
        }
        
        switch feedType {
            
        case .atom:
            return Result.atom(self.atomFeed!)
            
        case .rss1, .rss2:
            return Result.rss(self.rssFeed!)
                        
        }
        
    }
    
    
    /**
     
     Redirects characters found between XML elements to their proper model
     mappers based on the `currentXMLDOMPath`
     
     */
    fileprivate func mapCharacters(_ string: String) {
        
        guard let feedType = self.feedType else { return }
        
        switch feedType {
            
        case .atom:
            
            if let path = AtomPath(rawValue: self.currentXMLDOMPath.absoluteString) {
                self.atomFeed?.map(characters: string, forPath: path)
            }
            
        case .rss1, .rss2:
            
            if let path = RSSPath(rawValue: self.currentXMLDOMPath.absoluteString) {
                self.rssFeed?.map(string: string, forPath: path)
            }
            
        }
        
    }
    
    var parsingError: NSError?
    
    
}


// MARK: - XMLParser delegate


extension XMLFeedParser {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if attributeDict.index(forKey: "type") != nil {
            if attributeDict["type"] == "xhtml" {
                self.parsingInnerXMLTag = elementName
                self.currentXMLDOMPath = self.currentXMLDOMPath.appendingPathComponent(elementName)
            }
        }
        if elementName == "div" && attributeDict.index(forKey: "xmlns") != nil {
            if self.parsingInnerXMLTag != nil {
                self.parsingInnerXMLNamespaceFound = true
                return
            }
        }

        if self.parsingInnerXMLTag != nil && self.parsingInnerXMLTag != elementName {
            self.innerXMLContentsAccumulator.append("<\(elementName)>")
        } else if self.parsingInnerXMLTag != elementName {
            // Update the current path along the XML's DOM elements by appending the new component with `elementName`
            self.currentXMLDOMPath = self.currentXMLDOMPath.appendingPathComponent(elementName)
        }

        // Get the feed type from the element, if it hasn't been done yet
        guard let feedType = self.feedType else {
            self.feedType = XMLFeedType(rawValue: elementName)
            return
        }
        
        switch feedType {
            
        case .atom:
            
            if  self.atomFeed == nil {
                self.atomFeed = AtomFeed()
            }
            
            if let path = AtomPath(rawValue: self.currentXMLDOMPath.absoluteString) {
                self.atomFeed?.map(attributes: attributeDict, forPath: path)
            }
            
        case .rss1, .rss2:
            
            if  self.rssFeed == nil {
                self.rssFeed = RSSFeed()
            }
            
            if let path = RSSPath(rawValue: self.currentXMLDOMPath.absoluteString) {
                self.rssFeed?.map(attributes: attributeDict, forPath: path)
            }
            
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == self.parsingInnerXMLTag {
            if self.parsingInnerXMLNamespaceFound {
                let endIndex = innerXMLContentsAccumulator.index(innerXMLContentsAccumulator.endIndex, offsetBy: -6)
                innerXMLContentsAccumulator = innerXMLContentsAccumulator.substring(to: endIndex)
                self.parsingInnerXMLNamespaceFound = false
            }
            self.parsingInnerXMLTag = nil
            self.mapCharacters(self.innerXMLContentsAccumulator)
            self.innerXMLContentsAccumulator = ""
        }
        if self.parsingInnerXMLTag != nil {
            self.innerXMLContentsAccumulator.append("</\(elementName)>")
        } else {
            // Update the current path along the XML's DOM elements by deleting last component
            self.currentXMLDOMPath = self.currentXMLDOMPath.deletingLastPathComponent()
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        
        guard let string = String(data: CDATABlock, encoding: .utf8) else {
            self.xmlParser.abortParsing()
            self.parsingError = ParserError.feedCDATABlockEncodingError(path: self.currentXMLDOMPath.absoluteString).value
            return
        }
        
        self.mapCharacters(string)
        
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if self.parsingInnerXMLTag != nil {
            self.innerXMLContentsAccumulator.append(string.trimmingCharacters(in: .whitespacesAndNewlines))
        } else {
            self.mapCharacters(string)
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        self.parsingError = NSError(domain: parseError.localizedDescription, code: -1)
    }
    
}
