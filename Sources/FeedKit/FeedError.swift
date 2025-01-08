//
//  FeedError.swift
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
/// - invalidUrlString: The URL string provided is invalid.
/// - invalidUrl: The provided URL does not point to a valid file or resource.
/// - invalidHttpResponse: The HTTP response is invalid or has an unexpected
///   status code.
/// - invalidUtf8String: The provided string cannot be converted to UTF-8 data.
/// - unknownFeedFormat: The feed format is not recognized or supported.
/// - networkError: A network error occurred while downloading the feed.
/// - fileReadError: An error occurred while reading the file at the specified
///   URL.
/// - unexpected: An unexpected error with an optional reason, offering more
///   context on the issue.
public enum FeedError: Error {
  /// The URL string provided is invalid.
  case invalidUrlString
  /// The HTTP response is invalid or has an unexpected status code.
  case invalidHttpResponse(statusCode: Int?)
  /// The provided string cannot be converted to UTF-8 data.
  case invalidUtf8String
  /// The feed format is not recognized or supported.
  case unknownFeedFormat
}

// MARK: - LocalizedError

extension FeedError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .invalidUrlString:
      return "The URL string provided is invalid."
    case let .invalidHttpResponse(statusCode):
      if let code = statusCode {
        return "The HTTP response is invalid with status code: \(code)."
      } else {
        return "The HTTP response is invalid with an unknown status code."
      }
    case .invalidUtf8String:
      return "The provided string cannot be converted to UTF-8 data."
    case .unknownFeedFormat:
      return "The feed format is not recognized or supported."
    }
  }

  public var failureReason: String? {
    switch self {
    case .invalidUrlString:
      return "The URL string is not in a valid format."
    case let .invalidHttpResponse(statusCode):
      if let code = statusCode {
        return "Received HTTP status code \(code), which is outside the expected range."
      } else {
        return "Received an invalid HTTP response with no status code."
      }
    case .invalidUtf8String:
      return "The string data is not UTF-8 encoded or contains invalid bytes."
    case .unknownFeedFormat:
      return "The feed format could not be determined from the provided data."
    }
  }

  public var recoverySuggestion: String? {
    switch self {
    case .invalidUrlString:
      return "Verify the URL string and ensure it is correctly formatted."
    case .invalidHttpResponse:
      return "Ensure the server is reachable and returning a valid response."
    case .invalidUtf8String:
      return "Confirm that the string is UTF-8 encoded and does not contain invalid bytes."
    case .unknownFeedFormat:
      return "Ensure the feed data is in a recognized RSS, Atom, or JSON format."
    }
  }
}

// MARK: - CustomNSError

extension FeedError: CustomNSError {
  /// An error's code for the specified case.
  public var errorCode: Int {
    switch self {
    case .invalidUrlString: return -1001
    case .invalidHttpResponse: return -1003
    case .invalidUtf8String: return -1004
    case .unknownFeedFormat: return -1005
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
      domain: FeedError.errorDomain,
      code: errorCode,
      userInfo: errorUserInfo
    )
  }
}
