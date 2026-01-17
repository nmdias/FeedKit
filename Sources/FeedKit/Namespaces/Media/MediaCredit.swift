//
// MediaCredit.swift
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

public struct MediaCreditAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(
    role: String? = nil,
    scheme: String? = nil
  ) {
    self.role = role
    self.scheme = scheme
  }

  // MARK: Public

  /// Specifies the role the entity played. Must be lowercase. It is an
  /// optional attribute.
  public var role: String?

  /// The URI that identifies the role scheme. It is an optional attribute
  /// and possible values for this attribute are ( urn:ebu | urn:yvs ) . The
  /// default scheme is "urn:ebu". The list of roles supported under urn:ebu
  /// scheme can be found at European Broadcasting Union Role Codes. The
  /// roles supported under urn:yvs scheme are ( uploader | owner ).
  public var scheme: String?
}

/// Notable entity and the contribution to the creation of the media object.
/// Current entities can include people, companies, locations, etc. Specific
/// entities can have multiple roles, and several entities can have the same
/// role. These should appear as distinct <media:credit> elements. It has two
/// optional attributes.
public typealias MediaCredit = XMLKit.XMLElement<MediaCreditAttributes>
