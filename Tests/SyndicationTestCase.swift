//
//  SyndicationTestCase.swift
//  IrisKit
//
//  Created by Nuno Dias on 17/05/16.
//
//

import XCTest
import IrisKit

class SyndicationTestCase: BaseTestCase {
    
    func testSyndication() {

        // Given
        let URL = fileURL("Syndication", type: "xml")
        let parser = IrisFeedParser(URL: URL)
        
        // When
        parser.parse { (feed) in
            
            // Then
            guard let channel = feed?.channel else {
                assert(false)
            }
            
            assert(channel.syUpdatePeriod == SyndicationUpdatePeriod.Hourly)
            assert(channel.syUpdateFrequency == UInt(2))
            assert(channel.syUpdateBase == "2000-01-01T12:00+00:00")

        }
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
