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

class FeedTestCase: BaseTestCase {
    
    func testRSS2Feed() {
        
        // Given
        let URL = fileURL("RSS2", type: "xml")
        let parser = FeedParser(URL: URL)
        
        // When
        parser.parse { (result) in
            
            let feed = result.rssFeed
            
            // Then
            assert(feed?.channel != nil)
            
            assert(feed?.channel?.title                                            == "Iris")
            assert(feed?.channel?.link                                             == "http://www.iris.news/", "")
            assert(feed?.channel?.description                                      == "The one place for you daily news.")
            assert(feed?.channel?.language                                         == "en-us")
            assert(feed?.channel?.copyright                                        == "Copyright 2015, Iris News")
            assert(feed?.channel?.managingEditor                                   == "john.appleseed.editor@iris.news (John Appleseed)")
            assert(feed?.channel?.webMaster                                        == "john.appleseed.master@iris.news (John Appleseed)")
            assert(feed?.channel?.pubDate                                          == "Sun, 16 Aug 2015 05:00:00 GMT")
            assert(feed?.channel?.lastBuildDate                                    == "Sun, 16 Aug 2015 18:18:55 GMT")
            assert(feed?.channel?.categories                                       != nil)
            assert(feed?.channel?.categories?.count                                == 2)
            assert(feed?.channel?.categories?[0].value                             == "Media")
            assert(feed?.channel?.categories?[0].attributes                        == nil)
            assert(feed?.channel?.categories?[0].attributes?.domain                == nil)
            assert(feed?.channel?.categories?[1].value                             == "News/Media/Science")
            assert(feed?.channel?.categories?[1].attributes                        != nil)
            assert(feed?.channel?.categories?[1].attributes?.domain                == "dmoz")
            assert(feed?.channel?.generator                                        == "Iris Gen")
            assert(feed?.channel?.docs                                             == "http://blogs.law.harvard.edu/tech/rss")
            assert(feed?.channel?.cloud?.attributes                                != nil)
            assert(feed?.channel?.cloud?.attributes?.domain                        == "server.iris.com")
            assert(feed?.channel?.cloud?.attributes?.path                          == "/rpc")
            assert(feed?.channel?.cloud?.attributes?.port                          == 80)
            assert(feed?.channel?.cloud?.attributes?.protocolSpecification         == "xml-rpc")
            assert(feed?.channel?.cloud?.attributes?.registerProcedure             == "cloud.notify")
            assert(feed?.channel?.rating                                           == "(PICS-1.1 \"http://www.rsac.org/ratingsv01.html\" l by \"webmaster@example.com\" on \"2007.01.29T10:09-0800\" r (n 0 s 0 v 0 l 0))")
            assert(feed?.channel?.ttl                                              == 60)
            assert(feed?.channel?.image                                            != nil)
            assert(feed?.channel?.image?.link                                      == "http://www.iris.news/")
            assert(feed?.channel?.image?.url                                       == "http://www.iris.news/image.jpg")
            assert(feed?.channel?.image?.title                                     == "Iris")
            assert(feed?.channel?.image?.description                               == "Read the Iris news feed.")
            assert(feed?.channel?.image?.width                                     == 64)
            assert(feed?.channel?.image?.height                                    == 192)
            assert(feed?.channel?.skipDays                                         != nil)
            assert(feed?.channel?.skipDays?.count                                  == 2)
            assert(feed?.channel?.skipDays?[0]                                     == .Saturday)
            assert(feed?.channel?.skipDays?[1]                                     == .Sunday)
            assert(feed?.channel?.skipHours                                        != nil)
            assert(feed?.channel?.skipHours?.count                                 == 5)
            assert(feed?.channel?.skipHours?[0]                                    == 0)
            assert(feed?.channel?.skipHours?[1]                                    == 1)
            assert(feed?.channel?.skipHours?[2]                                    == 2)
            assert(feed?.channel?.skipHours?[3]                                    == 22)
            assert(feed?.channel?.skipHours?[4]                                    == 23)
            assert(feed?.channel?.textInput                                        != nil)
            assert(feed?.channel?.textInput?.title                                 == "TextInput Inquiry")
            assert(feed?.channel?.textInput?.description                           == "Your aggregator supports the textInput element. What software are you using?")
            assert(feed?.channel?.textInput?.name                                  == "query")
            assert(feed?.channel?.textInput?.link                                  == "http://www.iris.com/textinput.php")

        }
        
    }
    
    func testFeedItems() {
        
        // Given
        let URL = fileURL("RSS2", type: "xml")
        let parser = FeedParser(URL: URL)
        
        // When
        parser.parse { (result) in
            
            let feed = result.rssFeed
            
            // Then
            assert(feed?.channel != nil)
            
            assert(feed?.channel?.items                                            != nil)
            assert(feed?.channel?.items?[0].title                                  == "Seventh Heaven! Ryan Hurls Another No Hitter")
            assert(feed?.channel?.items?[0].link                                   == "http://dallas.example.com/1991/05/02/nolan.htm")
            assert(feed?.channel?.items?[0].author                                 == "jbb@dallas.example.com (Joe Bob Briggs)")
            assert(feed?.channel?.items?[0].categories                             != nil)
            assert(feed?.channel?.items?[0].categories?[0].value                   == "movies")
            assert(feed?.channel?.items?[0].categories?[0].attributes              == nil)
            assert(feed?.channel?.items?[0].categories?[0].attributes?.domain      == nil)
            assert(feed?.channel?.items?[0].categories?[1].value                   == "1983/V")
            assert(feed?.channel?.items?[0].categories?[1].attributes              != nil)
            assert(feed?.channel?.items?[0].categories?[1].attributes?.domain      == "rec.arts.movies.reviews")
            assert(feed?.channel?.items?[0].comments                               == "http://dallas.example.com/feedback/1983/06/joebob.htm")
            assert(feed?.channel?.items?[0].description                            == "I'm headed for France. I wasn't gonna go this year, but then last week \"Valley Girl\" came out and I said to myself, Joe Bob, you gotta get out of the country for a while.")
            assert(feed?.channel?.items?[0].enclosure                              != nil)
            assert(feed?.channel?.items?[0].enclosure?.attributes                  != nil)
            assert(feed?.channel?.items?[0].enclosure?.attributes?.length          == Int(24986239))
            assert(feed?.channel?.items?[0].enclosure?.attributes?.type            == "audio/mpeg")
            assert(feed?.channel?.items?[0].enclosure?.attributes?.url             == "http://dallas.example.com/joebob_050689.mp3")
            assert(feed?.channel?.items?[0].guid                                   != nil)
            assert(feed?.channel?.items?[0].guid?.value                            == "tag:dallas.example.com,4131:news")
            assert(feed?.channel?.items?[0].guid?.attributes?.isPermaLink          == false)
            assert(feed?.channel?.items?[0].pubDate                                == "Fri, 05 Oct 2007 09:00:00 CST")
            assert(feed?.channel?.items?[0].source                                 != nil)
            assert(feed?.channel?.items?[0].source?.value                          == "Los Angeles Herald-Examiner")
            assert(feed?.channel?.items?[0].source?.attributes                     != nil)
            assert(feed?.channel?.items?[0].source?.attributes?.url                == "http://la.example.com/rss.xml")
            assert(feed?.channel?.items?[1].title                                  == "Seventh Heaven! Ryan Hurls Another No Hitter")
            assert(feed?.channel?.items?[1].link                                   == "http://dallas.example.com/1991/05/02/nolan.htm")
            assert(feed?.channel?.items?[1].author                                 == "jbb@dallas.example.com (Joe Bob Briggs)")
            assert(feed?.channel?.items?[1].categories                             != nil)
            assert(feed?.channel?.items?[1].categories?[0].value                   == "movies")
            assert(feed?.channel?.items?[1].categories?[0].attributes              == nil)
            assert(feed?.channel?.items?[1].categories?[0].attributes?.domain      == nil)
            assert(feed?.channel?.items?[1].categories?[1].value                   == "1983/V")
            assert(feed?.channel?.items?[1].categories?[1].attributes              != nil)
            assert(feed?.channel?.items?[1].categories?[1].attributes?.domain      == "rec.arts.movies.reviews")
            assert(feed?.channel?.items?[1].comments                               == "http://dallas.example.com/feedback/1983/06/joebob.htm")
            assert(feed?.channel?.items?[1].description                            == "I\'m headed for France. I wasn\'t gonna go this year, but then last week <a href=\"http://www.imdb.com/title/tt0086525/\">Valley Girl</a> came out and I said to myself, Joe Bob, you gotta get out of the country for a while.")
            assert(feed?.channel?.items?[1].enclosure                              != nil)
            assert(feed?.channel?.items?[1].enclosure?.attributes != nil)
            assert(feed?.channel?.items?[1].enclosure?.attributes?.length          == Int(24986239))
            assert(feed?.channel?.items?[1].enclosure?.attributes?.type            == "audio/mpeg")
            assert(feed?.channel?.items?[1].enclosure?.attributes?.url             == "http://dallas.example.com/joebob_050689.mp3")
            assert(feed?.channel?.items?[1].guid                                   != nil)
            assert(feed?.channel?.items?[1].guid?.value                            == "http://dallas.example.com/item/1234")
            assert(feed?.channel?.items?[1].guid?.attributes                       != nil )
            assert(feed?.channel?.items?[1].guid?.attributes?.isPermaLink          == true)
            assert(feed?.channel?.items?[1].pubDate                                == "Fri, 05 Oct 2007 09:00:00 CST")
            assert(feed?.channel?.items?[1].source                                 != nil)
            assert(feed?.channel?.items?[1].source?.value                          == "Los Angeles Herald-Examiner")
            assert(feed?.channel?.items?[1].source?.attributes                     != nil)
            assert(feed?.channel?.items?[1].source?.attributes?.url                == "http://la.example.com/rss.xml")
            assert(feed?.channel?.items?[2].title                                  == "Seventh Heaven! Ryan Hurls Another No Hitter")
            assert(feed?.channel?.items?[2].link                                   == "http://dallas.example.com/1991/05/02/nolan.htm")
            assert(feed?.channel?.items?[2].author                                 == "jbb@dallas.example.com (Joe Bob Briggs)")
            assert(feed?.channel?.items?[2].categories                             != nil)
            assert(feed?.channel?.items?[2].categories?[0].value                   == "movies")
            assert(feed?.channel?.items?[2].categories?[0].attributes              == nil)
            assert(feed?.channel?.items?[2].categories?[0].attributes?.domain      == nil)
            assert(feed?.channel?.items?[2].categories?[1].value                   == "1983/V")
            assert(feed?.channel?.items?[2].categories?[1].attributes              != nil)
            assert(feed?.channel?.items?[2].categories?[1].attributes?.domain      == "rec.arts.movies.reviews")
            assert(feed?.channel?.items?[2].comments                               == "http://dallas.example.com/feedback/1983/06/joebob.htm")
            assert(feed?.channel?.items?[2].description                            == "I'm headed for France. I wasn't gonna go this year, but then last week <a href=\"http://www.imdb.com/title/tt0086525/\">Valley Girl</a> came out and I said to myself, Joe Bob, you gotta get out of the country for a while.")
            assert(feed?.channel?.items?[2].enclosure                              != nil)
            assert(feed?.channel?.items?[2].enclosure?.attributes                  != nil )
            assert(feed?.channel?.items?[2].enclosure?.attributes?.length          == Int(24986239))
            assert(feed?.channel?.items?[2].enclosure?.attributes?.type            == "audio/mpeg")
            assert(feed?.channel?.items?[2].enclosure?.attributes?.url             == "http://dallas.example.com/joebob_050689.mp3")
            assert(feed?.channel?.items?[2].guid                                   != nil)
            assert(feed?.channel?.items?[2].guid?.value                            == "http://dallas.example.com/1983/05/06/joebob.htm")
            assert(feed?.channel?.items?[2].guid?.attributes                       == nil)
            assert(feed?.channel?.items?[2].guid?.attributes?.isPermaLink          == nil)
            assert(feed?.channel?.items?[2].pubDate                                == "Fri, 05 Oct 2007 09:00:00 CST")
            assert(feed?.channel?.items?[2].source                                 != nil)
            assert(feed?.channel?.items?[2].source?.value                          == "Los Angeles Herald-Examiner")
            assert(feed?.channel?.items?[2].source?.attributes                     != nil)
            assert(feed?.channel?.items?[2].source?.attributes?.url                == "http://la.example.com/rss.xml")
            
        }
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
