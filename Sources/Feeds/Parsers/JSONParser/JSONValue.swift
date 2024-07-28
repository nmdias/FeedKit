//
//  JSONValue.swift
//
//  Based on implementation from the Swift.org open source project
//
//  See https://swift.org/LICENSE.txt for license information
//  See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//  Created by Axel Martinez on 2/7/24.
//

enum JSONValue: Equatable {
    case string(String)
    case number(String)
    case bool(Bool)
    case null
    
    case array([JSONValue])
    case object([String: JSONValue])
}

extension JSONValue {
    var debugDataTypeDescription: String {
        switch self {
        case .array:
            return "an array"
        case .bool:
            return "bool"
        case .number:
            return "a number"
        case .string:
            return "a string"
        case .object:
            return "a dictionary"
        case .null:
            return "null"
        }
    }
}
