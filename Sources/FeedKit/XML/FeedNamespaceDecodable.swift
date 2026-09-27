//
// FeedNamespaceDecodable.swift
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

/// A group of elements that belong to one XML namespace.
///
/// A namespace is not an element: `dc:title` and `dc:creator` are children of
/// the element that *uses* Dublin Core, not children of a `<dc>` element. The
/// protocol tells the decoder which prefix to look for, so a type such as
/// ``DublinCore`` can be read from its parent element and be `nil` when the
/// document has no elements in that namespace.
public protocol FeedNamespaceDecodable: Decodable {
  /// The prefix the namespace's elements are written with, e.g. `"dc"`.
  static var namespacePrefix: String { get }
}

extension Decoder {
  /// Decodes a namespace group from the element this decoder is positioned at,
  /// or `nil` when that element has no children in the namespace.
  func decodeNamespace<Namespace: FeedNamespaceDecodable>(_: Namespace.Type) throws -> Namespace? {
    guard try feedHasKey(withPrefix: Namespace.namespacePrefix + ":") else {
      return nil
    }
    return try Namespace(from: self)
  }
}
