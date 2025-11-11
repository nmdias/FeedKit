import Foundation
import XMLKit

/// The podcast namespace
///
/// See https://github.com/Podcastindex-org/podcast-namespace
public struct Podcast {
  // MARK: Lifecycle

  public init(
    guid: String? = nil

  ) {
    self.guid = guid
  }

  // MARK: Public
  /// This element is used to declare a unique, global identifier for a podcast. 
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/guid.md
  public var guid: String?
}

// MARK: - XMLNamespaceDecodable

extension Podcast: XMLNamespaceCodable {}

// MARK: - Sendable

extension Podcast: Sendable {}

// MARK: - Equatable

extension Podcast: Equatable {}

// MARK: - Hashable

extension Podcast: Hashable {}

// MARK: - Codable

extension Podcast: Codable {
  private enum CodingKeys: String, CodingKey {
    case guid = "podcast:guid"
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(
      keyedBy: CodingKeys.self)

    guid = try container.decodeIfPresent(String.self, forKey: CodingKeys.guid)
  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)

    try container.encodeIfPresent(guid, forKey: CodingKeys.guid)
  }
}
