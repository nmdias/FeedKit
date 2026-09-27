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

// MARK: - Declaration helper

/// A namespace declaration as written on an element.
public struct XMLNamespaceDeclaration: Sendable, Hashable {
  // MARK: Lifecycle

  /// Creates a declaration.
  public init(prefix: String? = nil, uri: String) {
    self.prefix = prefix
    self.uri = uri
  }

  // MARK: Public

  /// The prefix being declared, or `nil` for the default namespace.
  public var prefix: String?

  /// The namespace URI. The empty string un-declares the default namespace.
  public var uri: String
}

// MARK: - Node

/// A node in an XML document's tree.
///
/// Comments, processing instructions, CDATA and mixed content have no `Codable`
/// representation at all — `Codable` has no vocabulary for them. Rather than
/// invent a convention that would silently change a document's meaning, XMLKit
/// exposes them here, in a document model that is deliberately *not* shaped like
/// `Codable`. This is the "where a deliberate Swift API is required" half of the
/// design; ``XMLDecoder`` and ``XMLEncoder`` are the other half.
public enum XMLNode: Sendable {
  /// An element.
  case element(XMLElement)
  /// Character data. Its text is already unescaped.
  case text(String)
  /// A CDATA section. Retained as a distinct node so that serialising a parsed
  /// document reproduces the original lexical form.
  case cdata(String)
  /// A comment. Its text excludes the `<!--` and `-->` delimiters.
  case comment(String)
  /// A processing instruction. `data` excludes the target and the delimiters.
  case processingInstruction(target: String, data: String)

  // MARK: Public

  /// The element, if this node is one.
  public var element: XMLElement? {
    if case let .element(element) = self {
      return element
    }
    return nil
  }

  /// This node's text, for the node kinds that carry text.
  public var textValue: String? {
    switch self {
    case let .text(text): text
    case let .cdata(text): text
    default: nil
    }
  }
}

// MARK: - Element

/// An XML element.
///
/// Reference semantics are deliberate: an element is a mutable position in a
/// tree, and `XMLDocument`/`XMLElement` must behave like the DOMs developers
/// already know. Every node is a distinct object, so two lookups of the same
/// path return the same element and mutation through either is visible — which
/// is what makes building a document with loops and helper functions work.
///
/// - Note: `XMLElement` is `@unchecked Sendable` because it is a mutable
///   reference type. Concurrent mutation of a single tree is the caller's
///   responsibility, exactly as with a mutable array. Separate trees are
///   independent and safe to use from different tasks.
public final class XMLElement: @unchecked Sendable {
  // MARK: Lifecycle

  /// Creates an element.
  public init(name: String) {
    qualifiedName = name
  }

  /// Creates an element with text content.
  public convenience init(name: String, text: String) {
    self.init(name: name)
    if !text.isEmpty {
      children = [.text(text)]
    }
  }

  // MARK: Public

  /// The element's parent, or `nil` for a root.
  public private(set) weak var parent: XMLElement?

  /// The element's child nodes, in document order.
  public private(set) var children: [XMLNode] = []

  /// The element's attributes, in insertion order.
  ///
  /// Stored as ordered pairs rather than a dictionary because XML attribute
  /// order is preserved by round-tripping tools, and because a document with a
  /// handful of attributes is faster to scan linearly than to hash.
  public private(set) var attributes: [(name: String, value: String)] = []

  /// Namespace declarations written on this element.
  public private(set) var namespaceDeclarations: [XMLNamespaceDeclaration] = []

  /// The element's name, as written: possibly prefixed, possibly not.
  public var qualifiedName: String {
    didSet { invalidateDocumentIndex() }
  }

  /// The element's text content: the concatenation of its direct text and
  /// CDATA children.
  ///
  /// Setting it replaces all text and CDATA children with a single text node,
  /// leaving element, comment and processing-instruction children in place.
  /// This mirrors the DOM `textContent` accessor, which is what developers
  /// expect, and it is the only sane behaviour for mixed content.
  public var text: String {
    get {
      // Text and CDATA both contribute: XML defines an element's character
      // data as the concatenation of its text nodes, and whether a run was
      // written escaped or as a CDATA section is a lexical choice with no
      // bearing on the value.
      var result = ""
      for child in children {
        switch child {
        case let .cdata(value),
             let .text(value):
          result += value
        default:
          break
        }
      }
      return result
    }
    set {
      var rebuilt: [XMLNode] = []
      var inserted = false
      for child in children {
        switch child {
        case .cdata,
             .text:
          if !inserted {
            rebuilt.append(.text(newValue))
            inserted = true
          }

        default:
          rebuilt.append(child)
        }
      }
      if !inserted, !newValue.isEmpty || children.isEmpty {
        rebuilt.append(.text(newValue))
      }
      children = rebuilt
      invalidateDocumentIndex()
    }
  }

  /// The element's name split into prefix and local part.
  public var name: XMLQualifiedName {
    (try? XMLQualifiedName(XMLName(validating: qualifiedName))) ?? XMLQualifiedName(unchecked: qualifiedName)
  }

  /// The element's local name, with any prefix removed.
  public var localName: String {
    if let colon = qualifiedName.firstIndex(of: ":") {
      return String(qualifiedName[qualifiedName.index(after: colon)...])
    }
    return qualifiedName
  }

  /// The element's prefix, or `nil`.
  public var prefix: String? {
    guard let colon = qualifiedName.firstIndex(of: ":") else {
      return nil
    }
    return String(qualifiedName[qualifiedName.startIndex ..< colon])
  }

  /// Every child element.
  public var childElements: [XMLElement] {
    children.compactMap(\.element)
  }

  /// Every direct child text and CDATA node's text, in order.
  public var textNodes: [String] {
    children.compactMap(\.textValue)
  }

  // MARK: Children

  /// Appends `node` as the last child.
  public func appendChild(_ node: XMLNode) {
    attach(node)
    children.append(node)
    invalidateDocumentIndex()
  }

  /// Appends `element` as the last child.
  public func appendChild(_ element: XMLElement) {
    appendChild(.element(element))
  }

  /// Inserts `node` at `index`.
  ///
  /// - Precondition: `index` must be a valid insertion point.
  public func insertChild(_ node: XMLNode, at index: Int) {
    precondition(index >= 0 && index <= children.count, "child index out of range")
    attach(node)
    children.insert(node, at: index)
    invalidateDocumentIndex()
  }

  /// Inserts `element` at `index`.
  public func insertChild(_ element: XMLElement, at index: Int) {
    insertChild(.element(element), at: index)
  }

  /// Removes the child at `index` and returns it.
  @discardableResult
  public func removeChild(at index: Int) -> XMLNode {
    precondition(index >= 0 && index < children.count, "child index out of range")
    let node = children.remove(at: index)
    detach(node)
    invalidateDocumentIndex()
    return node
  }

  /// Removes every child.
  public func removeAllChildren() {
    for child in children {
      detach(child)
    }
    children.removeAll(keepingCapacity: false)
    invalidateDocumentIndex()
  }

  /// Replaces every child.
  public func setChildren(_ nodes: [XMLNode]) {
    for child in children {
      detach(child)
    }
    children = nodes
    for child in nodes {
      attach(child)
    }
    invalidateDocumentIndex()
  }

  // MARK: Lookup

  /// The first child element with the given qualified name, or `nil`.
  ///
  /// Matching is on the *qualified* name as written. Namespace-aware lookup is
  /// a separate concern; see ``elements(namespaceURI:localName:)``.
  public func firstChild(named name: String) -> XMLElement? {
    guard let positions = ensureChildIndex()[name], let first = positions.first else {
      return nil
    }
    return children[first].element
  }

  /// Every child element with the given qualified name, in document order.
  public func children(named name: String) -> [XMLElement] {
    guard let positions = ensureChildIndex()[name] else {
      return []
    }
    return positions.compactMap { children[$0].element }
  }

  /// The markup of this element's children, serialised in document order.
  ///
  /// The counterpart of ``XMLDecoder``'s `#markup` key, for the constructs
  /// `Codable` cannot express as values — Atom's `type="xhtml"` content, for
  /// instance, whose children *are* the value.
  public func innerMarkup(configuration: XMLWriterConfiguration = .default) -> String {
    XMLWriter(configuration: configuration).innerMarkup(for: self)
  }

  /// All descendants matching `name`, in document order, excluding self.
  ///
  /// Iterative rather than recursive, so a deep tree cannot overflow the stack.
  public func descendants(named name: String) -> [XMLElement] {
    var result: [XMLElement] = []
    var stack: [XMLElement] = children.compactMap(\.element).reversed()
    while let element = stack.popLast() {
      if element.qualifiedName == name {
        result.append(element)
      }
      for child in element.children.reversed() {
        if case let .element(nested) = child {
          stack.append(nested)
        }
      }
    }
    return result
  }

  /// The first descendant matching `name`, in document order.
  public func firstDescendant(named name: String) -> XMLElement? {
    var stack: [XMLElement] = children.compactMap(\.element).reversed()
    while let element = stack.popLast() {
      if element.qualifiedName == name {
        return element
      }
      for child in element.children.reversed() {
        if case let .element(nested) = child {
          stack.append(nested)
        }
      }
    }
    return nil
  }

  // MARK: Attributes

  /// The value of an attribute, or `nil`.
  public func attribute(_ name: String) -> String? {
    for entry in attributes where entry.name == name {
      return entry.value
    }
    return nil
  }

  /// Sets an attribute, replacing an existing one with the same name.
  public func setAttribute(_ name: String, value: String) {
    for index in attributes.indices where attributes[index].name == name {
      attributes[index].value = value
      return
    }
    attributes.append((name: name, value: value))
  }

  /// Removes an attribute, returning its value.
  @discardableResult
  public func removeAttribute(_ name: String) -> String? {
    for index in attributes.indices where attributes[index].name == name {
      return attributes.remove(at: index).value
    }
    return nil
  }

  // MARK: Namespaces

  /// Adds a namespace declaration to this element.
  public func declareNamespace(prefix: String? = nil, uri: String) {
    for index in namespaceDeclarations.indices
      where namespaceDeclarations[index].prefix == prefix
    {
      namespaceDeclarations[index].uri = uri
      return
    }
    namespaceDeclarations.append(XMLNamespaceDeclaration(prefix: prefix, uri: uri))
  }

  /// Looks up a prefix in this element's scope, walking outward.
  ///
  /// Returns the URI, or `nil` when the prefix is not declared. An unprefixed
  /// name resolves against the default namespace, which this method reports for
  /// a `nil` prefix.
  public func resolveNamespacePrefix(_ prefix: String?) -> String? {
    var element: XMLElement? = self
    while let current = element {
      for declaration in current.namespaceDeclarations where declaration.prefix == prefix {
        return declaration.uri
      }
      element = current.parent
    }
    // `xml` is predeclared.
    if prefix == "xml" {
      return "http://www.w3.org/XML/1998/namespace"
    }
    return nil
  }

  /// Direct child elements in the given namespace with the given local name.
  public func children(namespaceURI: String, localName: String) -> [XMLElement] {
    var result: [XMLElement] = []
    for child in childElements {
      guard child.localName == localName else {
        continue
      }
      let uri = child.prefix.flatMap { child.resolveNamespacePrefix($0) }
        ?? child.resolveNamespacePrefix(nil)
        ?? ""
      if uri == namespaceURI {
        result.append(child)
      }
    }
    return result
  }

  // MARK: Internal

  /// Token storage attached to a fragment's top-level elements.
  ///
  /// A fragment has no `XMLDocument` to own its tokens, so the first element
  /// carries them. Internal, and only ever set by `parseFragment`.
  var unusedFragmentTokens: XMLTokenizedDocument?

  /// The token index this element was parsed from, when it came from a
  /// document.
  ///
  /// Used as a cache key by ``XMLDecoder``. `nil` for elements built by hand,
  /// which is what makes the cache correct as well as fast: a synthetic element
  /// has no stable position and is never cached.
  var documentPosition: Int?

  /// Replaces the attribute list wholesale.
  ///
  /// Internal because the parser is the only caller that needs to set many
  /// attributes at once, and going through ``setAttribute(_:value:)`` for each
  /// would be quadratic in the attribute count.
  func setAttributes(_ newAttributes: [(name: String, value: String)]) {
    attributes = newAttributes
  }

  // MARK: Private

  // MARK: Indexing

  /// A cache of child-name lookups, invalidated on mutation.
  ///
  /// `firstChild(named:)` is the DOM's hot operation: a hand-written traversal
  /// calls it once per level. Without a cache, a wide element makes every lookup
  /// a linear scan. The cache is built on first use, so a document that is only
  /// traversed once never pays for it.
  private var childIndex: [String: [Int]]?

  private func invalidateDocumentIndex() {
    childIndex = nil
    // An ancestor's index is unaffected by a descendant's name change, so no
    // propagation is needed.
  }

  private func ensureChildIndex() -> [String: [Int]] {
    if let childIndex {
      return childIndex
    }
    var index: [String: [Int]] = [:]
    index.reserveCapacity(children.count)
    for (position, child) in children.enumerated() {
      guard case let .element(element) = child else {
        continue
      }
      index[element.qualifiedName, default: []].append(position)
    }
    childIndex = index
    return index
  }

  private func attach(_ node: XMLNode) {
    if case let .element(element) = node {
      element.parent = self
    }
  }

  private func detach(_ node: XMLNode) {
    if case let .element(element) = node, element.parent === self {
      element.parent = nil
    }
  }
}

extension XMLElement: CustomStringConvertible {
  public var description: String {
    XMLWriter().string(for: self)
  }
}

// MARK: - Document

/// A parsed XML document.
///
/// This is the full-fidelity counterpart to ``XMLDecoder``. It retains
/// everything `Codable` cannot express — comments, processing instructions,
/// CDATA sections, namespace prefixes, mixed content, attribute order, and
/// whether an empty element was written `<a/>` or `<a></a>` — and it can
/// serialise a document back to bytes that differ from the input only where the
/// caller changed something.
///
/// Use it when the document *is* the data, or when conformance to an external
/// schema matters. Use ``XMLDecoder`` when a Swift type *describes* the data.
public struct XMLDocument: Sendable {
  // MARK: Lifecycle

  /// Creates a document from a root element.
  public init(
    root: XMLElement,
    declaration: XMLDeclaration? = nil,
    prolog: [XMLNode] = [],
    epilog: [XMLNode] = [],
    documentType: String? = nil
  ) {
    self.root = root
    self.declaration = declaration
    self.prolog = prolog
    self.epilog = epilog
    self.documentType = documentType
    tokenizedDocument = .empty
  }

  /// Creates a document from a root element, retaining the token array it was
  /// built from so that ``tokens`` can be produced without re-parsing.
  ///
  /// Internal because the token array is an implementation detail; the public
  /// initialiser above is what callers use for hand-built documents.
  init(
    root: XMLElement,
    declaration: XMLDeclaration?,
    prolog: [XMLNode],
    epilog: [XMLNode],
    documentType: String?,
    tokenizedDocument: XMLTokenizedDocument
  ) {
    self.root = root
    self.declaration = declaration
    self.prolog = prolog
    self.epilog = epilog
    self.documentType = documentType
    self.tokenizedDocument = tokenizedDocument
  }

  /// Creates a document with a single root element of the given name.
  public init(rootName: String, declaration: XMLDeclaration? = nil) {
    self.init(root: XMLElement(name: rootName), declaration: declaration)
  }

  // MARK: Parsing

  /// Parses `string` as an XML document.
  public init(
    xml string: String,
    configuration: XMLParserConfiguration = .default
  ) throws {
    try self.init(bytes: Array(string.utf8), configuration: configuration)
  }

  /// Parses `data` as an XML document.
  public init(
    data: Data,
    configuration: XMLParserConfiguration = .default
  ) throws {
    try self.init(bytes: [UInt8](data), configuration: configuration)
  }

  /// Parses UTF-8 `bytes` as an XML document.
  ///
  /// - Throws: ``XMLParserError`` when the document is not well-formed.
  public init(
    bytes: [UInt8],
    configuration: XMLParserConfiguration = .default
  ) throws {
    let tokenized = try XMLTokenizer.tokenize(bytes: bytes, configuration: configuration)
    var builder: DOMBuilder = .init(document: tokenized, configuration: configuration)
    self = try builder.build()
  }

  // MARK: Public

  /// The document element.
  ///
  /// Built during parsing rather than on demand. A lazy accessor would have to
  /// be a `mutating` getter, which would force every caller to hold the document
  /// as a `var` and would make `let document = try XMLDocument(…)` — the natural
  /// way to write it — a compile error. That is too high a price for deferring
  /// work that a caller who parses a document almost always wants.
  ///
  /// ``tokens`` is available alongside it for the lexical view; it is not a
  /// substitute for skipping the tree.
  public var root: XMLElement

  /// Nodes before the root element: the XML declaration, comments,
  /// processing instructions and the DOCTYPE.
  public var prolog: [XMLNode]

  /// Nodes after the root element: comments and processing instructions.
  public var epilog: [XMLNode]

  /// The XML declaration, when the document had one.
  public var declaration: XMLDeclaration?

  /// The DOCTYPE declaration's raw text, when the document had one.
  ///
  /// Retained verbatim and never interpreted: XMLKit does not process DTD
  /// internal subsets, which is what makes entity-expansion attacks
  /// structurally impossible. Preserving the declaration lets a parse/serialise
  /// round-trip keep it for consumers that need it.
  public var documentType: String?

  // MARK: Access

  /// Every element in the document, in document order.
  public var allElements: [XMLElement] {
    var result: [XMLElement] = []
    var stack: [XMLElement] = [root]
    while let element = stack.popLast() {
      result.append(element)
      for child in element.children.reversed() {
        if case let .element(nested) = child {
          stack.append(nested)
        }
      }
    }
    return result
  }

  /// The document's lexical tokens, in document order.
  ///
  /// This is the escape hatch for the constructs a tree cannot express
  /// directly — exactly where each CDATA section begins and ends, which empty
  /// elements were written self-closing, and the source position of every
  /// construct. It is computed on first access and the result is not cached, so
  /// a caller who wants it twice should hold on to it.
  public var tokens: XMLTokenSequence {
    XMLTokenSequence(buildingFrom: tokenizedDocument)
  }

  /// The number of lexical tokens in the document.
  ///
  /// Cheap, because the tokenizer has already counted them; useful for
  /// diagnostics and for asserting that a document is the size you expect.
  public var tokenCount: Int {
    tokenizedDocument.tokens.count
  }

  /// Parses a *fragment*: content that may contain several top-level elements
  /// and need not have a single root.
  ///
  /// Used when a document's root element is not fixed, which is the read-side
  /// counterpart of ``XMLEncoder/rootElementName``.
  public static func parseFragment(
    bytes: [UInt8],
    configuration: XMLParserConfiguration = .default
  ) throws -> [XMLElement] {
    let tokenized = try XMLTokenizer.tokenize(
      bytes: bytes,
      configuration: configuration,
      allowsMultipleRoots: true
    )
    var builder: DOMBuilder = .init(document: tokenized, configuration: configuration)
    let elements = try builder.buildFragment()
    for element in elements {
      // A fragment's elements need a token view of their own; the first
      // element's document carries the whole fragment's tokens.
      element.unusedFragmentTokens = tokenized
    }
    return elements
  }

  /// Parses a fragment from a string.
  public static func parseFragment(
    xml string: String,
    configuration: XMLParserConfiguration = .default
  ) throws -> [XMLElement] {
    try parseFragment(bytes: Array(string.utf8), configuration: configuration)
  }

  // MARK: Serialisation

  /// Serialises the document to UTF-8 bytes.
  public func serialized(configuration: XMLWriterConfiguration = .default) -> [UInt8] {
    // A document built by the parser always has a declaration slot when the
    // source had one; preferring the explicit configuration lets a caller
    // change or suppress it.
    var effective = configuration
    if effective.xmlDeclaration == nil {
      effective.xmlDeclaration = declaration
    }
    return XMLWriter(configuration: effective).bytes(for: self)
  }

  /// Serialises the document to a `String`.
  ///
  /// Output is always valid UTF-8, because every value that could reach it was
  /// validated on the way in.
  public func serializedString(configuration: XMLWriterConfiguration = .default) -> String {
    String(decoding: serialized(configuration: configuration), as: UTF8.self)
  }

  /// Serialises the document to `Data`.
  public func serializedData(configuration: XMLWriterConfiguration = .default) -> Data {
    Data(serialized(configuration: configuration))
  }

  /// Elements whose qualified name matches, anywhere in the document.
  public func elements(named name: String) -> [XMLElement] {
    var result: [XMLElement] = []
    var stack: [XMLElement] = [root]
    while let element = stack.popLast() {
      if element.qualifiedName == name {
        result.append(element)
      }
      for child in element.children.reversed() {
        if case let .element(nested) = child {
          stack.append(nested)
        }
      }
    }
    return result
  }

  // MARK: Internal

  /// The internal token array the document was parsed from.
  ///
  /// Retained so that ``tokens`` and ``root`` can be produced on demand without
  /// re-parsing, and so that asking only for tokens never pays for a tree.
  /// Not public: the token layer is an implementation detail that the DOM
  /// deliberately hides, so that the tokenizer can be replaced without a
  /// breaking change.
  var tokenizedDocument: XMLTokenizedDocument = .empty
}

extension XMLDocument: CustomStringConvertible {
  public var description: String {
    serializedString()
  }
}
