//
//  iTunesTests.swift
//
//  Copyright (c) 2017 Ben Murphy
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
import Feeds

class iTunesTests: BaseTestCase {

    func testITunesFeed() async {
        //Given
        let URL = fileURL("iTunesPodcasting", withExtension: "xml")

        do {
            // When
            let feed = try await RSSFeed(URL: URL)

            // Then
            XCTAssertNotNil(feed)
            XCTAssertNotNil(feed.channel?.iTunes)
            
            XCTAssertEqual(feed.channel?.iTunes?.iTunesTitle, "Dan Carlin's Hardcore History")
            XCTAssertEqual(feed.channel?.iTunes?.iTunesAuthor, "Dan Carlin")
            XCTAssertEqual(feed.channel?.iTunes?.iTunesBlock, "No")
            XCTAssertEqual(feed.channel?.iTunes?.iTunesCategories?.last?.text, "Society & Culture")
            XCTAssertEqual(feed.channel?.iTunes?.iTunesCategories?.last?.subcategory?.text, "History")
            XCTAssertEqual(feed.channel?.iTunes?.iTunesImage?.href, "http://www.dancarlin.com/graphics/DC_HH_iTunes.jpg")
            XCTAssertEqual(feed.channel?.iTunes?.iTunesExplicit, "no")
            XCTAssertEqual(feed.channel?.iTunes?.iTunesComplete, "No")
            XCTAssertEqual(feed.channel?.iTunes?.iTunesNewFeedURL, "http://newlocation.com/example.rss")
            XCTAssertEqual(feed.channel?.iTunes?.iTunesOwner?.email, "dan@dancarlin.com")
            XCTAssertEqual(feed.channel?.iTunes?.iTunesOwner?.name, "Dan Carlin's Hardcore History")
            XCTAssertEqual(feed.channel?.iTunes?.iTunesSubtitle, "This isn't academic history (and Carlin isn't a historian) but the podcast's unique blend of high drama, masterful narration and Twilight Zone-style twists has entertained millions of listeners.")
            XCTAssertEqual(feed.channel?.iTunes?.iTunesSummary, "In \"Hardcore History\" journalist and broadcaster Dan Carlin takes his \"Martian\", unorthodox way of thinking and applies it to the past. Was Alexander the Great as bad a person as Adolf Hitler? What would Apaches with modern weapons be like? Will our modern civilization ever fall like civilizations from past eras? This isn't academic history (and Carlin isn't a historian) but the podcast's unique blend of high drama, masterful narration and Twilight Zone-style twists has entertained millions of listeners.")
            XCTAssertEqual(feed.channel?.iTunes?.iTunesKeywords, "History, Military, War, Ancient, Archaeology, Classics, Carlin")
            XCTAssertEqual(feed.channel?.iTunes?.iTunesType, "episodic")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testITunesFeedItems() async {
        //Given
        let URL = fileURL("iTunesPodcasting", withExtension: "xml")

        do {
            // When
            let feed = try await RSSFeed(URL: URL)

            // Then
            XCTAssertNotNil(feed.channel?.items?.first?.iTunes)
            XCTAssertEqual(feed.channel?.items?.first?.iTunes?.iTunesTitle, "Dan Carlin's Hardcore History")
            XCTAssertEqual(feed.channel?.items?.first?.iTunes?.iTunesAuthor, "Dan Carlin")
            XCTAssertEqual(feed.channel?.items?.first?.iTunes?.iTunesBlock, "No")
            XCTAssertEqual(feed.channel?.items?.first?.iTunes?.isClosedCaptioned, "Yes")
            XCTAssertEqual(feed.channel?.items?.first?.iTunes?.iTunesOrder, 1)
            XCTAssertEqual(feed.channel?.items?.first?.iTunes?.iTunesImage?.href, "http://www.dancarlin.com/graphics/DC_HH_iTunes.jpg")
            
            XCTAssertNil(feed.channel?.items?.last?.iTunes?.iTunesImage)
            
            XCTAssertEqual(feed.channel?.items?.first?.iTunes?.iTunesDuration, 18030)
            XCTAssertEqual(feed.channel?.items?.last?.iTunes?.iTunesDuration, 16081)
            XCTAssertEqual(feed.channel?.items?.first?.iTunes?.iTunesExplicit, "No")
            XCTAssertEqual(feed.channel?.items?.first?.iTunes?.iTunesSubtitle, "If this were a movie, the events and cameos would be too numerous and star-studded to mention. It includes Xerxes, Spartans, Immortals, Alexander the Great, scythed chariots, and several of the greatest battles in history.")
            XCTAssertEqual(feed.channel?.items?.first?.iTunes?.iTunesSummary, "If this were a movie, the events and cameos would be too numerous and star-studded to mention. It includes Xerxes, Spartans, Immortals, Alexander the Great, scythed chariots, and several of the greatest battles in history.")
            XCTAssertEqual(feed.channel?.items?.first?.iTunes?.iTunesKeywords, "Persia, Achaemenid, Xerxes, Darius, Artaxerxes, Greek, Macedonian, ancient history, military, Philip, Alexander, Spartan, Athens, Herodotus, Leonidas, podcast, Plataea, Issus, Salamis, Gaugamela")
            XCTAssertEqual(feed.channel?.items?.first?.iTunes?.iTunesEpisodeType, "full")
            XCTAssertEqual(feed.channel?.items?.first?.iTunes?.iTunesSeason, 3)
            XCTAssertEqual(feed.channel?.items?.first?.iTunes?.iTunesEpisode, 2)
        } catch {
            XCTFail(error.localizedDescription)
        }
        


    }
    
    
    
    
    
}
