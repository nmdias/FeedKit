//
//  URLNotFoundTests.swift
//  FeedKit
//
//  Created by Brett Ohland on 7/19/16.
//
//

import XCTest
@testable import FeedKit

class URLNotFoundTests: BaseTestCase {
    
    func testBadURL() {
    
        // Given
        let URL = NSURL()
        let parser = FeedParser(URL: URL)!
        
        // When
        parser.parse { (result) in
            
            // Then
            switch result {
            case .Atom(_):
                XCTFail("Unexpected atom feed found")
            case .RSS(_):
                XCTFail("Unexpected rss feed found")
            case .Failure(let error):
                // Error code -1 is the NSCocoaErrorDomain that represents "Could not open data stream"
                XCTAssertEqual(error.code, -1)
            }
            
        }
    }
    
    
    
}
