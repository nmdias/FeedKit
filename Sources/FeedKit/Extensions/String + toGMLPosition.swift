//
// String + toGMLPosition.swift
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
  /// Converts a space-separated string into a tuple of latitude and longitude.
  ///
  /// - Returns: A tuple `(latitude: Double, longitude: Double)` if the string
  ///   contains exactly two valid `Double` values. Returns `nil` if the string
  ///   contains more or fewer than two components, or if the components cannot
  ///   be converted to `Double`.
  func toGMLPosition() -> (latitude: Double, longitude: Double)? {
    // Split the string by spaces
    let components = split(separator: " ")

    // Ensure exactly two components (latitude and longitude)
    guard components.count == 2 else {
      return nil
    }

    guard
      let latitude = Double(components[0]),
      let longitude = Double(components[1])
    else {
      return nil
    }

    return (latitude: latitude, longitude: longitude)
  }
}
