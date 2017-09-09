//
//  DublinCoreTests.swift
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

class DublinCoreTests: BaseTestCase {
    
    func testRSSDublinCore() {
        
        // Given
        let URL = fileURL("RSSDC", type: "xml")
        let parser = FeedParser(URL: URL)!
        
        // When
        let feed = parser.parse().rssFeed
        
        // Then
        XCTAssertNotNil(feed)
        
        XCTAssertEqual(feed?.dublinCore?.dcTitle, "title")
        XCTAssertEqual(feed?.dublinCore?.dcCreator, "creator")
        XCTAssertEqual(feed?.dublinCore?.dcSubject, "subject")
        XCTAssertEqual(feed?.dublinCore?.dcDescription, "description")
        XCTAssertEqual(feed?.dublinCore?.dcPublisher, "publisher")
        XCTAssertEqual(feed?.dublinCore?.dcContributor, "contributor")
        XCTAssertNotNil(feed?.dublinCore?.dcDate)
        XCTAssertEqual(feed?.dublinCore?.dcType, "type")
        XCTAssertEqual(feed?.dublinCore?.dcFormat, "format")
        XCTAssertEqual(feed?.dublinCore?.dcIdentifier, "identifier")
        XCTAssertEqual(feed?.dublinCore?.dcSource, "source")
        XCTAssertEqual(feed?.dublinCore?.dcLanguage, "language")
        XCTAssertEqual(feed?.dublinCore?.dcRelation, "relation")
        XCTAssertEqual(feed?.dublinCore?.dcCoverage, "coverage")
        XCTAssertEqual(feed?.dublinCore?.dcRights, "rights")
        
        XCTAssertNotNil(feed?.items?.last?.dublinCore)
        
        XCTAssertEqual(feed?.items?.last?.dublinCore?.dcTitle, "title")
        XCTAssertEqual(feed?.items?.last?.dublinCore?.dcCreator, "creator")
        XCTAssertEqual(feed?.items?.last?.dublinCore?.dcSubject, "subject")
        XCTAssertEqual(feed?.items?.last?.dublinCore?.dcDescription, "description")
        XCTAssertEqual(feed?.items?.last?.dublinCore?.dcPublisher, "publisher")
        XCTAssertEqual(feed?.items?.last?.dublinCore?.dcContributor, "contributor")
        XCTAssertNotNil(feed?.items?.last?.dublinCore?.dcDate)
        XCTAssertEqual(feed?.items?.last?.dublinCore?.dcType, "type")
        XCTAssertEqual(feed?.items?.last?.dublinCore?.dcFormat, "format")
        XCTAssertEqual(feed?.items?.last?.dublinCore?.dcIdentifier, "identifier")
        XCTAssertEqual(feed?.items?.last?.dublinCore?.dcSource, "source")
        XCTAssertEqual(feed?.items?.last?.dublinCore?.dcLanguage, "language")
        XCTAssertEqual(feed?.items?.last?.dublinCore?.dcRelation, "relation")
        XCTAssertEqual(feed?.items?.last?.dublinCore?.dcCoverage, "coverage")
        XCTAssertEqual(feed?.items?.last?.dublinCore?.dcRights, "rights")
        
    }
    
    func testRssDublinCoreParsingPerformance() {
        
        self.measure {
            
            // Given
            let expectation = self.expectation(description: "Dublin Core Parsing Performance")
            let URL = self.fileURL("RSSDC", type: "xml")
            let parser = FeedParser(URL: URL)!
            
            // When
            parser.parseAsync{ (result) in
                
                // Then
                expectation.fulfill()
                
            }
            
            self.waitForExpectations(timeout: self.timeout, handler: nil)
            
        }
        
    }
 
    func testRDFDublinCore() {
        
        // Given
        let URL = fileURL("RDFDC", type: "xml")
        let parser = FeedParser(URL: URL)!
        
        // When
        let feed = parser.parse().rssFeed
        
        // Then
        XCTAssertNotNil(feed)
        
        XCTAssertEqual(feed?.dublinCore?.dcTitle, "title")
        XCTAssertEqual(feed?.dublinCore?.dcCreator, "creator")
        XCTAssertEqual(feed?.dublinCore?.dcSubject, "subject")
        XCTAssertEqual(feed?.dublinCore?.dcDescription, "description")
        XCTAssertEqual(feed?.dublinCore?.dcPublisher, "publisher")
        XCTAssertEqual(feed?.dublinCore?.dcContributor, "contributor")
        XCTAssertNotNil(feed?.dublinCore?.dcDate)
        XCTAssertEqual(feed?.dublinCore?.dcType, "type")
        XCTAssertEqual(feed?.dublinCore?.dcFormat, "format")
        XCTAssertEqual(feed?.dublinCore?.dcIdentifier, "identifier")
        XCTAssertEqual(feed?.dublinCore?.dcSource, "source")
        XCTAssertEqual(feed?.dublinCore?.dcLanguage, "language")
        XCTAssertEqual(feed?.dublinCore?.dcRelation, "relation")
        XCTAssertEqual(feed?.dublinCore?.dcCoverage, "coverage")
        XCTAssertEqual(feed?.dublinCore?.dcRights, "rights")
        
        XCTAssertNotNil(feed?.items?.last?.dublinCore)
        
        XCTAssertEqual(feed?.items?.last?.dublinCore?.dcTitle, "title")
        XCTAssertEqual(feed?.items?.last?.dublinCore?.dcCreator, "creator")
        XCTAssertEqual(feed?.items?.last?.dublinCore?.dcSubject, "subject")
        XCTAssertEqual(feed?.items?.last?.dublinCore?.dcDescription, "description")
        XCTAssertEqual(feed?.items?.last?.dublinCore?.dcPublisher, "publisher")
        XCTAssertEqual(feed?.items?.last?.dublinCore?.dcContributor, "contributor")
        XCTAssertNotNil(feed?.items?.last?.dublinCore?.dcDate)
        XCTAssertEqual(feed?.items?.last?.dublinCore?.dcType, "type")
        XCTAssertEqual(feed?.items?.last?.dublinCore?.dcFormat, "format")
        XCTAssertEqual(feed?.items?.last?.dublinCore?.dcIdentifier, "identifier")
        XCTAssertEqual(feed?.items?.last?.dublinCore?.dcSource, "source")
        XCTAssertEqual(feed?.items?.last?.dublinCore?.dcLanguage, "language")
        XCTAssertEqual(feed?.items?.last?.dublinCore?.dcRelation, "relation")
        XCTAssertEqual(feed?.items?.last?.dublinCore?.dcCoverage, "coverage")
        XCTAssertEqual(feed?.items?.last?.dublinCore?.dcRights, "rights")
        
    }
    
    func testRDFDublinCoreParsingPerformance() {
        
        self.measure {
            
            // Given
            let expectation = self.expectation(description: "Dublin Core Parsing Performance")
            let URL = self.fileURL("RDFDC", type: "xml")
            let parser = FeedParser(URL: URL)!
            
            // When
            parser.parseAsync{ (result) in
                
                // Then
                expectation.fulfill()
                
            }
            
            self.waitForExpectations(timeout: self.timeout, handler: nil)
            
        }
        
    }
    
}
