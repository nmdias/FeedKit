//
//  URL + replacingScheme.swift
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

extension URL {
  /// Returns a new `URL` with the scheme replaced by a given replacement scheme,
  /// if the current scheme matches the target scheme (case-insensitive).
  ///
  /// - Parameters:
  ///   - target: The target scheme to match.
  ///   - replacement: The scheme to use as the replacement.
  /// - Returns: A new URL with the replaced scheme, or `nil` if no changes were made or
  ///            the replacement could not be applied.
  func replacingScheme<Target, Replacement>(
    _ target: Target,
    with replacement: Replacement
  ) -> URL? where Target: StringProtocol, Replacement: StringProtocol {
    guard
      let urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true),
      let currentScheme = urlComponents.scheme,
      currentScheme.caseInsensitiveCompare(target) == .orderedSame
    else {
      return nil
    }

    var modifiedComponents = urlComponents
    modifiedComponents.scheme = String(replacement)

    return modifiedComponents.url
  }
}
