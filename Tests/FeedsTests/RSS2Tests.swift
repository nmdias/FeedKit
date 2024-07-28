//
//  RSS2Tests.swift
//
//  Copyright (c) 2016 - 2018 Nuno Manuel Dias
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

class RSS2Tests: BaseTestCase {
    
    func testRSS2Feed() async {
        
        // Given
        let URL = fileURL("RSS2", withExtension: "xml")
        
        do {
            // When
            let feed = try await RSSFeed(URL: URL)

            // Then
            XCTAssertNotNil(feed)
            
            XCTAssertEqual(feed.channel?.title, "Iris")
            XCTAssertEqual(feed.channel?.link, "http://www.iris.news/", "")
            XCTAssertEqual(feed.channel?.description, "The one place for you daily news.")
            XCTAssertEqual(feed.channel?.language, "en-us")
            XCTAssertEqual(feed.channel?.copyright, "Copyright 2015, Iris News")
            XCTAssertEqual(feed.channel?.managingEditor, "john.appleseed.editor@iris.news (John Appleseed)")
            XCTAssertEqual(feed.channel?.webMaster, "john.appleseed.master@iris.news (John Appleseed)")
            
            XCTAssertNotNil(feed.channel?.pubDate)
            XCTAssertNotNil(feed.channel?.lastBuildDate)
            XCTAssertNotNil(feed.channel?.categories)
            
            XCTAssertEqual(feed.channel?.categories?.count, 2)
            XCTAssertEqual(feed.channel?.categories?.first?.category, "Media")
            
            XCTAssertEqual(feed.channel?.categories?.first?.domain, nil)
            XCTAssertEqual(feed.channel?.categories?.last?.category, "News/Media/Science")
            
            XCTAssertEqual(feed.channel?.categories?.last?.domain, "dmoz")
            XCTAssertEqual(feed.channel?.generator, "Iris Gen")
            XCTAssertEqual(feed.channel?.docs, "http://blogs.law.harvard.edu/tech/rss")
            
            XCTAssertEqual(feed.channel?.cloud?.domain, "server.iris.com")
            XCTAssertEqual(feed.channel?.cloud?.path, "/rpc")
            XCTAssertEqual(feed.channel?.cloud?.port, 80)
            XCTAssertEqual(feed.channel?.cloud?.protocolSpecification, "xml-rpc")
            XCTAssertEqual(feed.channel?.cloud?.registerProcedure, "cloud.notify")
            XCTAssertEqual(feed.channel?.rating, "(PICS-1.1 \"http://www.rsac.org/ratingsv01.html\" l by \"webmaster@example.com\" on \"2007.01.29T10:09-0800\" r (n 0 s 0 v 0 l 0))")
            XCTAssertEqual(feed.channel?.ttl, 60)
            
            XCTAssertNotNil(feed.channel?.image)
            
            XCTAssertEqual(feed.channel?.image?.link, "http://www.iris.news/")
            XCTAssertEqual(feed.channel?.image?.url, "http://www.iris.news/image.jpg")
            XCTAssertEqual(feed.channel?.image?.title, "Iris")
            XCTAssertEqual(feed.channel?.image?.description, "Read the Iris news feed.")
            XCTAssertEqual(feed.channel?.image?.width, 64)
            XCTAssertEqual(feed.channel?.image?.height, 192)
            
            XCTAssertNotNil(feed.channel?.skipDays)
            
            XCTAssertEqual(feed.channel?.skipDays?.day?.count, 2)
            XCTAssertEqual(feed.channel?.skipDays?.day?.first, WeekDay.saturday)
            XCTAssertEqual(feed.channel?.skipDays?.day?.last, WeekDay.sunday)
            
            XCTAssertNotNil(feed.channel?.skipHours)
            
            XCTAssertEqual(feed.channel?.skipHours?.hour?.count, 5)
            XCTAssertEqual(feed.channel?.skipHours?.hour?.first, 0)
            XCTAssertEqual(feed.channel?.skipHours?.hour?[1], 1)
            XCTAssertEqual(feed.channel?.skipHours?.hour?[2], 2)
            XCTAssertEqual(feed.channel?.skipHours?.hour?[3], 22)
            XCTAssertEqual(feed.channel?.skipHours?.hour?[4], 23)
            
            XCTAssertNotNil(feed.channel?.textInput)
            
            XCTAssertEqual(feed.channel?.textInput?.title, "TextInput Inquiry")
            XCTAssertEqual(feed.channel?.textInput?.description, "Your aggregator supports the textInput element. What software are you using?")
            XCTAssertEqual(feed.channel?.textInput?.name, "query")
            XCTAssertEqual(feed.channel?.textInput?.link, "http://www.iris.com/textinput.php")
            
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        
    }
    
    func testFeedItems() async {
        // Given
        let URL = fileURL("RSS2", withExtension: "xml")

        // When
        do {
            let feed = try await RSSFeed(URL: URL)
            
            // Then
            XCTAssertNotNil(feed)
            
            XCTAssertNotNil(feed.channel?.items)
            XCTAssertEqual(feed.channel?.items?.count, 2)
            
            XCTAssertEqual(feed.channel?.items?.first?.title, "Seventh Heaven! Ryan Hurls Another No Hitter")
            XCTAssertEqual(feed.channel?.items?.first?.link, "http://dallas.example.com/1991/05/02/nolan.htm")
            XCTAssertEqual(feed.channel?.items?.first?.author, "jbb@dallas.example.com (Joe Bob Briggs)")
            
            XCTAssertNotNil(feed.channel?.items?.first?.categories)
            XCTAssertEqual(feed.channel?.items?.first?.categories?.count, 2)
            
            XCTAssertEqual(feed.channel?.items?.first?.categories?.first?.category, "movies")
            XCTAssertEqual(feed.channel?.items?.first?.categories?.first?.domain, nil)
            
            XCTAssertEqual(feed.channel?.items?.first?.categories?.last?.category, "1983/V")
            XCTAssertEqual(feed.channel?.items?.first?.categories?.last?.domain, "rec.arts.movies.reviews")
            
            XCTAssertEqual(feed.channel?.items?.first?.comments, "http://dallas.example.com/feedback/1983/06/joebob.htm")
            XCTAssertEqual(feed.channel?.items?.first?.description, "I'm headed for France. I wasn't gonna go this year, but then last week \"Valley Girl\" came out and I said to myself, Joe Bob, you gotta get out of the country for a while.")
            
            XCTAssertNotNil(feed.channel?.items?.first?.enclosure)
            XCTAssertEqual(feed.channel?.items?.first?.enclosure?.length, 24986239)
            XCTAssertEqual(feed.channel?.items?.first?.enclosure?.type, "audio/mpeg")
            XCTAssertEqual(feed.channel?.items?.first?.enclosure?.url, "http://dallas.example.com/joebob_050689.mp3")
            
            XCTAssertNotNil(feed.channel?.items?.first?.guid)
            XCTAssertEqual(feed.channel?.items?.first?.guid?.guid, "tag:dallas.example.com,4131:news")
            XCTAssertEqual(feed.channel?.items?.first?.guid?.isPermaLink, false)
            
            XCTAssertNotNil(feed.channel?.items?.first?.pubDate)
            
            XCTAssertNotNil(feed.channel?.items?.first?.source)
            XCTAssertEqual(feed.channel?.items?.first?.source?.source, "Los Angeles Herald-Examiner")
            XCTAssertEqual(feed.channel?.items?.first?.source?.url, "http://la.example.com/rss.xml")
            
            XCTAssertEqual(feed.channel?.items?.last?.title, "Seventh Heaven! Ryan Hurls Another No Hitter")
            XCTAssertEqual(feed.channel?.items?.last?.link, "http://dallas.example.com/1991/05/02/nolan.htm")
            XCTAssertEqual(feed.channel?.items?.last?.author, "jbb@dallas.example.com (Joe Bob Briggs)")
            
            XCTAssertNotNil(feed.channel?.items?.last?.categories)
            XCTAssertEqual(feed.channel?.items?.last?.categories?.count, 2)
            
            XCTAssertEqual(feed.channel?.items?.last?.categories?.first?.category, "movies")
            XCTAssertEqual(feed.channel?.items?.last?.categories?.first?.domain, nil)
            
            XCTAssertEqual(feed.channel?.items?.last?.categories?.last?.category, "1983/V")
            XCTAssertEqual(feed.channel?.items?.last?.categories?.last?.domain, "rec.arts.movies.reviews")
            
            XCTAssertEqual(feed.channel?.items?.last?.comments, "http://dallas.example.com/feedback/1983/06/joebob.htm")
            XCTAssertEqual(feed.channel?.items?.last?.description, "I\'m headed for France. I wasn\'t gonna go this year, but then last week <a href=\"http://www.imdb.com/title/tt0086525/\">Valley Girl</a> came out and I said to myself, Joe Bob, you gotta get out of the country for a while.")
            
            XCTAssertNotNil(feed.channel?.items?.last?.enclosure)
            XCTAssertEqual(feed.channel?.items?.last?.enclosure?.length, 24986239)
            XCTAssertEqual(feed.channel?.items?.last?.enclosure?.type, "audio/mpeg")
            XCTAssertEqual(feed.channel?.items?.last?.enclosure?.url, "http://dallas.example.com/joebob_050689.mp3")
            
            XCTAssertNotNil(feed.channel?.items?.last?.guid)
            XCTAssertEqual(feed.channel?.items?.last?.guid?.guid, "http://dallas.example.com/item/1234")
            XCTAssertEqual(feed.channel?.items?.last?.guid?.isPermaLink, true)
            
            XCTAssertNotNil(feed.channel?.items?.last?.pubDate)
            
            XCTAssertNotNil(feed.channel?.items?.last?.source)
            XCTAssertEqual(feed.channel?.items?.last?.source?.source, "Los Angeles Herald-Examiner")
            XCTAssertEqual(feed.channel?.items?.last?.source?.url, "http://la.example.com/rss.xml")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testRSS2FeedParsingPerformance() {
        self.measure {
            // Given
            let expectation = self.expectation(description: "RSS2 Parsing Performance")
            let URL = self.fileURL("RSS2", withExtension: "xml")

            // When
            Task {
                _ = try await RSSFeed(URL: URL)
                
                // Then
                expectation.fulfill()
            }
            
            self.waitForExpectations(timeout: self.timeout, handler: nil)
        }
    }
}
