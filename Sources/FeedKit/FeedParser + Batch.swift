//
//  FeedParser + Batch.swift
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

extension FeedParser {
  /// Parses multiple feeds from the provided URL strings concurrently.
  ///
  /// - Parameters:
  ///   - urlStrings: The list of URL strings to fetch and parse feeds from.
  ///     Defaults to the active processor count if not specified.
  ///   - onFeedParsed: An optional closure called with each parsed feed.
  ///     Executes as soon as a feed is parsed or an error occurs.
  ///
  /// - Returns: A list of results, one for each URL, indicating either a
  ///   successfully parsed `Feed` or an error.
  ///
  /// - Note: The `onFeedParsed` closure is executed immediately on completion
  ///   of each feed, while the returned result set contains all feed results
  ///   after processing completes.
  @discardableResult
  public func parse(
    from urlStrings: [String],
    onFeedParsed: (@Sendable (Result<Feed, Error>) -> Void)? = nil
  ) async -> [Result<Feed, Error>] {
    let urls = urlStrings.compactMap { URL(string: $0) }
    return await parse(from: urls, onFeedParsed: onFeedParsed)
  }

  /// Parses multiple feeds from the provided URLs concurrently.
  ///
  /// - Parameters:
  ///   - urls: The list of URLs to fetch and parse feeds from.
  ///     Defaults to the active processor count if not specified.
  ///   - onFeedParsed: An optional closure called with each parsed feed.
  ///     Executes as soon as a feed is parsed or an error occurs.
  ///
  /// - Returns: A list of results, one for each URL, indicating either a
  ///   successfully parsed `Feed` or an error.
  ///
  /// - Note: The `onFeedParsed` closure is executed immediately on completion
  ///   of each feed, while the returned result set contains all feed results
  ///   after processing completes.
  @discardableResult
  public func parse(
    from urls: [URL],
    onFeedParsed: (@Sendable (Result<Feed, Error>) -> Void)? = nil
  ) async -> [Result<Feed, Error>] {
    var parsedFeeds: [Result<Feed, Error>] = []

    await withTaskGroup(of: Result<Feed, Error>.self) { group in
      for url in urls {
        group.addTask {
          do {
            let result = try await parse(url: url)

            // Invoke the callback immediately if provided
            if let onFeedParsed = onFeedParsed {
              onFeedParsed(result)
            }

            return result
          } catch {
            if let onFeedParsed = onFeedParsed {
              onFeedParsed(.failure(error))
            }
            return .failure(error)
          }
        }
      }

      // Collect all parsed results
      for await result in group {
        parsedFeeds.append(result)
      }
    }

    return parsedFeeds
  }
}
