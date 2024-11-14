//
//  XMLElement + toXMLString.swift
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

extension XMLElement {
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