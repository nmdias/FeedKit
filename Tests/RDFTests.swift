//
//  RDFTests.swift
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

import XCTest
import FeedKit

class RDFTests: BaseTestCase {
    
    func testRDFFeed() {
        
        // Given
        let URL = fileURL("RDF", type: "xml")
        let parser = FeedParser(URL: URL)!
        
        // When
        let feed = parser.parse().rssFeed
        
        // Then
        XCTAssertNotNil(feed)
        
        XCTAssertEqual(feed?.title, "XML.com")
        XCTAssertEqual(feed?.link, "http://xml.com/pub")
        XCTAssertEqual(feed?.description, "XML.com features a rich mix of information and services for the XML community.")
        
        XCTAssertNotNil(feed?.items)
        XCTAssertEqual(feed?.items?.count, 2)
        
        XCTAssertEqual(feed?.items?.first?.title, "Processing Inclusions with XSLT")
        XCTAssertEqual(feed?.items?.first?.link, "http://xml.com/pub/2000/08/09/xslt/xslt.html")
        XCTAssertEqual(feed?.items?.first?.description, "Processing document inclusions with general XML tools can be problematic. This article proposes a way of preserving inclusion information through SAX-based processing.")
        
        XCTAssertEqual(feed?.items?.last?.title, "Putting RDF to Work")
        XCTAssertEqual(feed?.items?.last?.link, "http://xml.com/pub/2000/08/09/rdfdb/index.html")
        XCTAssertEqual(feed?.items?.last?.description, "Tool and API support for the Resource Description Framework is slowly coming of age. Edd Dumbill takes a look at RDFDB, one of the most exciting new RDF toolkits.")
        
    }
    
    func testRDFFeedParsingPerformance() {
        
        self.measure {
            
            // Given
            let expectation = self.expectation(description: "RDF Parsing Performance")
            let URL = self.fileURL("RDF", type: "xml")
            let parser = FeedParser(URL: URL)!
            
            // When
            parser.parseAsync { (result) in
                
                // Then
                expectation.fulfill()
                
            }
            
            self.waitForExpectations(timeout: self.timeout, handler: nil)
            
        }
        
    }
    
}
