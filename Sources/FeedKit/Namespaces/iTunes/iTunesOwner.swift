//
// iTunesOwner.swift
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

/// Use the <itunes:owner> tag to specify contact information for the podcast
/// owner. Include the email address of the owner in a nested <itunes:email> tag
/// and the name of the owner in a nested <itunes:name> tag.
///
/// The <itunes:owner> tag information is for administrative communication about
/// the podcast and is not displayed on the iTunes Store.
public struct iTunesOwner {
  // MARK: Lifecycle

  public init(
    email: String? = nil,
    name: String? = nil
  ) {
    self.email = email
    self.name = name
  }

  // MARK: Public

  /// The email address of the owner.
  public var email: String?

  /// The name of the owner.
  public var name: String?
}

// MARK: - Sendable

extension iTunesOwner: Sendable {}

// MARK: - Equatable

extension iTunesOwner: Equatable {}

// MARK: - Hashable

extension iTunesOwner: Hashable {}

// MARK: - Codable

extension iTunesOwner: Codable {
  private enum CodingKeys: String, CodingKey {
    case email = "itunes:email"
    case name = "itunes:name"
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

    email = try container.decodeIfPresent(String.self, forKey: CodingKeys.email)
    name = try container.decodeIfPresent(String.self, forKey: CodingKeys.name)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)

    try container.encodeIfPresent(email, forKey: CodingKeys.email)
    try container.encodeIfPresent(name, forKey: CodingKeys.name)
  }
}
