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
  /// Parses multiple feeds concurrently from an array of string URLs.
  ///
  /// - Parameters:
  ///   - stringUrls: An array of stringUrls pointing to feed data.
  ///   - maxConcurrency: Maximum number of feeds to parse concurrently.
  ///   - onFeedParsed: A closure called with the result of each parsed feed.
  ///   - completion: An optional closure called with an array of all results
  ///     after parsing is complete. If `completion` is not provided, the
  ///     function does not store all parsed results in memory, reducing
  ///     resource usage. Only `onFeedParsed` will be invoked.
  public func parse(
    _ stringUrls: [String],
    maxConcurrency: Int,
    onFeedParsed: @escaping (Result<Feed, Error>) -> Void,
    completion: (([Result<Feed, Error>]) -> Void)? = nil) {
    fatalError()
  }

  /// Parses multiple feeds concurrently from an array of URLs.
  ///
  /// - Parameters:
  ///   - URLs: An array of URLs pointing to feed data.
  ///   - maxConcurrency: Maximum number of feeds to parse concurrently.
  ///   - onFeedParsed: A closure called with the result of each parsed feed.
  ///   - completion: An optional closure called with an array of all results
  ///     after parsing is complete. If `completion` is not provided, the
  ///     function does not store all parsed results in memory, reducing
  ///     resource usage. Only `onFeedParsed` will be invoked.
  public func parse(
    _ URLs: [URL],
    maxConcurrency: Int,
    onFeedParsed: @escaping (Result<Feed, Error>) -> Void,
    completion: (([Result<Feed, Error>]) -> Void)? = nil) {
    fatalError()
  }

  /// Parses multiple feeds concurrently from an array of data objects.
  ///
  /// - Parameters:
  ///   - data: An array of data objects containing feed content.
  ///   - maxConcurrency: Maximum number of feeds to parse concurrently.
  ///   - onFeedParsed: A closure called with the result of each parsed feed.
  ///   - completion: An optional closure called with an array of all results
  ///     after parsing is complete. If `completion` is not provided, the
  ///     function does not store all parsed results in memory, reducing
  ///     resource usage. Only `onFeedParsed` will be invoked.
  public func parse(
    _ data: [Data],
    maxConcurrency: Int,
    onFeedParsed: @escaping (Result<Feed, Error>) -> Void,
    completion: (([Result<Feed, Error>]) -> Void)? = nil) {
    fatalError()
  }
}
