//
//  AtomTests.swift
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

class AtomTests: BaseTestCase {
    
    func testAtomFeed() {
        
        // Given
        let URL = fileURL("Atom", type: "xml")
        let parser = FeedParser(URL: URL)
        
        // When
        parser.parse { (result) in
            
            let feed = result.atomFeed
            
            // Then
            assert(feed?.title == "dive into mark")
            
            // Feed subtitle
            assert(feed?.subtitle != nil)
            assert(feed?.subtitle?.attributes != nil)
            assert(feed?.subtitle?.attributes?.type == "html")
            assert(feed?.subtitle?.value == "A <em>lot</em> of effort went into making this effortless")
            
            // Feed links
            
            assert(feed?.links != nil)
            assert(feed?.links?.count == 2)
            
            assert(feed?.links?.first != nil)
            assert(feed?.links?.first?.attributes != nil)
            assert(feed?.links?.first?.attributes?.href == "http://example.org/")
            assert(feed?.links?.first?.attributes?.rel == "alternate")
            assert(feed?.links?.first?.attributes?.type == "text/html")
            assert(feed?.links?.first?.attributes?.hreflang == "en")
            assert(feed?.links?.first?.attributes?.title == "Human-readable information about the link")
            assert(feed?.links?.first?.attributes?.length == 1234)
            
            assert(feed?.links?.last != nil)
            assert(feed?.links?.last?.attributes != nil)
            assert(feed?.links?.last?.attributes?.href == "http://example.org/feed.atom")
            assert(feed?.links?.last?.attributes?.rel == "self")
            assert(feed?.links?.last?.attributes?.type == "application/atom+xml")
            assert(feed?.links?.last?.attributes?.hreflang == nil)
            assert(feed?.links?.last?.attributes?.title == nil)
            assert(feed?.links?.last?.attributes?.length == nil)
            
            // Feed updated
            assert(feed?.updated == "2005-07-31T12:29:29Z")
            
            // Feed authors
            
            assert(feed?.authors?.count == 2)
            
            assert(feed?.authors?.first != nil)
            assert(feed?.authors?.first?.name == "Pilgrim Mark")
            assert(feed?.authors?.first?.email == "1234@example.com")
            assert(feed?.authors?.first?.uri == "http://example.org/")
            
            assert(feed?.authors?.last != nil)
            assert(feed?.authors?.last?.name == "Mark the Pilgrim")
            assert(feed?.authors?.last?.email == "5678@example.com")
            assert(feed?.authors?.last?.uri == "http://example.org/")
            
            assert(feed?.contributors?.count == 2)
            assert(feed?.contributors?.first?.name == "Jane Doe")
            assert(feed?.contributors?.first?.email == "9101@example.com")
            assert(feed?.contributors?.first?.uri == "http://example.org/")
            assert(feed?.contributors?.last?.name == "John Doe")
            assert(feed?.contributors?.last?.email == "2345@example.com")
            assert(feed?.contributors?.last?.uri == "http://example.org/")
            
            // Feed ID
            assert(feed?.id == "tag:example.org,2003:3")
            
            // Feed Generator
            assert(feed?.generator != nil)
            assert(feed?.generator?.value == "Example Toolkit")
            assert(feed?.generator?.attributes?.uri == "http://www.example.com/")
            assert(feed?.generator?.attributes?.version == "1.0")
            
            // Feed Logo
            assert(feed?.logo == "http://www.example.uk/logo.png")
            
            // Feed Right
            assert(feed?.rights == "Copyright (c) 2003, Mark Pilgrim")
            
            // Feed Entries
            assert(feed?.entries != nil)
            assert(feed?.entries?.count == 1)
            assert(feed?.entries?.first?.title == "Atom draft-07 snapshot")
            assert(feed?.entries?.first?.id == "tag:example.org,2003:3.2397")
            assert(feed?.entries?.first?.summary != nil)
            assert(feed?.entries?.first?.summary?.attributes?.type == "text")
            assert(feed?.entries?.first?.summary?.value == "An overview of Atom 1.0")
            
            assert(feed?.entries?.first?.links != nil)
            assert(feed?.entries?.first?.links?.count == 2)
            assert(feed?.entries?.first?.links?.first?.attributes?.href == "http://example.org/2005/04/02/atom")
            assert(feed?.entries?.first?.links?.first?.attributes?.rel == "alternate")
            assert(feed?.entries?.first?.links?.first?.attributes?.type == "text/html")
            assert(feed?.entries?.first?.links?.first?.attributes?.hreflang == nil)
            assert(feed?.entries?.first?.links?.first?.attributes?.title == nil)
            assert(feed?.entries?.first?.links?.first?.attributes?.length == nil)
            assert(feed?.entries?.first?.links?.last?.attributes?.href == "http://example.org/audio/ph34r_my_podcast.mp3")
            assert(feed?.entries?.first?.links?.last?.attributes?.rel == "enclosure")
            assert(feed?.entries?.first?.links?.last?.attributes?.type == "audio/mpeg")
            assert(feed?.entries?.first?.links?.last?.attributes?.hreflang == nil)
            assert(feed?.entries?.first?.links?.last?.attributes?.title == nil)
            assert(feed?.entries?.first?.links?.last?.attributes?.length == 1337)
            
            assert(feed?.entries?.first?.updated == "2005-07-31T12:29:29Z")
            assert(feed?.entries?.first?.published == "2003-12-13T08:29:29-04:00")
            assert(feed?.entries?.first?.authors != nil)
            assert(feed?.entries?.first?.authors?.count == 1)
            assert(feed?.entries?.first?.authors?.first?.name == "Mark Pilgrim")
            assert(feed?.entries?.first?.authors?.first?.uri == "http://example.org/")
            assert(feed?.entries?.first?.authors?.first?.email == "f8dy@example.com")
            assert(feed?.entries?.first?.contributors != nil)
            assert(feed?.entries?.first?.contributors?.count == 2)
            assert(feed?.entries?.first?.contributors?.first?.name == "Sam Ruby")
            assert(feed?.entries?.first?.contributors?.first?.email == "2345@example.com")
            assert(feed?.entries?.first?.contributors?.first?.uri == "http://example.org/")
            assert(feed?.entries?.first?.contributors?.last?.name == "Joe Gregorio")
            assert(feed?.entries?.first?.contributors?.last?.email == "2345@example.com")
            assert(feed?.entries?.first?.contributors?.last?.uri == "http://example.org/")
            assert(feed?.entries?.first?.content != nil)
            assert(feed?.entries?.first?.content?.value == "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><i>[Update: The Atom draft is finished.]</i></p></div>")
            assert(feed?.entries?.first?.content?.attributes != nil)
            assert(feed?.entries?.first?.content?.attributes?.type == "xhtml")
            assert(feed?.entries?.first?.content?.attributes?.src == nil)
            
        }
        
        
    }
    
    func testAtomFeedParsingPerformance() {
        
        self.measureBlock {
            
            // Given
            let expectation = self.expectationWithDescription("Atom Parsing Performance")
            let URL = self.fileURL("Atom", type: "xml")
            let parser = FeedParser(URL: URL)
            
            // When
            parser.parse({ (result) in
                
                // Then
                expectation.fulfill()
                
            })

            self.waitForExpectationsWithTimeout(self.timeout, handler: nil)
            
        }
        
    }
    
}