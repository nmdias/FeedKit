//
//  XMLCodingKey.swift
//
//  Copyright (c) 2016 - 2024 Nuno Dias
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

/// A custom `CodingKey` implementation for encoding XML nodes.
struct XMLCodingKey: CodingKey {
  /// The string value of the coding key.
  var stringValue: String
  /// The integer value of the coding key, or `nil` if not applicable.
  var intValue: Int?
  
  /// Initializes a new coding key with a string value.
  /// - Parameter stringValue: The string value for the key.
  init?(stringValue: String) {
    self.stringValue = stringValue
    intValue = nil
  }

  /// Initializes a new coding key with an integer value.
  /// - Parameter intValue: The integer value for the key.
  init?(intValue: Int) {
    stringValue = "\(intValue)"
    self.intValue = intValue
  }

  /// Initializes a new coding key with both a string and an integer value.
  /// - Parameters:
  ///   - stringValue: The string value for the key.
  ///   - intValue: The integer value for the key.
  init(stringValue: String, intValue: Int?) {
    self.stringValue = stringValue
    self.intValue = intValue
  }
}
