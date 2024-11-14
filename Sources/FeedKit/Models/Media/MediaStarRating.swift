//
//  MediaStarRating.swift
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

/// This element specifies the rating-related information about a media object.
/// Valid attributes are average, count, min and max.
public struct MediaStarRating: Codable {
  /// The element's attributes.
  public struct Attributes: Codable {
    /// The star rating's average.
    public var average: Double?

    /// The star rating's total count.
    public var count: Int?

    /// The star rating's minimum value.
    public var min: Int?

    /// The star rating's maximum value.
    public var max: Int?

    public init(
      average: Double? = nil,
      count: Int? = nil,
      min: Int? = nil,
      max: Int? = nil) {
      self.average = average
      self.count = count
      self.min = min
      self.max = max
    }
  }

  /// The element's attributes.
  public var attributes: Attributes?

  public init(attributes: Attributes? = nil) {
    self.attributes = attributes
  }
}