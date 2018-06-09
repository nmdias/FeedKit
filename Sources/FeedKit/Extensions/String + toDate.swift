//
//  String + toDate.swift
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

extension String {
    
    /// Attempts to convert the textual representation of a date with
    /// the specified `DateSpec` to a `Date` object.
    ///
    /// - Parameter spec: The `DateSpec` to interpert the string.
    /// - Returns: A `Date` object, or nil if the conversion failed.
    func toDate(from spec: DateSpec) -> Date? {
        switch spec {
        case .rfc822:   return RFC822DateFormatter().date(from: self)
        case .rfc3999:  return RFC3339DateFormatter().date(from: self)
        case .iso8601:  return ISO8601DateFormatter().date(from: self)
        }
    }
    
    /// Attempts to convert the textual representation of a date to a
    /// `Date` object according to several common schemes.
    ///
    /// - Returns: A `Date` object, or nil if the conversion failed.
    func toPermissiveDate() -> Date? {
        return RFC822DateFormatter().date(from: self) ??
            (RFC3339DateFormatter().date(from: self) ??
            ISO8601DateFormatter().date(from: self))
    }
    
}
