//
//  XMLDecoder.swift
//
//  Created by Axel Martinez on 2/7/24.
//

import Foundation

fileprivate struct _XMLKey: CodingKey {
    var stringValue: String
    var intValue: Int?
    
    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    init?(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
    
    init(index: Int) {
        self.stringValue = "[\(index)]"
        self.intValue = index
    }
}

struct XMLDecoder {
    /// The decoder's storage.
    var element: XMLElement

    /// The decoder's current name
    fileprivate let elementName: String?
    
    /// The decoder's current namespace
    fileprivate let namespace: XMLNode?
    
    /// Options set on the top-level decoder.
    fileprivate let options: DecoderOptions
    
    /// The path to the current point in encoding.
    fileprivate(set) public var codingPath: [CodingKey]

    /// Contextual user-provided information for use during encoding.
    public var userInfo: [CodingUserInfoKey : Any]
    
    /// Initializes `self` with the given top-level container and options.
    init(from xml: XMLElement, at codingPath: [CodingKey] = [], elementName: String = "", namespace: XMLNode? = nil, options: DecoderOptions) {
        self.element = xml
        self.elementName = elementName
        self.namespace = namespace
        self.codingPath = codingPath
        self.options = options
        self.userInfo = [:]
    }
    
    func qualifiedName(forNode node: XMLNode) -> String? {
        guard let name = node.name else {
            return nil
        }
        
        return qualifiedName(forKey: name)
    }
    
    func qualifiedName(forKey key: String) -> String {
        guard let namespace = self.namespace?.localName else {
            return key
        }

        return "\(namespace):\(key)"
    }
}

// MARK: - Decoder Methods

extension XMLDecoder: Decoder {
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        switch self.element.kind {
        case .element, .document:
            let nodes = nodes(of: element)
            let container = KeyedContainer<Key>(decoder: self, codingPath: codingPath, dictionary: nodes)
            return KeyedDecodingContainer(container)
        case .invalid:
            throw DecodingError.valueNotFound([String: XMLNode].self, DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Cannot get keyed decoding container -- found invalid value instead"
            ))
        default:
            throw DecodingError.typeMismatch([String: XMLNode].self, DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected to decode \([String: XMLNode].self) but found \(self.element.kind) instead."
            ))
        }
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        switch self.element.kind {
        case .element:
            guard let elementName = self.elementName else {
                throw DecodingError.valueNotFound([String: XMLNode].self, DecodingError.Context(
                    codingPath: self.codingPath,
                    debugDescription: "Cannot get keyed decoding container -- found invalid value instead"
                ))
            }
            let elements = element.elements(forName: elementName)
            return UnkeyedContainer(decoder: self, array: elements)
        case .invalid:
            throw DecodingError.valueNotFound([String: XMLNode].self, DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Cannot get keyed decoding container -- found invalid value instead"
            ))
        default:
            throw DecodingError.typeMismatch([String: XMLNode].self, DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected to decode \([String: XMLNode].self) but found \(self.element.kind) instead."
            ))
        }
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return SingleValueContainer(decoder: self, codingPath: codingPath, node: element)
    }
    
    func nodes(of element: XMLElement) -> [String:XMLNode] {
        var nodes = [String:XMLNode]()
        
        for attribute in element.attributes ?? [] {
            if let name = attribute.name {
                nodes[name] = attribute
            }
        }

        let children = self.element.children?.filter({ $0.prefix == namespace?.localName ?? "" || $0.prefix == nil })
        
        for child in children ?? [] {
            switch child.kind {
            case .element:
                if let name = child.name, nodes[name] == nil {
                    nodes[name] = child
                }
            case .text:
                if let name = element.name {
                    nodes[name] = child
                }
            default:
                break
            }
        }

        return nodes
    }
    
    func unwrap<T: Decodable>(as type: T.Type) throws -> T {
        if type == Date.self {
            return try self.unwrapDate() as! T
        }
        if type == Data.self {
            return try self.unwrapData() as! T
        }
        if type == URL.self {
            return try self.unwrapURL() as! T
        }
        
        return try type.init(from: self)
    }
    
    func unwrapDate() throws -> Date {
        guard let value = self.element.stringValue else {
            throw DecodingError.valueNotFound(Date.self, DecodingError.Context(codingPath: self.codingPath, debugDescription: "Could not decode \(Date.self)."))
        }
        
        switch options.dateDecodingStrategy {
        case .deferredToDate:
            return try Date(from: self)
        case .secondsSince1970:
            let container = SingleValueContainer(decoder: self, codingPath: self.codingPath, node: self.element)
            let double = try container.decode(Double.self)
            return Date(timeIntervalSince1970: double)
        case .millisecondsSince1970:
            let container = SingleValueContainer(decoder: self, codingPath: self.codingPath, node: self.element)
            let double = try container.decode(Double.self)
            return Date(timeIntervalSince1970: double / 1000.0)
        case .iso8601:
            if #available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) {
                let container = SingleValueContainer(decoder: self, codingPath: self.codingPath, node: self.element)
                let string = try container.decode(String.self)
                guard let date = ISO8601DateFormatter().date(from: string) else {
                    throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Expected date string to be ISO8601-formatted."))
                }
                return date
            } else {
                fatalError("ISO8601DateFormatter is unavailable on this platform.")
            }        case .formatted(let customDateFormatter):
            guard let value = customDateFormatter.date(from: value) else {
                throw DecodingError.valueNotFound(Date.self, DecodingError.Context(codingPath: self.codingPath, debugDescription: "Could not decode \(Date.self)."))
            }
            return value
        case .custom(let closure):
            return try closure(self)
        }
    }

    func unwrapData() throws -> Data {
        guard let value = self.element.stringValue else {
            throw DecodingError.valueNotFound(Date.self, DecodingError.Context(codingPath: self.codingPath, debugDescription: "Could not decode \(Date.self)."))
        }
        
        switch options.dataDecodingStrategy {
        case .deferredToData:
            return try Data(from: self)
        case .base64:
            guard let value = Data(base64Encoded: value) else {
                throw DecodingError.valueNotFound(Data.self, DecodingError.Context(codingPath: self.codingPath, debugDescription: "Could not decode \(Data.self)."))
            }
            return value
            /*case .hex:
             guard let value = Data(hexEncoded: string) else {
             throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.codingPath, debugDescription: "Could not decode \(type)."))
             }
             return value*/
        case .custom(let closure):
            return try closure(self)
        }
    }
    
    func unwrapURL() throws -> URL {
        guard let value = self.element.stringValue, let url = URL(string: value) else {
            throw DecodingError.valueNotFound(Date.self, DecodingError.Context(codingPath: self.codingPath, debugDescription: "Could not decode \(Date.self)."))
        }
        return url
    }
    
    func unwrapFloatingPoint<T: LosslessStringConvertible & BinaryFloatingPoint>(
        from value: XMLNode,
        for additionalKey: CodingKey? = nil,
        as type: T.Type
    ) throws -> T {
        guard let number = value.stringValue else {
            throw DecodingError.valueNotFound(Date.self, DecodingError.Context(codingPath: self.codingPath, debugDescription: "Could not decode \(Date.self)."))
        }
        
        guard let floatingPoint = T(number), floatingPoint.isFinite else {
            var path = self.codingPath
            if let additionalKey = additionalKey {
                path.append(additionalKey)
            }
            throw DecodingError.dataCorrupted(.init(
                codingPath: path,
                debugDescription: "Parsed JSON number <\(value)> does not fit in \(T.self)."))
        }
        
        var path = self.codingPath
        if let additionalKey = additionalKey {
            path.append(additionalKey)
        }
        
        return floatingPoint
    }
    
    func unwrapFixedWidthInteger<T: FixedWidthInteger>(
        from value: XMLNode,
        for additionalKey: CodingKey? = nil,
        as type: T.Type
    ) throws -> T {
        guard let number = value.stringValue else {
            throw DecodingError.valueNotFound(String.self, DecodingError.Context(codingPath: self.codingPath, debugDescription: "Could not decode \(String.self)."))
        }
        
        // this is the fast pass. Number directly convertible to Integer
        if let integer = T(number) {
            return integer
        }
 
        // this is the really slow path... If the fast path has failed. For example for "34.0" as
        // an integer, we try to go through NSNumber
        if let nsNumber = NSNumber.fromJSONNumber(number) {
            if type == UInt8.self, NSNumber(value: nsNumber.uint8Value) == nsNumber {
                return nsNumber.uint8Value as! T
            }
            if type == Int8.self, NSNumber(value: nsNumber.int8Value) == nsNumber {
                return nsNumber.int8Value as! T
            }
            if type == UInt16.self, NSNumber(value: nsNumber.uint16Value) == nsNumber {
                return nsNumber.uint16Value as! T
            }
            if type == Int16.self, NSNumber(value: nsNumber.int16Value) == nsNumber {
                return nsNumber.int16Value as! T
            }
            if type == UInt32.self, NSNumber(value: nsNumber.uint32Value) == nsNumber {
                return nsNumber.uint32Value as! T
            }
            if type == Int32.self, NSNumber(value: nsNumber.int32Value) == nsNumber {
                return nsNumber.int32Value as! T
            }
            if type == UInt64.self, NSNumber(value: nsNumber.uint64Value) == nsNumber {
                return nsNumber.uint64Value as! T
            }
            if type == Int64.self, NSNumber(value: nsNumber.int64Value) == nsNumber {
                return nsNumber.int64Value as! T
            }
            if type == UInt.self, NSNumber(value: nsNumber.uintValue) == nsNumber {
                return nsNumber.uintValue as! T
            }
            if type == Int.self, NSNumber(value: nsNumber.intValue) == nsNumber {
                return nsNumber.intValue as! T
            }
        }
        
        var path = self.codingPath
        if let additionalKey = additionalKey {
            path.append(additionalKey)
        }
        
        throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.codingPath, debugDescription: "Could not decode \(type)."))
    }
}

// MARK: Single Value Container

extension XMLDecoder {
    struct SingleValueContainer: SingleValueDecodingContainer {
        let decoder: XMLDecoder
        let value: XMLNode
        let codingPath: [CodingKey]
        
        init(decoder: XMLDecoder, codingPath: [CodingKey], node: XMLNode) {
            self.decoder = decoder
            self.codingPath = codingPath
            self.value = node
        }
        
        func decodeNil() -> Bool {
            fatalError()
        }
        
        func decode(_ type: Bool.Type) throws -> Bool {
            guard let string = value.stringValue, let result = Bool(string) else {
                throw DecodingError.valueNotFound(String.self, DecodingError.Context(
                    codingPath: self.codingPath,
                    debugDescription: "Could not decode \(String.self).")
                )
            }
            return result
        }
        
        func decode(_ type: String.Type) throws -> String {
            return value.stringValue ?? ""
        }
        
        func decode(_ type: Double.Type) throws -> Double {
            return try decodeFloatingPoint()
        }
        
        func decode(_ type: Float.Type) throws -> Float {
            return try decodeFloatingPoint()
        }
        
        func decode(_ type: Int.Type) throws -> Int {
            return try decodeFixedWidthInteger()
        }
        
        func decode(_ type: Int8.Type) throws -> Int8 {
            return try decodeFixedWidthInteger()
        }
        
        func decode(_ type: Int16.Type) throws -> Int16 {
            return try decodeFixedWidthInteger()
        }
        
        func decode(_ type: Int32.Type) throws -> Int32 {
            return try decodeFixedWidthInteger()
        }
        
        func decode(_ type: Int64.Type) throws -> Int64 {
            return try decodeFixedWidthInteger()
        }
        
        func decode(_ type: UInt.Type) throws -> UInt {
            return try decodeFixedWidthInteger()
        }
        
        func decode(_ type: UInt8.Type) throws -> UInt8 {
            return try decodeFixedWidthInteger()
        }
        
        func decode(_ type: UInt16.Type) throws -> UInt16 {
            return try decodeFixedWidthInteger()
        }
        
        func decode(_ type: UInt32.Type) throws -> UInt32 {
            return try decodeFixedWidthInteger()
        }
        
        func decode(_ type: UInt64.Type) throws -> UInt64 {
            return try decodeFixedWidthInteger()
        }
        
        func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
            try self.decoder.unwrap(as: type)
        }
        
        @inline(__always) private func decodeFixedWidthInteger<T: FixedWidthInteger>() throws -> T {
            try self.decoder.unwrapFixedWidthInteger(from: self.value, as: T.self)
        }
        
        @inline(__always) private func decodeFloatingPoint<T: LosslessStringConvertible & BinaryFloatingPoint>() throws -> T {
            try self.decoder.unwrapFloatingPoint(from: self.value, as: T.self)
        }
    }
}

// MARK: Keyed Container

extension XMLDecoder {
    struct KeyedContainer<K: CodingKey>: KeyedDecodingContainerProtocol {
        /// A reference to the encoder we're reading from.
        private let decoder: XMLDecoder

        /// A reference to the root element namespaces
        private let namespaces: [String: XMLNode]?
        
        /// A reference to the nodes we're reading from.
        private var elements: [String: XMLNode]

        /// A reference to the nodes we're reading from.
        private var attributes: [String: XMLNode]
        
        /// The path of coding keys taken to get to this point in decoding.
        private(set) public var codingPath: [CodingKey]
        
        // MARK: - Initialization

        /// Initializes `self` with the given references.
        fileprivate init(decoder: XMLDecoder, codingPath: [CodingKey], dictionary: [String: XMLNode]) {
            self.decoder = decoder
            self.codingPath = codingPath
            self.elements = dictionary.filter({ $0.value.kind == .element || $0.value.kind == .text })
            self.attributes = dictionary.filter({ $0.value.kind == .attribute })
            self.namespaces = decoder.element.rootDocument?.rootElement()?.namespaces?.reduce(into: [String: XMLNode]()) {
                if let name = $1.name {
                    $0[name] = $1
                }
            }
        }

        // MARK: KeyedDecodingContainerProtocol Implementation

        var allKeys: [K] {
            self.elements.keys.compactMap { K(stringValue: $0) } +
            self.attributes.keys.compactMap { K(stringValue: $0) }
        }

        func contains(_ key: K) -> Bool {
            let qualifiedKey = decoder.qualifiedName(forKey: key.stringValue)
            return attributes[key.stringValue] != nil || elements[qualifiedKey] != nil || namespaces?[key.stringValue] != nil
        }

        func node(forKey key: K) -> XMLNode? {
            let qualifiedKey = decoder.qualifiedName(forKey: key.stringValue)
            if let node = attributes[key.stringValue] {
                return node
            } else if let node = elements[qualifiedKey] {
                return node
            } else if let node = namespaces?[key.stringValue] {
                return node
            }

            return nil
        }

        func decodeNil(forKey key: K) throws -> Bool {
            guard let node = node(forKey: key) else {
                return true
            }
            
            switch node.kind {
            case .element:
                guard let element = node as? XMLElement else {
                    throw DecodingError.valueNotFound([String: XMLNode].self, DecodingError.Context(
                        codingPath: self.codingPath,
                        debugDescription: "Cannot get keyed decoding container -- found invalid value instead"
                    ))
                }
                return element.stringValue?.isEmpty ?? true && element.attributes?.isEmpty ?? true
            case .attribute, .text, .namespace:
                return node.stringValue?.isEmpty ?? true
            default:
                return true
            }
        }

        func decode(_ type: Bool.Type, forKey key: K) throws -> Bool {
            guard let node = node(forKey: key), let string = node.stringValue, let value = Bool(string) else {
                throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "No value associated with key \(key.stringValue)."))
            }
            return value
        }

        func decode(_ type: String.Type, forKey key: K) throws -> String {
            guard let node = node(forKey: key) else {
                throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "No value associated with key \(key.stringValue)."))
            }
            return node.stringValue ?? ""
        }
        
        func decode(_: Double.Type, forKey key: K) throws -> Double {
            try decodeFloatingPoint(key: key)
        }
        
        func decode(_: Float.Type, forKey key: K) throws -> Float {
            try decodeFloatingPoint(key: key)
        }
        
        func decode(_: Int.Type, forKey key: K) throws -> Int {
            try decodeFixedWidthInteger(key: key)
        }
        
        func decode(_: Int8.Type, forKey key: K) throws -> Int8 {
            try decodeFixedWidthInteger(key: key)
        }
        
        func decode(_: Int16.Type, forKey key: K) throws -> Int16 {
            try decodeFixedWidthInteger(key: key)
        }
        
        func decode(_: Int32.Type, forKey key: K) throws -> Int32 {
            try decodeFixedWidthInteger(key: key)
        }
        
        func decode(_: Int64.Type, forKey key: K) throws -> Int64 {
            try decodeFixedWidthInteger(key: key)
        }
        
        func decode(_: UInt.Type, forKey key: K) throws -> UInt {
            try decodeFixedWidthInteger(key: key)
        }
        
        func decode(_: UInt8.Type, forKey key: K) throws -> UInt8 {
            try decodeFixedWidthInteger(key: key)
        }
        
        func decode(_: UInt16.Type, forKey key: K) throws -> UInt16 {
            try decodeFixedWidthInteger(key: key)
        }
        
        func decode(_: UInt32.Type, forKey key: K) throws -> UInt32 {
            try decodeFixedWidthInteger(key: key)
        }
        
        func decode(_: UInt64.Type, forKey key: K) throws -> UInt64 {
            try decodeFixedWidthInteger(key: key)
        }
    
        func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T: Decodable {
            var newDecoder: XMLDecoder

            if type is any Collection.Type {
                newDecoder = try decoderForArray(key)
            } else {
                newDecoder = try decoderForKey(key)
            }
            
            return try newDecoder.unwrap(as: type)
        }

        private func decoderForArray(_ key: K) throws -> XMLDecoder {
            var newPath = self.codingPath
            newPath.append(key)

            guard let node = node(forKey: key) as? XMLElement, let name = node.name, let parent = node.parent as? XMLElement else {
                throw DecodingError.valueNotFound(String.self, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "Could not decode."))
            }

            return XMLDecoder(
                from: parent,
                at: newPath,
                elementName: name,
                namespace: self.decoder.namespace,
                options: self.decoder.options
            )
        }

        private func decoderForKey(_ key: K) throws -> XMLDecoder {
            var newPath = self.codingPath
            newPath.append(key)

            guard let node = node(forKey: key) else {
                throw DecodingError.valueNotFound(String.self, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "Could not decode."))
            }

            if node.kind == .namespace {
                return XMLDecoder(
                    from: self.decoder.element,
                    at: newPath,
                    namespace: node,
                    options: self.decoder.options
                )
            } else if let element = node as? XMLElement {
                return XMLDecoder(
                    from: element,
                    at: newPath,
                    namespace: self.decoder.namespace,
                    options: self.decoder.options
                )
            } else {
                throw DecodingError.valueNotFound(String.self, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "Could not decode."))
            }
        }

        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: K) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            fatalError()
        }
        
        func nestedUnkeyedContainer(forKey key: K) throws -> UnkeyedDecodingContainer {
            fatalError()
        }
        
        func superDecoder() throws -> Decoder {
            fatalError()
        }
        
        func superDecoder(forKey key: K) throws -> Decoder {
            fatalError()
        }
        
        @inline(__always) private func decodeFixedWidthInteger<T: FixedWidthInteger>(key: Self.Key) throws -> T {
            guard let node = node(forKey: key) else {
                throw DecodingError.valueNotFound(String.self, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "Could not decode."))
            }
            return try self.decoder.unwrapFixedWidthInteger(from: node, for: key, as: T.self)
        }
        
        @inline(__always) private func decodeFloatingPoint<T: LosslessStringConvertible & BinaryFloatingPoint>(key: K) throws -> T {
            guard let value = node(forKey: key) else {
                throw DecodingError.valueNotFound(String.self, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "Could not decode."))
            }
            
            return try self.decoder.unwrapFloatingPoint(from: value, for: key, as: T.self)
        }
    }
}

// MARK: Unkeyed Container

extension XMLDecoder {
    struct UnkeyedContainer: UnkeyedDecodingContainer {
        /// A reference to the decoder we're reading from.
        private let decoder: XMLDecoder
        
        /// The container's filtered children nodes.
        private var array: [XMLNode]
        
        /// The path of coding keys taken to get to this point in decoding.
        var codingPath: [CodingKey]
        
        var currentIndex: Int
        
        /// Initializes `self` by referencing the given decoder and container.
        fileprivate init(decoder: XMLDecoder, array: [XMLNode]) {
            self.decoder = decoder
            self.codingPath = decoder.codingPath
            self.currentIndex = 0
            self.array = array
        }
        
        // MARK: - UnkeyedDecodingContainer Methods
        
        public var count: Int? {
            return self.array.count
        }
        
        public var isAtEnd: Bool {
            return self.currentIndex >= self.count!
        }
        
        private func decodeStringAtCurrentIndex() throws -> String? {
            guard !self.isAtEnd else {
                throw DecodingError.valueNotFound(String.self, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "Unkeyed container is at end."))
            }
            return self.array[currentIndex].stringValue
        }
        
        mutating func decodeNil() throws -> Bool {
            fatalError()
        }
        
        mutating func decode(_ type: Bool.Type) throws -> Bool {
            guard let string = try self.decodeStringAtCurrentIndex(), let value = Bool(string)  else {
                throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "Expected \(type) but found empty node instead."))
            }
            return value
        }
        
        mutating func decode(_ type: String.Type) throws -> String {
            let decoded = try self.decodeStringAtCurrentIndex() ?? ""
            self.currentIndex += 1
            return decoded
        }
        
        mutating func decode(_: Double.Type) throws -> Double {
            try decodeFloatingPoint()
        }
        
        mutating func decode(_: Float.Type) throws -> Float {
            try decodeFloatingPoint()
        }
        
        mutating func decode(_: Int.Type) throws -> Int {
            try decodeFixedWidthInteger()
        }
        
        mutating func decode(_: Int8.Type) throws -> Int8 {
            try decodeFixedWidthInteger()
        }
        
        mutating func decode(_: Int16.Type) throws -> Int16 {
            try decodeFixedWidthInteger()
        }
        
        mutating func decode(_: Int32.Type) throws -> Int32 {
            try decodeFixedWidthInteger()
        }
        
        mutating func decode(_: Int64.Type) throws -> Int64 {
            try decodeFixedWidthInteger()
        }
        
        mutating func decode(_: UInt.Type) throws -> UInt {
            try decodeFixedWidthInteger()
        }
        
        mutating func decode(_: UInt8.Type) throws -> UInt8 {
            try decodeFixedWidthInteger()
        }
        
        mutating func decode(_: UInt16.Type) throws -> UInt16 {
            try decodeFixedWidthInteger()
        }
        
        mutating func decode(_: UInt32.Type) throws -> UInt32 {
            try decodeFixedWidthInteger()
        }
        
        mutating func decode(_: UInt64.Type) throws -> UInt64 {
            try decodeFixedWidthInteger()
        }
        
        mutating func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
            let newDecoder = try decoderForNextElement(ofType: type)
            let result = try newDecoder.unwrap(as: type)
            
            // Because of the requirement that the index not be incremented unless
            // decoding the desired result type succeeds, it can not be a tail call.
            // Hopefully the compiler still optimizes well enough that the result
            // doesn't get copied around.
            self.currentIndex += 1
            return result
        }
        
        mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            fatalError()
        }
        
        mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
            fatalError()
        }
        
        mutating func superDecoder() throws -> Decoder {
            fatalError()
        }
        
        private mutating func decoderForNextElement<T>(ofType: T.Type) throws -> XMLDecoder {
            let value = try self.getNextValue(ofType: T.self)
            let newPath = self.codingPath + [_XMLKey(index: self.currentIndex)]
            
            return XMLDecoder(
                from: value as! XMLElement,
                at: newPath,
                namespace: self.decoder.namespace,
                options: self.decoder.options
            )
        }
        
        @inline(__always)
        private func getNextValue<T>(ofType: T.Type) throws -> XMLNode {
            guard !self.isAtEnd else {
                var message = "Unkeyed container is at end."
                if T.self == UnkeyedContainer.self {
                    message = "Cannot get nested unkeyed container -- unkeyed container is at end."
                }
                if T.self == Decoder.self {
                    message = "Cannot get superDecoder() -- unkeyed container is at end."
                }
                
                var path = self.codingPath
                path.append(_XMLKey(index: self.currentIndex))
                
                throw DecodingError.valueNotFound(
                    T.self,
                    .init(codingPath: path,
                          debugDescription: message,
                          underlyingError: nil))
            }
            return self.array[self.currentIndex]
        }
        
        @inline(__always) private mutating func decodeFixedWidthInteger<T: FixedWidthInteger>() throws -> T {
            let value = try self.getNextValue(ofType: T.self)
            let key = _XMLKey(index: self.currentIndex)
            let result = try self.decoder.unwrapFixedWidthInteger(from: value, for: key, as: T.self)
            self.currentIndex += 1
            return result
        }
        
        @inline(__always) private mutating func decodeFloatingPoint<T: LosslessStringConvertible & BinaryFloatingPoint>() throws -> T {
            let value = try self.getNextValue(ofType: T.self)
            let key = _XMLKey(index: self.currentIndex)
            let result = try self.decoder.unwrapFloatingPoint(from: value, for: key, as: T.self)
            self.currentIndex += 1
            return result
        }
    }
}
