//
//  XMLFeedParser.swift
//
//  Copyright (c) 2016 - 2018 Nuno Manuel Dias
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
#if canImport(FoundationXML)
import FoundationXML
#endif

/// The actual engine behind the `FeedKit` framework. `XMLFeedParser` handles
/// the parsing of RSS and Atom feeds. It is an `XMLParserDelegate` of
/// itself.
class XMLFeedParser: NSObject, XMLParserDelegate, FeedParserProtocol {
    
    /// The Feed Type currently being parsed. The Initial value of this variable
    /// is unknown until a recognizable element that matches a feed type is
    /// found.
    var feedType: XMLFeedType?
    
    /// The RSS feed model.
    var rssFeed: RSSFeed?
    
    /// The Atom feed model.
    var atomFeed: AtomFeed?
    
    /// The XML Parser.
    let xmlParser: XMLParser
    
    /// An XML Feed Parser, for rss and atom feeds.
    ///
    /// - Parameter data: A `Data` object containing an XML feed.
    required init(data: Data) {
        self.xmlParser = XMLParser(data: data)
        super.init()
        self.xmlParser.delegate = self
    }
    
    /// An XML Feed Parser, for rss and atom feeds.
    ///
    /// - Parameter stream: An `InputStream` object containing an XML feed.
    init(stream: InputStream) {
        self.xmlParser = XMLParser(stream: stream)
        super.init()
        self.xmlParser.delegate = self
    }

    /// The current path along the XML's DOM elements. Path components are
    /// updated to reflect the current XML element being parsed.
    /// e.g. "/rss/channel/title" means it's currently parsing the channels
    /// `<title>` element.
    fileprivate var currentXMLDOMPath: URL = URL(string: "/")!
    
    /// A parsing error, if any.
    var parsingError: Error?
    var parseComplete = false
    
    /// Starts parsing the feed.
    func parse() -> Result<Feed, ParserError> {
        let _ = self.xmlParser.parse()
        
        if let error = parsingError {
            return .failure(.internalError(reason: error.localizedDescription))
        }
        
        guard let feedType = feedType else {
            return .failure(.feedNotFound)
        }
        
        switch feedType {
        case .atom:
            guard let atomFeed = atomFeed else {
                return .failure(.internalError(reason: "Unable to initialize atom feed model"))
            }
            return .success(.atom(atomFeed))
        case .rdf, .rss:
            guard let rssFeed = rssFeed else {
                return .failure(.internalError(reason: "Unable to initialize rss feed model"))
            }
            return .success(.rss(rssFeed))
        }
        
    }
    
    /// Redirects characters found between XML elements to their proper model
    /// mappers based on the `currentXMLDOMPath`.
    ///
    /// - Parameter string: The characters to map.
    fileprivate func map(_ string: String) {
        guard let feedType = self.feedType else { return }
        
        switch feedType {
        case .atom:
            if let path = AtomPath(rawValue: self.currentXMLDOMPath.absoluteString) {
                self.atomFeed?.map(string, for: path)
            }
            
        case .rdf:
            if let path = RDFPath(rawValue: self.currentXMLDOMPath.absoluteString) {
                self.rssFeed?.map(string, for: path)
            }
            
        case .rss:
            if let path = RSSPath(rawValue: self.currentXMLDOMPath.absoluteString) {
                self.rssFeed?.map(string, for: path)
            }
            
        }
        
    }
    
}

// MARK: - XMLParser delegate

extension XMLFeedParser {

    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String])
    {
        
        // Update the current path along the XML's DOM elements by appending the new component with `elementName`.
        self.currentXMLDOMPath = self.currentXMLDOMPath.appendingPathComponent(elementName)
        
        // Get the feed type from the element, if it hasn't been done yet.
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
                self.atomFeed?.map(attributeDict, for: path)
            }
            
        case .rdf:
            if  self.rssFeed == nil {
                self.rssFeed = RSSFeed()
            }
            if let path = RDFPath(rawValue: self.currentXMLDOMPath.absoluteString) {
                self.rssFeed?.map(attributeDict, for: path)
            }
            
        case .rss:
            if  self.rssFeed == nil {
                self.rssFeed = RSSFeed()
            }
            if let path = RSSPath(rawValue: self.currentXMLDOMPath.absoluteString) {
                self.rssFeed?.map(attributeDict, for: path)
            }
            
        }
        
    }
    
    func parser(
        _ parser: XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?)
    {
        // Update the current path along the XML's DOM elements by deleting last component.
        self.currentXMLDOMPath = self.currentXMLDOMPath.deletingLastPathComponent()
        if currentXMLDOMPath.absoluteString == "/" {
            parseComplete = true
            xmlParser.abortParsing()
        }
    }
    
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        guard let string = String(data: CDATABlock, encoding: .utf8) else {
            self.xmlParser.abortParsing()
            self.parsingError = ParserError.feedCDATABlockEncodingError(path: self.currentXMLDOMPath.absoluteString)
            return
        }
        self.map(string)
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.map(string)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        // Ignore errors that occur after a feed is successfully parsed. Some
        // real-world feeds contain junk such as "[]" after the XML segment;
        // just ignore this stuff.
        guard !parseComplete, parsingError == nil else { return }
        self.parsingError = parseError
    }
    
}
