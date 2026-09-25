//
// XMLNodeEscapingTests.swift
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

/// `Foundation` also declares `XMLNode` and `XMLDocument` on Apple platforms,
/// so the XMLKit types are qualified throughout this suite.
struct XMLNodeEscapingTests: XMLKitTestable {
  @Test("Text is escaped when a node is serialized")
  func escapesText() {
    // Given
    let node: XMLKit.XMLNode = .init(name: "title", text: #"A & B < C > D "quoted" 'single'"#)

    // When
    let xml = node.toXMLString()

    // Then
    #expect(xml == "<title>A &amp; B &lt; C &gt; D &quot;quoted&quot; &apos;single&apos;</title>")
  }

  @Test("Attribute values are escaped when a node is serialized")
  func escapesAttributeValues() {
    // Given
    let node: XMLKit.XMLNode = .init(name: "enclosure")
    node.setAttribute(name: "url", value: "https://example.com/?a=1&b=2")
    node.setAttribute(name: "title", value: #"He said "hi" & left"#)

    // When
    let xml = node.toXMLString()

    // Then
    #expect(xml == #"<enclosure url="https://example.com/?a=1&amp;b=2" title="He said &quot;hi&quot; &amp; left" />"#)
  }

  @Test("XHTML text is emitted verbatim and never escaped twice")
  func doesNotEscapeXhtmlText() {
    // Given the markup that `XMLReader` captures verbatim for `type="xhtml"`.
    let markup = #"<div xmlns="http://www.w3.org/1999/xhtml"><p>Tom &amp; Jerry</p></div>"#
    let node: XMLKit.XMLNode = .init(name: "content", text: markup, isXhtml: true)

    // When
    let xml = node.toXMLString()

    // Then
    #expect(xml == "<content>\(markup)</content>")
  }

  @Test("Escaped output parses back to the original text and attributes")
  func roundTripsEscapedCharacters() throws {
    // Given
    let text = #"Tom & Jerry < "best" > 'friends'"#
    let url = "https://example.com/?a=1&b=2"

    let root: XMLKit.XMLNode = .init(name: "root")
    root.setAttribute(name: "url", value: url)
    root.addChild(.init(name: "title", text: text))
    let document: XMLKit.XMLDocument = .init(root: root)

    // When
    let xml = document.toXMLString()
    let reparsed = try XMLReader(data: Data(xml.utf8)).read().get().root

    // Then
    #expect(reparsed?.child(for: "title")?.text == text)
    #expect(reparsed?.children?.first(where: { $0.name == "@attributes" })?.child(for: "url")?.text == url)
  }
}
