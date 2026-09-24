//
// PodcastImage.swift
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

// MARK: - Image

/// Attributes for the `<podcast:image>` element.
public struct PodcastImageAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(
    href: String? = nil,
    alt: String? = nil,
    aspectRatio: String? = nil,
    width: Int? = nil,
    height: Int? = nil,
    type: String? = nil,
    purpose: String? = nil
  ) {
    self.href = href
    self.alt = alt
    self.aspectRatio = aspectRatio
    self.width = width
    self.height = height
    self.type = type
    self.purpose = purpose
  }

  // MARK: Public

  /// The URL to the media to embed.
  public var href: String?

  /// An accessibility focused text replacement for the image's content.
  public var alt: String?

  /// A ratio value such as `1/1`, `16/9` or `4/1`, following CSS syntax.
  public var aspectRatio: String?

  /// The width of the asset in pixels.
  public var width: Int?

  /// The height of the asset in pixels.
  public var height: Int?

  /// The mime type of the media, such as `image/jpeg` or `video/mp4`.
  public var type: String?

  /// A space-separated set of tokens describing the suggested uses of this
  /// media, such as `artwork`, `social` or `banner`.
  public var purpose: String?

  // MARK: Private

  private enum CodingKeys: String, CodingKey {
    case href
    case alt
    case aspectRatio = "aspect-ratio"
    case width
    case height
    case type
    case purpose
  }
}

/// An image of a particular size and use case for the podcast or an episode.
///
/// Example:
/// ```xml
/// <podcast:image href="https://example.com/images/art.png" alt="Show art" aspect-ratio="1/1" width="3000" type="image/png" />
/// ```
///
/// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/image.md
public typealias PodcastImage = XMLAttributesElement<PodcastImageAttributes>

// MARK: - Images (Deprecated)

/// Attributes for the deprecated `<podcast:images>` element.
public struct PodcastImagesAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(srcset: String? = nil) {
    self.srcset = srcset
  }

  // MARK: Public

  /// Each image url followed by a space and the pixel width, with each one
  /// separated by a comma, following the HTML5 `srcset` syntax.
  public var srcset: String?
}

/// Allows specifying many different image sizes in a compact way at either the
/// episode or channel level.
///
/// This element is deprecated in favour of `<podcast:image>`.
///
/// Example:
/// ```xml
/// <podcast:images srcset="https://example.com/1500.jpg 1500w, https://example.com/600.jpg 600w" />
/// ```
///
/// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/images-(deprecated).md
public typealias PodcastImages = XMLAttributesElement<PodcastImagesAttributes>
