//
// GeoRSSSimplePoint.swift
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

public struct GeoRSSSimplePoint {
  // MARK: Lifecycle

  public init(position: (latitude: Double, longitude: Double)? = nil) {
    self.position = position
  }

  // MARK: Public

  /// The geographical position represented as latitude and longitude
  /// for a <georss:point> element.
  ///
  /// - The `position` is an optional tuple containing the latitude and longitude
  ///   as `Double` values. If not provided, it defaults to `nil`.
  public var position: (latitude: Double, longitude: Double)?
}

// MARK: - Sendable

extension GeoRSSSimplePoint: Sendable {}

// MARK: - Equatable

extension GeoRSSSimplePoint: Equatable {
  public static func == (lhs: GeoRSSSimplePoint, rhs: GeoRSSSimplePoint) -> Bool {
    lhs.position?.latitude == rhs.position?.latitude && lhs.position?.longitude == rhs.position?.longitude
  }
}

// MARK: - Hashable

extension GeoRSSSimplePoint: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(position?.latitude)
    hasher.combine(position?.longitude)
  }
}

// MARK: - Codable

extension GeoRSSSimplePoint: Codable {
  public init(from decoder: any Decoder) throws {
    let container = try decoder.singleValueContainer()

    position = try container.decode(String.self).toGMLPosition()
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()

    if let position {
      let positionString = "\(position.latitude) \(position.longitude)"
      try container.encode(positionString)
    }
  }
}
