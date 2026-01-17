//
// Feed.swift
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

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

/// `Feed` is an enum that can parse and hold either an `AtomFeed`, `RSSFeed`,
/// or `JSONFeed` feed. It provides type-safe access to the underlying feed format
/// through its cases and convenience accessors.
///
/// ## Examples
/// You can parse and access a feed either through pattern matching or convenience
/// properties:
///
/// Start by fetching and parsing a feed
/// ```swift
/// let feed = try await Feed(url: feedURL)
/// ```
///
/// Method 1: Pattern matching with switch
///
/// ```swift
/// switch feed {
/// case .atom(let atomFeed):
///    print("Atom feed title: \(atomFeed)")
/// case .rss(let rssFeed):
///    print("RSS feed title: \(rssFeed)")
/// case .json(let jsonFeed):
///    print("JSON feed title: \(jsonFeed)")
/// }
/// ```
/// Method 2: Optional property access
///
/// ```swift
///
/// if let atomFeed = feed.atom {
///    print("Atom feed: \(atomFeed)")
/// } else if let rssFeed = feed.rss {
///    print("RSS feed: \(rssFeed)")
/// } else if let jsonFeed = feed.json {
///    print("JSON feed: \(jsonFeed)")
/// }
/// ```
///
/// Feed parsing supports both local and remote URLs, raw data, and string input.
/// The feed type is automatically detected during initialization. If a valid
/// is detected, parsing is attempted, otherwise an error is thrown.
///
/// - Note: All initializers may throw errors if an invalid input is detected
///         or if parsing fails.
/// - SeeAlso: `AtomFeed`, `RSSFeed`, `JSONFeed`, `FeedError`
public enum Feed {
  case atom(AtomFeed)
  case rss(RSSFeed)
  case json(JSONFeed)
}

// MARK: - FeedInitializable

extension Feed: FeedInitializable {
  /// Initializes a `Feed` by parsing content from the specified URL string.
  ///
  /// - Parameter urlString: A valid URL string pointing to a feed.
  /// - Throws: `FeedError.invalidURLString` if the URL string is invalid, or other
  ///           parsing errors if the feed content cannot be processed.
  public init(urlString: String) async throws {
    guard let url = URL(string: urlString) else {
      throw FeedError.invalidURLString
    }
    try await self.init(url: url)
  }

  /// Initializes a `Feed` by parsing content from the specified URL.
  ///
  /// This initializer automatically handles both local file URLs and remote URLs.
  ///
  /// - Parameter url: The URL pointing to the feed content.
  /// - Throws: Various errors depending on whether the URL is local or remote.
  public init(url: URL) async throws {
    if url.isFileURL {
      try self.init(fileURL: url)
    } else {
      try await self.init(remoteURL: url)
    }
  }

  /// Initializes a `Feed` by parsing content from a local file URL.
  ///
  /// - Parameter url: A file URL pointing to the feed content.
  /// - Throws: File reading errors or parsing errors if the content is invalid.
  public init(fileURL url: URL) throws {
    let data = try Data(contentsOf: url)
    try self.init(data: data)
  }

  /// Initializes a `Feed` by downloading and parsing content from a remote URL.
  ///
  /// - Parameter url: A remote URL pointing to the feed content.
  /// - Throws: Network errors, HTTP errors, or parsing errors if the download
  ///           fails or the content is invalid.
  public init(remoteURL url: URL) async throws {
    let session: URLSession = .shared
    let (data, response) = try await session.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw FeedError.invalidHttpResponse(statusCode: nil)
    }

    let statusCode = httpResponse.statusCode
    guard (200 ... 299).contains(statusCode) else {
      throw FeedError.invalidHttpResponse(statusCode: statusCode)
    }

    try self.init(data: data)
  }

  /// Initializes a `Feed` by parsing the provided string content.
  ///
  /// - Parameter string: A string containing the feed content.
  /// - Throws: `FeedError` if the string cannot be converted to data or if
  ///           parsing fails.
  public init(string: String) throws {
    guard let data = string.data(using: .utf8) else {
      throw FeedError.invalidUtf8String
    }
    try self.init(data: data)
  }

  /// Initializes a `Feed` by parsing the provided raw data.
  ///
  /// This is the core initializer that all other initialization methods ultimately
  /// use. It automatically detects the feed type from the content and parses it
  /// into the appropriate format.
  ///
  /// - Parameter data: The raw feed data to parse.
  /// - Throws: `FeedError.unknownFeedFormat` if the feed type cannot be determined or
  ///           if parsing fails.
  public init(data: Data) throws {
    let feedType = try FeedType(data: data)

    switch feedType {
    case .atom:
      let feed = try AtomFeed(data: data)
      self = .atom(feed)

    case .rss:
      let feed = try RSSFeed(data: data)
      self = .rss(feed)

    case .json:
      let feed = try JSONFeed(data: data)
      self = .json(feed)
    }
  }
}

// MARK: - Convenience Accessors

public extension Feed {
  /// Returns the wrapped RSS feed if this feed is of type `.rss`.
  ///
  /// Use this property to safely access the RSS feed content when you expect
  /// an RSS format.
  var rss: RSSFeed? {
    guard case let .rss(feed) = self else {
      return nil
    }
    return feed
  }

  /// Returns the wrapped Atom feed if this feed is of type `.atom`.
  ///
  /// Use this property to safely access the Atom feed content when you expect
  /// an Atom format.
  var atom: AtomFeed? {
    guard case let .atom(feed) = self else {
      return nil
    }
    return feed
  }

  /// Returns the wrapped JSON feed if this feed is of type `.json`.
  ///
  /// Use this property to safely access the JSON feed content when you expect
  /// a JSON format.
  var json: JSONFeed? {
    guard case let .json(feed) = self else {
      return nil
    }
    return feed
  }
}

// MARK: - Equatable

extension Feed: Equatable {}

// MARK: - Sendable

extension Feed: Sendable {}
