//
// FeedTests.swift
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
import Foundation
import Testing

@Suite("Feed")
struct FeedTests: FeedKitTestable {
  @Test
  func url() async throws {
    // Given
    let url = url(resource: "Atom", withExtension: "xml")
    let expected: Feed = .atom(mock)

    // When
    let actual = try await Feed(url: url)

    // Then
    #expect(expected == actual)
  }

  @Test
  func fileURL() throws {
    // Given
    let fileURL = url(resource: "Atom", withExtension: "xml")
    let expected: Feed = .atom(mock)

    // When
    let actual = try Feed(fileURL: fileURL)

    // Then
    #expect(expected == actual)
  }

  @Test
  func string() throws {
    // Given
    let string = string(resource: "Atom", withExtension: "xml")
    let expected: Feed = .atom(mock)

    // When
    let actual = try Feed(string: string)

    // Then
    #expect(expected == actual)
  }

  @Test
  func data() throws {
    // Given
    let data = data(resource: "Atom", withExtension: "xml")
    let expected: Feed = .atom(mock)

    // When
    let actual = try Feed(data: data)

    // Then
    #expect(expected == actual)
  }
}
