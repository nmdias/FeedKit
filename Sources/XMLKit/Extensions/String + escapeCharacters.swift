//
// String + escapeCharacters.swift
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
  /// Escapes characters in the string for use in XML strings.
  ///
  /// Characters escaped:
  /// - `&` → `&amp;`
  /// - `<` → `&lt;`
  /// - `>` → `&gt;`
  /// - `'` → `&apos;`
  /// - `"` → `&quot;`
  ///
  /// - Returns: A new string with the special characters replaced by their
  ///            corresponding escape sequences.
  func escapeCharacters() -> String {
    // Mapping of special characters to their escapes entities.
    let escapeMap: [Character: String] = [
      "&": "&amp;",
      "<": "&lt;",
      ">": "&gt;",
      "\"": "&quot;",
      "'": "&apos;"
    ]

    // String Builder pattern to efficiently construct the result.
    var result = ""
    result.reserveCapacity(count) // Optimize memory allocation.

    for character in self {
      if let escaped = escapeMap[character] {
        // Append escaped version if character is in the map.
        result.append(escaped)
      } else {
        // Append the original character if no escaping is needed.
        result.append(character)
      }
    }

    return result
  }
}
