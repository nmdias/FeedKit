//
// FeedInitializable.swift
//
// Copyright (c) 2016 - 2025 Nuno Dias
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
import XMLKit

/// A protocol defining initializers to create a feed from various sources.
public protocol FeedInitializable: Codable {
  /// Initializes from a URL string pointing to a feed.
  /// - Parameter urlString: The URL string of the feed.
  /// - Parameter customDateFormatter: The optional `DateFormatter` that can be used to handle weird formats
  /// - Throws: An error if the URL string is invalid or loading fails.
  init(urlString: String, customDateFormatter: DateFormatter?) async throws

  /// Initializes from a URL pointing to a feed.
  /// - Parameter url: The URL of the feed.
  /// - Parameter customDateFormatter: The optional `DateFormatter` that can be used to handle weird formats
  /// - Throws: An error if the URL is invalid or loading fails.
  init(url: URL, customDateFormatter: DateFormatter?) async throws

  /// Initializes from a file URL.
  /// - Parameter url: The local file URL of the feed.
  /// - Parameter customDateFormatter: The optional `DateFormatter` that can be used to handle weird formats
  /// - Throws: An error if the file cannot be read or parsed.
  init(fileURL url: URL, customDateFormatter: DateFormatter?) throws
  /// Initializes from a remote URL.
  /// - Parameter url: The remote URL of the feed.
  /// - Parameter customDateFormatter: The optional `DateFormatter` that can be used to handle weird formats
  /// - Throws: An error if fetching or parsing fails.
  init(remoteURL url: URL, customDateFormatter: DateFormatter?) async throws

  /// Initializes from a string.
  /// - Parameter string: The feed content as a string.
  /// - Parameter customDateFormatter: The optional `DateFormatter` that can be used to handle weird formats
  /// - Throws: An error if the string cannot be parsed.
  init(string: String, customDateFormatter: DateFormatter?) throws

  /// Initializes from data.
  /// - Parameter data: The feed content as raw data.
  /// - Parameter customDateFormatter: The optional `DateFormatter` that can be used to handle weird formats
  /// - Throws: An error if the data cannot be parsed.
  init(data: Data, customDateFormatter: DateFormatter?) throws
}

// MARK: - Default

public extension FeedInitializable {
  /// Default implementation for initializing from a URL string.
  /// - Parameter urlString: The URL string of the feed.
  /// - Parameter customDateFormatter: The optional `DateFormatter` that can be used to handle weird formats
  /// - Throws: An error if the feed cannot be loaded or parsed.
  init(urlString: String, customDateFormatter: DateFormatter? = nil) async throws {
    guard let url = URL(string: urlString) else {
      throw FeedError.invalidURLString
    }
    try await self.init(url: url, customDateFormatter: customDateFormatter)
  }

  /// Default implementation for initializing from a URL.
  /// - Parameter url: The URL of the feed.
  /// - Parameter customDateFormatter: The optional `DateFormatter` that can be used to handle weird formats
  /// - Throws: An error if the feed cannot be loaded or parsed.
  init(url: URL, customDateFormatter: DateFormatter? = nil) async throws {
    if url.isFileURL {
      try self.init(fileURL: url, customDateFormatter: customDateFormatter)
    } else {
      try await self.init(remoteURL: url, customDateFormatter: customDateFormatter)
    }
  }

  /// Initializes from a file URL.
  /// - Parameter url: The local file URL of the feed.
  /// - Parameter customDateFormatter: The optional `DateFormatter` that can be used to handle weird formats
  /// - Throws: An error if the file cannot be read or parsed.
  init(fileURL url: URL, customDateFormatter: DateFormatter? = nil) throws {
    let data = try Data(contentsOf: url)
    try self.init(data: data, customDateFormatter: customDateFormatter)
  }

  /// Initializes from a remote URL.
  /// - Parameter url: The remote URL of the feed.
  /// - Parameter customDateFormatter: The optional `DateFormatter` that can be used to handle weird formats
  /// - Throws: An error if fetching or parsing fails.
  init(remoteURL url: URL, customDateFormatter: DateFormatter? = nil) async throws {
    let session: URLSession = .shared
    let (data, response) = try await session.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw FeedError.invalidHttpResponse(statusCode: nil)
    }

    let statusCode = httpResponse.statusCode
    guard (200 ... 299).contains(statusCode) else {
      throw FeedError.invalidHttpResponse(statusCode: statusCode)
    }

    try self.init(data: data, customDateFormatter: customDateFormatter)
  }

  /// Default implementation for initializing from a string.
  /// - Parameter string: The feed content as a string.
  /// - Parameter customDateFormatter: The optional `DateFormatter` that can be used to handle weird formats
  /// - Throws: An error if the string cannot be converted to data or parsed.
  init(string: String, customDateFormatter: DateFormatter? = nil) throws {
    guard let data = string.data(using: .utf8) else {
      throw FeedError.invalidUtf8String
    }
    try self.init(data: data, customDateFormatter: customDateFormatter)
  }

  /// Default implementation for initializing from data.
  /// - Parameter data: The feed content as raw data.
  /// - Parameter customDateFormatter: The optional `DateFormatter` that can be used to handle weird formats
  /// - Throws: An error if parsing or decoding fails.
  init(data: Data, customDateFormatter: DateFormatter? = nil) throws {
    self = try Self.decode(data: data, customDateFormatter: customDateFormatter)
  }
}

// MARK: - Private

extension FeedInitializable {
  /// Helper method for decoding data into a model.
  /// - Parameter data: The raw feed data.
  /// - Parameter customDateFormatter: The optional `DateFormatter` that can be used to handle weird formats
  /// - Returns: A parsed feed model conforming to `FeedInitializable`.
  private static func decode(data: Data, customDateFormatter: DateFormatter? = nil) throws -> Self {
    let decoder: XMLDecoder = .init()
    let formatter: FeedDateFormatter = .init(spec: customDateFormatter == nil ? .permissive : .custom(customDateFormatter!))
    decoder.dateDecodingStrategy = .formatter(formatter)
    return try decoder.decode(Self.self, from: data)
  }
}
