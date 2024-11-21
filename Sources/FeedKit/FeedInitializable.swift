//
//  FeedInitializable.swift
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

/// A protocol that defines initializers for creating a feed from different sources.
protocol FeedInitializable: Codable {
  /// Default initializer.
  init()
  /// Initializes from a URL pointing to an XML feed.
  /// Throws an error if the URL is invalid or the feed cannot be loaded.
  init(url: URL) throws
  /// Initializes from an XML string.
  /// Throws an error if the XML string cannot be parsed.
  init(xmlString: String) throws
  /// Initializes from XML data.
  /// Throws an error if the XML data cannot be parsed.
  init(xmlData: Data) throws
}

extension FeedInitializable {
  /// Default implementation for initializing from a URL.
  init(url: URL) throws {
    fatalError()
  }

  /// Default implementation for initializing from an XML string.
  init(xmlString: String) throws {
    fatalError()
  }

  /// Default implementation for initializing from XML data.
  init(xmlData: Data) throws {
    fatalError()
  }
}
