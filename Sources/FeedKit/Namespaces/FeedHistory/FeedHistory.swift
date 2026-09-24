//
// FeedHistory.swift
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

/// Feed Paging and Archiving (RFC 5005) describes feeds whose entries are
/// published across more than one feed document.
///
/// The feed-level `fh:complete` and `fh:archive` elements identify what a
/// document represents. The documents themselves are tied together with the
/// first, last, previous, next, prev-archive, next-archive and current link
/// relations, which feed documents express with their regular link elements.
///
/// See https://datatracker.ietf.org/doc/html/rfc5005
public struct FeedHistory {
  // MARK: Lifecycle

  public init(isComplete: Bool? = nil, isArchive: Bool? = nil) {
    self.isComplete = isComplete
    self.isArchive = isArchive
  }

  // MARK: Public

  /// The `fh:complete` element, when present, indicates that the feed document
  /// it occurs in is a complete representation of the logical feed's entries.
  ///
  /// Any entry not actually in the document should not be considered part of
  /// the feed, which lets readers discard entries that are no longer listed.
  ///
  /// It is an empty element, so only its presence carries meaning: this is
  /// `true` when the element is present and `nil` when it is not.
  public var isComplete: Bool?

  /// The `fh:archive` element, when present, indicates that the feed document
  /// it occurs in is an archive document.
  ///
  /// Archive documents hold less recent entries and can be combined with the
  /// subscription document and with each other to reconstruct the logical
  /// feed.
  ///
  /// It is an empty element, so only its presence carries meaning: this is
  /// `true` when the element is present and `nil` when it is not.
  public var isArchive: Bool?
}

// MARK: - XMLNamespaceDecodable

extension FeedHistory: XMLNamespaceCodable {}

// MARK: - Sendable

extension FeedHistory: Sendable {}

// MARK: - Equatable

extension FeedHistory: Equatable {}

// MARK: - Hashable

extension FeedHistory: Hashable {}

// MARK: - Codable

extension FeedHistory: Codable {
  private enum CodingKeys: String, CodingKey {
    case isComplete = "fh:complete"
    case isArchive = "fh:archive"
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

    // Both elements are empty, so their presence is their value. `decodeIfPresent`
    // cannot be used here: the decoder reports an element without text or
    // children as nil, which would make a present `fh:complete` indistinguishable
    // from an absent one.
    isComplete = container.contains(CodingKeys.isComplete) ? true : nil
    isArchive = container.contains(CodingKeys.isArchive) ? true : nil
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)

    if isComplete == true {
      try container.encode(EmptyElement(), forKey: CodingKeys.isComplete)
    }

    if isArchive == true {
      try container.encode(EmptyElement(), forKey: CodingKeys.isArchive)
    }
  }
}

// MARK: - EmptyElement

/// An XML element with neither text nor attributes, such as `fh:complete` and
/// `fh:archive`, whose presence is the only thing that carries meaning.
private struct EmptyElement: Codable, Equatable, Hashable {}
