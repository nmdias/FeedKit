//
//  iTunesTests.swift
//  FeedKit
//
//  Created by Ben Murphy on 1/25/17.
//
//

import XCTest
import FeedKit

class iTunesTests: BaseTestCase {

    func testITunes() {
        //Given
        let URL = fileURL("iTunesPodcasting", type: "xml")
        let parser = FeedParser(URL: URL)!

        // When
        parser.parse { (result) in

            let feed = result.rssFeed

            // Then
            XCTAssertNotNil(feed)
            XCTAssertEqual(feed?.iTunes?.iTunesAuthor, "Dan Carlin")
            XCTAssertNotNil(feed?.iTunes)
            XCTAssertEqual(feed?.iTunes?.iTunesCategories?.last?.category, "Society & Culture")
            XCTAssertEqual(feed?.iTunes?.iTunesCategories?.last?.subcategory, "History")


        }

    }





    
}
