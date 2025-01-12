//
//  DateTests.swift
//
//  Copyright (c) 2016 - 2025 Nuno Dias
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

@testable import FeedKit

import Foundation
import Testing

@Suite("Date Formatters")
struct DateTests {
  var calendar: Calendar

  init() {
    calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: "en_US_POSIX")
    calendar.timeZone = TimeZone(secondsFromGMT: 0)!
  }

  // MARK: - RFC339

  @Test
  func rfc3339() {
    // Given
    let formatter = FeedDateFormatter(spec: .rfc3339)
    let dateString = "2016-01-15T15:54:10-01:00"

    let expected = DateComponents(year: 2016, month: 1, day: 15, hour: 16, minute: 54, second: 10)

    // When
    let date = formatter.date(from: dateString)
    let actual = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date!)

    // Then
    #expect(expected == actual)
  }

  @Test
  func rfc3339Spec() {
    // Given
    let formatter = FeedDateFormatter(spec: .rfc3339)
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
    let dates = dateStrings.compactMap { dateString -> Date? in
      formatter.date(from: dateString)
    }

    // Then
    #expect(dateStrings.count == dates.count)
  }

  // MARK: - RFC822

  @Test
  func rfc822() {
    // Given
    let formatter = FeedDateFormatter(spec: .rfc822)
    let dateString = "Tue, 04 Feb 2014 22:03:45 Z"

    let expected = DateComponents(year: 2014, month: 2, day: 4, hour: 22, minute: 3, second: 45)

    // When
    let date = formatter.date(from: dateString)
    let actual = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date!)

    // Then
    #expect(expected == actual)
  }

  @Test
  func rfc822Spec() {
    // Given
    let formatter = FeedDateFormatter(spec: .rfc822)
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
      "Thu, 02 Jun 2016 15:24:37 +0000",
    ]

    // When
    let dates = dateStrings.compactMap { dateString -> Date? in
      formatter.date(from: dateString)
    }

    // Then
    #expect(dateStrings.count == dates.count)
  }

  // MARK: - RFC822

  @Test
  func rfc8601() {
    // Given
    let formatter = FeedDateFormatter(spec: .iso8601)
    let dateString = "1994-11-05T08:15:30-05:00"

    let expected = DateComponents(year: 1994, month: 11, day: 5, hour: 13, minute: 15, second: 30)

    // When
    let date = formatter.date(from: dateString)
    let actual = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date!)

    // Then
    #expect(expected == actual)
  }

  @Test
  func rfc8601Spec() {
    // Given
    let formatter = FeedDateFormatter(spec: .iso8601)
    let dateStrings = [
      "1994-11-05T08:15:30-05:00",
      "1994-11-05T08:15:30.00-05:00",
      "1994-11-05T08:15",
    ]

    // When
    let dates = dateStrings.compactMap { dateString -> Date? in
      formatter.date(from: dateString)
    }

    // Then
    #expect(dateStrings.count == dates.count)
  }
}
