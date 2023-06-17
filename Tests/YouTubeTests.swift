//
//  YouTubeTests.swift
//
//  Copyright (c) 2023 Naufal Fachrian
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

class YouTubeTests: BaseTestCase {
    
    func testYouTubeChannelID() {
        
        let URL = fileURL("YouTubeXMLFeed", type: "xml")
        let parser = FeedParser(URL: URL)
        
        do {
            
            let feed = try parser.parse().get().atomFeed
            
            XCTAssertEqual(feed?.entries?.last?.yt?.channelID, "UCE_M8A5yxnLfW0KghEeajjw")
            
        } catch {
            XCTFail(error.localizedDescription)
        }
        
    }
    
    func testYouTubeVideoID() {
        
        let URL = fileURL("YouTubeXMLFeed", type: "xml")
        let parser = FeedParser(URL: URL)
        
        do {
            
            let feed = try parser.parse().get().atomFeed
            
            [
                "51QO4pavK3A",
                "j1HGOY32s2Y",
                "rc46cO3spSE",
                "0okuAwqTHs0",
                "GYkq9Rgoj8E",
                "TX9qSaGXFyg",
                "4-7jSoINyq4",
                "0mqWw5UH1qg",
                "L5wx0Takylc",
                "fVW8-px4Ufw",
                "1S8L7t2tu0U",
                "svpvEfQ1cp8",
                "f1VEks-QQ4Y",
                "1HWUjMjaBJI",
                "oMf_i1YBuMk"
            ].forEach { videoID in
                XCTAssertTrue(feed?.entries?.contains(where: { entry in entry.yt?.videoID == videoID }) == true)
            }
            
        } catch {
            XCTFail(error.localizedDescription)
        }
        
    }
    
}
