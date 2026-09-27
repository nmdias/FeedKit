//
// XMLDocument.swift
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
import XMLKitCore

/// An XML document containing a root element.
///
/// A document is produced by ``XMLEncoder`` and serialised with
/// ``XMLStringConvertible/toXMLString(formatted:indentationLevel:)``. The tree
/// itself — parsing, namespace resolution, escaping and the limits that make a
/// hostile document harmless — is the engine's; this type is the document-level
/// façade FeedKit's public API has always exposed.
public class XMLDocument: Equatable, Hashable, Codable {
  // MARK: Lifecycle

  /// Initializes a new document with an optional root element.
  /// - Parameter root: The root element of the document.
  init(root: XMLKitCore.XMLElement?) {
    self.root = root
  }

  /// Decodes a document.
  ///
  /// The wire format is the one XMLKit has always written — a root node with its
  /// prefix, name, text, XHTML marker and children — so documents encoded by an
  /// earlier release still decode.
  public required convenience init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: XMLDocument.CodingKeys.self)
    let snapshot = try container.decodeIfPresent(XMLDocumentNode.self, forKey: .root)
    self.init(root: snapshot?.element)
  }

  // MARK: Public

  // MARK: Equatable

  public static func == (lhs: XMLDocument, rhs: XMLDocument) -> Bool {
    switch (lhs.root, rhs.root) {
    case (nil, nil):
      true
    case let (lhs?, rhs?):
      lhs.xmlKitIsStructurallyEqual(to: rhs)
    default:
      false
    }
  }

  // MARK: Hashable

  public func hash(into hasher: inout Hasher) {
    root?.xmlKitHash(into: &hasher)
  }

  /// Sets the name of the root element.
  /// - Parameter name: The new name for the root element.
  public func setRootName(name: String) {
    root?.qualifiedName = name
  }

  /// Adds or updates an attribute in the root element.
  /// - Parameters:
  ///   - name: The name of the attribute to add or update.
  ///   - value: The value to associate with the attribute.
  public func setRootAttribute(name: String, value: String) {
    root?.setAttribute(name, value: value)
  }

  // MARK: Internal

  /// The root element of the document.
  var root: XMLKitCore.XMLElement?

  // MARK: Private

  private enum CodingKeys: String, CodingKey {
    case root
  }
}

// MARK: - XMLStringConvertible

extension XMLDocument: XMLStringConvertible {
  /// Generates an XML string representation of the document.
  /// - Parameter formatted: Whether to generate formatted XML (default is
  ///   false for compact XML).
  /// - Returns: A string representation of the XML.
  public func toXMLString(
    formatted: Bool = false,
    indentationLevel _: Int = 1
  ) -> String {
    guard let root else {
      return ""
    }

    let declaration = XMLKitCore.XMLDeclaration(version: "1.0", encoding: "UTF-8")
    let document = XMLKitCore.XMLDocument(root: root, declaration: declaration)

    // Two spaces per level, the same as every release of XMLKit has emitted, and
    // `>` escaped in text, which keeps the output safe for consumers that scan
    // for it instead of parsing.
    let configuration = XMLKitCore.XMLWriterConfiguration(
      xmlDeclaration: declaration,
      prettyPrinted: formatted,
      indentation: "  "
    )

    let bytes = XMLKitCore.XMLWriter(configuration: configuration).bytes(for: document)
    return String(decoding: XMLLegacyWriter.applyingLegacyEmptyElementSpacing(to: bytes), as: UTF8.self)
  }
}

// MARK: - Codable

public extension XMLDocument {
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: XMLDocument.CodingKeys.self)
    try container.encodeIfPresent(root.map(XMLDocumentNode.init), forKey: .root)
  }
}

// MARK: - Node snapshot

/// A document tree in the shape XMLKit has always encoded it.
///
/// The engine's nodes carry more than this — CDATA sections, comments,
/// processing instructions, attribute order — so the snapshot is a lossy but
/// faithful projection of everything XMLKit could represent before, which is
/// what keeps the encoding stable.
struct XMLDocumentNode: Codable {
  // MARK: Lifecycle

  /// Captures an element.
  init(_ element: XMLKitCore.XMLElement) {
    prefix = element.prefix
    name = element.qualifiedName
    let text = element.text
    self.text = text.isEmpty ? nil : text
    isXhtml = element.xmlKitIsXHTML
    let elementChildren = element.childElements
    children = elementChildren.isEmpty ? nil : elementChildren.map(XMLDocumentNode.init)
  }

  // MARK: Internal

  var prefix: String?
  var name: String
  var text: String?
  var isXhtml: Bool
  var children: [XMLDocumentNode]?

  /// The element this snapshot describes.
  var element: XMLKitCore.XMLElement {
    let element = XMLKitCore.XMLElement(name: name)
    if let text {
      element.appendChild(.text(text))
    }
    for child in children ?? [] {
      element.appendChild(.element(child.element))
    }
    return element
  }
}
