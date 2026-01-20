//
// GeoRSSSimple.swift
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
import XMLKit

public struct GeoRSSSimple {
  // MARK: Lifecycle

  public init(point: GeoRSSSimplePoint? = nil, elevation: Double? = nil) {
    self.point = point
    self.elevation = elevation
  }

  // MARK: Public

  public var point: GeoRSSSimplePoint?
  public var elevation: Double?
}

extension GeoRSSSimple: XMLNamespaceCodable {}

// MARK: - Sendable

extension GeoRSSSimple: Sendable {}

// MARK: - Equatable

extension GeoRSSSimple: Equatable {}

// MARK: - Hashable

extension GeoRSSSimple: Hashable {}

// MARK: - Codable

extension GeoRSSSimple: Codable {
  private enum CodingKeys: String, CodingKey {
    case point = "georss:point"
    case elevation = "georss:elev"
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<GeoRSSSimple.CodingKeys> = try decoder.container(keyedBy: GeoRSSSimple.CodingKeys.self)

    point = try container.decodeIfPresent(GeoRSSSimplePoint.self, forKey: GeoRSSSimple.CodingKeys.point)
    elevation = try container.decodeIfPresent(Double.self, forKey: GeoRSSSimple.CodingKeys.elevation)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<GeoRSSSimple.CodingKeys> = encoder.container(keyedBy: GeoRSSSimple.CodingKeys.self)

    try container.encodeIfPresent(point, forKey: GeoRSSSimple.CodingKeys.point)
    try container.encodeIfPresent(elevation, forKey: GeoRSSSimple.CodingKeys.elevation)
  }
}
