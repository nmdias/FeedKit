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

import Foundation
import Testing
@testable import XMLKit

/// End-to-end coverage of the mapping XMLKit publishes: elements, `@text`,
/// `@attributes`, namespace containers and XHTML content, in both directions.
struct SampleTests: XMLKitTestable {
  @Test("A parsed document decodes into the model it describes")
  func xmlDecoder() throws {
    // Given
    let data = data(resource: "Sample", withExtension: "xml")
    let decoder: XMLDecoder = .init()
    let expected: Sample = sampleMock

    // When
    let actual = try decoder.decode(Sample.self, from: data)

    // Then
    #expect(expected == actual)
  }

  @Test("A model encodes to a document that decodes back to it")
  func xmlEncoderDecoder() throws {
    // Given
    let encoder: XMLEncoder = .init()
    let decoder: XMLDecoder = .init()
    let expected: Sample = sampleMock

    // When
    let document = try encoder.encode(value: sampleMock)
    let actual = try decoder.decode(Sample.self, from: Data(document.toXMLString().utf8))

    // Then
    #expect(expected == actual)
  }

  @Test("The encoded document carries the document element's name and attributes")
  func xmlEncoderDocument() throws {
    // Given
    let encoder: XMLEncoder = .init()

    // When
    let document = try encoder.encode(value: sampleMock)
    document.setRootName(name: "sample")
    let xml = document.toXMLString(formatted: true)

    // Then
    #expect(xml.hasPrefix("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<sample xmlns:ns=\"http://example.ns/namespace\">"))
    #expect(xml.contains("<title type=\"text\">Sample Document</title>"))
    #expect(xml.contains("<ns:title>This title is a sample namespace element.</ns:title>"))
    #expect(xml.contains("<version>1.0</version>"))
  }

  @Test("Formatted output is indented and compact output is not")
  func formatting() throws {
    // Given
    let encoder: XMLEncoder = .init()

    // When
    let document = try encoder.encode(value: sampleMock)
    document.setRootName(name: "sample")
    let compact = document.toXMLString(formatted: false)
    let formatted = document.toXMLString(formatted: true)

    // Then
    #expect(!compact.contains("\n"))
    #expect(formatted.contains("\n"))
    #expect(formatted.contains("\n  <header>"))
  }
}
