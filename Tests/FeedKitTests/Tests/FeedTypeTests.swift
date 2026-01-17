//
// FeedTypeTests.swift
//
// Copyright (c) 2016 - 2026 Nuno Dias
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

@testable import FeedKit
import Testing

@Suite("FeedType")
struct FeedTypeTests: FeedKitTestable {
  @Test
  func atomFeedType() throws {
    // Given
    let data = data(resource: "Atom", withExtension: "xml")
    let expected: FeedType = .atom

    // When
    let actual = try FeedType(data: data)

    // Then
    #expect(actual.isXML)
    #expect(expected == actual)
  }

  @Test
  func rssFeedType() throws {
    // Given
    let data = data(resource: "RSS", withExtension: "xml")
    let expected: FeedType = .rss

    // When
    let actual = try FeedType(data: data)

    // Then
    #expect(actual.isXML)
    #expect(expected == actual)
  }

  @Test
  func jsonFeedType() throws {
    // Given
    let data = data(resource: "feed", withExtension: "json")
    let expected: FeedType = .json

    // When
    let actual = try FeedType(data: data)

    // Then
    #expect(actual.isJson)
    #expect(expected == actual)
  }
}
