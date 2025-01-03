//
//  XMLError.swift
//
//  Copyright (c) 2016 - 2024 Nuno Dias
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

/// Error types with `NSError` codes and user info providers.
///
/// - notFound: Couldn't find or parse any known feed.
/// - cdataDecoding: Unable to decode bytes in a CDATA block to Unicode
///   characters using UTF-8 encoding, often due to a malformed or unsupported
///   format.
/// - invalidUrl: Indicates that the provided URL is invalid or malformed.
/// - invalidUrlString: Indicates that the provided string does not represent a
///   valid URL.
/// - network: A network-related issue, with a `reason` describing the
///   specific cause.
/// - unexpected: An unexpected error with an optional `reason` offering more
///   context, typically indicating an issue the user cannot resolve.
public enum XMLError: Error {
  case notFound
  case cdataDecoding(element: String)
  case invalidUrl
  case invalidUrlString
  case network(reason: String)
  case unexpected(reason: String)
}

// MARK: - LocalizedError

extension XMLError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .notFound:
      return "Feed not found."
    case .cdataDecoding:
      return "Error decoding CDATA Block."
    case .invalidUrl:
      return "Invalid URL provided."
    case .invalidUrlString:
      return "Malformed URL string."
    case let .network(reason):
      return "Network error: \(reason)."
    case let .unexpected(reason):
      return "Internal error: \(reason)."
    }
  }

  public var failureReason: String? {
    switch self {
    case .notFound:
      return "No recognizable feed was found in the parsed data."
    case let .cdataDecoding(element):
      return "Failed to decode CDATA block to Unicode at element: \(element). Ensure the data is in UTF-8 format."
    case .invalidUrl:
      return "The provided URL could not be parsed or recognized."
    case .invalidUrlString:
      return "The URL string format is incorrect or incomplete."
    case let .network(reason):
      return "A network-related issue interrupted the process: \(reason)"
    case let .unexpected(reason):
      return "An internal error occurred that could not be resolved: \(reason)"
    }
  }

  public var recoverySuggestion: String? {
    switch self {
    case .notFound:
      return "Please provide a valid RSS, Atom, or JSON feed."
    case .cdataDecoding:
      return "Verify that CDATA blocks are UTF-8 encoded."
    case .invalidUrl:
      return "Ensure that a complete, well-formed URL is provided."
    case .invalidUrlString:
      return "Check that the URL string is correctly formatted and contains necessary components."
    case let .network(reason):
      return "Inspect network connection settings or retry later: \(reason)"
    case .unexpected:
      return "Consider submitting a detailed issue report on GitHub for assistance."
    }
  }
}

// MARK: - CustomNSError

extension XMLError: CustomNSError {
  /// An error's code for the specified case.
  public var errorCode: Int {
    switch self {
    case .notFound: return -1000
    case .cdataDecoding: return -10001
    case .invalidUrl: return -10002
    case .invalidUrlString: return -10003
    case .network: return -10004
    case .unexpected: return -90000
    }
  }

  /// The error's userInfo dictionary for the specified case.
  public var errorUserInfo: [String: Any] {
    return [
      NSLocalizedDescriptionKey: errorDescription ?? "",
      NSLocalizedFailureReasonErrorKey: failureReason ?? "",
      NSLocalizedRecoverySuggestionErrorKey: recoverySuggestion ?? "",
    ]
  }

  /// The error's domain for the specified case.
  public static var errorDomain: String {
    return "com.feedkit.error"
  }

  /// The `NSError` from the specified case.
  public var error: NSError {
    return NSError(
      domain: XMLError.errorDomain,
      code: errorCode,
      userInfo: errorUserInfo
    )
  }
}
