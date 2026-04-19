//
// KeyedDecodingContainer + LossyValues.swift
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

extension KeyedDecodingContainer {
  func decodeLossyIfPresent(_ type: Int64.Type, forKey key: Key, lossy: Bool) throws -> Int64? {
    if !lossy {
      return try decodeIfPresent(Int64.self, forKey: key)
    }

    if let value = try? decodeIfPresent(Int64.self, forKey: key) {
      return value
    }

    guard let value = try? decodeIfPresent(String.self, forKey: key)?
      .trimmingCharacters(in: .whitespacesAndNewlines),
      !value.isEmpty
    else {
      return nil
    }

    return Int64(value)
  }

  func decodeLossyIfPresent(_ type: Int.Type, forKey key: Key, lossy: Bool) throws -> Int? {
    if !lossy {
      return try decodeIfPresent(Int.self, forKey: key)
    }

    if let value = try? decodeIfPresent(Int.self, forKey: key) {
      return value
    }

    guard let value = try? decodeIfPresent(String.self, forKey: key)?
      .trimmingCharacters(in: .whitespacesAndNewlines),
      !value.isEmpty
    else {
      return nil
    }

    return Int(value)
  }

  func decodeLossyIfPresent(_ type: Double.Type, forKey key: Key, lossy: Bool) throws -> Double? {
    if !lossy {
      return try decodeIfPresent(Double.self, forKey: key)
    }

    if let value = try? decodeIfPresent(Double.self, forKey: key) {
      return value
    }

    guard let value = try? decodeIfPresent(String.self, forKey: key)?
      .trimmingCharacters(in: .whitespacesAndNewlines),
      !value.isEmpty
    else {
      return nil
    }

    return Double(value)
  }

  func decodeLossyIfPresent(_ type: Bool.Type, forKey key: Key, lossy: Bool) throws -> Bool? {
    if !lossy {
      return try decodeIfPresent(Bool.self, forKey: key)
    }

    if let value = try? decodeIfPresent(Bool.self, forKey: key) {
      return value
    }

    guard let value = try? decodeIfPresent(String.self, forKey: key)?
      .trimmingCharacters(in: .whitespacesAndNewlines),
      !value.isEmpty
    else {
      return nil
    }

    return value.toBool()
  }
}

enum FeedDecodingContext {
  private static let key = "FeedKit.feedLossyDecoding"

  static var isLossyDecodingEnabled: Bool {
    Thread.current.threadDictionary[key] as? Bool ?? false
  }

  static func withLossyDecoding<T>(_ lossy: Bool, perform operation: () throws -> T) rethrows -> T {
    let previousValue = Thread.current.threadDictionary[key]
    Thread.current.threadDictionary[key] = lossy
    defer {
      if let previousValue {
        Thread.current.threadDictionary[key] = previousValue
      } else {
        Thread.current.threadDictionary.removeObject(forKey: key)
      }
    }
    return try operation()
  }
}

extension Decoder {
  var isFeedLossyDecodingEnabled: Bool {
    FeedDecodingContext.isLossyDecodingEnabled
  }
}
