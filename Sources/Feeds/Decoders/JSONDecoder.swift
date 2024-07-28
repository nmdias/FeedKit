//
//  JSONDecoder.swift
//
//  Based on decoderementation from the Swift.org open source project
//
//  See https://swift.org/LICENSE.txt for license information
//  See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//  Created by Axel Martinez on 2/7/24.
//

import Foundation

// MARK: File private

fileprivate struct _JSONKey : CodingKey {
    public var stringValue: String
    public var intValue: Int?
    
    public init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    public init?(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
    
    public init(stringValue: String, intValue: Int?) {
        self.stringValue = stringValue
        self.intValue = intValue
    }
    
    init(index: Int) {
        self.stringValue = "Index \(index)"
        self.intValue = index
    }
    
    static let `super` = _JSONKey(stringValue: "super")!
}

fileprivate protocol _JSONStringDictionaryDecodableMarker {
    static var elementType: Decodable.Type { get }
}

extension Dictionary: _JSONStringDictionaryDecodableMarker where Key == String, Value: Decodable {
    fileprivate static var elementType: Decodable.Type { return Value.self }
}

extension Decodable {
    fileprivate static func createByDirectlyUnwrapping(from decoder: JSONDecoder) throws -> Self {
        if Self.self == URL.self
            || Self.self == Date.self
            || Self.self == Data.self
            || Self.self == Decimal.self
            || Self.self is _JSONStringDictionaryDecodableMarker.Type
        {
            return try decoder.unwrap(as: Self.self)
        }
        
        return try Self.init(from: decoder)
    }
}

// MARK: Decoder

struct JSONDecoder {
    let userInfo: [CodingUserInfoKey: Any]
    let codingPath: [CodingKey]
    let json: JSONValue
    let options: DecoderOptions
    
    init(userInfo: [CodingUserInfoKey: Any] = [:], from json: JSONValue, codingPath: [CodingKey] = [], options: DecoderOptions = .init()) {
        self.userInfo = userInfo
        self.codingPath = codingPath
        self.json = json
        self.options = options
    }
}

extension JSONDecoder: Decoder {
    @usableFromInline func container<Key>(keyedBy _: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
        switch self.json {
        case .object(let dictionary):
            let container = KeyedContainer<Key>(
                decoder: self,
                codingPath: codingPath,
                dictionary: dictionary
            )
            return KeyedDecodingContainer(container)
        case .null:
            throw DecodingError.valueNotFound([String: JSONValue].self, DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Cannot get keyed decoding container -- found null value instead"
            ))
        default:
            throw DecodingError.typeMismatch([String: JSONValue].self, DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected to decode \([String: JSONValue].self) but found \(self.json.debugDataTypeDescription) instead."
            ))
        }
    }
    
    @usableFromInline func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        switch self.json {
        case .array(let array):
            return UnkeyedContainer(
                decoder: self,
                codingPath: self.codingPath,
                array: array
            )
        case .null:
            throw DecodingError.valueNotFound([String: JSONValue].self, DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Cannot get unkeyed decoding container -- found null value instead"
            ))
        default:
            throw DecodingError.typeMismatch([JSONValue].self, DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected to decode \([JSONValue].self) but found \(self.json.debugDataTypeDescription) instead."
            ))
        }
    }
    
    @usableFromInline func singleValueContainer() throws -> SingleValueDecodingContainer {
        SingleValueContainer(
            decoder: self,
            codingPath: self.codingPath,
            json: self.json
        )
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
        if type == Decimal.self {
            return try self.unwrapDecimal() as! T
        }
        if type is _JSONStringDictionaryDecodableMarker.Type {
            return try self.unwrapDictionary(as: type)
        }
        
        return try type.init(from: self)
    }
    
    private func unwrapDate() throws -> Date {
        switch self.options.dateDecodingStrategy {
        case .deferredToDate:
            return try Date(from: self)
            
        case .secondsSince1970:
            let container = SingleValueContainer(decoder: self, codingPath: self.codingPath, json: self.json)
            let double = try container.decode(Double.self)
            return Date(timeIntervalSince1970: double)
            
        case .millisecondsSince1970:
            let container = SingleValueContainer(decoder: self, codingPath: self.codingPath, json: self.json)
            let double = try container.decode(Double.self)
            return Date(timeIntervalSince1970: double / 1000.0)
            
        case .iso8601:
            if #available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) {
                let container = SingleValueContainer(decoder: self, codingPath: self.codingPath, json: self.json)
                let string = try container.decode(String.self)
                guard let date = ISO8601DateFormatter().date(from: string) else {
                    throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Expected date string to be ISO8601-formatted."))
                }
                
                return date
            } else {
                fatalError("ISO8601DateFormatter is unavailable on this platform.")
            }
            
        case .formatted(let formatter):
            let container = SingleValueContainer(decoder: self, codingPath: self.codingPath, json: self.json)
            let string = try container.decode(String.self)
            guard let date = formatter.date(from: string) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Date string does not match format expected by formatter."))
            }
            return date
            
        case .custom(let closure):
            return try closure(self)
        }
    }
    
    private func unwrapData() throws -> Data {
        switch self.options.dataDecodingStrategy {
        case .deferredToData:
            return try Data(from: self)
            
        case .base64:
            let container = SingleValueContainer(decoder: self, codingPath: self.codingPath, json: self.json)
            let string = try container.decode(String.self)
            
            guard let data = Data(base64Encoded: string) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Encountered Data is not valid Base64."))
            }
            
            return data
            
        case .custom(let closure):
            return try closure(self)
        }
    }
    
    private func unwrapURL() throws -> URL {
        let container = SingleValueContainer(decoder: self, codingPath: self.codingPath, json: self.json)
        let string = try container.decode(String.self)
        
        guard let url = URL(string: string) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath,
                                                                    debugDescription: "Invalid URL string."))
        }
        return url
    }
    
    private func unwrapDecimal() throws -> Decimal {
        guard case .number(let numberString) = self.json else {
            throw DecodingError.typeMismatch(Decimal.self, DecodingError.Context(codingPath: self.codingPath, debugDescription: ""))
        }
        
        guard let decimal = Decimal(string: numberString) else {
            throw DecodingError.dataCorrupted(.init(
                codingPath: self.codingPath,
                debugDescription: "Parsed JSON number <\(numberString)> does not fit in \(Decimal.self)."))
        }
        
        return decimal
    }
    
    private func unwrapDictionary<T: Decodable>(as: T.Type) throws -> T {
        guard let dictType = T.self as? (_JSONStringDictionaryDecodableMarker & Decodable).Type else {
            preconditionFailure("Must only be called of T decoderements _JSONStringDictionaryDecodableMarker")
        }
        
        guard case .object(let object) = self.json else {
            throw DecodingError.typeMismatch([String: JSONValue].self, DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected to decode \([String: JSONValue].self) but found \(self.json.debugDataTypeDescription) instead."
            ))
        }
        
        var result = [String: Any]()
        
        for (key, value) in object {
            var newPath = self.codingPath
            newPath.append(_JSONKey(stringValue: key)!)
            let newDecoder = JSONDecoder(userInfo: self.userInfo, from: value, codingPath: newPath, options: self.options)
            
            result[key] = try dictType.elementType.createByDirectlyUnwrapping(from: newDecoder)
        }
        
        return result as! T
    }
    
    private func unwrapFloatingPoint<T: LosslessStringConvertible & BinaryFloatingPoint>(
        from value: JSONValue,
        for additionalKey: CodingKey? = nil,
        as type: T.Type) throws -> T
    {
        if case .number(let number) = value {
            guard let floatingPoint = T(number), floatingPoint.isFinite else {
                var path = self.codingPath
                if let additionalKey = additionalKey {
                    path.append(additionalKey)
                }
                throw DecodingError.dataCorrupted(.init(
                    codingPath: path,
                    debugDescription: "Parsed JSON number <\(number)> does not fit in \(T.self)."))
            }
            
            return floatingPoint
        }
        
        if case .string(let string) = value,
           case .convertFromString(let posInfString, let negInfString, let nanString) =
            self.options.nonConformingFloatDecodingStrategy
        {
            if string == posInfString {
                return T.infinity
            } else if string == negInfString {
                return -T.infinity
            } else if string == nanString {
                return T.nan
            }
        }
        
        throw self.createTypeMismatchError(type: T.self, for: additionalKey, value: value)
    }
    
    private func unwrapFixedWidthInteger<T: FixedWidthInteger>(
        from value: JSONValue,
        for additionalKey: CodingKey? = nil,
        as type: T.Type) throws -> T
    {
        guard case .number(let number) = value else {
            throw self.createTypeMismatchError(type: T.self, for: additionalKey, value: value)
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
        throw DecodingError.dataCorrupted(.init(
            codingPath: path,
            debugDescription: "Parsed JSON number <\(number)> does not fit in \(T.self)."))
    }
    
    private func createTypeMismatchError(type: Any.Type, for additionalKey: CodingKey? = nil, value: JSONValue) -> DecodingError {
        var path = self.codingPath
        if let additionalKey = additionalKey {
            path.append(additionalKey)
        }
        
        return DecodingError.typeMismatch(type, .init(
            codingPath: path,
            debugDescription: "Expected to decode \(type) but found \(value.debugDataTypeDescription) instead."
        ))
    }
}

// MARK: Single Value Container

extension JSONDecoder {
    struct SingleValueContainer: SingleValueDecodingContainer {
        let decoder: JSONDecoder
        let value: JSONValue
        let codingPath: [CodingKey]

        init(decoder: JSONDecoder, codingPath: [CodingKey], json: JSONValue) {
            self.decoder = decoder
            self.codingPath = codingPath
            self.value = json
        }
        
        func decodeNil() -> Bool {
            self.value == .null
        }
        
        func decode(_: Bool.Type) throws -> Bool {
            guard case .bool(let bool) = self.value else {
                throw self.decoder.createTypeMismatchError(type: Bool.self, value: self.value)
            }
            
            return bool
        }
        
        func decode(_: String.Type) throws -> String {
            guard case .string(let string) = self.value else {
                throw self.decoder.createTypeMismatchError(type: String.self, value: self.value)
            }
            
            return string
        }
        
        func decode(_: Double.Type) throws -> Double {
            try decodeFloatingPoint()
        }
        
        func decode(_: Float.Type) throws -> Float {
            try decodeFloatingPoint()
        }
        
        func decode(_: Int.Type) throws -> Int {
            try decodeFixedWidthInteger()
        }
        
        func decode(_: Int8.Type) throws -> Int8 {
            try decodeFixedWidthInteger()
        }
        
        func decode(_: Int16.Type) throws -> Int16 {
            try decodeFixedWidthInteger()
        }
        
        func decode(_: Int32.Type) throws -> Int32 {
            try decodeFixedWidthInteger()
        }
        
        func decode(_: Int64.Type) throws -> Int64 {
            try decodeFixedWidthInteger()
        }
        
        func decode(_: UInt.Type) throws -> UInt {
            try decodeFixedWidthInteger()
        }
        
        func decode(_: UInt8.Type) throws -> UInt8 {
            try decodeFixedWidthInteger()
        }
        
        func decode(_: UInt16.Type) throws -> UInt16 {
            try decodeFixedWidthInteger()
        }
        
        func decode(_: UInt32.Type) throws -> UInt32 {
            try decodeFixedWidthInteger()
        }
        
        func decode(_: UInt64.Type) throws -> UInt64 {
            try decodeFixedWidthInteger()
        }
        
        func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
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

extension JSONDecoder {
    struct KeyedContainer<K: CodingKey>: KeyedDecodingContainerProtocol {
        typealias Key = K

        let decoder: JSONDecoder
        let codingPath: [CodingKey]
        let dictionary: [String: JSONValue]

        init(decoder: JSONDecoder, codingPath: [CodingKey], dictionary: [String: JSONValue]) {
            self.decoder = decoder
            self.codingPath = codingPath
            
            switch decoder.options.keyDecodingStrategy {
            case .useDefaultKeys:
                self.dictionary = dictionary
            case .convertFromSnakeCase:
                // Convert the snake case keys in the container to camel case.
                // If we hit a duplicate key after conversion, then we'll use the first one we saw.
                // Effectively an undefined behavior with JSON dictionaries.
                var converted = [String: JSONValue]()
                converted.reserveCapacity(dictionary.count)
                dictionary.forEach { (key, value) in
                    converted[KeyedContainer.convertFromSnakeCase(key)] = value
                }
                self.dictionary = converted
            case .custom(let converter):
                var converted = [String: JSONValue]()
                converted.reserveCapacity(dictionary.count)
                dictionary.forEach { (key, value) in
                    var pathForKey = codingPath
                    pathForKey.append(_JSONKey(stringValue: key)!)
                    converted[converter(pathForKey).stringValue] = value
                }
                self.dictionary = converted
            }
        }
        
        static func convertFromSnakeCase(_ stringKey: String) -> String {
            guard !stringKey.isEmpty else { return stringKey }
            
            // Find the first non-underscore character
            guard let firstNonUnderscore = stringKey.firstIndex(where: { $0 != "_" }) else {
                // Reached the end without finding an _
                return stringKey
            }
            
            // Find the last non-underscore character
            var lastNonUnderscore = stringKey.index(before: stringKey.endIndex)
            while lastNonUnderscore > firstNonUnderscore && stringKey[lastNonUnderscore] == "_" {
                stringKey.formIndex(before: &lastNonUnderscore)
            }
            
            let keyRange = firstNonUnderscore...lastNonUnderscore
            let leadingUnderscoreRange = stringKey.startIndex..<firstNonUnderscore
            let trailingUnderscoreRange = stringKey.index(after: lastNonUnderscore)..<stringKey.endIndex
            
            let components = stringKey[keyRange].split(separator: "_")
            let joinedString: String
            if components.count == 1 {
                // No underscores in key, leave the word as is - maybe already camel cased
                joinedString = String(stringKey[keyRange])
            } else {
                joinedString = ([components[0].lowercased()] + components[1...].map { $0.capitalized }).joined()
            }
            
            // Do a cheap isEmpty check before creating and appending potentially empty strings
            let result: String
            if (leadingUnderscoreRange.isEmpty && trailingUnderscoreRange.isEmpty) {
                result = joinedString
            } else if (!leadingUnderscoreRange.isEmpty && !trailingUnderscoreRange.isEmpty) {
                // Both leading and trailing underscores
                result = String(stringKey[leadingUnderscoreRange]) + joinedString + String(stringKey[trailingUnderscoreRange])
            } else if (!leadingUnderscoreRange.isEmpty) {
                // Just leading
                result = String(stringKey[leadingUnderscoreRange]) + joinedString
            } else {
                // Just trailing
                result = joinedString + String(stringKey[trailingUnderscoreRange])
            }
            return result
        }
        
        var allKeys: [K] {
            self.dictionary.keys.compactMap { K(stringValue: $0) }
        }
        
        func contains(_ key: K) -> Bool {
            if let _ = dictionary[key.stringValue] {
                return true
            }
            return false
        }
        
        func decodeNil(forKey key: K) throws -> Bool {
            let value = try getValue(forKey: key)
            return value == .null
        }
        
        func decode(_ type: Bool.Type, forKey key: K) throws -> Bool {
            let value = try getValue(forKey: key)
            
            guard case .bool(let bool) = value else {
                throw createTypeMismatchError(type: type, forKey: key, value: value)
            }
            
            return bool
        }
        
        func decode(_ type: String.Type, forKey key: K) throws -> String {
            let value = try getValue(forKey: key)
            
            guard case .string(let string) = value else {
                throw createTypeMismatchError(type: type, forKey: key, value: value)
            }
            
            return string
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
            let newDecoder = try decoderForKey(key)
            return try newDecoder.unwrap(as: type)
        }
        
        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: K) throws
        -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey
        {
            try decoderForKey(key).container(keyedBy: type)
        }
        
        func nestedUnkeyedContainer(forKey key: K) throws -> UnkeyedDecodingContainer {
            try decoderForKey(key).unkeyedContainer()
        }
        
        func superDecoder() throws -> Decoder {
            return decoderForKeyNoThrow(_JSONKey.super)
        }
        
        func superDecoder(forKey key: K) throws -> Decoder {
            return decoderForKeyNoThrow(key)
        }
        
        private func decoderForKey<LocalKey: CodingKey>(_ key: LocalKey) throws -> JSONDecoder {
            let value = try getValue(forKey: key)
            var newPath = self.codingPath
            newPath.append(key)
            
            return JSONDecoder(
                userInfo: self.decoder.userInfo,
                from: value,
                codingPath: newPath,
                options: self.decoder.options
            )
        }
        
        private func decoderForKeyNoThrow<LocalKey: CodingKey>(_ key: LocalKey) -> JSONDecoder {
            let value: JSONValue
            do {
                value = try getValue(forKey: key)
            } catch {
                // if there no value for this key then return a null value
                value = .null
            }
            var newPath = self.codingPath
            newPath.append(key)
            
            return JSONDecoder(
                userInfo: self.decoder.userInfo,
                from: value,
                codingPath: newPath,
                options: self.decoder.options
            )
        }
        
        @inline(__always) private func getValue<LocalKey: CodingKey>(forKey key: LocalKey) throws -> JSONValue {
            guard let value = dictionary[key.stringValue] else {
                throw DecodingError.keyNotFound(key, .init(
                    codingPath: self.codingPath,
                    debugDescription: "No value associated with key \(key) (\"\(key.stringValue)\")."
                ))
            }
            
            return value
        }
        
        @inline(__always) private func createTypeMismatchError(type: Any.Type, forKey key: K, value: JSONValue) -> DecodingError {
            let codingPath = self.codingPath + [key]
            return DecodingError.typeMismatch(type, .init(
                codingPath: codingPath, debugDescription: "Expected to decode \(type) but found \(value.debugDataTypeDescription) instead."
            ))
        }
        
        @inline(__always) private func decodeFixedWidthInteger<T: FixedWidthInteger>(key: Self.Key) throws -> T {
            let value = try getValue(forKey: key)
            return try self.decoder.unwrapFixedWidthInteger(from: value, for: key, as: T.self)
        }
        
        @inline(__always) private func decodeFloatingPoint<T: LosslessStringConvertible & BinaryFloatingPoint>(key: K) throws -> T {
            let value = try getValue(forKey: key)
            return try self.decoder.unwrapFloatingPoint(from: value, for: key, as: T.self)
        }
    }
}

// MARK: Unkeyed Container

extension JSONDecoder {
    struct UnkeyedContainer: UnkeyedDecodingContainer {
        let decoder: JSONDecoder
        let codingPath: [CodingKey]
        let array: [JSONValue]

        var count: Int? { self.array.count }
        var isAtEnd: Bool { self.currentIndex >= (self.count ?? 0) }
        var currentIndex = 0

        init(decoder: JSONDecoder, codingPath: [CodingKey], array: [JSONValue]) {
            self.decoder = decoder
            self.codingPath = codingPath
            self.array = array
        }
        
        mutating func decodeNil() throws -> Bool {
            if try self.getNextValue(ofType: Never.self) == .null {
                self.currentIndex += 1
                return true
            }
            
            // The protocol states:
            //   If the value is not null, does not increment currentIndex.
            return false
        }
        
        mutating func decode(_ type: Bool.Type) throws -> Bool {
            let value = try self.getNextValue(ofType: Bool.self)
            guard case .bool(let bool) = value else {
                throw decoder.createTypeMismatchError(type: type, for: _JSONKey(index: currentIndex), value: value)
            }
            
            self.currentIndex += 1
            return bool
        }
        
        mutating func decode(_ type: String.Type) throws -> String {
            let value = try self.getNextValue(ofType: String.self)
            guard case .string(let string) = value else {
                throw decoder.createTypeMismatchError(type: type, for: _JSONKey(index: currentIndex), value: value)
            }
            
            self.currentIndex += 1
            return string
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
        
        mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws
        -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey
        {
            let decoder = try decoderForNextElement(ofType: KeyedDecodingContainer<NestedKey>.self)
            let container = try decoder.container(keyedBy: type)
            
            self.currentIndex += 1
            return container
        }
        
        mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
            let decoder = try decoderForNextElement(ofType: UnkeyedDecodingContainer.self)
            let container = try decoder.unkeyedContainer()
            
            self.currentIndex += 1
            return container
        }
        
        mutating func superDecoder() throws -> Decoder {
            let decoder = try decoderForNextElement(ofType: Decoder.self)
            self.currentIndex += 1
            return decoder
        }
        
        private mutating func decoderForNextElement<T>(ofType: T.Type) throws -> JSONDecoder {
            let value = try self.getNextValue(ofType: T.self)
            let newPath = self.codingPath + [_JSONKey(index: self.currentIndex)]
            
            return JSONDecoder(
                userInfo: self.decoder.userInfo,
                from: value,
                codingPath: newPath,
                options: self.decoder.options
            )
        }
        
        @inline(__always)
        private func getNextValue<T>(ofType: T.Type) throws -> JSONValue {
            guard !self.isAtEnd else {
                var message = "Unkeyed container is at end."
                if T.self == UnkeyedContainer.self {
                    message = "Cannot get nested unkeyed container -- unkeyed container is at end."
                }
                if T.self == Decoder.self {
                    message = "Cannot get superDecoder() -- unkeyed container is at end."
                }
                
                var path = self.codingPath
                path.append(_JSONKey(index: self.currentIndex))
                
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
            let key = _JSONKey(index: self.currentIndex)
            let result = try self.decoder.unwrapFixedWidthInteger(from: value, for: key, as: T.self)
            self.currentIndex += 1
            return result
        }
        
        @inline(__always) private mutating func decodeFloatingPoint<T: LosslessStringConvertible & BinaryFloatingPoint>() throws -> T {
            let value = try self.getNextValue(ofType: T.self)
            let key = _JSONKey(index: self.currentIndex)
            let result = try self.decoder.unwrapFloatingPoint(from: value, for: key, as: T.self)
            self.currentIndex += 1
            return result
        }
    }
}
