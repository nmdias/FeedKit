//
//  DublinCoreTests.swift
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

import XCTest
import FeedParser

class DublinCoreTests: BaseTestCase {
    
    func testDublinCore() {
        
        // Given
        let URL = fileURL("DC", type: "xml")
        let parser = FeedParser(URL: URL)!
        
        // When
        parser.parse { (result) in
            
            let feed = result.rssFeed
            
            // Then
            assert(feed != nil)
            
            assert(feed?.dublinCore?.dcTitle                      == "title")
            assert(feed?.dublinCore?.dcCreator                    == "creator")
            assert(feed?.dublinCore?.dcSubject                    == "subject")
            assert(feed?.dublinCore?.dcDescription                == "description")
            assert(feed?.dublinCore?.dcPublisher                  == "publisher")
            assert(feed?.dublinCore?.dcContributor                == "contributor")
            assert(feed?.dublinCore?.dcDate                       == "date")
            assert(feed?.dublinCore?.dcType                       == "type")
            assert(feed?.dublinCore?.dcFormat                     == "format")
            assert(feed?.dublinCore?.dcIdentifier                 == "identifier")
            assert(feed?.dublinCore?.dcSource                     == "source")
            assert(feed?.dublinCore?.dcLanguage                   == "language")
            assert(feed?.dublinCore?.dcRelation                   == "relation")
            assert(feed?.dublinCore?.dcCoverage                   == "coverage")
            assert(feed?.dublinCore?.dcRights                     == "rights")
            
            assert(feed?.items?.last?.dublinCore != nil)
            
            assert(feed?.items?.last?.dublinCore?.dcTitle         == "title")
            assert(feed?.items?.last?.dublinCore?.dcCreator       == "creator")
            assert(feed?.items?.last?.dublinCore?.dcSubject       == "subject")
            assert(feed?.items?.last?.dublinCore?.dcDescription   == "description")
            assert(feed?.items?.last?.dublinCore?.dcPublisher     == "publisher")
            assert(feed?.items?.last?.dublinCore?.dcContributor   == "contributor")
            assert(feed?.items?.last?.dublinCore?.dcDate          == "date")
            assert(feed?.items?.last?.dublinCore?.dcType          == "type")
            assert(feed?.items?.last?.dublinCore?.dcFormat        == "format")
            assert(feed?.items?.last?.dublinCore?.dcIdentifier    == "identifier")
            assert(feed?.items?.last?.dublinCore?.dcSource        == "source")
            assert(feed?.items?.last?.dublinCore?.dcLanguage      == "language")
            assert(feed?.items?.last?.dublinCore?.dcRelation      == "relation")
            assert(feed?.items?.last?.dublinCore?.dcCoverage      == "coverage")
            assert(feed?.items?.last?.dublinCore?.dcRights        == "rights")
            
        }
        
    }
    
    func testDublinCoreParsingPerformance() {
        
        self.measureBlock {
            
            // Given
            let expectation = self.expectationWithDescription("Dublin Core Parsing Performance")
            let URL = self.fileURL("DC", type: "xml")
            let parser = FeedParser(URL: URL)!
            
            // When
            parser.parse({ (result) in
                
                // Then
                expectation.fulfill()
                
            })
            
            self.waitForExpectationsWithTimeout(self.timeout, handler: nil)
            
        }
        
    }
    
}
