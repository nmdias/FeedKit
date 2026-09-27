//
// XMLDocumentTests.swift
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

/// The document model and the serialiser: what a parsed document keeps, and what
/// writing it out again produces.
struct XMLDocumentTests {
  @Test("A parsed document keeps what Codable cannot express")
  func keepsLexicalDetail() throws {
    let document = try XMLDocument(xml: """
    <?xml version="1.0" encoding="UTF-8"?>
    <!-- a note -->
    <root a="1"><child>text<![CDATA[<raw>]]></child><!-- inner --><?pi data?></root>
    """)

    #expect(document.root.qualifiedName == "root")
    #expect(document.root.attribute("a") == "1")
    #expect(document.root.firstChild(named: "child")?.text == "text<raw>")
    #expect(document.prolog.count == 1)
    #expect(document.serializedString().contains("<![CDATA[<raw>]]>"))
    #expect(document.serializedString().contains("<!-- inner -->"))
    #expect(document.serializedString().contains("<?pi data?>"))
  }

  @Test("A document survives a parse and serialise round trip")
  func roundTrips() throws {
    let source = #"<root xmlns:x="urn:x"><x:child a="1&amp;2">text</x:child><empty/></root>"#
    let once = try XMLDocument(xml: source).serializedString()
    let twice = try XMLDocument(xml: once).serializedString()

    #expect(once == twice)
    #expect(once.contains(#"a="1&amp;2""#))
  }

  @Test("Pretty printing indents element content and leaves text alone")
  func prettyPrints() throws {
    let document = try XMLDocument(xml: "<root><child>text</child><nested><leaf/></nested></root>")

    let formatted = document.serializedString(configuration: .init(prettyPrinted: true))

    #expect(formatted.contains("\n  <child>text</child>"))
    #expect(formatted.contains("\n  <nested>\n    <leaf/>\n  </nested>"))
  }

  @Test("Elements can be found, added and changed through the document model")
  func mutatesTheTree() throws {
    let document = try XMLDocument(xml: "<root><child id=\"1\"/></root>")

    document.root.setAttribute("id", value: "2")
    document.root.appendChild(XMLElement(name: "added", text: "value"))

    #expect(document.root.attribute("id") == "2")
    #expect(document.root.firstChild(named: "added")?.text == "value")
    #expect(document.elements(named: "child").count == 1)
  }

  @Test("The token view reports the lexical sequence")
  func exposesTokens() throws {
    let document = try XMLDocument(xml: "<root><child/></root>")

    #expect(document.tokenCount > 0)
    #expect(document.tokens.contains { $0.kind == .startTag && $0.name == "child" })
  }

  @Test("Deep nesting is refused rather than overflowing the stack")
  func boundsDepth() throws {
    let deep = String(repeating: "<a>", count: 300) + String(repeating: "</a>", count: 300)

    #expect(throws: XMLParserError.self) {
      try XMLDocument(xml: deep)
    }
  }

  @Test("Entity expansion and external entities have no path in")
  func refusesEntities() throws {
    #expect(throws: XMLParserError.self) {
      try XMLDocument(xml: #"<!DOCTYPE r [<!ENTITY a "x">]><r>&a;</r>"#)
    }
  }
}
