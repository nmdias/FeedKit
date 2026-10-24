//
// XMLNamespaceCodable.swift
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

/// A protocol indicating a type can be encoded or decoded in an XML namespace.
///
/// Types conforming to `XMLNamespaceCodable` allow `XMLEncoder` and `XMLDecoder`
/// to handle properties tied to specific XML namespaces. This ensures elements
/// belonging to namespaces are encoded or decoded into keyed structures, even
/// if the XML elements exist at the same depth.
///
/// ### Example
/// For an XML structure with elements in different namespaces:
///
/// ```xml
/// <root>
///     <meta:title>Sample Title</meta:title>
///     <meta:creator>Author</meta:creator>
///     <doc:revised>2024-12-05</doc:revised>
/// </root>
/// ```
///
/// A struct conforming to `XMLNamespaceCodable` can represent the data:
///
/// ```swift
/// struct Document: Codable {
///     struct Meta: Codable, XMLNamespaceCodable {
///         let title: String
///         let creator: String
///
///         private enum CodingKeys: String, CodingKey {
///             case title = "meta:title"
///             case creator = "meta:creator"
///         }
///     }
///
///     struct Doc: Codable, XMLNamespaceCodable {
///         let revised: String
///
///         private enum CodingKeys: String, CodingKey {
///             case revised = "doc:revised"
///         }
///     }
///
///     let meta: Meta
///     let doc: Doc
///
///     private enum CodingKeys: String, CodingKey {
///         case meta = "meta"
///         case doc = "doc"
///     }
/// }
/// ```
///
/// Using `XMLEncoder` or `XMLDecoder`, the `meta` and `doc` properties will map
/// to their respective namespaces (`meta:` and `doc:`) while maintaining their
/// association within the keyed structure of `Document`.
///
/// The `XMLNamespaceCodable` protocol is optional and primarily intended for models where
/// elements are grouped under specific namespaces. It is useful for extensive
/// models that require clear separation and organization of elements based on
/// their namespaces. For simpler use cases, direct encoding and decoding without
/// this protocol might suffice.
public protocol XMLNamespaceCodable {}
