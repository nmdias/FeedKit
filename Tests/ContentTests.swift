//
//  ContentTests.swift
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

class ContentTests: BaseTestCase {
    
    func testContent() {
        
        // Given
        let URL = fileURL("Content", type: "xml")
        let parser = FeedParser(URL: URL)!
        
        // When
        let feed = parser.parse().rssFeed
        
        // Then
        XCTAssertNotNil(feed)
        XCTAssertNotNil(feed?.items?.last?.content)
        XCTAssertEqual(feed?.items?.last?.content?.contentEncoded, "<p>What a <em>beautiful</em> day!</p>")
        
    }
    
    func testContentParsingPerformance() {
        
        self.measure {
            
            // Given
            let expectation = self.expectation(description: "Content Parsing Performance")
            let URL = self.fileURL("Content", type: "xml")
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
