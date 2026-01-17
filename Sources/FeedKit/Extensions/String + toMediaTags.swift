//
// String + toMediaTags.swift
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

extension String {
  /// Parses a string of user-generated tags separated by commas into an array of
  /// `MediaTag` objects.
  ///
  /// - Returns: An optional array of `MediaTag` objects, each with a tag and an
  ///           associated weight. Returns `nil` if the string is empty or cannot
  ///           be parsed into valid tags.
  func toMediaTags() -> [MediaTag]? {
    split(separator: ",").compactMap { value in
      let components = value.split(separator: ":").map {
        $0.trimmingCharacters(in: .whitespacesAndNewlines)
      }
      guard !components.isEmpty else {
        return nil
      }

      var mediaTag: MediaTag = .init()
      mediaTag.tag = components.first
      // Default weight if not provided = 1
      if components.count > 1 {
        mediaTag.weight = Int(components.last ?? "") ?? 1
      } else {
        mediaTag.weight = 1
      }
      return mediaTag
    }
  }
}
