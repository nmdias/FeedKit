//
// Atom.swift
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

/// Atom namespace in an RSS feed helps WebSub subscribers discover the topic
/// and hub information.
/// See https://www.w3.org/TR/websub/#discovery
public struct Atom {
  // MARK: Lifecycle

  public init(links: [AtomLink]? = nil) {
    self.links = links
  }

  // MARK: Public

  /// The "atom:link" element defines a reference from an entry or feed to
  /// a Web resource.  This specification assigns no meaning to the content
  /// (if any) of this element.
  public var links: [AtomLink]?
}

// MARK: - XMLNamespaceDecodable

extension Atom: XMLNamespaceCodable {}

// MARK: - Sendable

extension Atom: Sendable {}

// MARK: - Equatable

extension Atom: Equatable {}

// MARK: - Hashable

extension Atom: Hashable {}

// MARK: - Codable

extension Atom: Codable {
  private enum CodingKeys: String, CodingKey {
    case links = "atom:link"
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<Atom.CodingKeys> = try decoder.container(keyedBy: Atom.CodingKeys.self)

    links = try container.decodeIfPresent([AtomLink].self, forKey: Atom.CodingKeys.links)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<Atom.CodingKeys> = encoder.container(keyedBy: Atom.CodingKeys.self)

    try container.encodeIfPresent(links, forKey: Atom.CodingKeys.links)
  }
}
