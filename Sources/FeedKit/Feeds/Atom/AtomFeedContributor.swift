//
// AtomFeedContributor.swift
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

/// The "atom:contributor" element is a Person construct that indicates a
/// person or other entity who contributed to the entry or feed.
public struct AtomFeedContributor {
  // MARK: Lifecycle

  public init(
    name: String? = nil,
    email: String? = nil,
    uri: String? = nil
  ) {
    self.name = name
    self.email = email
    self.uri = uri
  }

  // MARK: Public

  /// The "atom:name" element's content conveys a human-readable name for
  /// the person.  The content of atom:name is Language-Sensitive.  Person
  /// constructs MUST contain exactly one "atom:name" element.
  public var name: String?

  /// The "atom:email" element's content conveys an e-mail address
  /// associated with the person.  Person constructs MAY contain an
  /// atom:email element, but MUST NOT contain more than one.  Its content
  /// MUST conform to the "addr-spec" production in [RFC2822].
  public var email: String?

  /// The "atom:uri" element's content conveys an IRI associated with the
  /// person.  Person constructs MAY contain an atom:uri element, but MUST
  /// NOT contain more than one.  The content of atom:uri in a Person
  /// construct MUST be an IRI reference [RFC3987].
  public var uri: String?
}

// MARK: - Sendable

extension AtomFeedContributor: Sendable {}

// MARK: - Equatable

extension AtomFeedContributor: Equatable {}

// MARK: - Hashable

extension AtomFeedContributor: Hashable {}

// MARK: - Codable

extension AtomFeedContributor: Codable {
  private enum CodingKeys: CodingKey {
    case name
    case email
    case uri
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

    name = try container.decodeIfPresent(String.self, forKey: CodingKeys.name)
    email = try container.decodeIfPresent(String.self, forKey: CodingKeys.email)
    uri = try container.decodeIfPresent(String.self, forKey: CodingKeys.uri)
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encodeIfPresent(name, forKey: CodingKeys.name)
    try container.encodeIfPresent(email, forKey: CodingKeys.email)
    try container.encodeIfPresent(uri, forKey: CodingKeys.uri)
  }
}
