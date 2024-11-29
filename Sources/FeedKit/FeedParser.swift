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
public struct FeedParser {
  let parser: FeedKit.XMLParser

  /// Initializes the parser with the JSON or XML content from a URL.
  ///
  /// - Parameter stringUrl: The URL string whose contents are used as feed data.
  public init(stringUrl: String) {
    fatalError()
  }

  /// Initializes the parser with the JSON or XML content from a URL.
  ///
  /// - Parameter URL: The URL whose contents are used as feed data.
  public init(URL: URL) {
    fatalError()
  }

  /// Initializes the parser with XML or JSON content from a data object.
  ///
  /// - Parameter data: The data object containing XML or JSON content.
  public init(data: Data) {
    parser = FeedKit.XMLParser(data: data)
  }

  /// Parses a single feed from the given data.
  ///
  /// - Parameter data: The feed data to parse.
  /// - Returns: A `Result` containing the parsed `Feed` or an error.
  public func parse() throws -> Result<Feed, Error> {
    // When
    let some = try parser.parse().get().root!
    let decoder = XMLDecoder()
    decoder.dateCodingStrategy = .formatter(RFC3339DateFormatter())
    let atomFeed = try decoder.decode(node: some, as: AtomFeed.self)
    return .success(.atom(atomFeed))
  }
}
