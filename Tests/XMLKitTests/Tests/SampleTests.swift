//
// SampleTests.swift
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
@testable import XMLKit

@Suite("Sample")
struct SampleTests: XMLKitTestable {
  @Test
  func xmlReader() throws {
    // Given
    let data = data(resource: "Sample", withExtension: "xml")
    let reader: XMLReader = .init(data: data)
    let expected: XMLNode = nodeMock

    // When
    let actual = try reader.read().get().root

    // Then
    #expect(expected == actual)
  }

  @Test
  func xmlString() {
    // Given
    let data = data(resource: "Sample", withExtension: "xml")
    let expected: String = .init(decoding: data, as: Unicode.UTF8.self)
    let document: XMLDocument = .init(root: nodeMock)

    // When
    let actual = document.toXMLString(formatted: true)

    // Then
    #expect(expected == actual)
  }

  @Test("Encode Node -> Model")
  func xmlDecoder() throws {
    // Given
    let decoder: XMLDecoder = .init()
    let expected: Sample = sampleMock

    // When
    let actual = try decoder.decode(Sample.self, from: nodeMock)

    // Then
    #expect(expected == actual)
  }

  @Test("Encode Model -> Node -> Model")
  func xmlEncoderDecoder() throws {
    // Given
    let encoder: XMLEncoder = .init()
    let decoder: XMLDecoder = .init()
    let expected: Sample = sampleMock

    // When
    let sampleDocument = try encoder.encode(value: sampleMock)
    let actual = try decoder.decode(Sample.self, from: #require(sampleDocument.root))

    // Then
    #expect(expected == actual)
  }
}
