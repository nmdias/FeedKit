//
//  FeedParser.swift
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

import Foundation

/// A parser for processing feed data in XML or JSON formats.
///
/// `FeedParser` can parse feeds in Atom, RSS (including RDF), and JSON formats,
/// automatically determining the format based on the provided data.
///
/// ### Usage Example
/// ```swift
/// let parser = FeedParser()
/// let feedData: Data = ... // Load feed data from a URL or file
///
/// do {
///     let result = try parser.parse(data: feedData)
///     switch result {
///     case .success(let feed):
///         switch feed {
///         case .atom(let atomFeed):
///             print("Parsed an Atom feed: \(atomFeed)")
///         case .rss(let rssFeed):
///             print("Parsed an RSS feed: \(rssFeed)")
///         case .json(let jsonFeed):
///             print("Parsed a JSON feed: \(jsonFeed)")
///         }
///     case .failure(let error):
///         print("Failed to parse feed: \(error)")
///     }
/// } catch {
///     print("Unexpected error: \(error)")
/// }
/// ```
///
/// - SeeAlso: `Feed`, `FeedType`, `AtomFeed`, `RSSFeed`, `JSONFeed`
public struct FeedParser {
  /// Creates a new instance of `FeedParser`.
  public init() {}

  /// Parses a feed from a URL string (file or remote).
  ///
  /// - Parameter urlString: The URL string of the feed.
  /// - Returns: A result with the parsed feed or an error.
  /// - Throws: An error if fetching or parsing fails.
  public func parse(urlString: String) async throws -> Result<Feed, Error> {
    guard let url = URL(string: urlString) else {
      throw FeedError.invalidUrlString
    }
    return try await parse(url: url)
  }

  /// Parses a feed from a URL (file or remote).
  ///
  /// - Parameter url: The URL of the feed.
  /// - Returns: A result with the parsed feed or an error.
  /// - Throws: An error if fetching or parsing fails.
  public func parse(url: URL) async throws -> Result<Feed, Error> {
    if url.isFileURL {
      return try parse(fileURL: url)
    } else {
      return try await parse(remoteURL: url)
    }
  }

  /// Parses a feed from a local file URL.
  ///
  /// - Parameter url: The file URL of the feed.
  /// - Returns: A result with the parsed feed or an error.
  /// - Throws: An error if reading or parsing fails.
  public func parse(fileURL url: URL) throws -> Result<Feed, Error> {
    let data = try Data(contentsOf: url)
    return try parse(data: data)
  }

  /// Parses a feed from a remote URL.
  ///
  /// - Parameter url: The remote URL of the feed.
  /// - Returns: A result with the parsed feed or an error.
  /// - Throws: An error if fetching or parsing fails.
  public func parse(remoteURL url: URL) async throws -> Result<Feed, Error> {
    let session = URLSession.shared
    let (data, response) = try await session.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse,
          (200 ... 299).contains(httpResponse.statusCode) else {
      throw FeedError.unexpected(reason: "Invalid response from URL.")
    }

    return try parse(data: data)
  }

  /// Parses a feed from the provided string.
  ///
  /// - Parameter string: The raw feed content as a string.
  /// - Returns: A `Result` containing the parsed `Feed` or an error.
  /// - Throws: An `XMLError` if the feed type is unknown or parsing fails.
  public func parse(string: String) throws -> Result<Feed, Error> {
    guard let data = string.data(using: .utf8) else {
      throw FeedError.unexpected(reason: "Unable to convert string to data.")
    }
    return try parse(data: data)
  }

  /// Parses a feed from the provided data.
  ///
  /// This method determines the feed type (Atom, RSS, RDF, or JSON) from the
  /// given data and parses it accordingly.
  ///
  /// - Parameter data: The raw feed data to parse.
  /// - Returns: A `Result` containing the parsed `Feed` or an error.
  /// - Throws: An `XMLError` if the feed type is unknown or parsing fails.
  public func parse(data: Data) throws -> Result<Feed, Error> {
    guard let feedType = FeedType(data: data) else {
      throw FeedError.unexpected(reason: "Unknown feed data type.")
    }

    switch feedType {
    case .atom:
      let feed = try AtomFeed(data: data)
      return .success(.atom(feed))

    case .rdf:
      let feed = try RDFFeed(data: data)
      return .success(.rdf(feed))

    case .rss:
      let feed = try RSSFeed(data: data)
      return .success(.rss(feed))

    case .json:
      let feed = try JSONFeed(data: data)
      return .success(.json(feed))
    }
  }
}

// MARK: - Sendble

extension FeedParser: Sendable {}
