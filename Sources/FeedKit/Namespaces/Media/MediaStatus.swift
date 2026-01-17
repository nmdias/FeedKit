//
// MediaStatus.swift
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

public struct MediaStatusAttributes: Codable, Equatable, Hashable, Sendable {
  // MARK: Lifecycle

  public init(
    state: String? = nil,
    reason: String? = nil
  ) {
    self.state = state
    self.reason = reason
  }

  // MARK: Public

  /// State can have values "active", "blocked" or "deleted". "active" means
  /// a media object is active in the system, "blocked" means a media object
  /// is blocked by the publisher, "deleted" means a media object has been
  /// deleted by the publisher.
  public var state: String?

  /// A reason explaining why a media object has been blocked/deleted. It can
  /// be plain text or a URL.
  public var reason: String?
}

/// Optional tag to specify the status of a media object -- whether it's still
/// active or it has been blocked/deleted.
public typealias MediaStatus = XMLAttributesElement<MediaStatusAttributes>
