//
//  FeedType.swift
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
/// Types of feed. The `rawValue` matches the top-level XML element of a feed.
///
/// - atom: The `Atom Syndication Format` feed type.
/// - rdf: The `Really Simple Syndication` feed type version 0.90.
/// - rss: The `Really Simple Syndication` feed type version 2.0.
/// - json: JSON formatted feed, commonly used for web APIs.
enum FeedType: String {
  case rss
  case rdf
  case atom
  case json
}

extension FeedType {
  /// Returns `true` if the feed type is XML-based (RSS, RDF, or Atom).
  var isXML: Bool {
    self == .rss || self == .rdf || self == .atom
  }

  /// Returns `true` if the feed type is JSON-based.
  var isJson: Bool {
    self == .json
  }
}

fileprivate let inspectionPrefixLength = 200

extension FeedType {
  /// Initializes a `FeedType` based on the provided `Data` object.
  ///
  /// - Parameter data: A `Data` object representing a feed to be inspected.
  /// - Returns: A `FeedType` if the data matches a known feed format, otherwise `nil`.
  init?(data: Data) {
    // Inspect only the first 200 bytes for efficiency
    let string = String(decoding: data.prefix(inspectionPrefixLength), as: UTF8.self)

    // Define the set of characters considered dispositive (non-whitespace)
    let dispositiveCharacters = CharacterSet.alphanumerics
      .union(CharacterSet.punctuationCharacters)
      .union(CharacterSet.symbols)

    // Loop through the first characters and determine feed type
    for scalar in string.unicodeScalars {
      // Skip whitespace and non-essential characters (e.g., BOM markers)
      if !dispositiveCharacters.contains(scalar) {
        continue
      }

      let char = Character(scalar)
      switch char {
      case "<":
        // Check for XML-based feed types (RSS, RDF, Atom)
        if string.contains("<rss") {
          self = .rss
        } else if string.contains("<rdf") {
          self = .rdf
        } else if string.contains("<feed") {
          self = .atom
        } else {
          return nil
        }
        return
      case "{":
        self = .json
        return
      default:
        return nil
      }
    }
    return nil
  }
}
