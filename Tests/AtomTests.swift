//
//  AtomTests.swift
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

class AtomTests: BaseTestCase {
    
    func testAtomFeed() {
        
        // Given
        let URL = fileURL("Atom", type: "xml")
        let parser = FeedParser(URL: URL)!
        
        // When
        let feed = parser.parse().atomFeed
        
        // Then
        
        XCTAssertNotNil(feed)
        
        XCTAssertEqual(feed?.title, "dive into mark")
        
        XCTAssertNotNil(feed?.subtitle)
        XCTAssertNotNil(feed?.subtitle?.attributes)
        XCTAssertEqual(feed?.subtitle?.attributes?.type, "html")
        XCTAssertEqual(feed?.subtitle?.value, "A <em>lot</em> of effort went into making this effortless")
        
        XCTAssertNotNil(feed?.links)
        XCTAssertEqual(feed?.links?.count, 2)
        
        XCTAssertNotNil(feed?.links?.first)
        XCTAssertNotNil(feed?.links?.first?.attributes)
        XCTAssertEqual(feed?.links?.first?.attributes?.href, "http://example.org/")
        XCTAssertEqual(feed?.links?.first?.attributes?.rel, "alternate")
        XCTAssertEqual(feed?.links?.first?.attributes?.type, "text/html")
        XCTAssertEqual(feed?.links?.first?.attributes?.hreflang, "en")
        XCTAssertEqual(feed?.links?.first?.attributes?.title, "Human-readable information about the link")
        XCTAssertEqual(feed?.links?.first?.attributes?.length, 1234)
        
        XCTAssertNotNil(feed?.links?.last)
        XCTAssertNotNil(feed?.links?.last?.attributes)
        XCTAssertEqual(feed?.links?.last?.attributes?.href, "http://example.org/feed.atom")
        XCTAssertEqual(feed?.links?.last?.attributes?.rel, "self")
        XCTAssertEqual(feed?.links?.last?.attributes?.type, "application/atom+xml")
        XCTAssertEqual(feed?.links?.last?.attributes?.hreflang, "pt")
        XCTAssertEqual(feed?.links?.last?.attributes?.title, "Information about the link is Human-readable")
        XCTAssertEqual(feed?.links?.last?.attributes?.length, 5678)
        
        XCTAssertNotNil(feed?.updated)
        
        XCTAssertNotNil(feed?.categories)
        XCTAssertEqual(feed?.categories?.count, 2)
        
        XCTAssertNotNil(feed?.categories?.first?.attributes)
        XCTAssertEqual(feed?.categories?.first?.attributes?.term, "music")
        
        XCTAssertNotNil(feed?.categories?.last?.attributes)
        XCTAssertEqual(feed?.categories?.last?.attributes?.term, "video")
        
        XCTAssertNotNil(feed?.authors)
        XCTAssertEqual(feed?.authors?.count, 2)
        
        XCTAssertNotNil(feed?.authors?.first)
        XCTAssertEqual(feed?.authors?.first?.name, "Pilgrim Mark")
        XCTAssertEqual(feed?.authors?.first?.email, "1234@example.com")
        XCTAssertEqual(feed?.authors?.first?.uri, "http://example.org/")
        
        XCTAssertNotNil(feed?.authors?.last)
        XCTAssertEqual(feed?.authors?.last?.name, "Mark the Pilgrim")
        XCTAssertEqual(feed?.authors?.last?.email, "5678@example.com")
        XCTAssertEqual(feed?.authors?.last?.uri, "http://example.org/")
        
        XCTAssertNotNil(feed?.contributors)
        XCTAssertEqual(feed?.contributors?.count, 2)
        
        XCTAssertEqual(feed?.contributors?.first?.name, "Jane Doe")
        XCTAssertEqual(feed?.contributors?.first?.email, "9101@example.com")
        XCTAssertEqual(feed?.contributors?.first?.uri, "http://example.org/")
        
        XCTAssertEqual(feed?.contributors?.last?.name, "John Doe")
        XCTAssertEqual(feed?.contributors?.last?.email, "2345@example.com")
        XCTAssertEqual(feed?.contributors?.last?.uri, "http://example.org/")
        
        XCTAssertEqual(feed?.id, "tag:example.org,2003:3")
        
        XCTAssertNotNil(feed?.generator)
        XCTAssertEqual(feed?.generator?.value, "Example Toolkit")
        XCTAssertEqual(feed?.generator?.attributes?.uri, "http://www.example.com/")
        XCTAssertEqual(feed?.generator?.attributes?.version, "1.0")
        
        XCTAssertEqual(feed?.logo, "http://www.example.uk/logo.png")
        XCTAssertEqual(feed?.rights, "Copyright (c) 2003, Mark Pilgrim")
        
        // Feed Entries
        XCTAssertNotNil(feed?.entries)
        XCTAssertEqual(feed?.entries?.count, 1)
        
        XCTAssertEqual(feed?.entries?.first?.title, "Atom draft-07 snapshot")
        XCTAssertEqual(feed?.entries?.first?.id, "tag:example.org,2003:3.2397")
        
        XCTAssertNotNil(feed?.entries?.first?.summary)
        XCTAssertEqual(feed?.entries?.first?.summary?.attributes?.type, "text")
        XCTAssertEqual(feed?.entries?.first?.summary?.value, "An overview of Atom 1.0")
        
        XCTAssertNotNil(feed?.entries?.first?.links)
        XCTAssertEqual(feed?.entries?.first?.links?.count, 2)
        
        XCTAssertEqual(feed?.entries?.first?.links?.first?.attributes?.href, "http://example.org/2005/04/02/atom")
        XCTAssertEqual(feed?.entries?.first?.links?.first?.attributes?.rel, "alternate")
        XCTAssertEqual(feed?.entries?.first?.links?.first?.attributes?.type, "text/html")
        XCTAssertEqual(feed?.entries?.first?.links?.first?.attributes?.hreflang, "en")
        XCTAssertEqual(feed?.entries?.first?.links?.first?.attributes?.title, "Human-readable information about the link")
        XCTAssertEqual(feed?.entries?.first?.links?.first?.attributes?.length, 1234)
        
        XCTAssertEqual(feed?.entries?.first?.links?.last?.attributes?.href, "http://example.org/audio/ph34r_my_podcast.mp3")
        XCTAssertEqual(feed?.entries?.first?.links?.last?.attributes?.rel, "enclosure")
        XCTAssertEqual(feed?.entries?.first?.links?.last?.attributes?.type, "audio/mpeg")
        XCTAssertEqual(feed?.entries?.first?.links?.last?.attributes?.hreflang, "pt")
        XCTAssertEqual(feed?.entries?.first?.links?.last?.attributes?.title, "Information about the link is Human-readable")
        XCTAssertEqual(feed?.entries?.first?.links?.last?.attributes?.length, 1337)
        
        XCTAssertNotNil(feed?.entries?.first?.updated)
        XCTAssertNotNil(feed?.entries?.first?.published)
        
        XCTAssertNotNil(feed?.entries?.first?.authors)
        XCTAssertEqual(feed?.entries?.first?.authors?.count, 1)
        
        XCTAssertEqual(feed?.entries?.first?.authors?.first?.name, "Mark Pilgrim")
        XCTAssertEqual(feed?.entries?.first?.authors?.first?.uri, "http://example.org/")
        XCTAssertEqual(feed?.entries?.first?.authors?.first?.email, "f8dy@example.com")
        
        XCTAssertNotNil(feed?.entries?.first?.contributors)
        XCTAssertEqual(feed?.entries?.first?.contributors?.count, 2)
        
        XCTAssertEqual(feed?.entries?.first?.contributors?.first?.name, "Sam Ruby")
        XCTAssertEqual(feed?.entries?.first?.contributors?.first?.email, "2345@example.com")
        XCTAssertEqual(feed?.entries?.first?.contributors?.first?.uri, "http://example.org/")
        
        XCTAssertEqual(feed?.entries?.first?.contributors?.last?.name, "Joe Gregorio")
        XCTAssertEqual(feed?.entries?.first?.contributors?.last?.email, "2345@example.com")
        XCTAssertEqual(feed?.entries?.first?.contributors?.last?.uri, "http://example.org/")
        
        XCTAssertNotNil(feed?.entries?.first?.content)
        XCTAssertEqual(feed?.entries?.first?.content?.value, "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><i>[Update: The Atom draft is finished.]</i></p></div>")
        XCTAssertNotNil(feed?.entries?.first?.content?.attributes)
        XCTAssertEqual(feed?.entries?.first?.content?.attributes?.type, "xhtml")
        XCTAssertEqual(feed?.entries?.first?.content?.attributes?.src, "http://www.example.org/")
        
        
    }
    
    func testAtomFeedParsingPerformance() {
        
        self.measure {
            
            // Given
            let expectation = self.expectation(description: "Atom Parsing Performance")
            let URL = self.fileURL("Atom", type: "xml")
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
