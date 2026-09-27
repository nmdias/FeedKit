//
// XMLDecoderTests.swift
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

/// The decoding contract: how a Swift type is spelled as XML, and what happens
/// when a document does not match.
struct XMLDecoderTests {
  @Test("A property is a child element")
  func decodesChildElements() throws {
    struct Keyed: Decodable, Equatable {
      var title: String?
      var description: String?
    }

    let keyed = try XMLDecoder().decode(Keyed.self, from: """
    <keyed><title>abc</title><description>xyz</description></keyed>
    """)

    #expect(keyed == .init(title: "abc", description: "xyz"))
  }

  @Test("An attribute is a key with an @ sigil")
  func decodesAttributes() throws {
    struct Enclosure: Decodable, Equatable {
      var url: String?
      var length: Int64?
      var type: String?

      private enum CodingKeys: String, CodingKey {
        case url = "@url"
        case length = "@length"
        case type = "@type"
      }
    }

    let enclosure = try XMLDecoder().decode(Enclosure.self, from: """
    <enclosure url="https://example.com/a.mp3" length="12216320" type="audio/mpeg"/>
    """)

    #expect(enclosure == .init(url: "https://example.com/a.mp3", length: 12_216_320, type: "audio/mpeg"))
  }

  @Test("An element's own text is the #text key, and CDATA reads as the same value")
  func decodesText() throws {
    struct Title: Decodable, Equatable {
      var value: String?

      private enum CodingKeys: String, CodingKey {
        case value = "#text"
      }
    }
    struct Wrapper: Decodable, Equatable {
      var title: Title?
    }

    let escaped = try XMLDecoder().decode(Wrapper.self, from: "<wrapper><title>Tom &amp; Jerry</title></wrapper>")
    let cdata = try XMLDecoder().decode(Wrapper.self, from: "<wrapper><title><![CDATA[Tom & Jerry]]></title></wrapper>")

    #expect(escaped.title?.value == "Tom & Jerry")
    #expect(cdata.title?.value == "Tom & Jerry")
  }

  @Test("An array property reads repeated sibling elements")
  func decodesRepeatedElements() throws {
    struct Root: Decodable, Equatable {
      var value: [String]?
    }

    let repeated = try XMLDecoder().decode(Root.self, from: "<root><value>a</value><value>b</value></root>")
    let single = try XMLDecoder().decode(Root.self, from: "<root><value>a</value></root>")
    let absent = try XMLDecoder().decode(Root.self, from: "<root/>")

    #expect(repeated.value == ["a", "b"])
    #expect(single.value == ["a"])
    #expect(absent.value == nil)
  }

  @Test("An absent element is nil, and an empty element is empty text for a string")
  func decodesOptionals() throws {
    struct Root: Decodable, Equatable {
      var title: String?
      var count: Int?
    }

    let root = try XMLDecoder().decode(Root.self, from: "<root><title/><count/></root>")

    #expect(root.title == "")
    #expect(root.count == nil)
  }

  @Test("Inner markup is reachable under the #markup key")
  func decodesInnerMarkup() throws {
    struct Content: Decodable, Equatable {
      var type: String?
      var markup: String?

      private enum CodingKeys: String, CodingKey {
        case type = "@type"
        case markup = "#markup"
      }
    }
    struct Feed: Decodable, Equatable {
      var content: Content?
    }

    let feed = try XMLDecoder().decode(Feed.self, from: """
    <feed><content type="xhtml"><div xmlns="http://www.w3.org/1999/xhtml"><p>Some <strong>markings</strong></p></div></content></feed>
    """)

    #expect(feed.content?.type == "xhtml")
    #expect(feed.content?.markup == #"<div xmlns="http://www.w3.org/1999/xhtml"><p>Some <strong>markings</strong></p></div>"#)
  }

  @Test("Attribute values are exact by default and trimmed on request")
  func attributeTrimming() throws {
    struct Enclosure: Decodable, Equatable {
      var length: String?

      private enum CodingKeys: String, CodingKey {
        case length = "@length"
      }
    }

    let document = #"<enclosure length=" 12216320 "/>"#

    let exact = try XMLDecoder().decode(Enclosure.self, from: document)
    #expect(exact.length == " 12216320 ")

    var tolerant: XMLDecoder = .init()
    tolerant.attributeTrimming = .whitespaceAndNewlines
    #expect(try tolerant.decode(Enclosure.self, from: document).length == "12216320")
  }

  @Test("A namespaced name is matched as written")
  func decodesNamespacedNames() throws {
    struct Item: Decodable, Equatable {
      var creator: String?

      private enum CodingKeys: String, CodingKey {
        case creator = "dc:creator"
      }
    }

    let item = try XMLDecoder().decode(Item.self, from: """
    <item xmlns:dc="http://purl.org/dc/elements/1.1/"><dc:creator>Nuno</dc:creator></item>
    """)

    #expect(item.creator == "Nuno")
  }

  @Test("A document that does not match the type throws a decoder error")
  func reportsMissingKeys() throws {
    struct Root: Decodable {
      var title: String
    }

    #expect(throws: XMLDecoderError.self) {
      try XMLDecoder().decode(Root.self, from: "<root/>")
    }
  }

  @Test("A malformed document throws a parser error")
  func reportsMalformedDocuments() throws {
    struct Root: Decodable {
      var title: String?
    }

    #expect(throws: XMLParserError.self) {
      try XMLDecoder().decode(Root.self, from: "<root><title>x</root>")
    }
  }
}
