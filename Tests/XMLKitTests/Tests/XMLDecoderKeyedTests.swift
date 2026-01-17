//
// XMLDecoderKeyedTests.swift
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

import Foundation
import Testing
import XMLKit

@Suite("XMLDecoder - Keyed")
struct XMLDecoderKeyedTests: XMLKitTestable {
  @Test
  func decodeKeyed() throws {
    // Given
    let decoder: XMLDecoder = .init()

    let data = """
    <root>
      <keyed>
        <title>abc</title>
        <description>xyz</description>
      </keyed>
    </root>
    """.data(using: .utf8)!

    let expected: Root = .init(
      keyed: .init(
        title: "abc",
        description: "xyz"
      )
    )

    // When
    let actual = try decoder.decode(Root.self, from: data)

    // Then
    #expect(expected == actual)
  }

  @Test
  func decodeKeyedNil() throws {
    // Given
    let decoder: XMLDecoder = .init()

    let data = """
    <root/>
    """.data(using: .utf8)!

    let expected: Root = .init(keyed: nil)

    // When
    let actual = try decoder.decode(Root.self, from: data)

    // Then
    #expect(expected == actual)
  }

  @Test(.disabled())
  func decodeKeyedNilProperties() throws {
    // Given
    let decoder: XMLDecoder = .init()

    let data = """
    <root>
      <keyed/>
    </root>
    """.data(using: .utf8)!

    let expected: Root = .init(
      keyed: .init(
        title: nil,
        description: nil
      )
    )
    // When
    let actual = try decoder.decode(Root.self, from: data)

    // Then
    #expect(expected == actual)
  }
}

extension XMLDecoderKeyedTests {
  struct Root: Decodable, Equatable {
    struct Keyed: Decodable, Equatable {
      var title: String?
      var description: String?
    }

    var keyed: Keyed?
  }
}
