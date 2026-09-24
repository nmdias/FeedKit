//
// FeedHistoryLinkRelation.swift
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

/// The link relation types that RFC 5005 uses to tie the feed documents of a
/// paged or archived feed together.
///
/// Paged feeds link their pages with ``first``, ``last``, ``previous`` and
/// ``next``, while archived feeds link the subscription document and their
/// archives with ``previousArchive``, ``nextArchive`` and ``current``.
///
/// See https://datatracker.ietf.org/doc/html/rfc5005
public enum FeedHistoryLinkRelation: String, CaseIterable, Sendable {
  /// A URI that refers to the furthest preceding document in a series of
  /// documents.
  case first

  /// A URI that refers to the furthest following document in a series of
  /// documents.
  case last

  /// A URI that refers to the immediately preceding document in a series of
  /// documents.
  case previous

  /// A URI that refers to the immediately following document in a series of
  /// documents.
  case next

  /// A URI that refers to the immediately preceding archive document.
  case previousArchive = "prev-archive"

  /// A URI that refers to the immediately following archive document.
  case nextArchive = "next-archive"

  /// A URI that, when dereferenced, returns a feed document containing the most
  /// recent entries in the feed.
  case current
}

// MARK: - Link Lookup

private extension FeedHistoryLinkRelation {
  /// The `rel` values that identify the relation.
  ///
  /// RFC 5005 spells the preceding page relation as "previous", while "prev" is
  /// its registered synonym, so both are accepted.
  var relValues: Set<String> {
    switch self {
    case .previous:
      ["previous", "prev"]
    default:
      [rawValue]
    }
  }
}

/// The attributes an `atom:link` must carry to be matched against a relation.
private protocol LinkAttributes {
  var rel: String? { get }
}

extension AtomLinkAttributes: LinkAttributes {}
extension AtomFeedLinkAttributes: LinkAttributes {}

/// Returns the first link whose relation matches the given relation.
private func firstLink<Attributes: LinkAttributes>(
  in links: [XMLAttributesElement<Attributes>]?,
  matching relation: FeedHistoryLinkRelation
) -> XMLAttributesElement<Attributes>? {
  let relValues = relation.relValues
  return links?.first { link in
    guard let rel = link.attributes?.rel?.lowercased() else {
      return false
    }
    return relValues.contains(rel)
  }
}

// MARK: - AtomFeed

public extension AtomFeed {
  /// Returns the feed's first `atom:link` with the given RFC 5005 relation, or
  /// `nil` when the feed has no such link.
  ///
  /// - Parameter relation: The link relation to look for.
  /// - Returns: The matching link, or `nil`.
  func link(for relation: FeedHistoryLinkRelation) -> AtomFeedLink? {
    firstLink(in: links, matching: relation)
  }
}

// MARK: - RSSFeedChannel

public extension RSSFeedChannel {
  /// Returns the channel's first `atom:link` with the given RFC 5005 relation,
  /// or `nil` when the channel has no such link.
  ///
  /// RSS 2.0 has no link relation of its own, so RFC 5005 reuses the `atom:link`
  /// element in the feed's Atom namespace; see Appendix B of the RFC.
  ///
  /// - Parameter relation: The link relation to look for.
  /// - Returns: The matching link, or `nil`.
  func link(for relation: FeedHistoryLinkRelation) -> AtomLink? {
    firstLink(in: atom?.links, matching: relation)
  }
}
