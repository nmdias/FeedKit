//
// XMLNamespaceKeyKnowledge.swift
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

/// What decoding has learned about the keys of one coding-key type.
///
/// `KeyedDecodingContainerProtocol.contains(_:)` has to answer for a key such as
/// `meta` before any value has been decoded at it, and the answer depends on the
/// type that key holds, which the key alone does not reveal. A key whose type
/// conforms to `XMLNamespaceCodable` is present when the element carries that
/// namespace, as `meta` is by `<meta:title>`; a key holding an ordinary element of
/// the same name is not, however many other keys of the document are spelled
/// with a prefix that matches it.
///
/// That mapping from a key to its type is fixed by the model source, not by the
/// document, so it is learned once for the whole process and read back for every
/// later document. Only a key the element does not name is recorded, since a key
/// the element names answers `contains(_:)` from the child.
///
/// The knowledge is kept per coding-key type rather than per key name, because
/// the same name can hold different types in different models: whether `content`
/// is carried by a namespace is a property of the model that declares the key,
/// not of the spelling of the key.
final class XMLNamespaceKeyKnowledge: @unchecked Sendable {
  // MARK: Lifecycle

  private init() {}

  // MARK: Internal

  /// What is known about one coding-key type.
  ///
  /// A copy shares its storage with the store it came from, so taking a snapshot
  /// costs a retain and nothing else.
  struct Snapshot {
    // MARK: Internal

    /// Whether the key holds an `XMLNamespaceCodable` container, or `nil` when
    /// nothing has decoded a value at that key yet.
    func holdsNamespaceContainer(_ name: String) -> Bool? {
      kinds[name]
    }

    // MARK: Fileprivate

    fileprivate var kinds: [String: Bool] = [:]
  }

  /// The knowledge shared by every decoder.
  static let shared: XMLNamespaceKeyKnowledge = .init()

  /// How many facts have been recorded, so that a caller can tell whether
  /// anything was learned while it was running.
  var recorded: Int {
    lock.lock()
    defer { lock.unlock() }
    return generation
  }

  /// The knowledge about `Key`, as of now.
  func snapshot<Key: CodingKey>(for _: Key.Type) -> Snapshot {
    lock.lock()
    defer { lock.unlock() }
    return snapshots[ObjectIdentifier(Key.self)] ?? Snapshot()
  }

  /// Records whether the key `name` holds a namespace container.
  func record<Key: CodingKey>(for _: Key.Type, key name: String, isNamespaceContainer: Bool) {
    lock.lock()
    defer { lock.unlock() }

    let identifier: ObjectIdentifier = .init(Key.self)
    guard snapshots[identifier]?.kinds[name] != isNamespaceContainer else {
      return
    }
    snapshots[identifier, default: Snapshot()].kinds[name] = isNamespaceContainer
    generation += 1
  }

  // MARK: Private

  private let lock: NSLock = .init()

  /// The knowledge about each coding-key type, by that type's identity.
  private var snapshots: [ObjectIdentifier: Snapshot] = [:]

  /// How many facts have been recorded.
  private var generation: Int = 0
}
