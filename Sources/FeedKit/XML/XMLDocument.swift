//
//  XMLDocument.swift
//
//  Copyright (c) 2016 - 2024 Nuno Dias
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

/// Represents an XML document containing a root node.
class XMLDocument: Equatable, Hashable {
  /// The root node of the document.
  var root: XMLNode?

  /// Initializes a new document with an optional root node.
  /// - Parameter root: The root node of the document.
  init(root: XMLNode?) {
    self.root = root
  }

  // MARK: Equatable

  static func == (lhs: XMLDocument, rhs: XMLDocument) -> Bool {
    lhs.root == rhs.root
  }

  // MARK: Hashable

  func hash(into hasher: inout Hasher) {
    hasher.combine(root)
  }
}

/// Represents an node in the XML document.
class XMLNode: Codable, Equatable, Hashable {
  /// The parent node of this node.
  weak var parent: XMLNode?
  /// Namespace prefix-to-URI mappings.
  var namespacePrefixes: [String: String] = [:]
  /// The namespace URI
  var namespaceURI: String?
  /// The namespace prefix
  var prefix: String?
  /// The name of the node.
  var name: String
  /// The text of the node, if present.
  var text: String?
  /// Is the `text` property xhtml
  var isXhtml: Bool = false
  /// The child nodes of this node.
  var children: [XMLNode]? {
    didSet {
      // Update the parent reference for all children
      children?.forEach { $0.parent = self }
    }
  }

  /// Initializes a new node.
  /// - Parameters:
  ///   - name: The name of the node.
  ///   - text: The text of the node, if any.
  ///   - attributes: Attributes for the node, if any.
  ///   - children: Children for the node, if any.
  init(
    namespacePrefixes: [String: String] = [:],
    namespaceURI: String? = nil,
    prefix: String? = nil,
    name: String,
    text: String? = nil,
    isXhtml: Bool = false,
    attributes: [String: String]? = nil,
    children: [XMLNode]? = nil) {
    self.namespacePrefixes = namespacePrefixes
    self.namespaceURI = namespaceURI
    self.prefix = prefix
    self.name = name
    self.text = text
    self.isXhtml = isXhtml
    self.children = children
    // Set parent for each child
    self.children?.forEach { $0.parent = self }
  }

  // MARK: Equatable

  static func == (lhs: XMLNode, rhs: XMLNode) -> Bool {
    if
      lhs.namespaceURI != rhs.namespaceURI ||
      lhs.prefix != rhs.prefix ||
      lhs.name != rhs.name ||
      lhs.text != rhs.text ||
      lhs.isXhtml != rhs.isXhtml {
      return false
    }

    let lhsChildren = lhs.children ?? []
    let rhsChildren = rhs.children ?? []
    if lhsChildren.count != rhsChildren.count {
      return false
    }

    // Compare child nodes pairwise by their properties
    // We avoid direct comparison of children to prevent recursion
    // caused by the parent property, which creates circular references
    for (lChild, rChild) in zip(lhsChildren, rhsChildren) {
      if
        lChild.namespaceURI != rChild.namespaceURI ||
        lChild.prefix != rChild.prefix ||
        lChild.name != rChild.name ||
        lChild.text != rChild.text ||
        lChild.isXhtml != rChild.isXhtml {
        return false
      }
    }

    return true
  }

  // MARK: Hashable

  func hash(into hasher: inout Hasher) {
    // Hash basic properties
    hasher.combine(name)
    hasher.combine(text)
    hasher.combine(isXhtml)

    // Recursively hash the children
    if let children = children {
      hasher.combine(children.map { $0.hashValue })
    }
  }

  func child(for name: String) -> XMLNode? {
    children?.first(where: { $0.name == name })
  }

  func hasChild(for name: String) -> Bool {
    children?.first(where: { $0.name == name }) != nil
  }
}

// MARK: - XMLStringConvertible

protocol XMLStringConvertible {
  func toXMLString(formatted: Bool, indentationLevel: Int) -> String
}

// MARK: - XMLDocument + XMLStringConvertible

extension XMLDocument: XMLStringConvertible {
  /// Generates an XML string representation of the document.
  /// - Parameter formatted: Whether to generate formatted XML (default is
  ///   false for compact XML).
  /// - Returns: A string representation of the XML.
  func toXMLString(
    formatted: Bool = false,
    indentationLevel: Int = 1) -> String {
    guard let root = root else { return "" }

    // XML header
    let header = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"

    // Generate the XML body with or without formatting
    let body = root.toXMLString(formatted: formatted, indentationLevel: 0)

    // Combine header and body
    return "\(header)\(formatted ? "\n" : "")\(body)"
  }
}

// MARK: - XMLNode + XMLStringConvertible

extension XMLNode: XMLStringConvertible {
  /// Generates an XML string representation of the node and its children.
  /// - Parameter formatted: Whether to generate formatted XML (default is
  ///   false for compact XML).
  /// - Parameter indentationLevel: The current level of indentation.
  /// - Returns: A string representation of the XML for the node.
  func toXMLString(
    formatted: Bool = false,
    indentationLevel: Int = 1) -> String {
    let indent = formatted ? String(repeating: "  ", count: indentationLevel) : ""

    // Skip processing nodes with the name "@attributes".
    if name == "@attributes" {
      return ""
    }
    var xml = ""

    if let prefix {
      xml += "\(indent)<\(prefix):\(name)"
    } else {
      xml += "\(indent)<\(name)"
    }

    xml += namespaceDeclarationsToString()

    xml += attributesToString()

    // Process child nodes, excluding "@attributes"
    if let children = children?.filter({ $0.name != "@attributes" }), !children.isEmpty {
      // Close the opening tag and add child nodes recursively.
      xml += ">\(formatted ? "\n" : "")"

      // Append children recursively, with increased
      // indentation level if formatted is true
      for child in children {
        // Process children of a "@namespace" node, if present.
        if child.name.split(separator: ":").first == "xmlns" {
          for namespaceNode in child.children?.filter({ $0.name != "@attributes" }) ?? [] {
            xml += namespaceNode.toXMLString(
              formatted: formatted,
              indentationLevel: indentationLevel + 1
            )
          }
        } else {
          xml += child.toXMLString(
            formatted: formatted,
            indentationLevel: indentationLevel + 1
          )
        }
      }

      // Add closing tag with indentation if formatted is true
      xml += "\(formatted ? indent : "")</\(name)>\(formatted ? "\n" : "")"
    } else if let text {
      // Element has text, close opening tag and add text
      if let prefix {
        xml += ">\(text)</\(prefix):\(name)>\(formatted ? "\n" : "")"
      } else {
        xml += ">\(text)</\(name)>\(formatted ? "\n" : "")"
      }

    } else {
      // Self-closing tag for an empty node
      xml += " />\(formatted ? "\n" : "")"
    }

    return xml
  }
}

// MARK: - XMLNode + XMLStringConvertible Helpers

extension XMLNode {
  /// Converts namespace declarations into a string representation.
  /// - Returns: A formatted string of namespace declarations, or an empty string.
  private func namespaceDeclarationsToString() -> String {
    // Generate a string for namespace declarations in the format:
    // - Default namespace: xmlns="URI"
    // - Prefixed namespace: xmlns:prefix="URI"
    let namespaceDeclarations = namespacePrefixes.map { prefix, uri in
      prefix.isEmpty
        ? "xmlns=\"\(uri)\""
        : "xmlns:\(prefix)=\"\(uri)\""
    }.joined(separator: " ")

    // Return the namespace declarations, prefixed with a space if not empty.
    return namespaceDeclarations.isEmpty ? "" : " \(namespaceDeclarations)"
  }

  /// Converts attributes of the node into a string representation.
  /// - Returns: A formatted string of attributes, or an empty string if none exist.
  private func attributesToString() -> String {
    var result = ""

    // Find a child node named "@attributes" that contains the attributes.
    if let attributesNode = children?.first(where: { $0.name == "@attributes" }) {
      // Append each attribute in the format: name="value".
      for attribute in attributesNode.children ?? [] {
        result += " \(attribute.name)=\"\(attribute.text ?? "")\""
      }
    }
    return result
  }
}
