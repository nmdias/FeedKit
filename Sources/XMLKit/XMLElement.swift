//
// XMLElement.swift
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

/// A generic text-based element with attributes.
public struct XMLElement<Attributes: Codable & Equatable & Hashable & Sendable>: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(text: String? = nil, attributes: Attributes? = nil) {
    self.text = text
    self.attributes = attributes
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    text = try container.decodeIfPresent(String.self, forKey: .text)
    attributes = try container.decodeIfPresent(Attributes.self, forKey: .attributes)
  }

  // MARK: Public

  /// The element's text.
  public var text: String?

  /// The element's attributes.
  public var attributes: Attributes?

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(text, forKey: .text)
    try container.encodeIfPresent(attributes, forKey: .attributes)
  }

  // MARK: Private

  private enum CodingKeys: String, CodingKey {
    case text = "@text"
    case attributes = "@attributes"
  }
}

/// A generic element with only attributes.
public struct XMLAttributesElement<Attributes: Codable & Equatable & Hashable & Sendable>: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(text _: String? = nil, attributes: Attributes? = nil) {
    self.attributes = attributes
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    attributes = try container.decodeIfPresent(Attributes.self, forKey: .attributes)
  }

  // MARK: Public

  /// The element's attributes.
  public var attributes: Attributes?

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(attributes, forKey: .attributes)
  }

  // MARK: Private

  private enum CodingKeys: String, CodingKey {
    case attributes = "@attributes"
  }
}
