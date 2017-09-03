//
//  DateTests.swift
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

class DateTests: BaseTestCase {
    
    func testRFC822DateFormatter() {
        
        // Given
        let rfc822DateFormatter = RFC822DateFormatter()
        let dateString = "Tue, 04 Feb 2014 22:03:45 Z"
        
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        
        // When
        let date = rfc822DateFormatter.date(from: dateString)
        
        // Then
        XCTAssertNotNil(date)
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date!)
        
        XCTAssertEqual(components.day, 4)
        XCTAssertEqual(components.month, 2)
        XCTAssertEqual(components.year, 2014)
        XCTAssertEqual(components.hour, 22)
        XCTAssertEqual(components.minute, 3)
        XCTAssertEqual(components.second, 45)
        
    }
    
    func testRFC3339DateFormatter() {
        
        // Given
        let rfc3339DateFormatter = RFC3339DateFormatter()
        let dateString = "2016-01-15T15:54:10-01:00"
        
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        
        // When
        let date = rfc3339DateFormatter.date(from: dateString)
        
        // Then
        XCTAssertNotNil(date)
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date!)
        
        XCTAssertEqual(components.day, 15)
        XCTAssertEqual(components.month, 1)
        XCTAssertEqual(components.year, 2016)
        XCTAssertEqual(components.hour, 16)
        XCTAssertEqual(components.minute, 54)
        XCTAssertEqual(components.second, 10)
        
    }
    
    func testISO8601DateFormatter() {
        
        // Given
        let iso8601DateFormatter = RFC3339DateFormatter()
        let dateString = "1994-11-05T08:15:30-05:00"
        
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        
        // When
        let date = iso8601DateFormatter.date(from: dateString)
        
        // Then
        XCTAssertNotNil(date)
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date!)
        
        XCTAssertEqual(components.day, 5)
        XCTAssertEqual(components.month, 11)
        XCTAssertEqual(components.year, 1994)
        XCTAssertEqual(components.hour, 13)
        XCTAssertEqual(components.minute, 15)
        XCTAssertEqual(components.second, 30)
        
    }
    
    func testDateFromRFC822Spec() {
        
        // Given
        let spec = DateSpec.rfc822
        let dateStrings = [
            "Tue, 04 Feb 2014 22:10:15 Z",
            "Sun, 05 Jun 2016 08:35:14 Z",
            "Sun, 05 Jun 2016 08:54 +0000",
            "Mon, 21 Mar 2016 13:31:23 GMT",
            "Sat, 04 Jun 2016 16:26:37 EDT",
            "Sat, 04 Jun 2016 11:55:28 PDT",
            "Sun, 5 Jun 2016 01:51:07 -0700",
            "Sun, 5 Jun 2016 01:30:30 -0700",
            "Thu, 02 June 2016 14:43:37 GMT",
            "Sun, 5 Jun 2016 01:49:56 -0700",
            "Fri, 27 May 2016 14:32:19 -0400",
            "Sun, 05 Jun 2016 01:45:00 -0700",
            "Sun, 05 Jun 2016 08:32:03 +0000",
            "Sat, 04 Jun 2016 22:33:02 +0000",
            "Sun, 05 Jun 2016 01:52:30 -0700",
            "Thu, 02 Jun 2016 15:24:37 +0000"
        ]
        
        // When
        let dates = dateStrings.flatMap { (dateString) -> Date? in
            return dateString.toDate(from: spec)
        }
        
        // Then
        XCTAssertEqual(dateStrings.count, dates.count)
        
    }
    
    func testDateFromRFC3339Spec() {
        
        // Given
        let spec = DateSpec.rfc3999
        let dateStrings = [
            "2016-06-05T09:30:01Z",
            "2016-06-05T03:18:00Z",
            "2016-06-05T04:30:29Z",
            "1985-04-12T23:20:50.52Z",
            "2016-06-02T18:07:16+01:00",
            "2016-06-05T05:00:03-04:00",
            "2016-04-30T11:51:54-04:00",
            "2016-06-03T17:01:48-07:00",
            "2016-06-05T03:12:10+00:00",
            "2015-02-22T13:13:48-05:00",
            "2016-06-03T23:33:00-04:00",
            "1996-12-19T16:39:57-08:00",
        ]
        
        // When
        let dates = dateStrings.flatMap { (dateString) -> Date? in
            return dateString.toDate(from: spec)
        }
        
        // Then
        XCTAssertEqual(dateStrings.count, dates.count)
        
    }
    
}
