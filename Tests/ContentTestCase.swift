//
//  ContentTestCase.swift
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

class ContentTestCase: BaseTestCase {
    
    func testContent() {
        
        // Given
        let URL = fileURL("Content", type: "xml")
        let parser = FeedParser(URL: URL)
        
        // When
        parser.parse { (feed) in
            
            // Then
            assert(feed?.channel != nil)
            
            assert(feed?.channel?.dcTitle                      == "title")
            assert(feed?.channel?.dcCreator                    == "creator")
            assert(feed?.channel?.dcSubject                    == "subject")
            assert(feed?.channel?.dcDescription                == "description")
            assert(feed?.channel?.dcPublisher                  == "publisher")
            assert(feed?.channel?.dcContributor                == "contributor")
            assert(feed?.channel?.dcDate                       == "date")
            assert(feed?.channel?.dcType                       == "type")
            assert(feed?.channel?.dcFormat                     == "format")
            assert(feed?.channel?.dcIdentifier                 == "identifier")
            assert(feed?.channel?.dcSource                     == "source")
            assert(feed?.channel?.dcLanguage                   == "language")
            assert(feed?.channel?.dcRelation                   == "relation")
            assert(feed?.channel?.dcCoverage                   == "coverage")
            assert(feed?.channel?.dcRights                     == "rights")
            
            assert(feed?.channel?.items?.last?.dcTitle         == "title")
            assert(feed?.channel?.items?.last?.dcCreator       == "creator")
            assert(feed?.channel?.items?.last?.dcSubject       == "subject")
            assert(feed?.channel?.items?.last?.dcDescription   == "description")
            assert(feed?.channel?.items?.last?.dcPublisher     == "publisher")
            assert(feed?.channel?.items?.last?.dcContributor   == "contributor")
            assert(feed?.channel?.items?.last?.dcDate          == "date")
            assert(feed?.channel?.items?.last?.dcType          == "type")
            assert(feed?.channel?.items?.last?.dcFormat        == "format")
            assert(feed?.channel?.items?.last?.dcIdentifier    == "identifier")
            assert(feed?.channel?.items?.last?.dcSource        == "source")
            assert(feed?.channel?.items?.last?.dcLanguage      == "language")
            assert(feed?.channel?.items?.last?.dcRelation      == "relation")
            assert(feed?.channel?.items?.last?.dcCoverage      == "coverage")
            assert(feed?.channel?.items?.last?.dcRights        == "rights")
            
        }
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
