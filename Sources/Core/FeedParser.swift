//
//  FeedParser.swift
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


public class FeedParser: NSObject, NSXMLParserDelegate {
    
    // MARK: - Private properties
    
    /**
     
     The RSS feed model
     
     */
    private var rssFeed: RSSFeed? = RSSFeed()
    
    /**
     
     The Atom feed model
     
     */
    private var atomFeed: AtomFeed? = AtomFeed()
    
    /** 
     
     The current path along the XML's DOM elements. Path components are 
     updated to reflect the current XML element being parsed.
     e.g. "/rss/channel/title" mean it's currently parsing the channels 
     `<title>` element.
     
     */
    private var currentXMLDOMPath: NSURL? = NSURL(string: "/")
    
    /**
     
     The XML parser. 
     
     */
    private var xmlParser: NSXMLParser?
    
    private var result: (ParseResult -> Void)?
    
    // MARK: - Initializers
    
    /**
     
     Initializes the parser with the XML content referenced by the given URL.
     
     - parameter URL: An NSURL object specifying a URL
     
     - returns: An instance of the feed parser.
     
     */
    public init(URL: NSURL) {
        
        guard let parser = NSXMLParser(contentsOfURL: URL) else {
            assertionFailure("Unable to initialize the parser with the provided URL: \(URL)")
            return
        }

        self.xmlParser = parser
    }
    
    // MARK: - Public methods
    
    /**
     
     Starts parsing the feed.
     
     */
    public func parse(result: ParseResult -> Void) {
        self.result = result
        self.xmlParser?.delegate = self
        self.xmlParser?.parse()
    }
    
    
    // MARK: - NSXMLParser delegate
    
    public func parserDidStartDocument(parser: NSXMLParser) { }
    
    public func parserDidEndDocument(parser: NSXMLParser) {

        let parseResult = ParseResult()
        parseResult.rssFeed = self.rssFeed
        parseResult.atomFeed = self.atomFeed
        self.result?(parseResult)
        
    }
    
    public func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        // Update the current path along the XML's DOM elements by appending the new component with `elementName`
        self.currentXMLDOMPath = self.currentXMLDOMPath?.URLByAppendingPathComponent(elementName)
        
        
        
        if let element = RSSFeedElementPath(rawValue: self.currentXMLDOMPath?.absoluteString ?? "") {
            self.map(attributes: attributeDict, toFeed: self.rssFeed!, forElement: element)
        }
        
        else if let element = AtomFeedElementPath(rawValue: self.currentXMLDOMPath?.absoluteString ?? "") {
            self.map(attributes: attributeDict, toFeed: self.atomFeed!, forElement: element)
        }
        
    }
    
    public func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        // Update the current path along the XML's DOM elements by deleting last component
        self.currentXMLDOMPath = self.currentXMLDOMPath?.URLByDeletingLastPathComponent
        
    }
    
    public func parser(parser: NSXMLParser, foundCDATA CDATABlock: NSData) {
        
        guard let string = NSString(data: CDATABlock, encoding: NSUTF8StringEncoding) as? String else {
            assertionFailure("Unable to convert the bytes in `CDATABlock` to Unicode characters using the encoding provided at current path: \(self.currentXMLDOMPath)")
            return
        }
        
        if let element = AtomFeedElementPath(rawValue: self.currentXMLDOMPath?.absoluteString ?? "") {
            self.map(string, toFeed: self.atomFeed!, forElement: element)
        }
        
        else if let element = RSSFeedElementPath(rawValue: self.currentXMLDOMPath?.absoluteString ?? "") {
            self.map(string, toFeed: self.rssFeed!, forElement: element)
        }
            
        else if let dublinCoreChannelElement = DublinCoreChannelElementPath(rawValue: self.currentXMLDOMPath?.absoluteString ?? "") {
            self.map(string, toFeed: self.rssFeed!, forElement: dublinCoreChannelElement)
        }
            
        else if let dublinCoreChannelItemElement = DublinCoreChannelItemElementPath(rawValue: self.currentXMLDOMPath?.absoluteString ?? "") {
            self.map(string, toFeed: self.rssFeed!, forElement: dublinCoreChannelItemElement)
        }
            
        else if let contentElement = ContentElementPath(rawValue: self.currentXMLDOMPath?.absoluteString ?? "") {
            self.map(string, toFeed: self.rssFeed!, forElement: contentElement)
        }
        
    }
    
    public func parser(parser: NSXMLParser, foundCharacters string: String) {

        if let feedElement = AtomFeedElementPath(rawValue: self.currentXMLDOMPath?.absoluteString ?? "") {
            self.map(string, toFeed: self.atomFeed!, forElement: feedElement)
        }
        
        else if let feedElement = RSSFeedElementPath(rawValue: self.currentXMLDOMPath?.absoluteString ?? "") {
            self.map(string, toFeed: self.rssFeed!, forElement: feedElement)
        }
            
        else if let syndicationElement = SyndicationElementPaths(rawValue: self.currentXMLDOMPath?.lastPathComponent ?? "") {
            self.map(string, toFeed: self.rssFeed!, forElement: syndicationElement)
        }
            
        else if let dublinCoreChannelElement = DublinCoreChannelElementPath(rawValue: self.currentXMLDOMPath?.absoluteString ?? "") {
            self.map(string, toFeed: self.rssFeed!, forElement: dublinCoreChannelElement)
        }
            
        else if let dublinCoreChannelItemElement = DublinCoreChannelItemElementPath(rawValue: self.currentXMLDOMPath?.absoluteString ?? "") {
            self.map(string, toFeed: self.rssFeed!, forElement: dublinCoreChannelItemElement)
        }
        
    }
    
    
    // MARK: - NSXMLParser delegate errors
    
    public func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {

    }
    
    public func parser(parser: NSXMLParser, validationErrorOccurred validationError: NSError) {
        
    }
    
    
}