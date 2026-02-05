//
// RSSFeedCloud.swift
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

/// The attributes of the `<channel>`'s `<cloud>` element.
public struct RSSFeedCloudAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(
    domain: String? = nil,
    port: Int? = nil,
    path: String? = nil,
    registerProcedure: String? = nil,
    protocol: String? = nil
  ) {
    self.domain = domain
    self.port = port
    self.path = path
    self.registerProcedure = registerProcedure
    self.protocol = `protocol`
  }

  // MARK: Public

  /// The domain to register notification to.
  public var domain: String?

  /// The port to connect to.
  public var port: Int?

  /// The path to the RPC service. e.g. "/RPC2".
  public var path: String?

  /// The procedure to call. e.g. "myCloud.rssPleaseNotify" .
  public var registerProcedure: String?

  /// The `protocol` specification. Can be HTTP-POST, XML-RPC or SOAP 1.1 -
  /// Note: "protocol" is a reserved keyword, so `protocolSpecification`
  /// is used instead and refers to the `protocol` attribute of the `cloud`
  /// element.
  public var `protocol`: String?
}

// Allows processes to register with a cloud to be notified of updates to
// the channel, implementing a lightweight publish-subscribe protocol for
// RSS feeds.
//
// Example: <cloud domain="rpc.sys.com" port="80" path="/RPC2" registerProcedure="pingMe" protocol="soap"/>
//
// <cloud> is an optional sub-element of <channel>.
//
// It specifies a web service that supports the rssCloud interface which can
// be implemented in HTTP-POST, XML-RPC or SOAP 1.1.
//
// Its purpose is to allow processes to register with a cloud to be notified
// of updates to the channel, implementing a lightweight publish-subscribe
// protocol for RSS feeds.
//
// <cloud domain="rpc.sys.com" port="80" path="/RPC2" registerProcedure="myCloud.rssPleaseNotify" protocol="xml-rpc" />
//
// In this example, to request notification on the channel it appears in,
// you would send an XML-RPC message to rpc.sys.com on port 80, with a path
// of /RPC2. The procedure to call is myCloud.rssPleaseNotify.
//
// A full explanation of this element and the rssCloud interface is here:
// http://cyber.law.harvard.edu/rss/soapMeetsRss.html#rsscloudInterface

public typealias RSSFeedCloud = XMLAttributesElement<RSSFeedCloudAttributes>
