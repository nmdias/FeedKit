//
//  RSSFeedTextInput.swift
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

/// Specifies a text input box that can be displayed with the channel.
///
/// A channel may optionally contain a <textInput> sub-element, which contains
/// four required sub-elements.
///
/// <title> -- The label of the Submit button in the text input area.
///
/// <description> -- Explains the text input area.
///
/// <name> -- The name of the text object in the text input area.
///
/// <link> -- The URL of the CGI script that processes text input requests.
///
/// The purpose of the <textInput> element is something of a mystery. You can
/// use it to specify a search engine box. Or to allow a reader to provide
/// feedback. Most aggregators ignore it.
public struct RSSFeedTextInput {
  /// The label of the Submit button in the text input area.
  public var title: String?

  /// Explains the text input area.
  public var description: String?

  /// The name of the text object in the text input area.
  public var name: String?

  /// The URL of the CGI script that processes text input requests.
  public var link: String?

  public init(
    title: String? = nil,
    description: String? = nil,
    name: String? = nil,
    link: String? = nil) {
    self.title = title
    self.description = description
    self.name = name
    self.link = link
  }
}

// MARK: - Equatable

extension RSSFeedTextInput: Equatable {}

// MARK: - Hashable

extension RSSFeedTextInput: Hashable {}

// MARK: - Codable

extension RSSFeedTextInput: Codable {
  private enum CodingKeys: CodingKey {
    case title
    case description
    case name
    case link
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<RSSFeedTextInput.CodingKeys> = try decoder.container(keyedBy: RSSFeedTextInput.CodingKeys.self)

    title = try container.decodeIfPresent(String.self, forKey: RSSFeedTextInput.CodingKeys.title)
    description = try container.decodeIfPresent(String.self, forKey: RSSFeedTextInput.CodingKeys.description)
    name = try container.decodeIfPresent(String.self, forKey: RSSFeedTextInput.CodingKeys.name)
    link = try container.decodeIfPresent(String.self, forKey: RSSFeedTextInput.CodingKeys.link)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<RSSFeedTextInput.CodingKeys> = encoder.container(keyedBy: RSSFeedTextInput.CodingKeys.self)

    try container.encodeIfPresent(title, forKey: RSSFeedTextInput.CodingKeys.title)
    try container.encodeIfPresent(description, forKey: RSSFeedTextInput.CodingKeys.description)
    try container.encodeIfPresent(name, forKey: RSSFeedTextInput.CodingKeys.name)
    try container.encodeIfPresent(link, forKey: RSSFeedTextInput.CodingKeys.link)
  }
}
