//
//  RSS2Tests.swift
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

class RSS2Tests: BaseTestCase {
    
    func testRSS2Feed() {
        
        // Given
        let URL = fileURL("RSS2", type: "xml")
        let parser = FeedParser(URL: URL)!
        
        // When
        parser.parse { (result) in
            
            let feed = result.rssFeed
            
            // Then
            assert(feed != nil)
            
            assert(feed?.title == "Iris")
            assert(feed?.link == "http://www.iris.news/", "")
            assert(feed?.description == "The one place for you daily news.")
            assert(feed?.language == "en-us")
            assert(feed?.copyright == "Copyright 2015, Iris News")
            assert(feed?.managingEditor == "john.appleseed.editor@iris.news (John Appleseed)")
            assert(feed?.webMaster == "john.appleseed.master@iris.news (John Appleseed)")
            assert(feed?.pubDate == "Sun, 16 Aug 2015 05:00:00 GMT")
            assert(feed?.lastBuildDate == "Sun, 16 Aug 2015 18:18:55 GMT")
            
            assert(feed?.categories != nil)
            assert(feed?.categories?.count == 2)
            
            assert(feed?.categories?.first?.value == "Media")
            assert(feed?.categories?.first?.attributes == nil)
            assert(feed?.categories?.first?.attributes?.domain == nil)
            assert(feed?.categories?.last?.value == "News/Media/Science")
            assert(feed?.categories?.last?.attributes != nil)
            assert(feed?.categories?.last?.attributes?.domain == "dmoz")
            
            assert(feed?.generator == "Iris Gen")
            assert(feed?.docs == "http://blogs.law.harvard.edu/tech/rss")
            
            assert(feed?.cloud?.attributes != nil)
            assert(feed?.cloud?.attributes?.domain == "server.iris.com")
            assert(feed?.cloud?.attributes?.path == "/rpc")
            assert(feed?.cloud?.attributes?.port == 80)
            assert(feed?.cloud?.attributes?.protocolSpecification == "xml-rpc")
            assert(feed?.cloud?.attributes?.registerProcedure == "cloud.notify")
            
            assert(feed?.rating == "(PICS-1.1 \"http://www.rsac.org/ratingsv01.html\" l by \"webmaster@example.com\" on \"2007.01.29T10:09-0800\" r (n 0 s 0 v 0 l 0))")
            assert(feed?.ttl == 60)
            
            assert(feed?.image != nil)
            assert(feed?.image?.link == "http://www.iris.news/")
            assert(feed?.image?.url == "http://www.iris.news/image.jpg")
            assert(feed?.image?.title == "Iris")
            assert(feed?.image?.description == "Read the Iris news feed.")
            assert(feed?.image?.width == 64)
            assert(feed?.image?.height == 192)
            
            assert(feed?.skipDays != nil)
            assert(feed?.skipDays?.count == 2)
            assert(feed?.skipDays?.first == .Saturday)
            assert(feed?.skipDays?.last == .Sunday)
            
            assert(feed?.skipHours != nil)
            assert(feed?.skipHours?.count == 5)
            assert(feed?.skipHours?.first == 0)
            assert(feed?.skipHours?[1] == 1)
            assert(feed?.skipHours?[2] == 2)
            assert(feed?.skipHours?[3] == 22)
            assert(feed?.skipHours?[4] == 23)
            
            assert(feed?.textInput != nil)
            assert(feed?.textInput?.title == "TextInput Inquiry")
            assert(feed?.textInput?.description == "Your aggregator supports the textInput element. What software are you using?")
            assert(feed?.textInput?.name == "query")
            assert(feed?.textInput?.link == "http://www.iris.com/textinput.php")

        }
        
    }
    
    func testFeedItems() {
        
        // Given
        let URL = fileURL("RSS2", type: "xml")
        let parser = FeedParser(URL: URL)!
        
        // When
        parser.parse { (result) in
            
            let feed = result.rssFeed
            
            // Then
            assert(feed != nil)
            
            assert(feed?.items != nil)
            assert(feed?.items?.count == 2)
            
            assert(feed?.items?.first?.title == "Seventh Heaven! Ryan Hurls Another No Hitter")
            assert(feed?.items?.first?.link == "http://dallas.example.com/1991/05/02/nolan.htm")
            assert(feed?.items?.first?.author == "jbb@dallas.example.com (Joe Bob Briggs)")
            
            assert(feed?.items?.first?.categories != nil)
            assert(feed?.items?.first?.categories?.count == 2)
            
            assert(feed?.items?.first?.categories?.first?.value == "movies")
            assert(feed?.items?.first?.categories?.first?.attributes == nil)
            assert(feed?.items?.first?.categories?.first?.attributes?.domain == nil)
            
            assert(feed?.items?.first?.categories?.last?.value == "1983/V")
            assert(feed?.items?.first?.categories?.last?.attributes != nil)
            assert(feed?.items?.first?.categories?.last?.attributes?.domain == "rec.arts.movies.reviews")
            
            assert(feed?.items?.first?.comments == "http://dallas.example.com/feedback/1983/06/joebob.htm")
            assert(feed?.items?.first?.description == "I'm headed for France. I wasn't gonna go this year, but then last week \"Valley Girl\" came out and I said to myself, Joe Bob, you gotta get out of the country for a while.")
            
            assert(feed?.items?.first?.enclosure != nil)
            assert(feed?.items?.first?.enclosure?.attributes != nil)
            assert(feed?.items?.first?.enclosure?.attributes?.length == 24986239)
            assert(feed?.items?.first?.enclosure?.attributes?.type == "audio/mpeg")
            assert(feed?.items?.first?.enclosure?.attributes?.url == "http://dallas.example.com/joebob_050689.mp3")
            
            assert(feed?.items?.first?.guid != nil)
            assert(feed?.items?.first?.guid?.value == "tag:dallas.example.com,4131:news")
            assert(feed?.items?.first?.guid?.attributes?.isPermaLink == false)
            
            assert(feed?.items?.first?.pubDate == "Fri, 05 Oct 2007 09:00:00 CST")
            
            assert(feed?.items?.first?.source != nil)
            assert(feed?.items?.first?.source?.value == "Los Angeles Herald-Examiner")
            assert(feed?.items?.first?.source?.attributes != nil)
            assert(feed?.items?.first?.source?.attributes?.url == "http://la.example.com/rss.xml")
            
            assert(feed?.items?.last?.title == "Seventh Heaven! Ryan Hurls Another No Hitter")
            assert(feed?.items?.last?.link == "http://dallas.example.com/1991/05/02/nolan.htm")
            assert(feed?.items?.last?.author == "jbb@dallas.example.com (Joe Bob Briggs)")
            
            assert(feed?.items?.last?.categories != nil)
            assert(feed?.items?.last?.categories?.count == 2)
            
            assert(feed?.items?.last?.categories?.first?.value == "movies")
            assert(feed?.items?.last?.categories?.first?.attributes == nil)
            assert(feed?.items?.last?.categories?.first?.attributes?.domain == nil)
            
            assert(feed?.items?.last?.categories?.last?.value == "1983/V")
            assert(feed?.items?.last?.categories?.last?.attributes != nil)
            assert(feed?.items?.last?.categories?.last?.attributes?.domain == "rec.arts.movies.reviews")
            
            assert(feed?.items?.last?.comments == "http://dallas.example.com/feedback/1983/06/joebob.htm")
            assert(feed?.items?.last?.description == "I\'m headed for France. I wasn\'t gonna go this year, but then last week <a href=\"http://www.imdb.com/title/tt0086525/\">Valley Girl</a> came out and I said to myself, Joe Bob, you gotta get out of the country for a while.")
            
            assert(feed?.items?.last?.enclosure != nil)
            assert(feed?.items?.last?.enclosure?.attributes != nil)
            assert(feed?.items?.last?.enclosure?.attributes?.length == 24986239)
            assert(feed?.items?.last?.enclosure?.attributes?.type == "audio/mpeg")
            assert(feed?.items?.last?.enclosure?.attributes?.url == "http://dallas.example.com/joebob_050689.mp3")
            
            assert(feed?.items?.last?.guid != nil)
            assert(feed?.items?.last?.guid?.value == "http://dallas.example.com/item/1234")
            assert(feed?.items?.last?.guid?.attributes != nil )
            assert(feed?.items?.last?.guid?.attributes?.isPermaLink == true)
            
            assert(feed?.items?.last?.pubDate == "Fri, 05 Oct 2007 09:00:00 CST")
            
            assert(feed?.items?.last?.source != nil)
            assert(feed?.items?.last?.source?.value == "Los Angeles Herald-Examiner")
            assert(feed?.items?.last?.source?.attributes != nil)
            assert(feed?.items?.last?.source?.attributes?.url == "http://la.example.com/rss.xml")
            
        }
        
    }
    
    func testRSS2FeedParsingPerformance() {

        self.measureBlock {
            
            // Given
            let expectation = self.expectationWithDescription("RSS2 Parsing Performance")
            let URL = self.fileURL("RSS2", type: "xml")
            let parser = FeedParser(URL: URL)!
            
            // When
            parser.parse({ (result) in
                
                // Then
                expectation.fulfill()
                
            })
            
            self.waitForExpectationsWithTimeout(self.timeout, handler: nil)
            
        }
        
    }
    
}
