//
// XMLNamespaceHandling.swift
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

/// Controls how elements using a namespace prefix that was never declared
/// via an `xmlns`/`xmlns:*` attribute are treated during decoding.
public enum XMLNamespaceHandling: Sendable {
  /// Resolve elements by their declared namespace URI when possible. When a
  /// prefix's namespace was never declared, fall back to matching it by its
  /// literal prefix text, tolerating real-world feeds that use a
  /// conventional prefix (e.g. `content:`, `dc:`) without declaring it.
  case lenient

  /// Resolve elements strictly by their declared namespace URI. Elements
  /// using a conventional prefix without a matching `xmlns` declaration are
  /// treated as if absent, rather than being matched by prefix text alone.
  case strict
}

extension XMLNode {
  /// Rewrites this node's subtree in place so elements whose namespace URI
  /// resolves to a known namespace use that namespace's canonical prefix,
  /// regardless of which prefix the source document actually declared it
  /// with (e.g. `<cnt:encoded>` bound to the content module URI becomes
  /// `<content:encoded>`, matching what `Content`'s `CodingKeys` expects).
  ///
  /// Only prefixed elements participate. Unprefixed elements are left
  /// untouched, since they are either plain, non-namespaced content or
  /// content in a document's default namespace (e.g. Atom's core elements),
  /// neither of which should be rewritten.
  ///
  /// - Parameters:
  ///   - uriToPrefix: A map of namespace URI to canonical prefix.
  ///   - knownPrefixes: The canonical prefixes present in `uriToPrefix`,
  ///     used under `.strict` handling to recognize elements that look like
  ///     a known namespace but were never declared.
  ///   - handling: How to treat elements whose namespace was never declared.
  func canonicalizingNamespaces(
    uriToPrefix: [String: String],
    knownPrefixes: Set<String>,
    handling: XMLNamespaceHandling
  ) {
    // Walked iteratively (rather than recursively) so arbitrarily deep or
    // wide trees can never risk a stack overflow.
    var pending: [XMLNode] = [self]
    while let node = pending.popLast() {
      if let prefix = node.prefix {
        if let namespaceURI = node.namespaceURI, let canonicalPrefix = uriToPrefix[namespaceURI] {
          if canonicalPrefix != prefix {
            node.rename(toPrefix: canonicalPrefix)
          }
        } else if node.namespaceURI == nil, handling == .strict, knownPrefixes.contains(prefix) {
          node.rename(toPrefix: "\(XMLNode.unresolvedPrefixMarker)\(prefix)")
        }
      }

      if let children = node.children {
        pending.append(contentsOf: children)
      }
    }
  }

  /// A prefix marker guaranteed not to match any namespaced `CodingKeys`,
  /// used by `.strict` handling to hide elements with an undeclared,
  /// conventionally-prefixed namespace from decoding.
  private static let unresolvedPrefixMarker = "unresolved.namespace."

  /// Rewrites `prefix` and the prefix portion of `name` to `newPrefix`.
  private func rename(toPrefix newPrefix: String) {
    let localName: String
    if let colonIndex = name.firstIndex(of: ":") {
      localName = String(name[name.index(after: colonIndex)...])
    } else {
      localName = name
    }
    prefix = newPrefix
    name = "\(newPrefix):\(localName)"
  }
}
