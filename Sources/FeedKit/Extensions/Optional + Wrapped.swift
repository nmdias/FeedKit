//
//  Optional + Wrapped.swift
//
//  Copyright (c) 2016 - 2024 Nuno Manuel Dias
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

/// An extension on `Optional` where the `Wrapped` type conforms to
/// `RangeReplaceableCollection`. Provides a convenient way to append an
/// element to an optional collection, initializing the collection if
/// it is currently `nil`.
extension Optional where Wrapped: RangeReplaceableCollection {
  /// Appends a new element to the collection, initializing the collection
  /// if it is `nil`.
  ///
  /// - Parameter value: The element to append to the collection.
  ///
  /// If the optional collection is `nil`, it creates a new instance of the
  /// collection containing the element. If the collection is already
  /// initialized, it appends the element to the existing collection.
  mutating func append(_ value: Wrapped.Element) {
    if self == nil {
      self = [value] as? Wrapped
    } else {
      self?.append(value)
    }
  }
}
