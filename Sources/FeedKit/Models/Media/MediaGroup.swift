//
//  MediaGroup.swift
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

/// The <media:group> element is a sub-element of <item>. It allows grouping
/// of <media:content> elements that are effectively the same content,
/// yet different representations. For instance: the same song recorded
/// in both the WAV and MP3 format. It's an optional element that must
/// only be used for this purpose.
public struct MediaGroup: Codable, Equatable {
  /// <media:content> is a sub-element of either <item> or <media:group>.
  /// Media objects that are not the same content should not be included
  /// in the same <media:group> element. The sequence of these items implies
  /// the order of presentation. While many of the attributes appear to be
  /// audio/video specific, this element can be used to publish any type of
  /// media. It contains 14 attributes, most of which are optional.
  public var contents: [MediaContent]?

  /// Notable entity and the contribution to the creation of the media object.
  /// Current entities can include people, companies, locations, etc. Specific
  /// entities can have multiple roles, and several entities can have the same
  /// role. These should appear as distinct <media:credit> elements. It has two
  /// optional attributes.
  public var credits: [MediaCredit]?

  /// Allows a taxonomy to be set that gives an indication of the type of media
  /// content, and its particular contents. It has two optional attributes.
  public var category: MediaCategory?

  /// This allows the permissible audience to be declared. If this element is not
  /// included, it assumes that no restrictions are necessary. It has one
  /// optional attribute.
  public var rating: MediaRating?

  public init(
    contents: [MediaContent]? = nil,
    credits: [MediaCredit]? = nil,
    category: MediaCategory? = nil,
    rating: MediaRating? = nil) {
    self.contents = contents
    self.credits = credits
    self.category = category
    self.rating = rating
  }
}
