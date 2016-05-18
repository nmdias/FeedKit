//
//  ContentTestCase.swift
//  FeedParser
//
//  Created by Nuno Dias on 17/05/16.
//
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
