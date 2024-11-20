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

/// Represents an XML document containing a root element.
class XMLDocument: Equatable {
  /// The root element of the document.
  var root: XMLElement?

  /// Initializes a new document with an optional root element.
  /// - Parameter root: The root element of the document.
  init(root: XMLElement?) {
    self.root = root
  }

  // MARK: Equatable

  static func == (lhs: XMLDocument, rhs: XMLDocument) -> Bool {
    lhs.root == rhs.root
  }
}

/// Represents an element in the XML document.
class XMLElement: Codable, Equatable {
  /// The parent element of this element.
  weak var parent: XMLElement?

  /// The name of the element.
  var name: String
  /// The text of the element, if present.
  var text: String?
  /// The attributes associated with the element.
  var attributes: [String: String]?
  /// The child elements of this element.
  var children: [XMLElement]? {
    didSet {
      // Update the parent reference for all children
      children?.forEach { $0.parent = self }
    }
  }

  /// Initializes a new element.
  /// - Parameters:
  ///   - name: The name of the element.
  ///   - text: The text of the element, if any.
  ///   - attributes: Attributes for the element, if any.
  ///   - children: Children for the element, if any.
  init(
    name: String,
    text: String? = nil,
    attributes: [String: String]? = nil,
    children: [XMLElement]? = nil) {
    self.name = name
    self.text = text
    self.attributes = attributes
    self.children = children
    // Set parent for each child
    self.children?.forEach { $0.parent = self }
  }

  // MARK: Equatable

  static func == (lhs: XMLElement, rhs: XMLElement) -> Bool {
    lhs.name == rhs.name &&
    lhs.text == rhs.text &&
    lhs.attributes == rhs.attributes &&
    lhs.children == rhs.children
  }
  
  func child(for name: String) -> XMLElement? {
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

// MARK: - XMLElement + XMLStringConvertible

extension XMLElement: XMLStringConvertible {
  /// Generates an XML string representation of the node and its children.
  /// - Parameter formatted: Whether to generate formatted XML (default is
  ///   false for compact XML).
  /// - Parameter indentationLevel: The current level of indentation.
  /// - Returns: A string representation of the XML for the element.
  func toXMLString(
    formatted: Bool = false,
    indentationLevel: Int = 1) -> String {
    let indent = formatted ? String(repeating: "  ", count: indentationLevel) : ""
    var xml = "\(indent)<\(name)"

    // Append attributes, if any
    if let attributes = attributes?.sorted(by: { $0.key < $1.key }) {
      for (key, value) in attributes {
        xml += " \(key)=\"\(value)\""
      }
    }

    if let children = children, !children.isEmpty {
      // Close the opening tag
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
    } else if let text = text {
      // Element has text, close opening tag and add text
      xml += ">\(text)</\(name)>\(formatted ? "\n" : "")"
    } else {
      // Self-closing tag for an empty element
      xml += " />\(formatted ? "\n" : "")"
    }

    return xml
  }
}
