//
// XMLNode.swift
//
// Copyright (c) 2016 - 2025 Nuno Dias
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

/// Represents an node in the XML document.
class XMLNode: Codable, Equatable, Hashable {
  // MARK: Lifecycle

  /// Initializes a new node.
  /// - Parameters:
  ///   - name: The name of the node.
  ///   - text: The text of the node, if any.
  ///   - attributes: Attributes for the node, if any.
  ///   - children: Children for the node, if any.
  init(
    prefix: String? = nil,
    name: String,
    text: String? = nil,
    isXhtml: Bool = false,
    children: [XMLNode]? = nil
  ) {
    self.prefix = prefix
    self.name = name
    self.text = text
    self.isXhtml = isXhtml
    self.children = children
    // Set parent for each child
    self.children?.forEach { $0.parent = self }
  }

  public required init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<XMLNode.CodingKeys> = try decoder.container(keyedBy: XMLNode.CodingKeys.self)

    prefix = try container.decodeIfPresent(String.self, forKey: XMLNode.CodingKeys.prefix)
    name = try container.decode(String.self, forKey: XMLNode.CodingKeys.name)
    text = try container.decodeIfPresent(String.self, forKey: XMLNode.CodingKeys.text)
    isXhtml = try container.decode(Bool.self, forKey: XMLNode.CodingKeys.isXhtml)
    children = try container.decodeIfPresent([XMLNode].self, forKey: XMLNode.CodingKeys.children)
  }

  // MARK: Public

  // MARK: Equatable

  public static func == (lhs: XMLNode, rhs: XMLNode) -> Bool {
    // Compare current node's properties
    if
      lhs.prefix != rhs.prefix ||
      lhs.name != rhs.name ||
      lhs.text != rhs.text ||
      lhs.isXhtml != rhs.isXhtml
    {
      return false
    }

    let lhsChildren = lhs.children ?? []
    let rhsChildren = rhs.children ?? []
    if lhsChildren.count != rhsChildren.count {
      return false
    }

    // Compare child nodes recursively
    for (lChild, rChild) in zip(lhsChildren, rhsChildren) {
      if lChild != rChild {
        return false
      }
    }

    return true
  }

  // MARK: Hashable

  public func hash(into hasher: inout Hasher) {
    // Hash basic properties
    hasher.combine(prefix)
    hasher.combine(name)
    hasher.combine(text)
    hasher.combine(isXhtml)

    // Hash children if present
    if let children {
      hasher.combine(children)
    }
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<XMLNode.CodingKeys> = encoder.container(keyedBy: XMLNode.CodingKeys.self)

    try container.encodeIfPresent(prefix, forKey: XMLNode.CodingKeys.prefix)
    try container.encode(name, forKey: XMLNode.CodingKeys.name)
    try container.encodeIfPresent(text, forKey: XMLNode.CodingKeys.text)
    try container.encode(isXhtml, forKey: XMLNode.CodingKeys.isXhtml)
    try container.encodeIfPresent(children, forKey: XMLNode.CodingKeys.children)
  }

  public func child(for name: String) -> XMLNode? {
    children?.first(where: { $0.name == name })
  }

  public func hasChild(for name: String) -> Bool {
    children?.first(where: { $0.name == name || $0.prefix == name }) != nil
  }

  public func addChild(_ child: XMLNode) {
    if children == nil {
      children = []
    }
    children?.append(child)
  }

  /// Adds an attribute to the `@attributes` child of the current element.
  /// - Parameters:
  ///   - name: The name of the attribute.
  ///   - value: The value of the attribute.
  public func setAttribute(name: String, value: String) {
    // Find or create the `@attributes` node
    if let attributesNode = children?.first(where: { $0.name == "@attributes" }) {
      // Add the new attribute as a child of `@attributes`
      if let child = attributesNode.child(for: name) {
        child.text = value
      } else {
        attributesNode.addChild(.init(
          name: name,
          text: value
        ))
      }

    } else {
      // Create the `@attributes` node, and
      // add the new attribute as a child of `@attributes`
      addChild(.init(
        name: "@attributes",
        children: [
          .init(
            name: name,
            text: value
          )
        ]
      ))
    }
  }

  // MARK: Internal

  /// The parent node of this node.
  weak var parent: XMLNode?
  /// Is the `text` property xhtml
  var isXhtml: Bool = false
  /// The namespace prefix
  var prefix: String?
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

  // MARK: Private

  // MARK: - Codable

  private enum CodingKeys: CodingKey {
    case prefix
    case name
    case text
    case isXhtml
    case children
  }
}

// MARK: - XMLStringConvertible

extension XMLNode: XMLStringConvertible {
  /// Generates an XML string representation of the node and its children.
  /// - Parameter formatted: Whether to generate formatted XML (default is
  ///   false for compact XML).
  /// - Parameter indentationLevel: The current level of indentation.
  /// - Returns: A string representation of the XML for the node.
  public func toXMLString(
    formatted: Bool = false,
    indentationLevel: Int = 1
  ) -> String {
    let indent = formatted ? String(repeating: "  ", count: indentationLevel) : ""

    // Skip processing nodes with the name "@attributes".
    if name == "@attributes" {
      return ""
    }
    var xml = "\(indent)<\(name)"

    xml += attributesToString()

    // Process child nodes, excluding "@attributes"
    if let children = children?.filter({ $0.name != "@attributes" }), !children.isEmpty {
      // Close the opening tag and add child nodes recursively.
      xml += ">\(formatted ? "\n" : "")"

      // Append children recursively, with increased
      // indentation level if formatted is true
      for child in children {
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

// MARK: - Private

extension XMLNode {
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
