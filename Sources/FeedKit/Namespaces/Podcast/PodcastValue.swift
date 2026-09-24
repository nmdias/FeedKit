//
// PodcastValue.swift
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

// MARK: - Value Recipient

/// Attributes for the `<podcast:valueRecipient>` element.
public struct PodcastValueRecipientAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(
    name: String? = nil,
    customKey: String? = nil,
    customValue: String? = nil,
    type: String? = nil,
    address: String? = nil,
    split: Int? = nil,
    fee: Bool? = nil
  ) {
    self.name = name
    self.customKey = customKey
    self.customValue = customValue
    self.type = type
    self.address = address
    self.split = split
    self.fee = fee
  }

  // MARK: Public

  /// A free-form string that designates who or what this recipient is.
  public var name: String?

  /// The name of a custom record key to send along with the payment.
  public var customKey: String?

  /// A custom value to pass along with the payment.
  public var customValue: String?

  /// A slug that represents the type of receiving address.
  ///
  /// Known values are `node` and `lnaddress`.
  public var type: String?

  /// The receiving address of the payee.
  public var address: String?

  /// The number of shares of the payment this recipient will receive.
  public var split: Int?

  /// Whether this recipient is a fee. Assumed to be false when absent.
  public var fee: Bool?
}

/// A destination for payments sent during consumption of the enclosed media.
///
/// Example:
/// ```xml
/// <podcast:valueRecipient name="Alice (Podcaster)" type="node" address="02d5c1bf..." split="40" />
/// ```
///
/// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/value-recipient.md
public typealias PodcastValueRecipient = XMLAttributesElement<PodcastValueRecipientAttributes>

// MARK: - Remote Item

/// Attributes for the `<podcast:remoteItem>` element.
public struct PodcastRemoteItemAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(
    feedGuid: String? = nil,
    feedURL: String? = nil,
    itemGuid: String? = nil,
    medium: String? = nil,
    title: String? = nil
  ) {
    self.feedGuid = feedGuid
    self.feedURL = feedURL
    self.itemGuid = itemGuid
    self.medium = medium
    self.title = title
  }

  // MARK: Public

  /// The `<podcast:guid>` of the remote feed being pointed to.
  public var feedGuid: String?

  /// The url of the remote feed being pointed to.
  public var feedURL: String?

  /// The value of the `<guid>` of the remote `<item>` being pointed to.
  public var itemGuid: String?

  /// The `<podcast:medium>` type of the feed being pointed to.
  public var medium: String?

  /// A hint that lets apps display a title without a remote lookup.
  public var title: String?

  // MARK: Private

  /// The attribute spellings of the specification differ from the Swift names
  /// for the url, so they are pinned explicitly.
  private enum CodingKeys: String, CodingKey {
    case feedGuid
    case feedURL = "feedUrl"
    case itemGuid
    case medium
    case title
  }
}

/// Points to another feed, or an item in another feed, in order to obtain some
/// sort of data that the other feed has.
///
/// Example:
/// ```xml
/// <podcast:remoteItem feedGuid="917393e3-1b1e-5cef-ace4-edaa54e1f810" />
/// ```
///
/// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/remote-item.md
public typealias PodcastRemoteItem = XMLAttributesElement<PodcastRemoteItemAttributes>

// MARK: - Value Time Split

/// Attributes for the `<podcast:valueTimeSplit>` element.
public struct PodcastValueTimeSplitAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(
    startTime: TimeInterval? = nil,
    duration: TimeInterval? = nil,
    remoteStartTime: TimeInterval? = nil,
    remotePercentage: Double? = nil
  ) {
    self.startTime = startTime
    self.duration = duration
    self.remoteStartTime = remoteStartTime
    self.remotePercentage = remotePercentage
  }

  // MARK: Public

  /// The time, in seconds, to stop using the currently active value recipient
  /// information and start using the information contained in this element.
  public var startTime: TimeInterval?

  /// How many seconds the playback app should use this element's value
  /// recipient information before switching back to the parent feed's.
  public var duration: TimeInterval?

  /// The time in the remote item where the value split begins. Defaults to 0.
  public var remoteStartTime: TimeInterval?

  /// The percentage of the payment the remote recipients will receive when a
  /// remote item is present. Defaults to 100.
  public var remotePercentage: Double?
}

/// Alternative value recipients for a certain period of the media.
///
/// A value time split contains either one or more `<podcast:valueRecipient>`
/// elements or exactly one `<podcast:remoteItem>` element whose own value block
/// supplies the recipients.
///
/// Example:
/// ```xml
/// <podcast:valueTimeSplit startTime="60" duration="237" remotePercentage="95">
///   <podcast:remoteItem itemGuid="..." feedGuid="..." medium="music" />
/// </podcast:valueTimeSplit>
/// ```
///
/// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/value-time-split.md
public struct PodcastValueTimeSplit: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(
    startTime: TimeInterval? = nil,
    duration: TimeInterval? = nil,
    remoteStartTime: TimeInterval? = nil,
    remotePercentage: Double? = nil,
    recipients: [PodcastValueRecipient]? = nil,
    remoteItem: PodcastRemoteItem? = nil
  ) {
    self.startTime = startTime
    self.duration = duration
    self.remoteStartTime = remoteStartTime
    self.remotePercentage = remotePercentage
    self.recipients = recipients
    self.remoteItem = remoteItem
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
    let attributes: PodcastValueTimeSplitAttributes? = try container.decodeIfPresent(
      PodcastValueTimeSplitAttributes.self,
      forKey: CodingKeys.attributes
    )

    startTime = attributes?.startTime
    duration = attributes?.duration
    remoteStartTime = attributes?.remoteStartTime
    remotePercentage = attributes?.remotePercentage

    recipients = try container.decodeIfPresent([PodcastValueRecipient].self, forKey: CodingKeys.recipients)
    remoteItem = try container.decodeIfPresent(PodcastRemoteItem.self, forKey: CodingKeys.remoteItem)
  }

  // MARK: Public

  /// The time, in seconds, to stop using the currently active value recipient
  /// information and start using the information contained in this element.
  public var startTime: TimeInterval?

  /// How many seconds the playback app should use this element's value
  /// recipient information before switching back to the parent feed's.
  public var duration: TimeInterval?

  /// The time in the remote item where the value split begins.
  public var remoteStartTime: TimeInterval?

  /// The percentage of the payment the remote recipients will receive.
  public var remotePercentage: Double?

  /// The recipients of the split, when the split is not remote.
  public var recipients: [PodcastValueRecipient]?

  /// The remote item whose value block supplies the recipients of the split.
  public var remoteItem: PodcastRemoteItem?

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)

    try container.encodeIfPresent(PodcastValueTimeSplitAttributes(
      startTime: startTime,
      duration: duration,
      remoteStartTime: remoteStartTime,
      remotePercentage: remotePercentage
    ), forKey: CodingKeys.attributes)
    try container.encodeIfPresent(recipients, forKey: CodingKeys.recipients)
    try container.encodeIfPresent(remoteItem, forKey: CodingKeys.remoteItem)
  }

  // MARK: Private

  private enum CodingKeys: String, CodingKey {
    case attributes = "@attributes"
    case recipients = "podcast:valueRecipient"
    case remoteItem = "podcast:remoteItem"
  }
}

// MARK: - Podroll

/// References to one or more podcasts, as a way of "recommending" other
/// podcasts to the listener.
///
/// The node value is one or more `<podcast:remoteItem>` elements.
///
/// Example:
/// ```xml
/// <podcast:podroll>
///   <podcast:remoteItem feedGuid="29cdca4a-32d8-56ba-b48b-09a011c5daa9" />
/// </podcast:podroll>
/// ```
///
/// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/podroll.md
public struct PodcastPodroll: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(remoteItems: [PodcastRemoteItem]? = nil) {
    self.remoteItems = remoteItems
  }

  // MARK: Public

  /// The remote feeds being recommended.
  public var remoteItems: [PodcastRemoteItem]?

  // MARK: Private

  private enum CodingKeys: String, CodingKey {
    case remoteItems = "podcast:remoteItem"
  }
}

// MARK: - Publisher

/// A link from a podcast feed to its "publisher feed" parent.
///
/// The node value is exactly one `<podcast:remoteItem medium="publisher">`
/// element pointing to the publisher feed.
///
/// Example:
/// ```xml
/// <podcast:publisher>
///   <podcast:remoteItem medium="publisher" feedGuid="003af0a0-6a45-55cf-b765-68e3d349551a" feedUrl="https://example.com/publisher.xml" />
/// </podcast:publisher>
/// ```
///
/// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/publisher.md
public struct PodcastPublisher: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(remoteItem: PodcastRemoteItem? = nil) {
    self.remoteItem = remoteItem
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

    remoteItem = try container.decodeIfPresent(PodcastRemoteItem.self, forKey: CodingKeys.remoteItem)
  }

  // MARK: Public

  /// The publisher feed being pointed to.
  public var remoteItem: PodcastRemoteItem?

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)

    try container.encodeIfPresent(remoteItem, forKey: CodingKeys.remoteItem)
  }

  // MARK: Private

  private enum CodingKeys: String, CodingKey {
    case remoteItem = "podcast:remoteItem"
  }
}

// MARK: - Value

/// Attributes for the `<podcast:value>` element.
public struct PodcastValueAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(type: String? = nil, method: String? = nil, suggested: Double? = nil) {
    self.type = type
    self.method = method
    self.suggested = suggested
  }

  // MARK: Public

  /// The service slug of the cryptocurrency or protocol layer.
  ///
  /// Example: `lightning`
  public var type: String?

  /// The transport mechanism that will be used.
  ///
  /// Example: `keysend`
  public var method: String?

  /// A suggestion on how much cryptocurrency to send with each payment.
  public var suggested: Double?
}

/// Designates the cryptocurrency or payment layer that will be used, the
/// transport method for transacting payments, and a suggested amount.
///
/// Example:
/// ```xml
/// <podcast:value type="lightning" method="keysend" suggested="0.00000005000">
///   <podcast:valueRecipient name="podcaster" type="node" address="036557ea..." split="99" />
/// </podcast:value>
/// ```
///
/// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/value.md
public struct PodcastValue: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(
    type: String? = nil,
    method: String? = nil,
    suggested: Double? = nil,
    recipients: [PodcastValueRecipient]? = nil,
    timeSplits: [PodcastValueTimeSplit]? = nil
  ) {
    self.type = type
    self.method = method
    self.suggested = suggested
    self.recipients = recipients
    self.timeSplits = timeSplits
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
    let attributes: PodcastValueAttributes? = try container.decodeIfPresent(
      PodcastValueAttributes.self,
      forKey: CodingKeys.attributes
    )

    type = attributes?.type
    method = attributes?.method
    suggested = attributes?.suggested

    recipients = try container.decodeIfPresent([PodcastValueRecipient].self, forKey: CodingKeys.recipients)
    timeSplits = try container.decodeIfPresent([PodcastValueTimeSplit].self, forKey: CodingKeys.timeSplits)
  }

  // MARK: Public

  /// The service slug of the cryptocurrency or protocol layer.
  public var type: String?

  /// The transport mechanism that will be used.
  public var method: String?

  /// A suggestion on how much cryptocurrency to send with each payment.
  public var suggested: Double?

  /// The destinations for payments sent during consumption of the enclosed
  /// media.
  public var recipients: [PodcastValueRecipient]?

  /// Alternative value recipients for certain periods of the media.
  public var timeSplits: [PodcastValueTimeSplit]?

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)

    try container.encodeIfPresent(PodcastValueAttributes(
      type: type,
      method: method,
      suggested: suggested
    ), forKey: CodingKeys.attributes)
    try container.encodeIfPresent(recipients, forKey: CodingKeys.recipients)
    try container.encodeIfPresent(timeSplits, forKey: CodingKeys.timeSplits)
  }

  // MARK: Private

  private enum CodingKeys: String, CodingKey {
    case attributes = "@attributes"
    case recipients = "podcast:valueRecipient"
    case timeSplits = "podcast:valueTimeSplit"
  }
}
