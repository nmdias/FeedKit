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
open class FeedParser {
    
    /**
     
     The actual engine behind the `FeedKit` framework. `Parser` handles
     the parsing of RSS and Atom feeds.
     
     */
    let parser: Parser
    
    
    
    /**
     
     Initializes the parser with the XML content referenced by the given URL.
     
     - parameter URL: An URL object specifying a URL
     
     - returns: An instance of the feed parser.
     
     */
    public init?(URL: URL) {
        
        guard let parser = Parser(contentsOf: URL) else {
            return nil
        }
        
        self.parser = parser
        
    }
    
    
    
    /**
     
     Initializes the parser with the XML contents encapsulated in a given data object.
     
     - parameter data: An `Data` object containing XML markup.
     
     - returns: An instance of the `FeedParser`.
     
     */
    public init(data: Data) {
        self.parser = Parser(data: data)
    }
    
    
    
    /**
     
     Initializes the parser with the specified stream.
     
     - parameter stream: The input stream. The content is incrementally loaded from the specified stream and parsed. The the underlying `XMLParser` will open the stream, and synchronously read from it without scheduling it.
     
     - returns: An instance of the `FeedParser`.
     
     */
    public init(stream: InputStream) {
        self.parser = Parser(stream: stream)
    }
    
    
    
    /**
     
     Starts parsing the feed.
     
     */
    open func parse(_ result: @escaping (Result) -> Void) {
        self.parser.parse(result)
    }
    
    
    /**
     
     Stops parsing the feed.
     
     */
    open func abortParsing() {
        self.parser.abortParsing()
    }
    
}


