//
//  FeedDataType.swift
//
//  Copyright (c) 2016 - 2018 Nuno Manuel Dias
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

/// Types of data to determine how to parse a feed.
///
/// - xml: XML Data Type.
/// - json: JSON Data Type.
enum FeedDataType: String {
    case xml
    case json
}

fileprivate let inspectionPrefixLength = 200

extension FeedDataType {
    
    /// A `FeedDataType` from the specified `Data` object
    ///
    /// - Parameter data: The `Data` object.
    init?(data: Data) {
        // As a practical matter, the dispositive characters will be found near
        // the start of the buffer. It's expensive to convert the entire buffer to
        // a string because the conversion is not lazy. So inspect only a prefix
        // of the buffer.
        let string = String(decoding: data.prefix(inspectionPrefixLength), as: UTF8.self)
        let dispositiveCharacters = CharacterSet.alphanumerics
            .union(CharacterSet.punctuationCharacters)
            .union(CharacterSet.symbols)
        for scalar in string.unicodeScalars {
            if !dispositiveCharacters.contains(scalar) { // Skip whitespace, BOM marker if present
                continue
            }
            let char = Character(scalar)
            switch char {
                case "<":
                    self = .xml
                    return
                case "{":
                    self = .json
                    return
                default:
                    return nil
            }
        }
        return nil
    }
    
}
