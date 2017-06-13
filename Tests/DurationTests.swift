//
//  DurationTests.swift
//
//  Copyright (c) 2017 Ben Murphy
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

class DurationTests: BaseTestCase {
    
    func testToDuration() {
        
        // Given
        let hhmmss = "01:15:15"
        let hmmss = "1:20:25"
        let mmss = "43:15"
        let mss = "5:09"
        let ss = "45"

        let garbagehhmmss = "o1:15:15"
        let totalJunk = "bh:123;12j!"
        let leadingZeroes = "001:15:15"
        let tachyon = "-01:15:15"

        // Then
        XCTAssertEqual(hhmmss.toDuration(), 4515)
        XCTAssertEqual(hmmss.toDuration(), 4825)
        XCTAssertEqual(mmss.toDuration(), 2595)
        XCTAssertEqual(mss.toDuration(), 309)
        XCTAssertEqual(ss.toDuration(), 45)

        XCTAssertNil(garbagehhmmss.toDuration())
        XCTAssertNil(totalJunk.toDuration())
        XCTAssertEqual(leadingZeroes.toDuration(), 4515)
        XCTAssertNil(tachyon.toDuration())
    }
    
}
