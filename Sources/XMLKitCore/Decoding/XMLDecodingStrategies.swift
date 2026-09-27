//
//  XMLDecodingStrategies.swift
//  XMLKit
//

import Foundation

// MARK: - Attribute and text conventions

/// How ``XMLDecoder`` and ``XMLEncoder`` name attributes and text content.
///
/// ## Why a convention is needed at all
///
/// `Codable`'s keyed container is a flat namespace of names to values. XML has
/// *three* channels on a single element — attributes, child elements, and text —
/// and nothing in `Codable` distinguishes them. A coding key must therefore carry
/// the channel as well as the name.
///
/// XMLKit uses explicit, validated sigils rather than a heuristic:
///
/// | Channel | Coding key | Why |
/// |---|---|---|
/// | Attribute | `@name` | `@` is not a legal XML name character, so an attribute key can never collide with an element name |
/// | Text | `#text` | `#` is likewise illegal in a name, so no collision is possible |
/// | Namespace declaration | `xmlns` / `xmlns:p` | These *are* the real attribute names, so no convention is invented |
/// | Child element | `name` | The common case needs no sigil, which keeps ordinary documents clean |
///
/// The sigils are checked in both directions, so a document whose element is
/// literally named `@foo` is impossible by construction: the parser would have
/// rejected the name before the decoder ever saw it. This is why the convention
/// is safe rather than merely conventional.
public enum XMLKeyConvention {
    /// The sigil that marks an attribute coding key.
    public static let attributeSigil = "@"

    /// The reserved key for an element's text content.
    public static let textKey = "#text"

    /// The reserved key for a CDATA section's content.
    ///
    /// Distinct from ``textKey`` only on *encoding*, where it selects the CDATA
    /// lexical form. On decoding both produce the same text, because a CDATA
    /// section and a text node carry identical content.
    public static let cdataKey = "#cdata"

    /// Returns `true` when `key` names an attribute.
    @inline(__always)
    public static func isAttributeKey(_ key: String) -> Bool {
        key.hasPrefix(attributeSigil) && key.count > attributeSigil.count
    }

    /// Returns the element name for a coding key, or `nil` when the key refers
    /// to text, CDATA content, or a namespace declaration rather than a child
    /// element.
    public static func elementName(for key: String) -> String? {
        if key == textKey || key == cdataKey { return nil }
        if key.hasPrefix(attributeSigil) { return nil }
        return key
    }

    /// Returns the attribute name for a coding key, or `nil` when the key does
    /// not name an attribute.
    public static func attributeName(for key: String) -> String? {
        guard isAttributeKey(key) else { return nil }
        return String(key.dropFirst(attributeSigil.count))
    }
}

/// How attribute names are derived from coding keys.
public enum XMLAttributeStrategy: Sendable, Hashable {
    /// Coding keys are written with an `@` sigil: `@id` maps to `id="…"`.
    ///
    /// The default, because it is explicit and requires no per-type
    /// configuration.
    case useConvention

    /// Only the listed keys are attributes; every other key is a child element.
    ///
    /// Useful when an existing type cannot be annotated. Keys are compared
    /// against the coding key's string value, and both the sigilled and
    /// unsigilled spellings are accepted so that a type using `@id`-style keys
    /// and one using plain keys can share this list.
    case keyedBy(Set<String>)

    /// No attribute channel: every coding key names a child element.
    ///
    /// Use this to prove that a type never reads or writes attributes. A document
    /// that contains attributes then produces ``XMLDecoderError/unknownContent``
    /// under ``UnknownContentStrategy/error``, which catches accidental reliance
    /// on them.
    case none
}

/// How text content is derived from coding keys.
public enum XMLTextStrategy: Sendable, Hashable {
    /// The reserved key `#text` names text content.
    case useConvention

    /// Only the listed key is text content.
    case keyedBy(String)

    /// No text channel.
    ///
    /// An element whose content must be a keyed container then rejects text,
    /// which is how you assert that an element has no character data.
    case none
}

// MARK: - Namespaces

/// How namespaces appear in coding keys.
public enum XMLNamespaceStrategy: Sendable, Hashable {
    /// A namespaced name uses its namespace URI: `"urn:example:ns localName"`.
    ///
    /// Keying on the URI rather than the prefix is the only namespace-correct
    /// choice: two documents may bind different prefixes to the same namespace,
    /// and one prefix may be bound to different namespaces in different scopes.
    /// Keying on a prefix would make the decoded type depend on a lexical detail
    /// of the document that carries no meaning.
    case uri

    /// A namespaced name uses the prefix as written: `"p:localName"`.
    ///
    /// Provided for interoperating with types already written against
    /// prefix-based names. Prefer ``uri`` unless a document's prefixes are known
    /// to be stable.
    case qualifiedNameAsWritten

    /// Namespace information is discarded: only local names are used.
    ///
    /// Convenient for documents whose namespaces never disambiguate anything, and
    /// dangerous otherwise, because two elements with the same local name in
    /// different namespaces become indistinguishable.
    case ignoreNamespace
}

// MARK: - Nil and empty elements

/// How absent values are written and recognised.
public enum XMLNilStrategy: Sendable, Hashable {
    /// A `nil` property produces no element at all.
    ///
    /// The default: it produces the smallest, most conventional XML, and decoding
    /// treats an absent element as `nil` regardless of this setting, so the
    /// choice only affects encoding.
    case omitElement

    /// A `nil` property produces an empty element: `<name/>`.
    ///
    /// Decoding maps a present-but-empty element back to `nil`, so this strategy
    /// round-trips. The consequence is that an *empty string* and a `nil` are
    /// written identically; if a type must distinguish them, use ``xsiNil`` or an
    /// optional `String` with a `#text` key.
    case emptyElement

    /// A `nil` property produces an element with the `xsi:nil` attribute:
    /// `<name xmlns:xsi="…" xsi:nil="true"/>`.
    ///
    /// This is the XML Schema idiom for an explicit null, and the only form that
    /// distinguishes "absent" from "present and empty". Decoding recognises it
    /// with any of these settings.
    case xsiNil
}

// MARK: - Text handling

/// How whitespace around a scalar value is treated.
///
/// This is a *decoding* strategy and never a parser behaviour: the tokenizer and
/// the DOM always preserve whitespace exactly, so nothing is lost before the
/// caller asks for a value.
public enum XMLTextTrimming: Sendable, Hashable {
    /// Remove nothing.
    case none

    /// Remove leading and trailing spaces and tabs.
    case whitespace

    /// Remove leading and trailing whitespace, including newlines.
    ///
    /// The default, because `<age>\n  42\n</age>` must decode as `42`.
    case whitespaceAndNewlines
}

// MARK: - Repeated elements

/// How arrays are matched to the document.
public enum XMLRepeatedElementStrategy: Sendable, Hashable {
    /// An array is matched against repeated sibling elements, and a nested
    /// container is also accepted if one is present.
    ///
    /// The default. `<item/><item/>` and `<item><item/><item/></item>` both
    /// decode into an array, which is what real documents require: both spellings
    /// occur in the wild and a decoder that accepts only one is wrong about half
    /// the documents it sees.
    case automatic

    /// Only repeated sibling elements are accepted; a nested container is an
    /// error.
    ///
    /// Use this to pin a schema down and catch a document that wraps its repeated
    /// elements when it should not.
    case siblingsOnly
}

// MARK: - Unknown content

/// What to do with content that the decoded type does not account for.
public enum XMLUnknownContentStrategy: Sendable, Hashable {
    /// Ignore it.
    ///
    /// The default, matching `JSONDecoder`, which ignores unknown keys. Required
    /// for forward compatibility with documents that gain elements over time.
    case ignore

    /// Report it as ``XMLDecoderError/unknownContent(kind:name:path:)``.
    ///
    /// Invaluable while integrating against a schema, because a misspelled
    /// property name otherwise fails silently as "no value found". Note that
    /// unknown *content* can only be detected for elements and attributes that
    /// the decoded type actually visits comprehensively; a type that never asks
    /// for its children cannot have them audited.
    case error
}
