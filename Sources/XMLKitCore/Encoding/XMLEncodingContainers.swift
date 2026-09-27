//
//  XMLEncodingContainers.swift
//  XMLKit
//
//  The container implementations that make Codable work when writing XML.
//

import Foundation

// MARK: - Keyed container

/// A keyed encoding container that writes into a single element.
///
/// ## Attribute handling requires a custom container
///
/// `KeyedEncodingContainer`'s own implementations of the generic `encode<T>`
/// methods forward to `_box` machinery that always creates a *nested* container.
/// An attribute, however, is not a nested container — it is a name/value pair on
/// the current element. Because `encode<T>(_:forKey:)` for a generic `T`
/// dispatches through this protocol's requirement, implementing it here is what
/// lets a coding key named `@id` become an attribute rather than a child element.
internal struct _XMLKeyedEncodingContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
    let encoder: _XMLEncoderEngine
    let element: _XMLEncodedElement

    var codingPath: [any CodingKey] { encoder.codingPath }

    init(encoder: _XMLEncoderEngine, element: _XMLEncodedElement) {
        self.encoder = encoder
        self.element = element
    }

    // MARK: Key classification

    /// The attribute name a key refers to, honouring ``XMLAttributeStrategy``.
    private func attributeName(for key: Key) -> String? {
        let raw = key.stringValue
        switch encoder.configuration.attributeStrategy {
        case .useConvention:
            return XMLKeyConvention.attributeName(for: raw)
        case .none:
            return nil
        case let .keyedBy(names):
            if names.contains(raw) { return XMLKeyConvention.attributeName(for: raw) ?? raw }
            if let stripped = XMLKeyConvention.attributeName(for: raw), names.contains(stripped) {
                return stripped
            }
            return nil
        }
    }

    /// Whether a key selects the element's text content.
    private func isTextKey(_ key: Key) -> Bool {
        let raw = key.stringValue
        if raw == XMLKeyConvention.cdataKey { return true }
        switch encoder.configuration.textStrategy {
        case .useConvention: return raw == XMLKeyConvention.textKey
        case let .keyedBy(name): return raw == name
        case .none: return false
        }
    }

    /// Whether a key selects a CDATA section rather than escaped text.
    private func isCDATAKey(_ key: Key) -> Bool {
        key.stringValue == XMLKeyConvention.cdataKey
    }

    // MARK: Scalar overloads

    func encodeNil(forKey key: Key) throws {
        switch encoder.configuration.nilStrategy {
        case .omitElement:
            // Nothing at all is written, which is the smallest faithful output.
            break
        case .emptyElement:
            if let attributeName = attributeName(for: key) {
                element.attributes.append((name: attributeName, value: ""))
            } else if isTextKey(key) {
                element.text = ""
            } else {
                let child = _XMLEncodedElement(name: try childName(for: key))
                element.children.append(child)
            }
        case .xsiNil:
            if let attributeName = attributeName(for: key) {
                element.attributes.append((name: attributeName, value: ""))
            } else {
                let child = _XMLEncodedElement(name: try childName(for: key))
                child.namespaceDeclarations.append(
                    XMLNamespaceDeclaration(prefix: "xsi", uri: "http://www.w3.org/2001/XMLSchema-instance")
                )
                child.attributes.append((name: "xsi:nil", value: "true"))
                element.children.append(child)
            }
        }
    }

    func encode(_ value: Bool, forKey key: Key) throws { try encodeScalar(value, key) }
    func encode(_ value: String, forKey key: Key) throws { try encodeScalar(value, key) }
    func encode(_ value: Double, forKey key: Key) throws { try encodeScalar(value, key) }
    func encode(_ value: Float, forKey key: Key) throws { try encodeScalar(value, key) }
    func encode(_ value: Int, forKey key: Key) throws { try encodeScalar(value, key) }
    func encode(_ value: Int8, forKey key: Key) throws { try encodeScalar(value, key) }
    func encode(_ value: Int16, forKey key: Key) throws { try encodeScalar(value, key) }
    func encode(_ value: Int32, forKey key: Key) throws { try encodeScalar(value, key) }
    func encode(_ value: Int64, forKey key: Key) throws { try encodeScalar(value, key) }
    func encode(_ value: UInt, forKey key: Key) throws { try encodeScalar(value, key) }
    func encode(_ value: UInt8, forKey key: Key) throws { try encodeScalar(value, key) }
    func encode(_ value: UInt16, forKey key: Key) throws { try encodeScalar(value, key) }
    func encode(_ value: UInt32, forKey key: Key) throws { try encodeScalar(value, key) }
    func encode(_ value: UInt64, forKey key: Key) throws { try encodeScalar(value, key) }

    private func encodeScalar<T: Encodable>(_ value: T, _ key: Key) throws {
        if let attributeName = attributeName(for: key) {
            // `Codable` has no way to hand back a string from an arbitrary
            // Encodable, so a scalar attribute is captured by encoding it into a
            // throwaway element with a "text" key and reading the text back.
            // A non-scalar attribute value is not representable in XML and is
            // reported rather than stringified.
            guard let text = textRepresentation(value) else {
                throw XMLEncoderError.valueNotRepresentable(
                    type: String(describing: T.self),
                    path: codingPath.map(\.stringValue) + [key.stringValue],
                    reason: "an attribute value must be a scalar; XML has no syntax for a structured attribute"
                )
            }
            try _XMLEncoderEngine.validate(text: text, path: codingPath.map(\.stringValue) + [key.stringValue])
            element.attributes.append((name: attributeName, value: text))
            return
        }

        if isTextKey(key) {
            guard let text = textRepresentation(value) else {
                throw XMLEncoderError.valueNotRepresentable(
                    type: String(describing: T.self),
                    path: codingPath.map(\.stringValue) + [key.stringValue],
                    reason: "text content must be a scalar"
                )
            }
            try writeText(text, isCDATA: isCDATAKey(key), key: key)
            return
        }

        let child = _XMLEncodedElement(name: try childName(for: key))
        element.children.append(child)
        let childEncoder = encoder.makeChild(key: key, index: nil)
        childEncoder.targetElement = child
        try childEncoder.encodeValue(value, into: child)
    }

    /// Writes a value into the element's text content.
    ///
    /// Text is *accumulated* rather than assigned, because a type may declare
    /// both a `#text` and a `#cdata` key and both contribute to the same
    /// element's character data. Assigning would silently drop one of them, which
    /// is exactly the bug a round-trip test catches.
    ///
    /// The CDATA marker is sticky: if any contribution came from a CDATA key, the
    /// whole text is written as a CDATA section. That is the only choice that
    /// preserves both contributions, since one element cannot have two text
    /// forms.
    private func writeText(_ text: String, isCDATA: Bool, key: Key) throws {
        try _XMLEncoderEngine.validate(
            text: text,
            path: codingPath.map(\.stringValue) + [key.stringValue]
        )
        element.text = (element.text ?? "") + text
        if isCDATA, encoder.configuration.outputFormatting.contains(.useCDATAForCDATAKeys) {
            element.textIsCDATA = true
        }
    }

    /// The text of a scalar value, or `nil` when it is not a scalar.
    private func textRepresentation<T: Encodable>(_ value: T) -> String? {
        if let scalar = value as? any _XMLValueEncodable {
            return try? scalar.xmlEncodedText(encoder: encoder, path: codingPath)
        }
        if let custom = value as? any XMLScalarEncodable { return custom.xmlText }
        if let string = value as? String { return string }
        return nil
    }

    // MARK: Generic encoding

    /// Encodes any `Encodable` under `key`.
    ///
    /// This is where XML's structure is decided. The order of the checks matters:
    ///
    /// 1. An attribute key writes an attribute.
    /// 2. A text key writes the element's character data.
    /// 3. A repeated element (array or set) writes one child element per item,
    ///    all named after the key — which is how XML spells a list.
    /// 4. A dictionary writes one child per entry, named after the key.
    /// 5. Anything else writes one child element named after the key.
    func encode<T: Encodable>(_ value: T, forKey key: Key) throws {
        if let attributeName = attributeName(for: key) {
            guard let text = textRepresentation(value) else {
                throw XMLEncoderError.valueNotRepresentable(
                    type: String(describing: T.self),
                    path: codingPath.map(\.stringValue) + [key.stringValue],
                    reason: "an attribute value must be a scalar; XML has no syntax for a structured attribute"
                )
            }
            try _XMLEncoderEngine.validate(text: text, path: codingPath.map(\.stringValue) + [key.stringValue])
            element.attributes.append((name: attributeName, value: text))
            return
        }

        if isTextKey(key) {
            guard let text = textRepresentation(value) else {
                throw XMLEncoderError.valueNotRepresentable(
                    type: String(describing: T.self),
                    path: codingPath.map(\.stringValue) + [key.stringValue],
                    reason: "text content must be a scalar"
                )
            }
            try writeText(text, isCDATA: isCDATAKey(key), key: key)
            return
        }

        if let repeated = value as? any _XMLRepeatedElementEncoding {
            let name = try childName(for: key)
            let holder = _XMLEncodedElement(name: name)
            let holderEncoder = encoder.makeChild(key: key, index: nil)
            holderEncoder.targetElement = holder
            try repeated.encodeRepeated(into: holder, encoder: holderEncoder)
            element.children.append(contentsOf: holder.children)
            return
        }

        if let dictionary = value as? any _XMLDictionaryEncoding {
            // A dictionary is written as a named element whose *children* are the
            // entries:
            //
            //     <properties><color>red</color><size>large</size></properties>
            //
            // The wrapper is required for symmetry. A dictionary at the top level
            // would otherwise have no element to live in, and the decoder reads a
            // dictionary from the children of the element named by the property's
            // coding key — so a wrapper that only one side wrote would be a
            // guaranteed round-trip failure. An empty dictionary therefore encodes
            // as an empty wrapper, which preserves the difference between "no
            // dictionary" and "an empty dictionary".
            let name = try childName(for: key)
            let wrapper = _XMLEncodedElement(name: name)
            element.children.append(wrapper)
            let wrapperEncoder = encoder.makeChild(key: key, index: nil)
            wrapperEncoder.targetElement = wrapper
            try dictionary.encodeDictionary(into: wrapper, encoder: wrapperEncoder)
            return
        }

        let child = _XMLEncodedElement(name: try childName(for: key))
        element.children.append(child)
        let childEncoder = encoder.makeChild(key: key, index: nil)
        childEncoder.targetElement = child
        try childEncoder.encodeValue(value, into: child)
    }

    // `Codable` synthesis encodes an `Optional` property by calling
    // `encodeIfPresent`, *not* `encodeNil`. This is therefore the method that
    // decides how a `nil` is written; without it every nil strategy would
    // silently behave as `.omitElement`.
    func encodeIfPresent<T: Encodable>(_ value: T?, forKey key: Key) throws {
        guard let value else {
            try encodeNil(forKey: key)
            return
        }
        try encode(value, forKey: key)
    }

    func encodeIfPresent(_ value: Bool?, forKey key: Key) throws {
        guard let value else { return try encodeNil(forKey: key) }
        try encode(value, forKey: key)
    }

    func encodeIfPresent(_ value: String?, forKey key: Key) throws {
        guard let value else { return try encodeNil(forKey: key) }
        try encode(value, forKey: key)
    }

    func encodeIfPresent(_ value: Double?, forKey key: Key) throws {
        guard let value else { return try encodeNil(forKey: key) }
        try encode(value, forKey: key)
    }

    func encodeIfPresent(_ value: Float?, forKey key: Key) throws {
        guard let value else { return try encodeNil(forKey: key) }
        try encode(value, forKey: key)
    }

    func encodeIfPresent(_ value: Int?, forKey key: Key) throws {
        guard let value else { return try encodeNil(forKey: key) }
        try encode(value, forKey: key)
    }

    func encodeIfPresent(_ value: Int8?, forKey key: Key) throws {
        guard let value else { return try encodeNil(forKey: key) }
        try encode(value, forKey: key)
    }

    func encodeIfPresent(_ value: Int16?, forKey key: Key) throws {
        guard let value else { return try encodeNil(forKey: key) }
        try encode(value, forKey: key)
    }

    func encodeIfPresent(_ value: Int32?, forKey key: Key) throws {
        guard let value else { return try encodeNil(forKey: key) }
        try encode(value, forKey: key)
    }

    func encodeIfPresent(_ value: Int64?, forKey key: Key) throws {
        guard let value else { return try encodeNil(forKey: key) }
        try encode(value, forKey: key)
    }

    func encodeIfPresent(_ value: UInt?, forKey key: Key) throws {
        guard let value else { return try encodeNil(forKey: key) }
        try encode(value, forKey: key)
    }

    func encodeIfPresent(_ value: UInt8?, forKey key: Key) throws {
        guard let value else { return try encodeNil(forKey: key) }
        try encode(value, forKey: key)
    }

    func encodeIfPresent(_ value: UInt16?, forKey key: Key) throws {
        guard let value else { return try encodeNil(forKey: key) }
        try encode(value, forKey: key)
    }

    func encodeIfPresent(_ value: UInt32?, forKey key: Key) throws {
        guard let value else { return try encodeNil(forKey: key) }
        try encode(value, forKey: key)
    }

    func encodeIfPresent(_ value: UInt64?, forKey key: Key) throws {
        guard let value else { return try encodeNil(forKey: key) }
        try encode(value, forKey: key)
    }

    // MARK: Nested containers

    func nestedContainer<NestedKey: CodingKey>(
        keyedBy keyType: NestedKey.Type,
        forKey key: Key
    ) -> KeyedEncodingContainer<NestedKey> {
        let child = _XMLEncodedElement(name: (try? childName(for: key)) ?? key.stringValue)
        element.children.append(child)
        let childEncoder = encoder.makeChild(key: key, index: nil)
        childEncoder.targetElement = child
        return KeyedEncodingContainer(_XMLKeyedEncodingContainer<NestedKey>(encoder: childEncoder, element: child))
    }

    func nestedUnkeyedContainer(forKey key: Key) -> any UnkeyedEncodingContainer {
        // Under a key, an unkeyed container has a name: the key. That is exactly
        // what makes an array property encode as repeated elements.
        let childEncoder = encoder.makeChild(key: key, index: nil)
        return _XMLUnkeyedEncodingContainer(encoder: childEncoder, element: element, name: try? childName(for: key))
    }

    func superEncoder() -> any Encoder {
        let child = _XMLEncodedElement(name: element.name)
        element.children.append(child)
        let childEncoder = encoder.makeChild(key: nil, index: nil)
        childEncoder.targetElement = child
        return childEncoder
    }

    func superEncoder(forKey key: Key) -> any Encoder {
        let child = _XMLEncodedElement(name: (try? childName(for: key)) ?? key.stringValue)
        element.children.append(child)
        let childEncoder = encoder.makeChild(key: key, index: nil)
        childEncoder.targetElement = child
        return childEncoder
    }

    /// The element name a key refers to, validated as a legal XML name.
    ///
    /// A coding key may name an element in a namespace in one of two ways,
    /// mirroring the decoder's ``XMLNamespaceStrategy``:
    ///
    /// * `"prefix:localName"` — a qualified name as written. Used literally.
    /// * `"namespaceURI localName"` — the decoder's default `.uri` form, where a
    ///   single space separates the URI from the local name. The encoder resolves
    ///   the URI to a prefix (configured through
    ///   ``XMLEncoder/namespacePrefixes``, or generated) and records the
    ///   declaration.
    private func childName(for key: Key) throws -> String {
        let raw = key.stringValue

        if let space = raw.firstIndex(of: " ") {
            let uri = String(raw[raw.startIndex..<space])
            let localName = String(raw[raw.index(after: space)...])
            guard !uri.isEmpty, !localName.isEmpty else {
                throw XMLEncoderError.invalidName(
                    raw,
                    reason: "a namespace-qualified key must be 'uri localName' with both parts non-empty"
                )
            }
            try _XMLEncoderEngine.validate(name: localName, path: codingPath.map(\.stringValue) + [raw])
            let prefix = encoder.prefix(forNamespaceURI: uri)
            element.namespaceDeclarations.append(XMLNamespaceDeclaration(prefix: prefix, uri: uri))
            return "\(prefix):\(localName)"
        }

        try _XMLEncoderEngine.validate(name: raw, path: codingPath.map(\.stringValue) + [raw])
        return raw
    }
}

// MARK: - Dictionary encoding

/// A dictionary that XMLKit writes as repeated named elements.
internal protocol _XMLDictionaryEncoding {
    func encodeDictionary(into element: _XMLEncodedElement, encoder: _XMLEncoderEngine) throws
}

extension Dictionary: _XMLDictionaryEncoding where Key == String, Value: Encodable {
    internal func encodeDictionary(into element: _XMLEncodedElement, encoder: _XMLEncoderEngine) throws {
        // XML has no dictionary literal; the faithful spelling is one child
        // element per entry, named by the key:
        //
        //     <properties><color>red</color><size>large</size></properties>
        //
        // Dictionaries are unordered, so entries are sorted by key to make output
        // deterministic. XML places no meaning on sibling order here, so nothing
        // is lost, and reproducible output is worth having.
        for (key, value) in sorted(by: { $0.key < $1.key }) {
            try _XMLEncoderEngine.validate(name: key, path: encoder.codingPath.map(\.stringValue) + [key])
            let child = _XMLEncodedElement(name: key)
            element.children.append(child)
            let childEncoder = encoder.makeChild(key: nil, index: nil)
            childEncoder.targetElement = child
            try childEncoder.encodeValue(value, into: child)
        }
    }
}

// MARK: - Unkeyed container

/// An unkeyed container that writes repeated elements.
///
/// - Important: Elements need a name, and an unkeyed container is only ever
///   reached with one when it was requested under a coding key (an array
///   property) or as the document root with ``XMLEncoder/rootElementName`` set.
///   A bare array nested inside another array has no name available, and encoding
///   it throws rather than inventing one.
internal struct _XMLUnkeyedEncodingContainer: UnkeyedEncodingContainer {
    let encoder: _XMLEncoderEngine
    /// The element this container appends to.
    let element: _XMLEncodedElement
    /// The name to give each child, or `nil` when no name is available.
    let name: String?

    private(set) var count: Int = 0

    var codingPath: [any CodingKey] { encoder.codingPath }

    init(encoder: _XMLEncoderEngine, element: _XMLEncodedElement, name: String?) {
        self.encoder = encoder
        self.element = element
        self.name = name
    }

    /// Creates the child element for the next item.
    private mutating func makeChild<T: Encodable>(_ value: T) throws -> (_XMLEncodedElement, _XMLEncoderEngine) {
        guard let name else {
            throw XMLEncoderError.unkeyedContainerNotRepresentable(
                path: encoder.codingPath.map(\.stringValue)
            )
        }
        let child = _XMLEncodedElement(name: name)
        element.children.append(child)
        let childEncoder = encoder.makeChild(key: nil, index: count)
        childEncoder.targetElement = child
        count += 1
        return (child, childEncoder)
    }

    mutating func encodeNil() throws {
        // A `nil` inside an array has no good representation, and the strategies
        // differ in how they fail to provide one:
        //
        //   * `.omitElement` drops the item, so `[1, nil, 3]` encodes as two
        //     elements and the array gets shorter. Round-tripping then yields
        //     `[1, 3]`. This is a real, documented loss, and it is the honest
        //     consequence of a strategy that says "a nil produces no element".
        //   * `.emptyElement` and `.xsiNil` write an empty element, which
        //     preserves the array's length.
        //
        // The index counter advances in every case so that the coding path of a
        // later element still reports its true position.
        switch encoder.configuration.nilStrategy {
        case .omitElement:
            count += 1
        case .emptyElement, .xsiNil:
            guard let name else {
                throw XMLEncoderError.unkeyedContainerNotRepresentable(
                    path: encoder.codingPath.map(\.stringValue)
                )
            }
            let child = _XMLEncodedElement(name: name)
            if encoder.configuration.nilStrategy == .xsiNil {
                child.namespaceDeclarations.append(
                    XMLNamespaceDeclaration(prefix: "xsi", uri: "http://www.w3.org/2001/XMLSchema-instance")
                )
                child.attributes.append((name: "xsi:nil", value: "true"))
            }
            element.children.append(child)
            count += 1
        }
    }

    mutating func encode(_ value: Bool) throws { try encodeElement(value) }
    mutating func encode(_ value: String) throws { try encodeElement(value) }
    mutating func encode(_ value: Double) throws { try encodeElement(value) }
    mutating func encode(_ value: Float) throws { try encodeElement(value) }
    mutating func encode(_ value: Int) throws { try encodeElement(value) }
    mutating func encode(_ value: Int8) throws { try encodeElement(value) }
    mutating func encode(_ value: Int16) throws { try encodeElement(value) }
    mutating func encode(_ value: Int32) throws { try encodeElement(value) }
    mutating func encode(_ value: Int64) throws { try encodeElement(value) }
    mutating func encode(_ value: UInt) throws { try encodeElement(value) }
    mutating func encode(_ value: UInt8) throws { try encodeElement(value) }
    mutating func encode(_ value: UInt16) throws { try encodeElement(value) }
    mutating func encode(_ value: UInt32) throws { try encodeElement(value) }
    mutating func encode(_ value: UInt64) throws { try encodeElement(value) }

    mutating func encode<T: Encodable>(_ value: T) throws {
        let (child, childEncoder) = try makeChild(value)
        try childEncoder.encodeValue(value, into: child)
    }

    private mutating func encodeElement<T: Encodable>(_ value: T) throws {
        let (child, childEncoder) = try makeChild(value)
        try childEncoder.encodeValue(value, into: child)
    }

    mutating func nestedContainer<NestedKey: CodingKey>(
        keyedBy keyType: NestedKey.Type
    ) -> KeyedEncodingContainer<NestedKey> {
        // Without a name there is nothing to nest into, and the container API is
        // not throwing, so the failure cannot be reported here. A placeholder name
        // is used instead: it is not a legal XML name, so `validate` rejects it
        // when the value is written, which reports the problem with a coding path
        // rather than silently emitting invalid output.
        let name = name ?? "__unnamed__"
        let child = _XMLEncodedElement(name: name)
        element.children.append(child)
        let childEncoder = encoder.makeChild(key: nil, index: count)
        childEncoder.targetElement = child
        count += 1
        return KeyedEncodingContainer(_XMLKeyedEncodingContainer<NestedKey>(encoder: childEncoder, element: child))
    }

    mutating func nestedUnkeyedContainer() -> any UnkeyedEncodingContainer {
        // An array of arrays has no naming rule in XML. It is reported when an
        // element is actually encoded, because an empty inner array is harmless.
        _XMLUnkeyedEncodingContainer(encoder: encoder, element: element, name: nil)
    }

    mutating func superEncoder() -> any Encoder {
        guard let name else {
            let fallback = _XMLEncodedElement(name: "__unnamed__")
            element.children.append(fallback)
            let childEncoder = encoder.makeChild(key: nil, index: count)
            childEncoder.targetElement = fallback
            count += 1
            return childEncoder
        }
        let child = _XMLEncodedElement(name: name)
        element.children.append(child)
        let childEncoder = encoder.makeChild(key: nil, index: count)
        childEncoder.targetElement = child
        count += 1
        return childEncoder
    }
}

// MARK: - Single value container

/// A container for a value with no key: the document root, or an element reached
/// without a coding key.
internal struct _XMLSingleValueEncodingContainer: SingleValueEncodingContainer {
    let encoder: _XMLEncoderEngine
    let element: _XMLEncodedElement

    var codingPath: [any CodingKey] { encoder.codingPath }

    init(encoder: _XMLEncoderEngine, element: _XMLEncodedElement) {
        self.encoder = encoder
        self.element = element
    }

    func encodeNil() throws {
        switch encoder.configuration.nilStrategy {
        case .omitElement:
            break
        case .emptyElement:
            break
        case .xsiNil:
            element.namespaceDeclarations.append(
                XMLNamespaceDeclaration(prefix: "xsi", uri: "http://www.w3.org/2001/XMLSchema-instance")
            )
            element.attributes.append((name: "xsi:nil", value: "true"))
        }
    }

    func encode(_ value: Bool) throws { try write(value) }
    func encode(_ value: String) throws { try write(value) }
    func encode(_ value: Double) throws { try write(value) }
    func encode(_ value: Float) throws { try write(value) }
    func encode(_ value: Int) throws { try write(value) }
    func encode(_ value: Int8) throws { try write(value) }
    func encode(_ value: Int16) throws { try write(value) }
    func encode(_ value: Int32) throws { try write(value) }
    func encode(_ value: Int64) throws { try write(value) }
    func encode(_ value: UInt) throws { try write(value) }
    func encode(_ value: UInt8) throws { try write(value) }
    func encode(_ value: UInt16) throws { try write(value) }
    func encode(_ value: UInt32) throws { try write(value) }
    func encode(_ value: UInt64) throws { try write(value) }

    func encode<T: Encodable>(_ value: T) throws {
        try write(value)
    }

    private func write<T: Encodable>(_ value: T) throws {
        try encoder.encodeValue(value, into: element)
    }
}
