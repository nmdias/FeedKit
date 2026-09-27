//
// XMLLegacyDOM.swift
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

/// The XML semantics XMLKit's public API has always exposed, expressed over the
/// engine's document model.
///
/// XMLKit's `Codable` contract is older than the engine that now backs it, and
/// the two disagree about how an element is spelled as Swift data:
///
/// - XMLKit folds an element's attributes into a child element named
///   `@attributes` whose children are the attributes, and addresses an element's
///   text with the key `@text`.
/// - The engine names attributes `@name` and text `#text`.
///
/// FeedKit's models, and every model written against XMLKit before this
/// migration, are written for the former, so the adapter lives here rather than
/// in the models: the engine parses, and these accessors give the decoder the
/// view the public contract promises.
///
/// Two other long-standing behaviours are reproduced here, because documents in
/// the wild depend on them:
///
/// - Attribute values are trimmed of surrounding whitespace. Some feeds pad
///   them, e.g. `length="169600320 "`, and `Int64` does not accept whitespace.
/// - An element with `type="xhtml"` exposes its child markup as text, which is
///   how Atom's XHTML content has always been surfaced.
extension XMLKitCore.XMLElement {
  // MARK: Names

  /// Whether the receiver contains an element belonging to `prefix`'s namespace.
  func xmlKitHasNamespace(for prefix: String) -> Bool {
    childElements.contains { $0.prefix == prefix }
  }

  // MARK: Text

  /// The element's text, as XMLKit has always reported it.
  ///
  /// Whitespace around the value is removed, and an empty result is `nil` rather
  /// than `""`, which is what makes an empty element mean "no value" to the
  /// decoder. An element marked `type="xhtml"` is the exception: its text is the
  /// markup of its children, because that markup *is* the value Atom defines.
  ///
  /// - Parameter cache: Per-decode cache. A decode asks for the same element's
  ///   text several times — `contains`, then `decodeNil`, then `decode` — and
  ///   both the concatenation and the trim are proportional to the value.
  func xmlKitText(cache: XMLDecodeCache) -> String? {
    if let cached = cache.text(for: self) {
      return cached
    }

    let value: String? = if xmlKitIsXHTML {
      // The markup of an XHTML element is the value Atom defines, and producing
      // it means serialising a subtree.
      xmlKitChildMarkup.trimmingCharacters(in: .whitespacesAndNewlines)
    } else {
      // An element with a single run of character data, which is almost every
      // element, is trimmed in place rather than concatenated first.
      xmlKitCharacterData
    }

    let text = (value?.isEmpty ?? true) ? nil : value
    cache.setText(text, for: self)
    return text
  }

  /// The element's character data, trimmed of surrounding whitespace.
  private var xmlKitCharacterData: String? {
    if children.count == 1, case let .text(text) = children[0] {
      return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    if children.count == 1, case let .cdata(text) = children[0] {
      return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    return text.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  /// Whether the element asks for its children to be treated as XHTML markup.
  var xmlKitIsXHTML: Bool {
    attribute("type") == "xhtml"
  }

  /// The markup of the element's children: child elements re-serialised, and
  /// character data appended exactly as it was read.
  var xmlKitChildMarkup: String {
    var result = ""
    for child in children {
      switch child {
      case let .element(element):
        result += XMLWriter().string(for: element)
      case let .cdata(text),
           let .text(text):
        // Character data is appended as it was read, not re-escaped. The reader
        // XMLKit used before this migration appended the *decoded* characters,
        // and re-escaping them here would double-encode any entity the document
        // legitimately contained — including a markup-carrying XHTML value that
        // was escaped on the way out by the encoder.
        result += text
      case .comment,
           .processingInstruction:
        // Neither contributes to character data, and the reader dropped both.
        break
      }
    }
    return result
  }

  // MARK: Children

  /// The child elements carrying `name`, in document order.
  func xmlKitChildren(named name: String) -> [XMLKitCore.XMLElement] {
    childElements.filter { $0.qualifiedName == name }
  }

  /// Whether the element has a child element carrying `name`.
  ///
  /// Separate from ``xmlKitChildren(named:)`` because a key lookup asks this
  /// question far more often than it needs the matches, and answering it must
  /// not build an array.
  func xmlKitHasChild(named name: String) -> Bool {
    for child in childElements where child.qualifiedName == name {
      return true
    }
    return false
  }

  /// The first child element carrying `name`, preferring one that has text.
  ///
  /// XML allows an element to repeat at the same level, and the repetitions do
  /// not have to be alike: an element may carry only attributes where a sibling
  /// of the same name carries the value, as in `<link rel="self" href="…"/>`
  /// followed by `<link>https://example.com/</link>`. Returning the first match
  /// would hand back the attribute-only element for a key that is asked to
  /// resolve to a value, so a child with text wins.
  ///
  /// - Parameter cache: Per-decode cache, forwarded to ``xmlKitText(cache:)``.
  func xmlKitChild(named name: String, cache: XMLDecodeCache) -> XMLKitCore.XMLElement? {
    var first: XMLKitCore.XMLElement?
    for child in childElements where child.qualifiedName == name {
      if first == nil {
        first = child
      }
      if child.xmlKitText(cache: cache)?.isEmpty == false {
        return child
      }
    }
    return first
  }

  // MARK: Attributes

  /// The element's attributes plus its namespace declarations, trimmed.
  ///
  /// Namespace declarations are included because the parser that backed XMLKit
  /// before this migration reported them as ordinary attributes, and types that
  /// decode them — XMLKit's own sample fixtures among them — must keep working.
  /// The names are the ones written in the document: `xmlns` and `xmlns:prefix`.
  var xmlKitAttributes: [(name: String, value: String)] {
    var entries = attributes.map {
      (name: $0.name, value: $0.value.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    for declaration in namespaceDeclarations {
      entries.append((
        name: declaration.prefix.map { "xmlns:\($0)" } ?? "xmlns",
        value: declaration.uri
      ))
    }
    return entries
  }

  /// The value of an attribute, trimmed, or `nil` when the element has none.
  ///
  /// Namespace declarations are attributes under the name they are written with,
  /// which is why they are consulted here; see ``xmlKitAttributes``.
  func xmlKitAttribute(named name: String) -> String? {
    for entry in attributes where entry.name == name {
      return entry.value.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    for declaration in namespaceDeclarations {
      let declaredName = declaration.prefix.map { "xmlns:\($0)" } ?? "xmlns"
      if declaredName == name {
        return declaration.uri
      }
    }
    return nil
  }

  /// Whether the element has any attribute or namespace declaration.
  var xmlKitHasAttributes: Bool {
    !attributes.isEmpty || !namespaceDeclarations.isEmpty
  }
}

// MARK: - Structural comparison

extension XMLKitCore.XMLElement {
  /// Whether two elements are the same tree with the same names, attributes,
  /// namespace declarations and children.
  ///
  /// The engine's elements are reference types with no value equality, so
  /// `XMLDocument`'s `Equatable` and `Hashable` conformances are built on this.
  func xmlKitIsStructurallyEqual(to other: XMLKitCore.XMLElement) -> Bool {
    guard qualifiedName == other.qualifiedName else {
      return false
    }
    guard attributes.elementsEqual(other.attributes, by: { $0.name == $1.name && $0.value == $1.value }) else {
      return false
    }
    guard namespaceDeclarations.count == other.namespaceDeclarations.count else {
      return false
    }
    for (lhs, rhs) in zip(namespaceDeclarations, other.namespaceDeclarations) {
      guard lhs.prefix == rhs.prefix, lhs.uri == rhs.uri else {
        return false
      }
    }
    guard children.count == other.children.count else {
      return false
    }
    for (lhs, rhs) in zip(children, other.children) {
      guard xmlKitIsStructurallyEqual(lhs, rhs) else {
        return false
      }
    }
    return true
  }

  private func xmlKitIsStructurallyEqual(_ lhs: XMLKitCore.XMLNode, _ rhs: XMLKitCore.XMLNode) -> Bool {
    switch (lhs, rhs) {
    case let (.element(lhs), .element(rhs)):
      lhs.xmlKitIsStructurallyEqual(to: rhs)
    case let (.text(lhs), .text(rhs)):
      lhs == rhs
    case let (.cdata(lhs), .cdata(rhs)):
      lhs == rhs
    case let (.comment(lhs), .comment(rhs)):
      lhs == rhs
    case let (.processingInstruction(lhsTarget, lhsData), .processingInstruction(rhsTarget, rhsData)):
      lhsTarget == rhsTarget && lhsData == rhsData
    default:
      false
    }
  }

  /// Hashes the same tree that ``xmlKitIsStructurallyEqual(to:)`` compares.
  func xmlKitHash(into hasher: inout Hasher) {
    hasher.combine(qualifiedName)
    for attribute in attributes {
      hasher.combine(attribute.name)
      hasher.combine(attribute.value)
    }
    for declaration in namespaceDeclarations {
      hasher.combine(declaration.prefix)
      hasher.combine(declaration.uri)
    }
    for child in children {
      child.xmlKitHash(into: &hasher)
    }
  }
}

private extension XMLKitCore.XMLNode {
  /// Hashes a node, mirroring ``XMLKitCore/XMLElement/xmlKitIsStructurallyEqual(to:)``.
  func xmlKitHash(into hasher: inout Hasher) {
    switch self {
    case let .element(element):
      hasher.combine(0)
      element.xmlKitHash(into: &hasher)

    case let .text(text):
      hasher.combine(1)
      hasher.combine(text)

    case let .cdata(text):
      hasher.combine(2)
      hasher.combine(text)

    case let .comment(text):
      hasher.combine(3)
      hasher.combine(text)

    case let .processingInstruction(target, data):
      hasher.combine(4)
      hasher.combine(target)
      hasher.combine(data)
    }
  }
}

// MARK: - Cache

/// State shared by every container of one decode.
///
/// Only the XHTML markup path needs it: serialising a subtree is the one
/// accessor here whose cost is proportional to the size of the element rather
/// than to a value already in hand, and a decode asks for the same element's text
/// more than once (`contains` followed by `decode`, and once per key for a type
/// that has several).
final class XMLDecodeCache {
  // MARK: Internal

  /// The text already computed for `element`, or `nil` when it has not been.
  ///
  /// - Returns: A double optional: the outer one means "not computed yet", the
  ///   inner one is the element's text, which may itself be `nil`.
  func text(for element: XMLKitCore.XMLElement) -> String?? {
    textByElement[ObjectIdentifier(element)]
  }

  func setText(_ text: String?, for element: XMLKitCore.XMLElement) {
    textByElement[ObjectIdentifier(element)] = text
  }

  // MARK: Private

  private var textByElement: [ObjectIdentifier: String?] = [:]
}
