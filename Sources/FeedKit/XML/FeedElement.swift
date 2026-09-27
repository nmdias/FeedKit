//
// FeedElement.swift
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
import XMLKit

/// An element whose value is its text and whose attributes are a separate type.
///
/// This is how a feed spells an element that carries both a value and metadata:
/// `<title type="html">A &amp; B</title>`, `<guid isPermaLink="false">…</guid>`,
/// `<content type="xhtml">…</content>`. The text is the element's own character
/// data, except where the children *are* the value — Atom's `type="xhtml"`
/// content — which XMLKit exposes as inner markup under the `#markup` key.
public struct FeedElement<Attributes: Codable & Equatable & Hashable & Sendable>: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  /// Creates an element.
  /// - Parameters:
  ///   - text: The element's text.
  ///   - attributes: The element's attributes.
  public init(text: String? = nil, attributes: Attributes? = nil) {
    self.text = text
    self.attributes = attributes
  }

  /// Decodes an element from the decoder positioned at it.
  ///
  /// The attributes type is decoded from the *same* element — its keys are the
  /// attributes, spelled with XMLKit's `@` sigil — which is what keeps the
  /// attributes and the value of one element together without an intermediate
  /// container element.
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: FeedElementKey.self)
    attributes = try decoder.decodeFeedAttributes(Attributes.self)
    // An element whose children *are* the value — Atom's `type="xhtml"` content
    // — is read as markup; every other element's value is its character data.
    text = if try decoder.feedHasChildElements() {
      try container.decodeIfPresent(String.self, forKey: .markup)
    } else {
      try container.decodeIfPresent(String.self, forKey: .text)
    }
  }

  // MARK: Public

  /// The element's text.
  public var text: String?

  /// The element's attributes.
  public var attributes: Attributes?

  public func encode(to encoder: any Encoder) throws {
    try attributes?.encode(to: encoder)
    var container = encoder.container(keyedBy: FeedElementKey.self)
    try container.encodeIfPresent(text, forKey: .text)
  }
}

/// An element that carries only attributes.
///
/// Its presence is its value: `<podcast:podping usesPodping="true"/>` says what
/// it has to say with attributes alone.
public struct FeedAttributesElement<Attributes: Codable & Equatable & Hashable & Sendable>: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  /// Creates an element.
  /// - Parameters:
  ///   - text: Ignored: this element has no text.
  ///   - attributes: The element's attributes.
  public init(text _: String? = nil, attributes: Attributes? = nil) {
    self.attributes = attributes
  }

  /// Decodes an element from the decoder positioned at it.
  public init(from decoder: any Decoder) throws {
    attributes = try decoder.decodeFeedAttributes(Attributes.self)
  }

  // MARK: Public

  /// The element's attributes.
  public var attributes: Attributes?

  public func encode(to encoder: any Encoder) throws {
    try attributes?.encode(to: encoder)
  }
}

// MARK: - Keys

/// The two channels of an element that are not child elements.
enum FeedElementKey: String, CodingKey {
  /// The element's character data.
  case text = "#text"
  /// The markup of the element's children, when they are the value.
  case markup = "#markup"
}

// MARK: - Inline attributes

extension Decoder {
  /// Decodes an attributes bag from the element this decoder is positioned at,
  /// or `nil` when the element has no attributes.
  ///
  /// `nil` rather than an empty value, because the attributes are optional in the
  /// model and "no attributes" must stay distinguishable from "attributes, all
  /// absent".
  func decodeFeedAttributes<Attributes: Decodable>(_: Attributes.Type) throws -> Attributes? {
    guard try feedHasKey(withPrefix: "@") else {
      return nil
    }
    return try Attributes(from: self)
  }

  /// Whether the element this decoder is positioned at has a key with `prefix`.
  ///
  /// The keys are enumerated through ``FeedAnyKey`` rather than through the
  /// caller's own coding keys: a model's key type only recognises the names it
  /// declares, so it cannot report an attribute or a namespace prefix it was not
  /// written for.
  func feedHasKey(withPrefix prefix: String) throws -> Bool {
    guard let container = try? container(keyedBy: FeedAnyKey.self) else {
      return false
    }
    return container.allKeys.contains { $0.stringValue.hasPrefix(prefix) }
  }

  /// Whether the element this decoder is positioned at has child elements, as
  /// opposed to only text, attributes or nothing at all.
  func feedHasChildElements() throws -> Bool {
    guard let container = try? container(keyedBy: FeedAnyKey.self) else {
      return false
    }
    return container.allKeys.contains { key in
      !key.stringValue.hasPrefix("@") && !key.stringValue.hasPrefix("#")
    }
  }
}

/// A coding key that accepts any name, used to inspect an element.
struct FeedAnyKey: CodingKey {
  // MARK: Lifecycle

  init(stringValue: String) {
    self.stringValue = stringValue
    intValue = nil
  }

  init?(intValue: Int) {
    stringValue = "\(intValue)"
    self.intValue = intValue
  }

  // MARK: Internal

  var stringValue: String
  var intValue: Int?
}
