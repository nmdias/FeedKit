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
            XCTAssertEqual(feed?.iTunes?.iTunesSummary, "In \"Hardcore History\" journalist and broadcaster Dan Carlin takes his \"Martian\", unorthodox way of thinking and applies it to the past. Was Alexander the Great as bad a person as Adolf Hitler? What would Apaches with modern weapons be like? Will our modern civilization ever fall like civilizations from past eras? This isn't academic history (and Carlin isn't a historian) but the podcast's unique blend of high drama, masterful narration and Twilight Zone-style twists has entertained millions of listeners.")
            XCTAssertEqual(feed?.items?.last?.iTunes?.iTunesDuration, 16081)
        }

    }





    
}
