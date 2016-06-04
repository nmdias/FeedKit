//
//  Parser.swift
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

class Parser: NSXMLParser, NSXMLParserDelegate {
    
    
    /**
     
     The Feed Type currently being parsed. The Initial value of this variable
     is unknown until a recognizable element that matches a feed type is
     found.
     
     */
    private var feedType: FeedType?
    
    
    
    /**
     
     The RSS feed model
     
     */
    private var rssFeed: RSSFeed?
    
    
    
    /**
     
     The Atom feed model
     
     */
    private var atomFeed: AtomFeed?
    
    
    /**
     
     The current path along the XML's DOM elements. Path components are
     updated to reflect the current XML element being parsed.
     e.g. "/rss/channel/title" mean it's currently parsing the channels
     `<title>` element.
     
     */
    private var currentXMLDOMPath: NSURL = NSURL(string: "/")!
    
    
    var result: (Result -> Void)?
    
    
    
    override init(data: NSData) {
        super.init(data: data)
        self.delegate = self
    }
    
    
    
    /**
     
     Starts parsing the feed.
     
     */
    func parse(result: Result -> Void) {
        self.result = result
        self.parse()
    }
    
    
    
    private func mapCharacters(string: String) {
        
        guard let feedType = self.feedType else { return }
        
        switch feedType {
            
        case .Atom:
            
            if let path = AtomPath(rawValue: self.currentXMLDOMPath.absoluteString) {
                self.atomFeed?.map(characters: string, forPath: path)
            }
            
        case .RSS1, .RSS2:
            
            if let path = RSSPath(rawValue: self.currentXMLDOMPath.absoluteString) {
                self.rssFeed?.map(string, forPath: path)
            }
            
        }
        
    }
    
    
    
}


// MARK: - NSXMLParser delegate


extension Parser {
    
    func parserDidEndDocument(parser: NSXMLParser) {
        
        guard let feedType = self.feedType else {
            self.result?(Result.Failure(error(Error.FeedNotFound)))
            return
        }
        
        switch feedType {
        case .Atom:         self.result?(Result.Atom(self.atomFeed!))
        case .RSS1, .RSS2:  self.result?(Result.RSS(self.rssFeed!))
        }
        
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        // Update the current path along the XML's DOM elements by appending the new component with `elementName`
        self.currentXMLDOMPath = self.currentXMLDOMPath.URLByAppendingPathComponent(elementName)
        
        // Get the feed type from the element, if it hasn't been done yet
        guard let feedType = self.feedType else {
            self.feedType = FeedType(rawValue: elementName)
            return
        }
        
        switch feedType {
            
        case .Atom:
            
            if  self.atomFeed == nil {
                self.atomFeed = AtomFeed()
            }
            
            if let path = AtomPath(rawValue: self.currentXMLDOMPath.absoluteString) {
                self.atomFeed?.map(attributes: attributeDict, forPath: path)
            }
            
        case .RSS1, .RSS2:
            
            if  self.rssFeed == nil {
                self.rssFeed = RSSFeed()
            }
            
            if let path = RSSPath(rawValue: self.currentXMLDOMPath.absoluteString) {
                self.rssFeed?.map(attributes: attributeDict, forPath: path)
            }
            
        }
        
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        // Update the current path along the XML's DOM elements by deleting last component
        self.currentXMLDOMPath = self.currentXMLDOMPath.URLByDeletingLastPathComponent!
        
    }
    
    func parser(parser: NSXMLParser, foundCDATA CDATABlock: NSData) {
        
        guard let string = NSString(data: CDATABlock, encoding: NSUTF8StringEncoding) as? String else {
            assertionFailure("Unable to convert the bytes in `CDATABlock` to Unicode characters using the encoding provided at current path: \(self.currentXMLDOMPath)")
            return
        }
        
        self.mapCharacters(string)
        
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        self.mapCharacters(string)
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        self.result?(Result.Failure(parseError))
    }
    
}
