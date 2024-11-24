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

enum XMLNodeType: Equatable, Codable {
  case element
  case attribute
}

/// Represents an XML document containing a root node.
class XMLDocument: Equatable {
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
}

/// Represents an node in the XML document.
class XMLNode: Codable, Equatable {
  /// The parent node of this node.
  weak var parent: XMLNode?
  /// The type of the node.
  var type: XMLNodeType
  /// The name of the node.
  var name: String
  /// The text of the node, if present.
  var text: String?
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
    type: XMLNodeType = .element,
    name: String,
    text: String? = nil,
    attributes: [String: String]? = nil,
    children: [XMLNode]? = nil) {
    self.type = type
    self.name = name
    self.text = text
    self.children = children
    // Set parent for each child
    self.children?.forEach { $0.parent = self }
  }

  // MARK: Equatable

  static func == (lhs: XMLNode, rhs: XMLNode) -> Bool {
    lhs.type == rhs.type &&
      lhs.name == rhs.name &&
      lhs.text == rhs.text &&
      lhs.children == rhs.children
  }

  func child(for name: String) -> XMLNode? {
    children?.first(where: { $0.name == name })
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
    var xml = "\(indent)<\(name)"

    // Append attributes, if any
    for attribute in children?.filter({ $0.type == .attribute }) ?? [] {
      xml += " \(attribute.name)=\"\(attribute.text ?? "")\""
    }

    if let children, !children.isEmpty {
      // Close the opening tag
      xml += ">\(formatted ? "\n" : "")"

      // Append children recursively, with increased
      // indentation level if formatted is true
      for child in children.filter({ $0.type == .element}) {
        xml += child.toXMLString(
          formatted: formatted,
          indentationLevel: indentationLevel + 1
        )
      }

      // Add closing tag with indentation if formatted is true
      xml += "\(formatted ? indent : "")</\(name)>\(formatted ? "\n" : "")"
    } else if let text {
      // Element has text, close opening tag and add text
      xml += ">\(text)</\(name)>\(formatted ? "\n" : "")"
    } else {
      // Self-closing tag for an empty node
      xml += " />\(formatted ? "\n" : "")"
    }

    return xml
  }
}
