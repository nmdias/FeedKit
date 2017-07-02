//
//  JSONTests.swift
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
@testable import FeedKit

class JSONTests: BaseTestCase {
    
    func testJSONFeed() {
        
        // Given
        let URL = fileURL("feed", type: "json")
        let parser = FeedParser(URL: URL)!
        
        // When
        let feed = parser.parse().jsonFeed
        
        // Then
        XCTAssertNotNil(feed)
        XCTAssertEqual(feed?.version, "https://jsonfeed.org/version/1")
        XCTAssertEqual(feed?.title, "Title")
        XCTAssertEqual(feed?.userComment, "User comment")
        XCTAssertEqual(feed?.homePageURL, "https://example.org/")
        XCTAssertEqual(feed?.description, "Description")
        XCTAssertEqual(feed?.feedUrl, "https://example.org/feed.json?p=1")
        XCTAssertEqual(feed?.nextUrl, "https://example.org/feed.json?p=2")
        XCTAssertEqual(feed?.icon, "https://example.org/icon.jpg")
        XCTAssertEqual(feed?.favicon, "https://example.org/favicon.ico")
        XCTAssertEqual(feed?.expired, false)
        
        XCTAssertNotNil(feed?.author)
        XCTAssertEqual(feed?.author?.name, "Brent Simmons")
        XCTAssertEqual(feed?.author?.url, "http://example.org/")
        XCTAssertEqual(feed?.author?.avatar, "https://example.org/avatar.png")
        
        XCTAssertNotNil(feed?.hubs)
        XCTAssertEqual(feed?.hubs?.first?.type, "Type 1")
        XCTAssertEqual(feed?.hubs?.first?.url, "http://example1.org/")
        XCTAssertEqual(feed?.hubs?.last?.type, "Type 2")
        XCTAssertEqual(feed?.hubs?.last?.url, "http://example2.org/")
        
        XCTAssertNotNil(feed?.items)
        XCTAssertEqual(feed?.items?.first?.id, "http://therecord.co/chris-parrish")
        XCTAssertEqual(feed?.items?.first?.title, "Special #1 - Chris Parrish")
        XCTAssertEqual(feed?.items?.first?.url, "http://therecord.co/chris-parrish")
        XCTAssertEqual(feed?.items?.first?.externalUrl, "http://external.com/example")
        XCTAssertEqual(feed?.items?.first?.contentText, "Chris has worked at Adobe and as a founder of Rogue Sheep, which won an Apple Design Award for Postage. Chris's new company is Aged & Distilled with Guy English - which shipped Napkin, a Mac app for visual collaboration. Chris is also the co-host of The Record. He lives on Bainbridge Island, a quick ferry ride from Seattle.")
        XCTAssertEqual(feed?.items?.first?.contentHtml, "Chris has worked at <a href=\"http://adobe.com/\">Adobe</a> and as a founder of Rogue Sheep, which won an Apple Design Award for Postage. Chris's new company is Aged & Distilled with Guy English - which shipped <a href=\"http://aged-and-distilled.com/napkin/\">Napkin</a>, a Mac app for visual collaboration. Chris is also the co-host of The Record. He lives on <a href=\"http://www.ci.bainbridge-isl.wa.us/\">Bainbridge Island</a>, a quick ferry ride from Seattle.")
        XCTAssertEqual(feed?.items?.first?.summary, "Brent interviews Chris Parrish, co-host of The Record and one-half of Aged & Distilled.")
        XCTAssertEqual(feed?.items?.first?.image, "https://example.org/image.jpg")
        XCTAssertEqual(feed?.items?.first?.bannerImage, "https://example.org/banner.jpg")
        XCTAssertNotNil(feed?.items?.first?.datePublished)
        XCTAssertNotNil(feed?.items?.first?.dateModified)
        
        XCTAssertNotNil(feed?.items?.first?.author)
        XCTAssertEqual(feed?.items?.first?.author?.name, "Brent Simmons")
        XCTAssertEqual(feed?.items?.first?.author?.url, "http://example.org/")
        XCTAssertEqual(feed?.items?.first?.author?.avatar, "https://example.org/avatar.png")
        
        XCTAssertNotNil(feed?.items?.first?.tags)
        XCTAssertEqual(feed?.items?.first?.tags?.first, "tag1")
        XCTAssertEqual(feed?.items?.first?.tags?.last, "tag2")
        
        XCTAssertNotNil(feed?.items?.first?.attachments)
        XCTAssertEqual(feed?.items?.first?.attachments?.first?.title, "128Kb's version")
        XCTAssertEqual(feed?.items?.first?.attachments?.first?.url, "http://therecord.co/downloads/The-Record-sp1e1-ChrisParrish-128.m4a")
        XCTAssertEqual(feed?.items?.first?.attachments?.first?.mimeType, "audio/x-m4a")
        XCTAssertEqual(feed?.items?.first?.attachments?.first?.sizeInBytes, Int(63207998))
        XCTAssertEqual(feed?.items?.first?.attachments?.first?.durationInSeconds, TimeInterval(6629))
        XCTAssertEqual(feed?.items?.first?.attachments?.last?.title, "256Kb's version")
        XCTAssertEqual(feed?.items?.first?.attachments?.last?.url, "http://therecord.co/downloads/The-Record-sp1e1-ChrisParrish-256.m4a")
        XCTAssertEqual(feed?.items?.first?.attachments?.last?.mimeType, "audio/x-m4a")
        XCTAssertEqual(feed?.items?.first?.attachments?.last?.sizeInBytes, Int(89970236))
        XCTAssertEqual(feed?.items?.first?.attachments?.last?.durationInSeconds, TimeInterval(6629))
        
        XCTAssertEqual(feed?.items?.last?.id, "1")
        XCTAssertEqual(feed?.items?.last?.contentHtml, "<p>Hello, world!</p>")
        XCTAssertEqual(feed?.items?.last?.url, "https://example.org/initial-post")
    }
    
    func testJSONFeedExtensions() {
        
        // Given
        let URL = fileURL("feed", type: "json")
        let parser = FeedParser(URL: URL)!
        
        // When
        let _feedExtension = parser.parse().jsonFeed?.extensions
        
        // Then
        XCTAssertNotNil(_feedExtension)
        
        guard let _blueShedFeedExtension = _feedExtension?["_blue_shed"] as? [String: Any] else {
            XCTFail("_blue_shed feed extension nil")
            return
        }
        
        XCTAssertEqual(_blueShedFeedExtension["about"] as? String, "https://blueshed-podcasts.com/json-feed-extension-docs")
        XCTAssertEqual(_blueShedFeedExtension["explicit"] as? Bool, false)
        XCTAssertEqual(_blueShedFeedExtension["copyright"] as? String, "1948 by George Orwell")
        XCTAssertEqual(_blueShedFeedExtension["owner"] as? String, "Big Brother and the Holding Company")
        XCTAssertEqual(_blueShedFeedExtension["subtitle"] as? String, "All shouting, all the time. Double. Plus. Good.")
        
    }
    
    func testJSONFeedItemExtensions() {
        
        // Given
        let URL = fileURL("feed", type: "json")
        let parser = FeedParser(URL: URL)!
        
        // When
        let _itemExtension = parser.parse().jsonFeed?.items?.first?.extensions
        
        // Then
        XCTAssertNotNil(_itemExtension)
        
        guard let _blueShedItemExtension = _itemExtension?["_blue_shed"] as? [String: Any] else {
            XCTFail("_blue_shed item extension nil")
            return
        }
        
        XCTAssertEqual(_blueShedItemExtension["about"] as? String, "https://blueshed-podcasts.com/json-feed-extension-docs")
        XCTAssertEqual(_blueShedItemExtension["explicit"] as? Bool, false)
        XCTAssertEqual(_blueShedItemExtension["copyright"] as? String, "1948 by George Orwell")
        XCTAssertEqual(_blueShedItemExtension["owner"] as? String, "Big Brother and the Holding Company")
        XCTAssertEqual(_blueShedItemExtension["subtitle"] as? String, "All shouting, all the time. Double. Plus. Good.")
        
    }
    
    
}
