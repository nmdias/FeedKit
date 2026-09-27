//
// XMLEncoderTests.swift
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

/// The encoding contract: what a Swift value becomes, and that the result is
/// well-formed enough to read back.
struct XMLEncoderTests {
  @Test("A type's name names the document element, unless the caller names it")
  func namesTheRootElement() throws {
    struct Library: Codable { var book: String }

    #expect(try XMLEncoder().encodeToString(Library(book: "XML")).contains("<Library>"))
    #expect(try XMLEncoder().encodeToString(Library(book: "XML"), rootElementName: "library").contains("<library>"))
  }

  @Test("Attributes are written from @ keys and text from #text")
  func encodesAttributesAndText() throws {
    struct Book: Codable, Equatable {
      var id: String
      var title: String

      private enum CodingKeys: String, CodingKey {
        case id = "@id"
        case title = "#text"
      }
    }

    let xml = try XMLEncoder().encodeToString(Book(id: "b1", title: "Tom & Jerry"), rootElementName: "book")

    #expect(xml == #"<book id="b1">Tom &amp; Jerry</book>"#)
  }

  @Test("An array is written as repeated sibling elements")
  func encodesRepeatedElements() throws {
    struct Library: Codable {
      var book: [String]
    }

    let xml = try XMLEncoder().encodeToString(Library(book: ["a", "b"]))

    #expect(xml == "<Library><book>a</book><book>b</book></Library>")
  }

  @Test("An encoded document decodes back to the value it came from")
  func roundTrips() throws {
    struct Enclosure: Codable, Equatable {
      var url: String
      var length: Int64

      private enum CodingKeys: String, CodingKey {
        case url = "@url"
        case length = "@length"
      }
    }

    let expected: Enclosure = .init(url: "https://example.com/?a=1&b=2", length: 42)
    let xml = try XMLEncoder().encodeToString(expected, rootElementName: "enclosure")
    let actual = try XMLDecoder().decode(Enclosure.self, from: xml)

    #expect(xml == #"<enclosure url="https://example.com/?a=1&amp;b=2" length="42"/>"#)
    #expect(actual == expected)
  }

  @Test("A nil property writes no element by default")
  func omitsNils() throws {
    struct Root: Codable {
      var title: String?
      var present: String?
    }

    let xml = try XMLEncoder().encodeToString(Root(title: nil, present: "here"))

    #expect(xml == "<Root><present>here</present></Root>")
  }

  @Test("Output is deterministic")
  func isDeterministic() throws {
    struct Root: Codable {
      var a: String
      var b: String
    }

    let encoder: XMLEncoder = .init()
    let first = try encoder.encodeToString(Root(a: "1", b: "2"))
    let second = try encoder.encodeToString(Root(a: "1", b: "2"))

    #expect(first == second)
  }
}
