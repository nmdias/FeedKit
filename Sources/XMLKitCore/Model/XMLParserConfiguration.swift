//
//  XMLParserConfiguration.swift
//  XMLKit
//

import Foundation

/// Limits and strictness settings shared by every XMLKit entry point.
///
/// This type exists so that ``XMLDecoder``, ``XMLEncoder`` and ``XMLDocument``
/// all agree on safety limits. A document rejected by one must not be silently
/// accepted by another, and duplicating the defaults in three places would
/// guarantee eventual drift.
///
/// The defaults are chosen to accept every real-world document while making
/// resource-exhaustion attacks impossible. See `SECURITY.md`.
public struct XMLParserConfiguration: Sendable, Hashable {
    /// The default maximum element nesting depth.
    ///
    /// 256 is far deeper than any hand-written or machine-generated document
    /// that a `Codable` type could describe, and shallow enough that even a
    /// per-level cost of a kilobyte stays well within a modest memory budget.
    public static let defaultMaxDepth = 256

    /// The default maximum number of attributes on a single element.
    ///
    /// Bounds the cost of the duplicate-name check, which compares a candidate
    /// against every name already seen on the element. Without a bound, a
    /// document with a million attributes on one element would be quadratic.
    public static let defaultMaxAttributesPerElement = 4_096

    /// The default maximum length of a single name, in bytes.
    public static let defaultMaxNameLength = 1_024

    /// The deepest element nesting permitted before
    /// ``XMLParserError/maximumDepthExceeded(limit:position:)`` is thrown.
    public var maxDepth: Int

    /// The greatest number of attributes permitted on one element.
    public var maxAttributesPerElement: Int

    /// The greatest length, in bytes, permitted for an element or attribute
    /// name.
    public var maxNameLength: Int

    /// Creates a configuration.
    public init(
        maxDepth: Int = XMLParserConfiguration.defaultMaxDepth,
        maxAttributesPerElement: Int = XMLParserConfiguration.defaultMaxAttributesPerElement,
        maxNameLength: Int = XMLParserConfiguration.defaultMaxNameLength
    ) {
        self.maxDepth = maxDepth
        self.maxAttributesPerElement = maxAttributesPerElement
        self.maxNameLength = maxNameLength
    }

    /// The default configuration.
    public static let `default` = XMLParserConfiguration()
}
