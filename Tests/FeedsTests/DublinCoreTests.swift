//
//  DublinCoreTests.swift
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

import XCTest
import Feeds

class DublinCoreTests: BaseTestCase {
    
    func testRSSDublinCore() async {
        
        // Given
        let URL = fileURL("RSSDC", withExtension: "xml")
        
        do {
            // When
            let feed = try await RSSFeed(URL: URL)

            XCTAssertEqual(feed.channel?.dublinCore?.title, "title")
            XCTAssertEqual(feed.channel?.dublinCore?.creator, "creator")
            XCTAssertEqual(feed.channel?.dublinCore?.subject, "subject")
            XCTAssertEqual(feed.channel?.dublinCore?.description, "description")
            XCTAssertEqual(feed.channel?.dublinCore?.publisher, "publisher")
            XCTAssertEqual(feed.channel?.dublinCore?.contributor, "contributor")
            
            XCTAssertNotNil(feed.channel?.dublinCore?.date)
            
            XCTAssertEqual(feed.channel?.dublinCore?.type, "type")
            XCTAssertEqual(feed.channel?.dublinCore?.format, "format")
            XCTAssertEqual(feed.channel?.dublinCore?.identifier, "identifier")
            XCTAssertEqual(feed.channel?.dublinCore?.source, "source")
            XCTAssertEqual(feed.channel?.dublinCore?.language, "language")
            XCTAssertEqual(feed.channel?.dublinCore?.relation, "relation")
            XCTAssertEqual(feed.channel?.dublinCore?.coverage, "coverage")
            XCTAssertEqual(feed.channel?.dublinCore?.rights, "rights")
            
            XCTAssertNotNil(feed.channel?.items?.last?.dublinCore)
            
            XCTAssertEqual(feed.channel?.items?.last?.dublinCore?.title, "title")
            XCTAssertEqual(feed.channel?.items?.last?.dublinCore?.creator, "creator")
            XCTAssertEqual(feed.channel?.items?.last?.dublinCore?.subject, "subject")
            XCTAssertEqual(feed.channel?.items?.last?.dublinCore?.description, "description")
            XCTAssertEqual(feed.channel?.items?.last?.dublinCore?.publisher, "publisher")
            XCTAssertEqual(feed.channel?.items?.last?.dublinCore?.contributor, "contributor")
            
            XCTAssertNotNil(feed.channel?.items?.last?.dublinCore?.date)
            
            XCTAssertEqual(feed.channel?.items?.last?.dublinCore?.type, "type")
            XCTAssertEqual(feed.channel?.items?.last?.dublinCore?.format, "format")
            XCTAssertEqual(feed.channel?.items?.last?.dublinCore?.identifier, "identifier")
            XCTAssertEqual(feed.channel?.items?.last?.dublinCore?.source, "source")
            XCTAssertEqual(feed.channel?.items?.last?.dublinCore?.language, "language")
            XCTAssertEqual(feed.channel?.items?.last?.dublinCore?.relation, "relation")
            XCTAssertEqual(feed.channel?.items?.last?.dublinCore?.coverage, "coverage")
            XCTAssertEqual(feed.channel?.items?.last?.dublinCore?.rights, "rights")
        } catch {
            XCTFail(String(describing: error))
        }
    }
    
    func testRssDublinCoreParsingPerformance() {
        
        self.measure {
            
            // Given
            let expectation = self.expectation(description: "Dublin Core Parsing Performance")
            let URL = self.fileURL("RSSDC", withExtension: "xml")
  
            // When
            Task {
                _ = await try RSSFeed(URL: URL)
                
                // Then
                expectation.fulfill()
            }
            
            self.waitForExpectations(timeout: self.timeout, handler: nil)
        }
    }
 
    func testRDFDublinCore() async {
        
        // Given
        let URL = fileURL("RDFDC", withExtension: "xml")
        
        do {
            // When
            let feed = try await RDFFeed(URL: URL)

            XCTAssertEqual(feed.channel?.dublinCore?.title, "title")
            XCTAssertEqual(feed.channel?.dublinCore?.creator, "creator")
            XCTAssertEqual(feed.channel?.dublinCore?.subject, "subject")
            XCTAssertEqual(feed.channel?.dublinCore?.description, "description")
            XCTAssertEqual(feed.channel?.dublinCore?.publisher, "publisher")
            XCTAssertEqual(feed.channel?.dublinCore?.contributor, "contributor")
            
            XCTAssertNotNil(feed.channel?.dublinCore?.date)
            
            XCTAssertEqual(feed.channel?.dublinCore?.type, "type")
            XCTAssertEqual(feed.channel?.dublinCore?.format, "format")
            XCTAssertEqual(feed.channel?.dublinCore?.identifier, "identifier")
            XCTAssertEqual(feed.channel?.dublinCore?.source, "source")
            XCTAssertEqual(feed.channel?.dublinCore?.language, "language")
            XCTAssertEqual(feed.channel?.dublinCore?.relation, "relation")
            XCTAssertEqual(feed.channel?.dublinCore?.coverage, "coverage")
            XCTAssertEqual(feed.channel?.dublinCore?.rights, "rights")
            
            XCTAssertNotNil(feed.items?.last?.dublinCore)
            
            XCTAssertEqual(feed.items?.last?.dublinCore?.title, "title")
            XCTAssertEqual(feed.items?.last?.dublinCore?.creator, "creator")
            XCTAssertEqual(feed.items?.last?.dublinCore?.subject, "subject")
            XCTAssertEqual(feed.items?.last?.dublinCore?.description, "description")
            XCTAssertEqual(feed.items?.last?.dublinCore?.publisher, "publisher")
            XCTAssertEqual(feed.items?.last?.dublinCore?.contributor, "contributor")
            
            XCTAssertNotNil(feed.items?.last?.dublinCore?.date)
            
            XCTAssertEqual(feed.items?.last?.dublinCore?.type, "type")
            XCTAssertEqual(feed.items?.last?.dublinCore?.format, "format")
            XCTAssertEqual(feed.items?.last?.dublinCore?.identifier, "identifier")
            XCTAssertEqual(feed.items?.last?.dublinCore?.source, "source")
            XCTAssertEqual(feed.items?.last?.dublinCore?.language, "language")
            XCTAssertEqual(feed.items?.last?.dublinCore?.relation, "relation")
            XCTAssertEqual(feed.items?.last?.dublinCore?.coverage, "coverage")
            XCTAssertEqual(feed.items?.last?.dublinCore?.rights, "rights")
            
        } catch {
            XCTFail(String(describing: error))
        }
    }
    
    func testRDFDublinCoreParsingPerformance() {
        self.measure {
            // Given
            let expectation = self.expectation(description: "Dublin Core Parsing Performance")
            let URL = self.fileURL("RDFDC", withExtension: "xml")
            
            // When
            Task {
                _ = try await RDFFeed(URL: URL)
                
                // Then
                expectation.fulfill()
            }
            
            self.waitForExpectations(timeout: self.timeout, handler: nil)
        }
    }
}
