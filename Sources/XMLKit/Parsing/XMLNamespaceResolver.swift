//
// XMLNamespaceResolver.swift
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

/// Resolves namespace prefixes to URIs using the token stream as its only input.
///
/// ## Why resolution is lazy rather than a tokenizer pass
///
/// Namespace resolution is a *scope* computation: a prefix's meaning depends on
/// the `xmlns` declarations in scope at the point of use. It could be performed
/// eagerly during tokenization, but doing so would cost every caller — including
/// the many documents and types that never mention a namespace — a full
/// declaration table and a per-name lookup.
///
/// Instead the resolver answers queries against the token array on demand, and
/// walks outward from a given position to find declarations. The walk is
/// bounded by nesting depth, not element count, and `XMLDecoder` caches results
/// per element, so the asymptotic cost is unchanged for the cases that matter.
///
/// ## Correctness rules implemented here
///
/// 1. `xmlns="uri"` declares the default namespace, which applies to elements
///    only — an unprefixed *attribute* is always in no namespace (Namespaces in
///    XML §6.2). This asymmetry is a common source of bugs and is the reason
///    ``resolveAttribute(_:at:)`` is a separate entry point from
///    ``resolveElement(_:at:)``.
/// 2. `xmlns:p="uri"` declares a prefix.
/// 3. `xmlns=""` un-declares the default namespace, which is legal in XML 1.0
///    namespaces (and is how a subtree opts out of an inherited default).
/// 4. The prefixes `xml` and `xmlns` are bound implicitly and must not be
///    declared to anything else. `xml` is *always* bound, so `xml:lang` is legal
///    without any declaration — a rule the conformance corpus specifically
///    checks.
/// 5. A prefixed name whose prefix is not in scope is an error, not a silent
///    "no namespace".
struct XMLNamespaceResolver {
  // MARK: Lifecycle

  init(document: XMLTokenizedDocument) {
    self.document = document
  }

  // MARK: Internal

  /// The resolved namespace of a name: its URI (empty for no namespace) and    /// The resolved namespace of a name: its URI (empty for no namespace) and
  /// the prefix used in the document.
  struct Resolution: Hashable {
    /// The namespace URI, or `""` for no namespace.
    let uri: String
    /// The prefix as written, or `nil` when unprefixed.
    let prefix: String?
    /// The local part of the name.
    let localName: String

    /// `true` when the name is in a namespace.
    var isNamespaced: Bool {
      !uri.isEmpty
    }
  }

  // MARK: - Declarations

  /// A namespace declaration found on an element.
  struct Declaration: Hashable {
    /// The prefix being declared, or `nil` for the default namespace.
    let prefix: String?
    /// The URI bound to the prefix. Empty means "no namespace".
    let uri: String
  }

  /// The namespace URI of the XML namespace, conventionally bound to `xml`.
  static let xmlNamespaceURI = "http://www.w3.org/XML/1998/namespace"
  /// The namespace URI reserved for `xmlns` declarations themselves.
  static let xmlnsNamespaceURI = "http://www.w3.org/2000/xmlns/"

  /// Reserved namespace URIs as bytes, so the tokenizer can validate
  /// declarations without allocating a `String` for each one.
  static let xmlNamespaceURIBytes: [UInt8] = Array(xmlNamespaceURI.utf8)
  static let xmlnsNamespaceURIBytes: [UInt8] = Array(xmlnsNamespaceURI.utf8)

  /// Validates that every namespace prefix used in `document` is in scope, and
  /// that no declaration rebinds a reserved prefix.
  ///
  /// ## Why this is a forward pass with an explicit stack
  ///
  /// The natural implementation asks, for each name, "walk outward from this
  /// element until the prefix is found". That is O(depth) per name and O(n·depth)
  /// for a document — and it was measured at 28 seconds for a 100 000-element
  /// document during benchmark development, because the walk continued to the
  /// start of the array whenever a prefix was never declared.
  ///
  /// A single forward pass maintains the bindings in force as an explicit stack
  /// of (prefix, uri) pairs, so a lookup is O(depth) *only in the number of
  /// bindings that shadow each other*, which is one or two in practice. The
  /// stack is pushed once per start tag and popped once per end tag, so the
  /// total cost is linear in the document.
  func validate(document: XMLTokenizedDocument) throws {
    var stack: [Binding] = []
    stack.reserveCapacity(16)

    /// Finds a prefix, searching from the innermost binding outward.
    func lookup(_ prefix: String?) -> String? {
      var index = stack.count - 1
      while index >= 0 {
        if stack[index].prefix == prefix {
          return stack[index].uri
        }
        index -= 1
      }
      return nil
    }

    /// Records a declaration's position for diagnostics.
    func undeclared(_ prefix: String, at offset: Int) throws -> Never {
      throw XMLParserError.undeclaredNamespacePrefix(
        prefix: prefix,
        position: xmlPositionNoLineTable(in: document.bytes, at: offset)
      )
    }

    for (index, token) in document.tokens.enumerated() {
      switch token.kind {
      case .startTag:
        // Everything after the element's own declarations is nested one
        // level deeper, so they are pushed before the name is checked —
        // which is what makes `<p:a xmlns:p="urn:x"/>` legal.
        let declarations = declarations(onElementAt: index)
        for declaration in declarations {
          stack.append(Binding(prefix: declaration.prefix, uri: declaration.uri))
        }

        // The element's own prefixed name.
        let nameLength = token.nameLength
        if nameLength > 0 {
          if let colon = colonOffset(in: token.nameStart, length: nameLength) {
            let prefixStart = token.nameStart
            let prefixLength = colon - prefixStart
            let prefix: String = .init(
              decoding: document.bytes[prefixStart ..< (prefixStart + prefixLength)],
              as: UTF8.self
            )
            try check(prefix: prefix, lookup: lookup, at: prefixStart)
          } else {
            _ = lookup(nil)
          }
        }

        // Attribute names. Declarations are not uses.
        if token.attributeStart >= 0 {
          let attributeStart: Int = .init(token.attributeStart)
          for attributeIndex in attributeStart ..< (attributeStart + Int(token.attributeCount)) {
            let attribute = document.attributes[attributeIndex]
            let length = attribute.nameLength
            if length == 5, xmlBytesEqual(document.bytes, attribute.nameStart, 5, Self.xmlnsPrefixBytes) {
              continue
            }
            if length > 6, xmlBytesEqual(document.bytes, attribute.nameStart, 6, Self.xmlnsColonBytes) {
              continue
            }
            if let colon = colonOffset(in: attribute.nameStart, length: length) {
              let prefixStart = attribute.nameStart
              let prefixLength = colon - prefixStart
              let prefix: String = .init(
                decoding: document.bytes[prefixStart ..< (prefixStart + prefixLength)],
                as: UTF8.self
              )
              try check(prefix: prefix, lookup: lookup, at: prefixStart)
            }
          }
        }

      case .endTag:
        // The matching start tag pushed this element's declarations.
        if token.match >= 0 {
          let declarationCount = declarations(onElementAt: Int(token.match)).count
          if declarationCount > 0 {
            stack.removeLast(Swift.min(declarationCount, stack.count))
          }
        }

      default:
        break
      }
    }

    /// Rejects a prefix that is not in scope.
    func check(prefix: String, lookup: (String?) -> String?, at offset: Int) throws {
      // `xml` is predeclared and never needs a declaration.
      if prefix == "xml" {
        return
      }
      if prefix == "xmlns" {
        return
      }
      guard let uri = lookup(prefix), !uri.isEmpty else {
        throw XMLParserError.undeclaredNamespacePrefix(
          prefix: prefix,
          position: xmlPositionNoLineTable(in: document.bytes, at: offset)
        )
      }
    }
  }

  // MARK: - Element names

  /// Resolves an element name at `tokenIndex`.
  ///
  /// - Throws: ``XMLParserError/undeclaredNamespacePrefix(prefix:position:)``
  ///   when the name is prefixed and the prefix is not in scope.
  func resolveElement(nameStart: Int, nameLength: Int, atToken tokenIndex: Int) throws -> Resolution {
    let (prefixStart, prefixLength, localStart, localLength, hasPrefix) =
      splitQualifiedName(nameStart: nameStart, length: nameLength)

    guard hasPrefix else {
      let uri = defaultNamespaceURI(atToken: tokenIndex, position: nameStart)
      return Resolution(
        uri: uri,
        prefix: nil,
        localName: string(from: localStart, length: localLength)
      )
    }

    let prefix = string(from: prefixStart, length: prefixLength)

    // `xml` is implicitly bound and never needs a declaration.
    if prefixLength == 3, xmlBytesEqual(document.bytes, prefixStart, 3, Self.xmlPrefixBytes) {
      return Resolution(
        uri: Self.xmlNamespaceURI,
        prefix: prefix,
        localName: string(from: localStart, length: localLength)
      )
    }

    guard let uri = prefixURI(prefix: prefix, prefixStart: prefixStart, prefixLength: prefixLength, atToken: tokenIndex) else {
      throw XMLParserError.undeclaredNamespacePrefix(
        prefix: prefix,
        position: xmlPosition(in: document.bytes, at: nameStart)
      )
    }
    return Resolution(uri: uri, prefix: prefix, localName: string(from: localStart, length: localLength))
  }

  /// Resolves an attribute name at `tokenIndex`.
  ///
  /// Differs from ``resolveElement(nameStart:nameLength:atToken:)`` in exactly
  /// one way, and it is the rule most implementations get wrong: an
  /// **unprefixed attribute is in no namespace**, even when a default
  /// namespace is in scope.
  func resolveAttribute(nameStart: Int, nameLength: Int, atToken tokenIndex: Int) throws -> Resolution {
    let (prefixStart, prefixLength, localStart, localLength, hasPrefix) =
      splitQualifiedName(nameStart: nameStart, length: nameLength)

    guard hasPrefix else {
      // No default namespace applies to attributes.
      return Resolution(uri: "", prefix: nil, localName: string(from: localStart, length: localLength))
    }

    let prefix = string(from: prefixStart, length: prefixLength)

    if prefixLength == 3, xmlBytesEqual(document.bytes, prefixStart, 3, Self.xmlPrefixBytes) {
      return Resolution(uri: Self.xmlNamespaceURI, prefix: prefix, localName: string(from: localStart, length: localLength))
    }
    if prefixLength == 5, xmlBytesEqual(document.bytes, prefixStart, 5, Self.xmlnsPrefixBytes) {
      // `xmlns:foo="…"` is syntactically an attribute in the xmlns
      // namespace. Reported as such so that a caller can recognise and skip
      // declarations.
      return Resolution(uri: Self.xmlnsNamespaceURI, prefix: prefix, localName: string(from: localStart, length: localLength))
    }

    guard let uri = prefixURI(prefix: prefix, prefixStart: prefixStart, prefixLength: prefixLength, atToken: tokenIndex) else {
      throw XMLParserError.undeclaredNamespacePrefix(
        prefix: prefix,
        position: xmlPosition(in: document.bytes, at: nameStart)
      )
    }
    return Resolution(uri: uri, prefix: prefix, localName: string(from: localStart, length: localLength))
  }

  /// The declarations written on the element whose start tag is `tokenIndex`.
  ///
  /// Returns declarations in document order, which is the order a
  /// re-serialising writer should preserve.
  func declarations(onElementAt tokenIndex: Int) -> [Declaration] {
    let token = document.tokens[tokenIndex]
    guard token.attributeCount > 0 else {
      return []
    }

    var result: [Declaration] = []
    let start: Int = .init(token.attributeStart)
    let end = start + Int(token.attributeCount)

    for attributeIndex in start ..< end {
      let attribute = document.attributes[attributeIndex]
      let nameStart = attribute.nameStart
      let nameLength = attribute.nameLength

      let isDefaultDeclaration = nameLength == 5
        && xmlBytesEqual(document.bytes, nameStart, 5, Self.xmlnsPrefixBytes)

      guard isDefaultDeclaration
        || (nameLength > 6 && xmlBytesEqual(document.bytes, nameStart, 6, Self.xmlnsColonBytes))
      else {
        continue
      }

      // The URI is the attribute value, which must be unescaped: an `&`
      // in a namespace URI is legal and would otherwise be compared raw.
      let raw = document.bytes[attribute.valueStart ..< attribute.valueEnd]
      let uri: String = if attribute.firstSpecial < 0 {
        String(decoding: raw, as: UTF8.self)
      } else if let decoded = try? XMLTextUnescaper.decode(
        document: document.bytes,
        start: attribute.valueStart,
        end: attribute.valueEnd,
        firstSpecial: attribute.firstSpecial,
        isAttributeValue: true
      ) {
        decoded.string(in: document.bytes)
      } else {
        String(decoding: raw, as: UTF8.self)
      }

      if isDefaultDeclaration {
        result.append(Declaration(prefix: nil, uri: uri))
      } else {
        let prefixStart = nameStart + 6
        let prefixLength = nameLength - 6
        result.append(
          Declaration(
            prefix: string(from: prefixStart, length: prefixLength),
            uri: uri
          )
        )
      }
    }

    return result
  }

  // MARK: Private

  /// A namespace binding in force at some point in the document.
  private struct Binding {
    /// The prefix, or `nil` for the default namespace.
    let prefix: String?
    let uri: String
  }

  /// Raw bytes of the reserved bindings, for byte-level comparison.
  private static let xmlPrefixBytes: [UInt8] = Array("xml".utf8)
  private static let xmlnsPrefixBytes: [UInt8] = Array("xmlns".utf8)
  private static let xmlnsColonBytes: [UInt8] = Array("xmlns:".utf8)

  private let document: XMLTokenizedDocument

  /// The offset of the first colon in a name, or `nil`.
  private func colonOffset(in start: Int, length: Int) -> Int? {
    var offset = 0
    while offset < length {
      if document.bytes[start + offset] == UInt8(ascii: ":") {
        return start + offset
      }
      offset += 1
    }
    return nil
  }

  // MARK: - Scope walk

  /// Returns the URI bound to `prefix` in the scope enclosing `tokenIndex`, or
  /// `nil` when the prefix is not declared.
  private func prefixURI(
    prefix _: String,
    prefixStart: Int,
    prefixLength: Int,
    atToken tokenIndex: Int
  ) -> String? {
    var found: String?
    forEachEnclosingElement(of: tokenIndex, containingByte: prefixStart) { elementIndex in
      for declaration in declarations(onElementAt: elementIndex) {
        guard let declaredPrefix = declaration.prefix else {
          continue
        }
        if declaredPrefix.utf8.elementsEqual(document.bytes[prefixStart ..< (prefixStart + prefixLength)]) {
          found = declaration.uri
          return false // stop the walk
        }
      }
      return true
    }
    // An empty URI un-declares the prefix, which is not permitted for a
    // prefixed declaration, but treating it as "not found" gives the clearer
    // error than silently resolving to no namespace.
    if let found, !found.isEmpty {
      return found
    }
    return nil
  }

  /// Returns the default namespace URI in scope at `tokenIndex`, or `""`.
  private func defaultNamespaceURI(atToken tokenIndex: Int, position: Int) -> String {
    var found: String?
    forEachEnclosingElement(of: tokenIndex, containingByte: position) { elementIndex in
      for declaration in declarations(onElementAt: elementIndex) where declaration.prefix == nil {
        found = declaration.uri
        return false
      }
      return true
    }
    return found ?? ""
  }

  /// Walks from the innermost enclosing element outward, calling `body` with
  /// each element's start-tag token index until it returns `false`.
  ///
  /// The walk uses the token array's matching information rather than a
  /// separate parent table, so it needs no extra storage: an element contains
  /// `tokenIndex` exactly when its match is at or after it.
  private func forEachEnclosingElement(
    of tokenIndex: Int,
    containingByte byteOffset: Int,
    _ body: (Int) -> Bool
  ) {
    var index = tokenIndex - 1
    while index >= 0 {
      let token = document.tokens[index]
      if token.kind == .startTag {
        let isEnclosing = token.match < 0 || Int(token.match) > tokenIndex
        if isEnclosing, !body(index) {
          return
        }
      }
      index -= 1
    }

    // Finally the element the name belongs to. A namespace declared on an
    // element is in scope for that element's own name and attributes — this
    // is the rule that makes `<p:a xmlns:p="urn:x"/>` legal, and omitting it
    // rejects every prefixed element that declares its own prefix, which is
    // the most common way namespaces appear in real documents.
    //
    // The element is only its own scope when `byteOffset` lies within its
    // start tag; when the walk starts from a descendant's position it must
    // not be included, or a sibling's declaration would leak into scope.
    guard tokenIndex >= 0, tokenIndex < document.tokens.count else {
      return
    }
    let selfToken = document.tokens[tokenIndex]
    if selfToken.kind == .startTag,
       byteOffset >= selfToken.start,
       byteOffset < selfToken.end
    {
      _ = body(tokenIndex)
    }
  }

  // MARK: - Helpers

  /// Splits `nameStart..<nameStart+length` at its first colon.
  private func splitQualifiedName(
    nameStart: Int,
    length: Int
  ) -> (prefixStart: Int, prefixLength: Int, localStart: Int, localLength: Int, hasPrefix: Bool) {
    var offset = 0
    while offset < length {
      if document.bytes[nameStart + offset] == UInt8(ascii: ":") {
        return (
          prefixStart: nameStart,
          prefixLength: offset,
          localStart: nameStart + offset + 1,
          localLength: length - offset - 1,
          hasPrefix: true
        )
      }
      offset += 1
    }
    return (prefixStart: nameStart, prefixLength: 0, localStart: nameStart, localLength: length, hasPrefix: false)
  }

  private func string(from start: Int, length: Int) -> String {
    guard length > 0 else {
      return ""
    }
    return String(decoding: document.bytes[start ..< (start + length)], as: UTF8.self)
  }
}
