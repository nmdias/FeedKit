//
//  MediaDescription.swift
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

/// Short description describing the media object typically a sentence in
/// length. It has one optional attribute.
public struct MediaDescription: Codable {
  /// The element's text.
  public var text: String?

  /// The element's attributes.
  public struct Attributes: Codable {
    /// Specifies the type of text embedded. Possible values are either "plain" or "html".
    /// Default value is "plain". All HTML must be entity-encoded. It is an optional attribute.
    public var type: String?

    public init(type: String? = nil) {
      self.type = type
    }
  }

  /// The element's attributes.
  public var attributes: Attributes?

  public init(
    text: String? = nil,
    attributes: Attributes? = nil) {
    self.attributes = attributes
    self.text = text
  }
}