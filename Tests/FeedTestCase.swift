//
//  FeedTestCase.swift
//  IrisKit
//
//  Created by Nuno Dias on 17/05/16.
//
//

import XCTest
import FeedParser

class FeedTestCase: BaseTestCase {
    
    func testFeed() {
        
        // Given
        let URL = fileURL("RSS2", type: "xml")
        let parser = IrisFeedParser(URL: URL)
        
        // When
        parser.parse { (feed) in
            
            // Then
            guard let channel = feed?.channel else {
                assert(false)
            }
            
            assert(channel.title                                            == "Iris")
            assert(channel.link                                             == "http://www.iris.news/", "")
            assert(channel.description                                      == "The one place for you daily news.")
            assert(channel.language                                         == "en-us")
            assert(channel.copyright                                        == "Copyright 2015, Iris News")
            assert(channel.managingEditor                                   == "john.appleseed.editor@iris.news (John Appleseed)")
            assert(channel.webMaster                                        == "john.appleseed.master@iris.news (John Appleseed)")
            assert(channel.pubDate                                          == "Sun, 16 Aug 2015 05:00:00 GMT")
            assert(channel.lastBuildDate                                    == "Sun, 16 Aug 2015 18:18:55 GMT")
            assert(channel.categories                                       != nil)
            assert(channel.categories?.count                                == 2)
            assert(channel.categories?[0].value                             == "Media")
            assert(channel.categories?[0].attributes                        == nil)
            assert(channel.categories?[0].attributes?.domain                == nil)
            assert(channel.categories?[1].value                             == "News/Media/Science")
            assert(channel.categories?[1].attributes                        != nil)
            assert(channel.categories?[1].attributes?.domain                == "dmoz")
            assert(channel.generator                                        == "Iris Gen")
            assert(channel.docs                                             == "http://blogs.law.harvard.edu/tech/rss")
            assert(channel.cloud?.attributes                                != nil)
            assert(channel.cloud?.attributes?.domain                        == "server.iris.com")
            assert(channel.cloud?.attributes?.path                          == "/rpc")
            assert(channel.cloud?.attributes?.port                          == 80)
            assert(channel.cloud?.attributes?.protocolSpecification         == "xml-rpc")
            assert(channel.cloud?.attributes?.registerProcedure             == "cloud.notify")
            assert(channel.rating                                           == "(PICS-1.1 \"http://www.rsac.org/ratingsv01.html\" l by \"webmaster@example.com\" on \"2007.01.29T10:09-0800\" r (n 0 s 0 v 0 l 0))")
            assert(channel.ttl                                              == 60)
            assert(channel.image                                            != nil)
            assert(channel.image?.link                                      == "http://www.iris.news/")
            assert(channel.image?.url                                       == "http://www.iris.news/image.jpg")
            assert(channel.image?.title                                     == "Iris")
            assert(channel.image?.description                               == "Read the Iris news feed.")
            assert(channel.image?.width                                     == 64)
            assert(channel.image?.height                                    == 192)
            assert(channel.skipDays                                         != nil)
            assert(channel.skipDays?.count                                  == 2)
            assert(channel.skipDays?[0]                                     == .Saturday)
            assert(channel.skipDays?[1]                                     == .Sunday)
            assert(channel.skipHours                                        != nil)
            assert(channel.skipHours?.count                                 == 5)
            assert(channel.skipHours?[0]                                    == 0)
            assert(channel.skipHours?[1]                                    == 1)
            assert(channel.skipHours?[2]                                    == 2)
            assert(channel.skipHours?[3]                                    == 22)
            assert(channel.skipHours?[4]                                    == 23)
            assert(channel.textInput                                        != nil)
            assert(channel.textInput?.title                                 == "TextInput Inquiry")
            assert(channel.textInput?.description                           == "Your aggregator supports the textInput element. What software are you using?")
            assert(channel.textInput?.name                                  == "query")
            assert(channel.textInput?.link                                  == "http://www.iris.com/textinput.php")

        }
        
    }
    
    func testFeedItems() {
        
        // Given
        let URL = fileURL("RSS2", type: "xml")
        let parser = IrisFeedParser(URL: URL)
        
        // When
        parser.parse { (feed) in
            
            // Then
            guard let channel = feed?.channel else {
                assert(false)
            }
            
            assert(channel.items                                            != nil)
            assert(channel.items?[0].title                                  == "Seventh Heaven! Ryan Hurls Another No Hitter")
            assert(channel.items?[0].link                                   == "http://dallas.example.com/1991/05/02/nolan.htm")
            assert(channel.items?[0].author                                 == "jbb@dallas.example.com (Joe Bob Briggs)")
            assert(channel.items?[0].categories                             != nil)
            assert(channel.items?[0].categories?[0].value                   == "movies")
            assert(channel.items?[0].categories?[0].attributes              == nil)
            assert(channel.items?[0].categories?[0].attributes?.domain      == nil)
            assert(channel.items?[0].categories?[1].value                   == "1983/V")
            assert(channel.items?[0].categories?[1].attributes              != nil)
            assert(channel.items?[0].categories?[1].attributes?.domain      == "rec.arts.movies.reviews")
            assert(channel.items?[0].comments                               == "http://dallas.example.com/feedback/1983/06/joebob.htm")
            assert(channel.items?[0].description                            == "I'm headed for France. I wasn't gonna go this year, but then last week \"Valley Girl\" came out and I said to myself, Joe Bob, you gotta get out of the country for a while.")
            assert(channel.items?[0].enclosure                              != nil)
            assert(channel.items?[0].enclosure?.attributes                  != nil)
            assert(channel.items?[0].enclosure?.attributes?.length          == UInt64(24986239))
            assert(channel.items?[0].enclosure?.attributes?.type            == "audio/mpeg")
            assert(channel.items?[0].enclosure?.attributes?.url             == "http://dallas.example.com/joebob_050689.mp3")
            assert(channel.items?[0].guid                                   != nil)
            assert(channel.items?[0].guid?.value                            == "tag:dallas.example.com,4131:news")
            assert(channel.items?[0].guid?.attributes?.isPermaLink          == false)
            assert(channel.items?[0].pubDate                                == "Fri, 05 Oct 2007 09:00:00 CST")
            assert(channel.items?[0].source                                 != nil)
            assert(channel.items?[0].source?.value                          == "Los Angeles Herald-Examiner")
            assert(channel.items?[0].source?.attributes                     != nil)
            assert(channel.items?[0].source?.attributes?.url                == "http://la.example.com/rss.xml")
            assert(channel.items?[1].title                                  == "Seventh Heaven! Ryan Hurls Another No Hitter")
            assert(channel.items?[1].link                                   == "http://dallas.example.com/1991/05/02/nolan.htm")
            assert(channel.items?[1].author                                 == "jbb@dallas.example.com (Joe Bob Briggs)")
            assert(channel.items?[1].categories                             != nil)
            assert(channel.items?[1].categories?[0].value                   == "movies")
            assert(channel.items?[1].categories?[0].attributes              == nil)
            assert(channel.items?[1].categories?[0].attributes?.domain      == nil)
            assert(channel.items?[1].categories?[1].value                   == "1983/V")
            assert(channel.items?[1].categories?[1].attributes              != nil)
            assert(channel.items?[1].categories?[1].attributes?.domain      == "rec.arts.movies.reviews")
            assert(channel.items?[1].comments                               == "http://dallas.example.com/feedback/1983/06/joebob.htm")
            assert(channel.items?[1].description                            == "I\'m headed for France. I wasn\'t gonna go this year, but then last week <a href=\"http://www.imdb.com/title/tt0086525/\">Valley Girl</a> came out and I said to myself, Joe Bob, you gotta get out of the country for a while.")
            assert(channel.items?[1].enclosure                              != nil)
            assert(channel.items?[1].enclosure?.attributes != nil)
            assert(channel.items?[1].enclosure?.attributes?.length          == UInt64(24986239))
            assert(channel.items?[1].enclosure?.attributes?.type            == "audio/mpeg")
            assert(channel.items?[1].enclosure?.attributes?.url             == "http://dallas.example.com/joebob_050689.mp3")
            assert(channel.items?[1].guid                                   != nil)
            assert(channel.items?[1].guid?.value                            == "http://dallas.example.com/item/1234")
            assert(channel.items?[1].guid?.attributes                       != nil )
            assert(channel.items?[1].guid?.attributes?.isPermaLink          == true)
            assert(channel.items?[1].pubDate                                == "Fri, 05 Oct 2007 09:00:00 CST")
            assert(channel.items?[1].source                                 != nil)
            assert(channel.items?[1].source?.value                          == "Los Angeles Herald-Examiner")
            assert(channel.items?[1].source?.attributes                     != nil)
            assert(channel.items?[1].source?.attributes?.url                == "http://la.example.com/rss.xml")
            assert(channel.items?[2].title                                  == "Seventh Heaven! Ryan Hurls Another No Hitter")
            assert(channel.items?[2].link                                   == "http://dallas.example.com/1991/05/02/nolan.htm")
            assert(channel.items?[2].author                                 == "jbb@dallas.example.com (Joe Bob Briggs)")
            assert(channel.items?[2].categories                             != nil)
            assert(channel.items?[2].categories?[0].value                   == "movies")
            assert(channel.items?[2].categories?[0].attributes              == nil)
            assert(channel.items?[2].categories?[0].attributes?.domain      == nil)
            assert(channel.items?[2].categories?[1].value                   == "1983/V")
            assert(channel.items?[2].categories?[1].attributes              != nil)
            assert(channel.items?[2].categories?[1].attributes?.domain      == "rec.arts.movies.reviews")
            assert(channel.items?[2].comments                               == "http://dallas.example.com/feedback/1983/06/joebob.htm")
            assert(channel.items?[2].description                            == "I'm headed for France. I wasn't gonna go this year, but then last week <a href=\"http://www.imdb.com/title/tt0086525/\">Valley Girl</a> came out and I said to myself, Joe Bob, you gotta get out of the country for a while.")
            assert(channel.items?[2].enclosure                              != nil)
            assert(channel.items?[2].enclosure?.attributes                  != nil )
            assert(channel.items?[2].enclosure?.attributes?.length          == UInt64(24986239))
            assert(channel.items?[2].enclosure?.attributes?.type            == "audio/mpeg")
            assert(channel.items?[2].enclosure?.attributes?.url             == "http://dallas.example.com/joebob_050689.mp3")
            assert(channel.items?[2].guid                                   != nil)
            assert(channel.items?[2].guid?.value                            == "http://dallas.example.com/1983/05/06/joebob.htm")
            assert(channel.items?[2].guid?.attributes                       == nil)
            assert(channel.items?[2].guid?.attributes?.isPermaLink          == nil)
            assert(channel.items?[2].pubDate                                == "Fri, 05 Oct 2007 09:00:00 CST")
            assert(channel.items?[2].source                                 != nil)
            assert(channel.items?[2].source?.value                          == "Los Angeles Herald-Examiner")
            assert(channel.items?[2].source?.attributes                     != nil)
            assert(channel.items?[2].source?.attributes?.url                == "http://la.example.com/rss.xml")
            
        }
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
