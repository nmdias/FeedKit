//
//  FeedParser.swift
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
import Dispatch

/**
 
 An RSS and Atom feed parser. `FeedParser` uses `Foundation`'s
 `XMLParser`.
 
 */
public class FeedParser {
    
    /**
     
     The actual engine behind the `FeedKit` framework. `Parser` handles
     the parsing of RSS and Atom feeds.
     
     */
    let parser: FeedParserProtocol
    
    
    
    /**
     
     Initializes the parser with the XML contents encapsulated in a given data 
     object.
     
     - parameter data: An `Data` object containing XML markup.
     
     - returns: An instance of the `FeedParser`.
     
     */
    public init?(data: Data) {
        
        guard let feedDataType = FeedDataType(data: data) else { return nil }
        
        switch feedDataType {
        case .json:
            self.parser = JSONFeedParser(data: data)
        case .xml:
            self.parser = XMLFeedParser(data: data)
        }
        
    }
    
    
    
    /**
     
     Initializes the parser with the XML content referenced by the given URL.
     
     - parameter URL: An URL object specifying a URL
     
     - returns: An instance of the feed parser.
     
     */
    public convenience init?(URL: URL) {
        
        guard let data = try? Data(contentsOf: URL) else {
            return nil
        }
        
        self.init(data: data)
        
    }
    
    
    
    /**
     
     Starts parsing the feed.
     
     */
    public func parse() -> Result {
        return self.parser.parse()
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
    public func parseAsync(queue: DispatchQueue = DispatchQueue.main, result: @escaping (Result) -> Void) {
        queue.async {
            result(self.parse())
        }
    }
    
    /**
     
     Stops parsing XML feeds.
     
     */
    public func abortParsing() {
        
        if let xmlFeedParser = self.parser as? XMLFeedParser {
            xmlFeedParser.xmlParser.abortParsing()
        }
        
    }
    
}


