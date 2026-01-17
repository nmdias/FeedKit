//
// MediaRating.swift
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

public struct MediaRatingAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(scheme: String? = nil) {
    self.scheme = scheme
  }

  // MARK: Public

  /// The URI that identifies the rating scheme. It is an optional attribute.
  /// If this attribute is not included, the default scheme is urn:simple (adult | nonadult).
  public var scheme: String?
}

/// This allows the permissible audience to be declared. If this element is not
/// included, it assumes that no restrictions are necessary. It has one optional
/// attribute.
public typealias MediaRating = XMLKit.XMLElement<MediaRatingAttributes>
