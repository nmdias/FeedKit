//
// EscapeCharactersTests.swift
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

/// Coverage for the escaping the serialiser applies, which is what keeps an
/// encoded document well-formed and re-parseable.
struct EscapeCharactersTests: XMLKitTestable {
  @Test("Metacharacters in text are escaped")
  func escapesText() throws {
    // Given
    let encoder: XMLEncoder = .init()

    struct Document: Codable {
      var value: String
    }

    // When
    let document = try encoder.encode(value: Document(value: #"& < > "quoted" 'single'"#))
    document.setRootName(name: "root")
    let xml = document.toXMLString()

    // Then
    #expect(xml == #"<?xml version="1.0" encoding="UTF-8"?><root><value>&amp; &lt; &gt; "quoted" 'single'</value></root>"#)
  }

  @Test("Metacharacters in an attribute value are escaped")
  func escapesAttributeValues() throws {
    // Given
    let encoder: XMLEncoder = .init()

    struct Attributes: Codable, Equatable {
      var url: String
    }

    struct Element: Codable {
      var attributes: Attributes

      private enum CodingKeys: String, CodingKey {
        case attributes = "@attributes"
      }
    }

    // When
    let document = try encoder.encode(value: Element(attributes: .init(url: "https://example.com/?a=1&b=2")))
    document.setRootName(name: "enclosure")
    let xml = document.toXMLString()

    // Then
    #expect(xml == #"<?xml version="1.0" encoding="UTF-8"?><enclosure url="https://example.com/?a=1&amp;b=2" />"#)
  }

  @Test("Escaped output parses back to the original values")
  func roundTripsEscapedCharacters() throws {
    // Given
    let text = #"Tom & Jerry < "best" > 'friends'"#
    let url = "https://example.com/?a=1&b=2"
    let encoder: XMLEncoder = .init()
    let decoder: XMLDecoder = .init()

    struct Attributes: Codable, Equatable {
      var url: String
    }

    struct Element: Codable, Equatable {
      var text: String
      var attributes: Attributes

      private enum CodingKeys: String, CodingKey {
        case text = "@text"
        case attributes = "@attributes"
      }
    }

    let expected: Element = .init(text: text, attributes: .init(url: url))

    // When
    let document = try encoder.encode(value: expected)
    let actual = try decoder.decode(Element.self, from: Data(document.toXMLString().utf8))

    // Then
    #expect(expected == actual)
  }
}
