//
// FeedKitDeploymentCompatibility.swift
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

//
//  FeedKitDeploymentCompatibility.swift
//  XMLKitCore
//
//  The only file in this target that is not part of the upstream XMLKit sources.
//
//  XMLKit declares a macOS 13 / iOS 16 / tvOS 16 / watchOS 9 floor, while
//  FeedKit supports macOS 12 / iOS 15 / tvOS 15 / watchOS 8. The library itself
//  is written to be floor-agnostic — this file exists because exactly one
//  expression in it is not.
//
//  `XMLEncoder.swift` writes the ISO 8601 fallback time zone as
//  `TimeZone(secondsFromGMT: 0) ?? .gmt`, and `TimeZone.gmt` is only available
//  from macOS 13 / iOS 16 onwards. Declaring the same value here — UTC, the
//  identical time zone, created the identical way — lets the vendored sources
//  stay byte-for-byte identical to upstream while FeedKit keeps its existing
//  deployment targets.
//
//  Keep this file to the minimum: anything else the vendored code needs from a
//  newer deployment target belongs in the upstream library, not here.
//

import Foundation

extension TimeZone {
  /// Coordinated Universal Time.
  ///
  /// Shadows `Foundation.TimeZone.gmt`, which requires macOS 13 / iOS 16. The
  /// two are the same time zone, so the substitution is behaviour-preserving on
  /// every deployment target.
  static var gmt: TimeZone {
    // `TimeZone(secondsFromGMT: 0)` is total in practice; the force unwrap
    // mirrors Foundation's own definition of `gmt`.
    TimeZone(secondsFromGMT: 0)!
  }
}
