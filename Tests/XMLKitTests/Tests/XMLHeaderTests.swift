//
// XMLHeaderTests.swift
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

import Testing
import XMLKit

@Suite("XMLHeader")
struct XMLHeaderTests: XMLKitTestable {
  @Test
  func `default`() {
    // Given
    let header: XMLHeader = .default
    let expected = """
    <?xml version=\"1.0\" encoding=\"UTF-8\"?>
    """

    // When
    let actual = header.toXMLString()

    // Then
    #expect(expected == actual)
  }

  @Test
  func version() {
    // Given
    let header: XMLHeader = .init(version: "1.1")
    let expected = """
    <?xml version=\"1.1\" encoding=\"UTF-8\"?>
    """

    // When
    let actual = header.toXMLString()

    // Then
    #expect(expected == actual)
  }

  @Test
  func encoding() {
    // Given
    let header: XMLHeader = .init(encoding: .utf16)
    let expected = """
    <?xml version=\"1.0\" encoding=\"UTF-16\"?>
    """

    // When
    let actual = header.toXMLString()

    // Then
    #expect(expected == actual)
  }

  @Test
  func isStandalone() {
    // Given
    let header: XMLHeader = .init(version: "1.0", isStandalone: true)
    let expected = """
    <?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>
    """

    // When
    let actual = header.toXMLString()

    // Then
    #expect(expected == actual)
  }
}
