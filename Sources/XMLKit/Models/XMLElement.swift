//
//  XMLElement.swift
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

/// Represents an element in the XML document.
class XMLElement: Equatable {
  /// The name of the element.
  var name: String
  /// The text of the element, if present.
  var text: String?
  /// The attributes associated with the element.
  var attributes: [String: String]?
  /// The child elements of this element.
  var children: [XMLElement]?

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
  }

  // MARK: Equatable

  static func == (lhs: XMLElement, rhs: XMLElement) -> Bool {
    lhs.name == rhs.name &&
      lhs.text == rhs.text &&
      lhs.attributes == rhs.attributes &&
      lhs.children == rhs.children
  }
}
