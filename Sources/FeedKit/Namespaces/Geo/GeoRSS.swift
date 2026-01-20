//
// GeoRSS.swift
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

/// GeoRSS is designed as a lightweight, community driven way to extend existing
/// RSS feeds with simple geographic information. The GeoRSS standard provides for
/// encoding location in an interoperable manner so that applications can request,
/// aggregate, share and map geographically tag feeds.
public struct GeoRSS {
  // MARK: Lifecycle

  public init(gmlPoint: GMLPoint? = nil) {
    self.gmlPoint = gmlPoint
  }

  // MARK: Public

  /// A point consists of a GML <Point> element with a child <pos> element.
  /// Within<pos> the latitude and longitude coordinate values are separated
  /// by a space.
  public var gmlPoint: GMLPoint?
}

// MARK: - Sendable

extension GeoRSS: Sendable {}

// MARK: - Equatable

extension GeoRSS: Equatable {}

// MARK: - Hashable

extension GeoRSS: Hashable {}

// MARK: - Codable

extension GeoRSS: Codable {
  private enum CodingKeys: String, CodingKey {
    case gmlPoint = "gml:Point"
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

    gmlPoint = try container.decodeIfPresent(GMLPoint.self, forKey: CodingKeys.gmlPoint)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)

    try container.encodeIfPresent(gmlPoint, forKey: CodingKeys.gmlPoint)
  }
}
