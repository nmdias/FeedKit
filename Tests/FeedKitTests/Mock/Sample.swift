//
//  Sample.swift
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

@testable import FeedKit

import Foundation

struct Sample: Codable, Equatable {
  struct Header: Codable, Equatable {
    struct Keywords: Codable, Equatable {
      let keyword: [String]
    }

    let title: String
    let description: String
    let version: String
    let keywords: Keywords
  }

  struct Content: Codable, Equatable {
    struct Item: Equatable {
      struct Attributes: Codable, Equatable {
        let id: Int
        let value: String
      }

      struct Details: Codable, Equatable {
        let detail: [String]
      }

      let attributes: Attributes
      let name: String
      let description: String
      let precision: Double
      let details: Details
    }

    let item: [Item]
  }

  struct Footer: Codable, Equatable {
    let notes: String
    let created: String
    let revision: Int
  }

  let header: Header
  let content: Content
  let footer: Footer
}

extension Sample.Content.Item: Codable {
  private enum CodingKeys: String, CodingKey {
    case attributes
    case name
    case description
    case precision
    case details
  }

  init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<Sample.Content.Item.CodingKeys> = try decoder.container(keyedBy: Sample.Content.Item.CodingKeys.self)

    attributes = try container.decode(Sample.Content.Item.Attributes.self, forKey: Sample.Content.Item.CodingKeys.attributes)
    name = try container.decode(String.self, forKey: Sample.Content.Item.CodingKeys.name)
    description = try container.decode(String.self, forKey: Sample.Content.Item.CodingKeys.description)
    precision = try container.decode(Double.self, forKey: Sample.Content.Item.CodingKeys.precision)
    details = try container.decode(Sample.Content.Item.Details.self, forKey: Sample.Content.Item.CodingKeys.details)
  }

  func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<Sample.Content.Item.CodingKeys> = encoder.container(keyedBy: Sample.Content.Item.CodingKeys.self)

    try container.encode(attributes, forKey: Sample.Content.Item.CodingKeys.attributes)
    try container.encode(name, forKey: Sample.Content.Item.CodingKeys.name)
    try container.encode(description, forKey: Sample.Content.Item.CodingKeys.description)
    try container.encode(precision, forKey: Sample.Content.Item.CodingKeys.precision)
    try container.encode(details, forKey: Sample.Content.Item.CodingKeys.details)
  }
}

//  private enum CodingKeys: CodingKey {
//    case attributes
//    case id
//    case value
//    case name
//    case description
//    case precision
//    case details
//  }
//
//  init(from decoder: any Decoder) throws {
//    let container: KeyedDecodingContainer<Sample.Content.Item.CodingKeys> = try decoder.container(keyedBy: Sample.Content.Item.CodingKeys.self)
//
////    if let xmlDecoder = decoder as? XMLDecoder {
//////      name = try container.decode(String.self, forKey: Sample.Content.Item.CodingKeys.name)
////
////      if let dictionary = xmlDecoder.stack.top()?.attributes {
////        guard let idString = dictionary[CodingKeys.id.stringValue],
////              let id = Int(idString),
////              let value = dictionary[CodingKeys.value.stringValue] else {
////          throw DecodingError.dataCorruptedError(
////            forKey: .attributes,
////            in: container,
////            debugDescription: "Invalid attributes format. Expected 'id' and 'value'."
////          )
////        }
////
//////        attributes = .init(id: id, value: value)
////      } else {
////        throw DecodingError.dataCorruptedError(
////          forKey: .attributes,
////          in: container,
////          debugDescription: "Missing attributes in XML."
////        )
////      }
////    }
//
//    attributes = try container.decode(Sample.Content.Item.Attributes.self, forKey: Sample.Content.Item.CodingKeys.attributes)
//    name = try container.decode(String.self, forKey: Sample.Content.Item.CodingKeys.name)
//    description = try container.decode(String.self, forKey: Sample.Content.Item.CodingKeys.description)
//    precision = try container.decode(Double.self, forKey: Sample.Content.Item.CodingKeys.precision)
//    details = try container.decode(Sample.Content.Item.Details.self, forKey: Sample.Content.Item.CodingKeys.details)
//  }
//
//  func encode(to encoder: any Encoder) throws {
//    var container: KeyedEncodingContainer<Sample.Content.Item.CodingKeys> = encoder.container(keyedBy: Sample.Content.Item.CodingKeys.self)
//
//    try container.encode(attributes, forKey: Sample.Content.Item.CodingKeys.attributes)
//    try container.encode(name, forKey: Sample.Content.Item.CodingKeys.name)
//    try container.encode(description, forKey: Sample.Content.Item.CodingKeys.description)
//    try container.encode(precision, forKey: Sample.Content.Item.CodingKeys.precision)
//    try container.encode(details, forKey: Sample.Content.Item.CodingKeys.details)
//  }
// }
