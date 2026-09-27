//
// XMLCompatibilityTests.swift
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

/// The behaviours the engine does not provide on its own, and which XMLKit's
/// public contract does: the tolerance real-world feeds need, the XHTML content
/// convention, and the error surface.
struct XMLCompatibilityTests: XMLKitTestable {
  @Test("An XHTML element exposes its child markup as text")
  func xhtmlContentIsMarkup() throws {
    // Given
    let decoder: XMLDecoder = .init()
    let data: Data = .init("""
    <feed><content type="xhtml">
      <div xmlns="http://www.w3.org/1999/xhtml"><p>Some <strong>markings</strong></p></div>
    </content></feed>
    """.utf8)

    struct Content: Decodable, Equatable {
      var text: String?

      private enum CodingKeys: String, CodingKey {
        case text = "@text"
      }
    }

    struct Feed: Decodable, Equatable {
      var content: Content
    }

    // When
    let feed = try decoder.decode(Feed.self, from: data)

    // Then
    #expect(feed.content.text == #"<div xmlns="http://www.w3.org/1999/xhtml"><p>Some <strong>markings</strong></p></div>"#)
  }

  @Test("Attribute values are trimmed of surrounding whitespace")
  func attributesAreTrimmed() throws {
    // Given
    let decoder: XMLDecoder = .init()
    let data: Data = .init(#"<root><item length=" 24986239 "/></root>"#.utf8)

    struct Attributes: Decodable, Equatable {
      var length: Int64
    }

    struct Item: Decodable, Equatable {
      var attributes: Attributes

      private enum CodingKeys: String, CodingKey {
        case attributes = "@attributes"
      }
    }

    struct Root: Decodable, Equatable {
      var item: Item
    }

    // When
    let root = try decoder.decode(Root.self, from: data)

    // Then
    #expect(root.item.attributes.length == 24_986_239)
  }

  @Test("A prefix that is never declared does not stop the document from decoding")
  func undeclaredPrefixIsAccepted() throws {
    // Given
    let decoder: XMLDecoder = .init()
    let data: Data = .init("""
    <rss version="2.0"><channel><item>
      <dcterms:valid>start=2002-10-13T09:00+01:00;</dcterms:valid>
      <media:title>Hello</media:title>
    </item></channel></rss>
    """.utf8)

    struct Item: Decodable, Equatable {
      var valid: String?
      var title: String?

      private enum CodingKeys: String, CodingKey {
        case valid = "dcterms:valid"
        case title = "media:title"
      }
    }

    struct Channel: Decodable, Equatable {
      var item: Item
    }

    struct RSS: Decodable, Equatable {
      var channel: Channel
    }

    // When
    let rss = try decoder.decode(RSS.self, from: data)

    // Then
    #expect(rss.channel.item.valid == "start=2002-10-13T09:00+01:00;")
    #expect(rss.channel.item.title == "Hello")
  }

  @Test("A document in a declared non-UTF-8 encoding is transcoded")
  func nonUTF8DocumentIsDecoded() throws {
    // Given a Latin-1 document, as published by the feed from issue #53.
    let decoder: XMLDecoder = .init()
    var data: Data = .init("<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><root><title>bes".utf8)
    data.append(0xE6) // 'æ' in ISO-8859-1
    data.append(Data("ge</title></root>".utf8))

    struct Root: Decodable, Equatable {
      var title: String?
    }

    // When
    let root = try decoder.decode(Root.self, from: data)

    // Then
    #expect(root.title == "besæge")
  }

  @Test("A UTF-16 document is transcoded, with and without a byte order mark")
  func utf16DocumentIsDecoded() throws {
    // Given
    let decoder: XMLDecoder = .init()
    let xml = "<?xml version=\"1.0\" encoding=\"UTF-16\"?><root><title>Hello</title></root>"

    struct Root: Decodable, Equatable {
      var title: String?
    }

    // When / Then
    let withBOM = try #require(xml.data(using: .utf16))
    #expect(try decoder.decode(Root.self, from: withBOM).title == "Hello")

    let withoutBOM = try #require(xml.data(using: .utf16LittleEndian))
    #expect(try decoder.decode(Root.self, from: withoutBOM).title == "Hello")
  }

  @Test("Content after the document element is ignored")
  func trailingContentIsIgnored() throws {
    // Given
    let decoder: XMLDecoder = .init()
    let data: Data = .init(#"<root><title>Hello</title></root>[]"#.utf8)

    struct Root: Decodable, Equatable {
      var title: String?
    }

    // When
    let root = try decoder.decode(Root.self, from: data)

    // Then
    #expect(root.title == "Hello")
  }

  @Test("A document that is not well-formed is reported as an XMLError")
  func malformedDocumentIsAnXMLError() throws {
    // Given
    let decoder: XMLDecoder = .init()
    let data: Data = .init("<root><title>Hello</root>".utf8)

    // When / Then
    #expect(throws: XMLError.self) {
      try decoder.decode(Sample.self, from: data)
    }
  }

  @Test("Namespace containers decode from the prefixed elements of their parent")
  func namespaceContainerDecodes() throws {
    // Given
    let decoder: XMLDecoder = .init()
    let data: Data = .init("""
    <item>
      <dc:title>Title</dc:title>
      <dc:creator>Creator</dc:creator>
      <title>Plain title</title>
    </item>
    """.utf8)

    struct DublinCore: Decodable, Equatable, XMLNamespaceCodable {
      var title: String?
      var creator: String?

      private enum CodingKeys: String, CodingKey {
        case title = "dc:title"
        case creator = "dc:creator"
      }
    }

    struct Item: Decodable, Equatable {
      var title: String?
      var dublinCore: DublinCore?

      private enum CodingKeys: String, CodingKey {
        case title
        case dublinCore = "dc"
      }
    }

    // When
    let item = try decoder.decode(Item.self, from: data)

    // Then
    #expect(item.title == "Plain title")
    #expect(item.dublinCore?.title == "Title")
    #expect(item.dublinCore?.creator == "Creator")
  }

  @Test("A prefix that merely looks like a key is not a namespace container")
  func prefixLookalikeIsNotANamespaceContainer() throws {
    // Given an element whose prefix matches the RSS `source` element's name.
    let decoder: XMLDecoder = .init()
    let data: Data = .init("""
    <item><source:markdown>markdown body</source:markdown></item>
    """.utf8)

    struct Item: Decodable, Equatable {
      var source: String?
      var markdown: String?

      private enum CodingKeys: String, CodingKey {
        case source
        case markdown = "source:markdown"
      }
    }

    // When
    let item = try decoder.decode(Item.self, from: data)

    // Then
    #expect(item.source == nil)
    #expect(item.markdown == "markdown body")
  }

  @Test("An error's code, domain and descriptions are preserved")
  func errorSurface() {
    // Given
    let error: XMLError = .unexpected(reason: "boom")

    // Then
    #expect(XMLError.errorDomain == "com.feedkit.error")
    #expect(error.errorCode == -90000)
    #expect(XMLError.notFound.errorCode == -1000)
    #expect(XMLError.cdataDecoding(element: "title").errorCode == -1001)
    #expect(error.error.domain == "com.feedkit.error")
    #expect(error.error.code == -90000)
    #expect(XMLError.notFound.errorDescription == "Feed not found.")
  }
}
