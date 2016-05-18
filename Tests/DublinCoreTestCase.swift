//
//  DublinCoreTestCase.swift
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

class DublinCoreTestCase: BaseTestCase {
    
    func testDublinCore() {
        
        // Given
        let URL = fileURL("DC", type: "xml")
        let parser = FeedParser(URL: URL)
        
        // When
        parser.parse { (feed) in
            
            //Then
            guard let channel = feed?.channel else {
                assert(false)
            }
            
            assert(channel.dcTitle                      == "title")
            assert(channel.dcCreator                    == "creator")
            assert(channel.dcSubject                    == "subject")
            assert(channel.dcDescription                == "description")
            assert(channel.dcPublisher                  == "publisher")
            assert(channel.dcContributor                == "contributor")
            assert(channel.dcDate                       == "date")
            assert(channel.dcType                       == "type")
            assert(channel.dcFormat                     == "format")
            assert(channel.dcIdentifier                 == "identifier")
            assert(channel.dcSource                     == "source")
            assert(channel.dcLanguage                   == "language")
            assert(channel.dcRelation                   == "relation")
            assert(channel.dcCoverage                   == "coverage")
            assert(channel.dcRights                     == "rights")
            
            assert(channel.items?.last?.dcTitle         == "title")
            assert(channel.items?.last?.dcCreator       == "creator")
            assert(channel.items?.last?.dcSubject       == "subject")
            assert(channel.items?.last?.dcDescription   == "description")
            assert(channel.items?.last?.dcPublisher     == "publisher")
            assert(channel.items?.last?.dcContributor   == "contributor")
            assert(channel.items?.last?.dcDate          == "date")
            assert(channel.items?.last?.dcType          == "type")
            assert(channel.items?.last?.dcFormat        == "format")
            assert(channel.items?.last?.dcIdentifier    == "identifier")
            assert(channel.items?.last?.dcSource        == "source")
            assert(channel.items?.last?.dcLanguage      == "language")
            assert(channel.items?.last?.dcRelation      == "relation")
            assert(channel.items?.last?.dcCoverage      == "coverage")
            assert(channel.items?.last?.dcRights        == "rights")
            
        }
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
