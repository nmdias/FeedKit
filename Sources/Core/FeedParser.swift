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
     
     The Feed Type currently being parsed. The Initial value of this variable
     is unknown until a recognizable element that matches a feed type is 
     found.
     
     */
    private var feedType: FeedType?
    
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
    private var currentXMLDOMPath: NSURL = NSURL(string: "/")!
    
    /**
     
     The XML parser. 
     
     */
    private var xmlParser: NSXMLParser?
    
    private var result: (Result -> Void)?
    
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
    public func parse(result: Result -> Void) {
        self.result = result
        self.xmlParser?.delegate = self
        self.xmlParser?.parse()
    }
    
    
    func mapCharacters(string: String) {
        
        guard let feedType = self.feedType else { return }
        
        switch feedType {
            
        case .Atom:
            
            if let path = AtomPath(rawValue: self.currentXMLDOMPath.absoluteString) {
                self.atomFeed?.map(characters: string, forPath: path)
            }

        case .RSS1, .RSS2:
            
                 if let path = RSSPath(rawValue: self.currentXMLDOMPath.absoluteString) { self.rssFeed?.map(string, forPath: path) }
            else if let path = SyndicationPath(rawValue: self.currentXMLDOMPath.lastPathComponent ?? "") { self.rssFeed?.map(string, forPath: path) }
            
        }
        
    }
    
    // MARK: - NSXMLParser delegate
    
    public func parserDidStartDocument(parser: NSXMLParser) { }
    
    public func parserDidEndDocument(parser: NSXMLParser) {

        guard let feedType = self.feedType else { return }
        
        switch feedType {
        case .Atom: self.result?(Result.Atom(self.atomFeed!))
        case .RSS1, .RSS2: self.result?(Result.RSS(self.rssFeed!))
        }
        
    }
    
    public func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        // Update the current path along the XML's DOM elements by appending the new component with `elementName`
        self.currentXMLDOMPath = self.currentXMLDOMPath.URLByAppendingPathComponent(elementName)

        // Get the feed type from the element, if it hasn't been done yet
        guard let feedType = self.feedType else {
            self.feedType = FeedType(rawValue: elementName)
            return
        }
        
        switch feedType {
        case .Atom:
            
            if let path = AtomPath(rawValue: self.currentXMLDOMPath.absoluteString) {
                self.atomFeed?.map(attributes: attributeDict, forPath: path)
            }
            
        case .RSS1, .RSS2:
            
            if let path = RSSPath(rawValue: self.currentXMLDOMPath.absoluteString) {
                self.rssFeed?.map(attributes: attributeDict, forPath: path)
            }

            
        }
        
    }
    
    public func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        // Update the current path along the XML's DOM elements by deleting last component
        self.currentXMLDOMPath = self.currentXMLDOMPath.URLByDeletingLastPathComponent!
        
    }
    
    public func parser(parser: NSXMLParser, foundCDATA CDATABlock: NSData) {

        guard let string = NSString(data: CDATABlock, encoding: NSUTF8StringEncoding) as? String else {
            assertionFailure("Unable to convert the bytes in `CDATABlock` to Unicode characters using the encoding provided at current path: \(self.currentXMLDOMPath)")
            return
        }
        
        self.mapCharacters(string)
        
    }
    
    public func parser(parser: NSXMLParser, foundCharacters string: String) {
        self.mapCharacters(string)
    }
    
    
    // MARK: - NSXMLParser delegate errors
    
    public func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        self.result?(Result.Failure(parseError))
    }
    
}