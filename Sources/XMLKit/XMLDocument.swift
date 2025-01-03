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
public class XMLDocument: Equatable, Hashable {
  /// The root node of the document.
  var root: XMLNode?

  /// Initializes a new document with an optional root node.
  /// - Parameter root: The root node of the document.
  init(root: XMLNode?) {
    self.root = root
  }

  // MARK: Equatable

  public static func == (lhs: XMLDocument, rhs: XMLDocument) -> Bool {
    lhs.root == rhs.root
  }

  // MARK: Hashable

  public func hash(into hasher: inout Hasher) {
    hasher.combine(root)
  }

  public func setRootName(name: String) {
    root?.name = name
  }

  public func setRootAttribute(name: String, value: String) {
    root?.addAttribute(name: name, value: value)
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
