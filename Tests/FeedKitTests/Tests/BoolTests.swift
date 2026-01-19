//
// BoolTests.swift
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

@Suite("String + toBool")
struct BoolTests {
  @Test
  func stringToBool() {
    // Given
    let trueStrings = ["true", "True", "1", "yes", "Yes", "Y", "y"]
    let falseStrings = ["false", "False", "0", "no", "No", "N", "n"]
    let invalidStrings = ["", "maybe", "123", "tru", "fal", "yes!", "NO.", "null"]

    // Then
    for trueString in trueStrings {
      #expect(trueString.toBool() == true)
    }

    for falseString in falseStrings {
      #expect(falseString.toBool() == false)
    }

    for invalidString in invalidStrings {
      #expect(invalidString.toBool() == nil)
    }
  }
}
