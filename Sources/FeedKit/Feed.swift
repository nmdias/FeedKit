//
//  Feed.swift
//
//  Copyright (c) 2016 - 2024 Nuno Manuel Dias
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

/// Represents different types of feeds: Atom, RSS, and JSON.
public enum Feed {
  case atom(AtomFeed)
  case rdf(RDFFeed)
  case rss(RSSFeed)
  case json(JSONFeed)
}

// MARK: - Equatable

extension Feed: Equatable {}

// MARK: - Sendable

extension Feed: Sendable {}

extension Feed {
  /// Returns the associated `RDFFeed` if the feed is of type `.rdf`,
  /// otherwise returns `nil`.
  public var rdf: RDFFeed? {
    guard case let .rdf(feed) = self else { return nil }
    return feed
  }
  
  /// Returns the associated `RSSFeed` if the feed is of type `.rss`,
  /// otherwise returns `nil`.
  public var rss: RSSFeed? {
    guard case let .rss(feed) = self else { return nil }
    return feed
  }

  /// Returns the associated `AtomFeed` if the feed is of type `.atom`,
  /// otherwise returns `nil`.
  public var atom: AtomFeed? {
    guard case let .atom(feed) = self else { return nil }
    return feed
  }

  /// Returns the associated `JSONFeed` if the feed is of type `.json`,
  /// otherwise returns `nil`.
  public var json: JSONFeed? {
    guard case let .json(feed) = self else { return nil }
    return feed
  }
}
