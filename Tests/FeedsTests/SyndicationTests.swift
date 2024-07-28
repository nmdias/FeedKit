//
//  SyndicationTests.swift
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

class SyndicationTests: BaseTestCase {
    
    func testSyndication() async {
        // Given
        let URL = fileURL("Syndication", withExtension: "xml")

        do {
            // When
            let feed = try await RSSFeed(URL: URL)
            
            // Then
            XCTAssertEqual(feed.channel?.syndication?.updatePeriod , SyndicationUpdatePeriod.hourly)
            XCTAssertEqual(feed.channel?.syndication?.updateFrequency , Int(2))
            
            XCTAssertNotNil(feed.channel?.syndication?.updateBase)
            
        } catch {
            XCTFail(String(describing:error))
        }
    }
    
    func testSyndicationParsingPerformance() {
        self.measure {
            // Given
            let expectation = self.expectation(description: "Syndication Parsing Performance")
            let URL = self.fileURL("Syndication", withExtension: "xml")

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
