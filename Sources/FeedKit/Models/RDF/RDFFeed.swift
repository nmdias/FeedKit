//
//  RDFFeed.swift
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

public struct RDFFeed {
  public var channel: RDFFeedChannel?

  public init(channel: RDFFeedChannel? = nil) {
    self.channel = channel
  }
}

// MARK: - Equatable

extension RDFFeed: Equatable {}

// MARK: - Hashable

extension RDFFeed: Hashable {}

// MARK: - Codable

extension RDFFeed: Codable {
  private enum CodingKeys: CodingKey {
    case channel
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<RDFFeed.CodingKeys> = try decoder.container(keyedBy: RDFFeed.CodingKeys.self)

    channel = try container.decodeIfPresent(RDFFeedChannel.self, forKey: RDFFeed.CodingKeys.channel)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<RDFFeed.CodingKeys> = encoder.container(keyedBy: RDFFeed.CodingKeys.self)

    try container.encodeIfPresent(channel, forKey: RDFFeed.CodingKeys.channel)
  }
}

// MARK: - FeedInitializable

extension RDFFeed: FeedInitializable {
  init(data: Data) throws {
    let parser = FeedKit.XMLParser(data: data)
    let result = try parser.parse().get()

    guard let rootNode = result.root else {
      throw XMLError.unexpected(reason: "Unexpected parsing result. Root node is nil.")
    }

    let decoder = XMLDecoder()
    decoder.dateDecodingStrategy = .formatter(FeedDateFormatter(spec: .permissive))
    self = try decoder.decode(Self.self, from: rootNode)
  }
}

extension RDFFeed: XMLStringConvertible {
  func toXMLString(formatted: Bool, indentationLevel: Int = 1) throws -> String {
    fatalError()
  }
}
