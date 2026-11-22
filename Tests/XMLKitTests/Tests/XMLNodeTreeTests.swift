//
// XMLNodeTreeTests.swift
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
struct XMLNodeTreeTests: XMLKitTestable {
  @Test("addChild parents each child and keeps document order")
  func addChildParentsInOrder() {
    // Given
    let channel: XMLKit.XMLNode = .init(name: "channel")
    let items: [XMLKit.XMLNode] = (0 ..< 5000).map { .init(name: "item", text: "\($0)") }

    // When
    items.forEach(channel.addChild)

    // Then
    #expect(channel.children?.count == 5000)
    #expect(channel.children?.map(\.text) == items.map(\.text))
    #expect(items.allSatisfy { $0.parent === channel })
  }

  @Test("Assigning children re-parents every child")
  func assigningChildrenParents() {
    // Given
    let node: XMLKit.XMLNode = .init(name: "item")
    let children: [XMLKit.XMLNode] = [.init(name: "title"), .init(name: "link")]

    // When
    node.children = children

    // Then
    #expect(children.allSatisfy { $0.parent === node })
  }

  @Test("child(for:) prefers the first text-bearing match")
  func childPrefersTextBearingMatch() {
    // Given
    let empty: XMLKit.XMLNode = .init(name: "title")
    let first: XMLKit.XMLNode = .init(name: "title", text: "First")
    let second: XMLKit.XMLNode = .init(name: "title", text: "Second")
    let node: XMLKit.XMLNode = .init(name: "item", children: [.init(name: "link"), empty, first, second])

    // Then
    #expect(node.child(for: "title") === first)
  }

  @Test("child(for:) falls back to the first match, or nil")
  func childFallsBackToFirstMatch() {
    // Given
    let a: XMLKit.XMLNode = .init(name: "enclosure")
    let b: XMLKit.XMLNode = .init(name: "enclosure", text: "")
    let node: XMLKit.XMLNode = .init(name: "item", children: [a, b])

    // Then
    #expect(node.child(for: "enclosure") === a)
    #expect(node.child(for: "guid") == nil)
    #expect(XMLKit.XMLNode(name: "item").child(for: "guid") == nil)
  }
}
