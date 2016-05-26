//
//  AtomTestCase.swift
//  FeedParser
//
//  Created by Nuno Dias on 26/05/16.
//
//

import XCTest
import FeedParser

class AtomTestCase: BaseTestCase {
    
    func testFeed() {
        
        // Given
        let URL = fileURL("Atom", type: "xml")
        let parser = FeedParser(URL: URL)
        
        // When
        parser.parse { (result) in
            
            let feed = result.atomFeed
            
            // Then
            // TODO: - Run tests here
            
            
            
        }
        
        
    }
    
}