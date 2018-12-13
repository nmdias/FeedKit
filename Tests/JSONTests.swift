//
//  JSONTests.swift
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
@testable import FeedKit

class JSONTests: BaseTestCase {
    
    func testJSONFeed() {
        
        // Given
        let URL = fileURL("feed", type: "json")
        let parser = FeedParser(URL: URL)
        var jsonFeed = JSONFeed()
        
        jsonFeed.version = "https://jsonfeed.org/version/1"
        jsonFeed.title = "Title"
        jsonFeed.userComment = "User comment"
        jsonFeed.homePageURL = "https://example.org/"
        jsonFeed.description = "Description"
        jsonFeed.feedUrl = "https://example.org/feed.json?p=1"
        jsonFeed.nextUrl = "https://example.org/feed.json?p=2"
        jsonFeed.icon = "https://example.org/icon.jpg"
        jsonFeed.favicon = "https://example.org/favicon.ico"
        jsonFeed.expired = false
        jsonFeed.author = JSONFeedAuthor(
            name: "Brent Simmons",
            url: "http://example.org/",
            avatar: "https://example.org/avatar.png"
        )
        jsonFeed.hubs = [
            JSONFeedHub(
                type: "Type 1",
                url: "http://example1.org/"
            ),
            JSONFeedHub(
                type: "Type 2",
                url: "http://example2.org/"
            )
        ]
        jsonFeed.items = [
            JSONFeedItem(
                id: "http://therecord.co/chris-parrish",
                url: "http://therecord.co/chris-parrish",
                externalUrl: "http://external.com/example",
                title: "Special #1 - Chris Parrish",
                contentText: "Chris has worked at Adobe and as a founder of Rogue Sheep, which won an Apple Design Award for Postage. Chris's new company is Aged & Distilled with Guy English - which shipped Napkin, a Mac app for visual collaboration. Chris is also the co-host of The Record. He lives on Bainbridge Island, a quick ferry ride from Seattle.",
                contentHtml: "Chris has worked at <a href=\"http://adobe.com/\">Adobe</a> and as a founder of Rogue Sheep, which won an Apple Design Award for Postage. Chris's new company is Aged & Distilled with Guy English - which shipped <a href=\"http://aged-and-distilled.com/napkin/\">Napkin</a>, a Mac app for visual collaboration. Chris is also the co-host of The Record. He lives on <a href=\"http://www.ci.bainbridge-isl.wa.us/\">Bainbridge Island</a>, a quick ferry ride from Seattle.",
                summary: "Brent interviews Chris Parrish, co-host of The Record and one-half of Aged & Distilled.",
                image: "https://example.org/image.jpg",
                bannerImage: "https://example.org/banner.jpg",
                datePublished: RFC3339DateFormatter().date(from: "2014-05-09T12:04:00-07:00"),
                dateModified: RFC3339DateFormatter().date(from: "2014-05-09T14:04:00-07:00"),
                author: JSONFeedAuthor(
                    name: "Brent Simmons",
                    url: "http://example.org/",
                    avatar: "https://example.org/avatar.png"
                ),
                tags: [
                    "tag1",
                    "tag2"
                ],
                attachments: [
                    JSONFeedAttachment(
                        url: "http://therecord.co/downloads/The-Record-sp1e1-ChrisParrish-128.m4a",
                        mimeType: "audio/x-m4a",
                        title: "128Kb's version",
                        sizeInBytes: 63207998,
                        durationInSeconds: 6629
                    ),
                    JSONFeedAttachment(
                        url: "http://therecord.co/downloads/The-Record-sp1e1-ChrisParrish-256.m4a",
                        mimeType: "audio/x-m4a",
                        title: "256Kb's version",
                        sizeInBytes: 89970236,
                        durationInSeconds: 6629
                    )
                ]
            ),
            JSONFeedItem(
                id: "1",
                url: "https://example.org/initial-post",
                externalUrl: nil,
                title: nil,
                contentText: nil,
                contentHtml: "<p>Hello, world!</p>",
                summary: nil,
                image: nil,
                bannerImage: nil,
                datePublished: nil,
                dateModified: nil,
                author: nil,
                tags: nil,
                attachments: nil
            )
        ]
        
        // When
        let parsedJsonFeed = parser.parse().jsonFeed
        
        // Then
        XCTAssertEqual(parsedJsonFeed, jsonFeed)
        
    }
    
}
