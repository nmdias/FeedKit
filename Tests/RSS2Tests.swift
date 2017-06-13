//
//  RSS2Tests.swift
//
//  Copyright (c) 2017 Nuno Manuel Dias
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
import FeedKit

class RSS2Tests: BaseTestCase {
    
    func testRSS2Feed() {
        
        // Given
        let URL = fileURL("RSS2", type: "xml")
        let parser = FeedParser(URL: URL)!
        
        // When
        let feed = parser.parse().rssFeed
        
        // Then
        XCTAssertNotNil(feed)
        
        XCTAssertEqual(feed?.title, "Iris")
        XCTAssertEqual(feed?.link, "http://www.iris.news/", "")
        XCTAssertEqual(feed?.description, "The one place for you daily news.")
        XCTAssertEqual(feed?.language, "en-us")
        XCTAssertEqual(feed?.copyright, "Copyright 2015, Iris News")
        XCTAssertEqual(feed?.managingEditor, "john.appleseed.editor@iris.news (John Appleseed)")
        XCTAssertEqual(feed?.webMaster, "john.appleseed.master@iris.news (John Appleseed)")
        XCTAssertNotNil(feed?.pubDate)
        XCTAssertNotNil(feed?.lastBuildDate)
        
        XCTAssertNotNil(feed?.categories)
        XCTAssertEqual(feed?.categories?.count, 2)
        
        XCTAssertEqual(feed?.categories?.first?.value, "Media")
        XCTAssertNil(feed?.categories?.first?.attributes)
        XCTAssertEqual(feed?.categories?.first?.attributes?.domain, nil)
        XCTAssertEqual(feed?.categories?.last?.value, "News/Media/Science")
        XCTAssertNotNil(feed?.categories?.last?.attributes)
        XCTAssertEqual(feed?.categories?.last?.attributes?.domain, "dmoz")
        
        XCTAssertEqual(feed?.generator, "Iris Gen")
        XCTAssertEqual(feed?.docs, "http://blogs.law.harvard.edu/tech/rss")
        
        XCTAssertNotNil(feed?.cloud?.attributes)
        XCTAssertEqual(feed?.cloud?.attributes?.domain, "server.iris.com")
        XCTAssertEqual(feed?.cloud?.attributes?.path, "/rpc")
        XCTAssertEqual(feed?.cloud?.attributes?.port, 80)
        XCTAssertEqual(feed?.cloud?.attributes?.protocolSpecification, "xml-rpc")
        XCTAssertEqual(feed?.cloud?.attributes?.registerProcedure, "cloud.notify")
        
        XCTAssertEqual(feed?.rating, "(PICS-1.1 \"http://www.rsac.org/ratingsv01.html\" l by \"webmaster@example.com\" on \"2007.01.29T10:09-0800\" r (n 0 s 0 v 0 l 0))")
        XCTAssertEqual(feed?.ttl, 60)
        
        XCTAssertNotNil(feed?.image)
        XCTAssertEqual(feed?.image?.link, "http://www.iris.news/")
        XCTAssertEqual(feed?.image?.url, "http://www.iris.news/image.jpg")
        XCTAssertEqual(feed?.image?.title, "Iris")
        XCTAssertEqual(feed?.image?.description, "Read the Iris news feed.")
        XCTAssertEqual(feed?.image?.width, 64)
        XCTAssertEqual(feed?.image?.height, 192)
        
        XCTAssertNotNil(feed?.skipDays)
        XCTAssertEqual(feed?.skipDays?.count, 2)
        XCTAssertEqual(feed?.skipDays?.first, .saturday)
        XCTAssertEqual(feed?.skipDays?.last, .sunday)
        
        XCTAssertNotNil(feed?.skipHours)
        XCTAssertEqual(feed?.skipHours?.count, 5)
        XCTAssertEqual(feed?.skipHours?.first, 0)
        XCTAssertEqual(feed?.skipHours?[1], 1)
        XCTAssertEqual(feed?.skipHours?[2], 2)
        XCTAssertEqual(feed?.skipHours?[3], 22)
        XCTAssertEqual(feed?.skipHours?[4], 23)
        
        XCTAssertNotNil(feed?.textInput)
        XCTAssertEqual(feed?.textInput?.title, "TextInput Inquiry")
        XCTAssertEqual(feed?.textInput?.description, "Your aggregator supports the textInput element. What software are you using?")
        XCTAssertEqual(feed?.textInput?.name, "query")
        XCTAssertEqual(feed?.textInput?.link, "http://www.iris.com/textinput.php")
        
    }
    
    func testFeedItems() {
        
        // Given
        let URL = fileURL("RSS2", type: "xml")
        let parser = FeedParser(URL: URL)!
        
        // When
        let feed = parser.parse().rssFeed
        
        // Then
        XCTAssertNotNil(feed)
        
        XCTAssertNotNil(feed?.items)
        XCTAssertEqual(feed?.items?.count, 2)
        
        XCTAssertEqual(feed?.items?.first?.title, "Seventh Heaven! Ryan Hurls Another No Hitter")
        XCTAssertEqual(feed?.items?.first?.link, "http://dallas.example.com/1991/05/02/nolan.htm")
        XCTAssertEqual(feed?.items?.first?.author, "jbb@dallas.example.com (Joe Bob Briggs)")
        
        XCTAssertNotNil(feed?.items?.first?.categories)
        XCTAssertEqual(feed?.items?.first?.categories?.count, 2)
        
        XCTAssertEqual(feed?.items?.first?.categories?.first?.value, "movies")
        XCTAssertNil(feed?.items?.first?.categories?.first?.attributes)
        XCTAssertEqual(feed?.items?.first?.categories?.first?.attributes?.domain, nil)
        
        XCTAssertEqual(feed?.items?.first?.categories?.last?.value, "1983/V")
        XCTAssertNotNil(feed?.items?.first?.categories?.last?.attributes)
        XCTAssertEqual(feed?.items?.first?.categories?.last?.attributes?.domain, "rec.arts.movies.reviews")
        
        XCTAssertEqual(feed?.items?.first?.comments, "http://dallas.example.com/feedback/1983/06/joebob.htm")
        XCTAssertEqual(feed?.items?.first?.description, "I'm headed for France. I wasn't gonna go this year, but then last week \"Valley Girl\" came out and I said to myself, Joe Bob, you gotta get out of the country for a while.")
        
        XCTAssertNotNil(feed?.items?.first?.enclosure)
        XCTAssertNotNil(feed?.items?.first?.enclosure?.attributes)
        XCTAssertEqual(feed?.items?.first?.enclosure?.attributes?.length, 24986239)
        XCTAssertEqual(feed?.items?.first?.enclosure?.attributes?.type, "audio/mpeg")
        XCTAssertEqual(feed?.items?.first?.enclosure?.attributes?.url, "http://dallas.example.com/joebob_050689.mp3")
        
        XCTAssertNotNil(feed?.items?.first?.guid)
        XCTAssertEqual(feed?.items?.first?.guid?.value, "tag:dallas.example.com,4131:news")
        XCTAssertEqual(feed?.items?.first?.guid?.attributes?.isPermaLink, false)
        
        XCTAssertNotNil(feed?.items?.first?.pubDate)
        
        XCTAssertNotNil(feed?.items?.first?.source)
        XCTAssertEqual(feed?.items?.first?.source?.value, "Los Angeles Herald-Examiner")
        XCTAssertNotNil(feed?.items?.first?.source?.attributes)
        XCTAssertEqual(feed?.items?.first?.source?.attributes?.url, "http://la.example.com/rss.xml")
        
        XCTAssertEqual(feed?.items?.last?.title, "Seventh Heaven! Ryan Hurls Another No Hitter")
        XCTAssertEqual(feed?.items?.last?.link, "http://dallas.example.com/1991/05/02/nolan.htm")
        XCTAssertEqual(feed?.items?.last?.author, "jbb@dallas.example.com (Joe Bob Briggs)")
        
        XCTAssertNotNil(feed?.items?.last?.categories)
        XCTAssertEqual(feed?.items?.last?.categories?.count, 2)
        
        XCTAssertEqual(feed?.items?.last?.categories?.first?.value, "movies")
        XCTAssertNil(feed?.items?.last?.categories?.first?.attributes)
        XCTAssertEqual(feed?.items?.last?.categories?.first?.attributes?.domain, nil)
        
        XCTAssertEqual(feed?.items?.last?.categories?.last?.value, "1983/V")
        XCTAssertNotNil(feed?.items?.last?.categories?.last?.attributes)
        XCTAssertEqual(feed?.items?.last?.categories?.last?.attributes?.domain, "rec.arts.movies.reviews")
        
        XCTAssertEqual(feed?.items?.last?.comments, "http://dallas.example.com/feedback/1983/06/joebob.htm")
        XCTAssertEqual(feed?.items?.last?.description, "I\'m headed for France. I wasn\'t gonna go this year, but then last week <a href=\"http://www.imdb.com/title/tt0086525/\">Valley Girl</a> came out and I said to myself, Joe Bob, you gotta get out of the country for a while.")
        
        XCTAssertNotNil(feed?.items?.last?.enclosure)
        XCTAssertNotNil(feed?.items?.last?.enclosure?.attributes)
        XCTAssertEqual(feed?.items?.last?.enclosure?.attributes?.length, 24986239)
        XCTAssertEqual(feed?.items?.last?.enclosure?.attributes?.type, "audio/mpeg")
        XCTAssertEqual(feed?.items?.last?.enclosure?.attributes?.url, "http://dallas.example.com/joebob_050689.mp3")
        
        XCTAssertNotNil(feed?.items?.last?.guid)
        XCTAssertEqual(feed?.items?.last?.guid?.value, "http://dallas.example.com/item/1234")
        XCTAssertNotNil(feed?.items?.last?.guid?.attributes)
        XCTAssertEqual(feed?.items?.last?.guid?.attributes?.isPermaLink, true)
        
        XCTAssertNotNil(feed?.items?.last?.pubDate)
        
        XCTAssertNotNil(feed?.items?.last?.source)
        XCTAssertEqual(feed?.items?.last?.source?.value, "Los Angeles Herald-Examiner")
        XCTAssertNotNil(feed?.items?.last?.source?.attributes)
        XCTAssertEqual(feed?.items?.last?.source?.attributes?.url, "http://la.example.com/rss.xml")
        
    }
    
    func testRSS2FeedParsingPerformance() {

        self.measure {
            
            // Given
            let expectation = self.expectation(description: "RSS2 Parsing Performance")
            let URL = self.fileURL("RSS2", type: "xml")
            let parser = FeedParser(URL: URL)!
            
            // When
            parser.parseAsync { (result) in
                
                // Then
                expectation.fulfill()
                
            }
            
            self.waitForExpectations(timeout: self.timeout, handler: nil)
            
        }
        
    }
    
}
