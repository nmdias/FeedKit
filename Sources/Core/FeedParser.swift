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

/**
 
 An RSS and Atom feed parser. `FeedParser` uses `Foundation`'s
 `XMLParser`.
 
 */
open class FeedParser: NSObject, XMLParserDelegate {
    
    /**
     
     The actual engine behind the `FeedKit` framework. `parser` handles
     the parsing of RSS and Atom feeds.
     
     */
    let parser: XMLParser
    
    
    
    /**
     
     Initializes the parser with the XML content referenced by the given URL.
     
     - parameter URL: An URL object specifying a URL
     
     - returns: An instance of the `XMLParser`.
     
     */
    public init?(URL: URL) {
        
        guard let parser = XMLParser(contentsOf: URL) else {
            return nil
        }
        
        self.parser = parser
        
    }
    
    
    
    /**
     
     Initializes the parser with the XML contents encapsulated in a given data object.
     
     - parameter data: An `Data` object containing XML markup.
     
     - returns: An instance of the `XMLParser`.
     
     */
    public init(data: Data) {
        self.parser = XMLParser(data: data)
    }
    
    
    
    /**
     
     Initializes the parser with the specified stream.
     
     - parameter stream: The input stream. The content is incrementally loaded from the specified stream and parsed. The the underlying `XMLParser` will open the stream, and synchronously read from it without scheduling it.
     
     - returns: An instance of the `XMLParser`.
     
     */
    public init(stream: InputStream) {
        self.parser = XMLParser(stream: stream)
    }
    
    
    
    /**
     
     Starts parsing the feed.
     
     */
    func parseFeed() -> Result {
        
        parser.delegate = self
        parser.parse()
        
        if let error = parsingError {
            return Result.failure(error)
        }
        
        guard let feedType = self.feedType else {
            return Result.failure(ParserError.feedNotFound.value)
        }
        
        switch feedType {
            
        case .Atom:
            return Result.atom(self.atomFeed!)
            
        case .RSS1, .RSS2:
            return Result.rss(self.rssFeed!)
            
        }
        
    }
    
    /**
     
     Starts parsing the feed asynchronously. Parsing runs by default on the main queue. 
     So it is safe to run any UI code on the result closure.
     
     If a different queue is specified, the user is responsible to manually bring the 
     resulting closure to whichever queue is apropriate. Usually `DispatchQueue.main.async`.
     
     If you're unsure, don't provide the `queue` parameter.
     
     - parameter queue: The queue on which the completion handler is dispatched.
     - parameter result: The parse result
     
     */
    open func parseAsync(queue: DispatchQueue = DispatchQueue.main, result: @escaping (Result) -> Void) {
        queue.async {
            result(self.parseFeed())
        }
    }
    
    /**
     
     Stops parsing the feed.
     
     */
    open func abortParsing() {
        self.parser.abortParsing()
    }
    
    
    /**
     
     The Feed Type currently being parsed. The Initial value of this variable
     is unknown until a recognizable element that matches a feed type is
     found.
     
     */
    var feedType: FeedType?
    
    
    
    /**
     
     The RSS feed model
     
     */
    var rssFeed: RSSFeed?
    
    
    
    /**
     
     The Atom feed model
     
     */
    var atomFeed: AtomFeed?
    
    
    /**
     
     The current path along the XML's DOM elements. Path components are
     updated to reflect the current XML element being parsed.
     e.g. "/rss/channel/title" mean it's currently parsing the channels
     `<title>` element.
     
     */
    fileprivate var currentXMLDOMPath: URL = URL(string: "/")!
    
    
    
    /**
     
     A completion handler, providing a callback with a `Result` object.
     This closure is called whenever the parser finishes or an error as
     ocurred.
     
     */
    var result: ((Result) -> Void)?
    
    
    
    /**
     
     Redirects characters found between XML elements to their proper model
     mappers based on the `currentXMLDOMPath`
     
     */
    fileprivate func mapCharacters(_ string: String) {
        
        guard let feedType = self.feedType else { return }
        
        switch feedType {
            
        case .Atom:
            
            if let path = AtomPath(rawValue: self.currentXMLDOMPath.absoluteString) {
                self.atomFeed?.map(characters: string, forPath: path)
            }
            
        case .RSS1, .RSS2:
            
            if let path = RSSPath(rawValue: self.currentXMLDOMPath.absoluteString) {
                self.rssFeed?.map(string: string, forPath: path)
            }
            
        }
        
    }
    
    var parsingError: NSError?
    
}

public extension FeedParser {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        // Update the current path along the XML's DOM elements by appending the new component with `elementName`
        self.currentXMLDOMPath = self.currentXMLDOMPath.appendingPathComponent(elementName)
        
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
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        // Update the current path along the XML's DOM elements by deleting last component
        self.currentXMLDOMPath = self.currentXMLDOMPath.deletingLastPathComponent()
        
    }
    
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        
        guard let string = String(data: CDATABlock, encoding: .utf8) else {
            self.abortParsing()
            self.parsingError = ParserError.feedCDATABlockEncodingError(path: self.currentXMLDOMPath.absoluteString).value
            return
        }
        
        self.mapCharacters(string)
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.mapCharacters(string)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        self.parsingError = parseError as NSError
    }
    
}
