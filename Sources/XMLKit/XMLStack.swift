//
// XMLStack.swift
//
// Copyright (c) 2016 - 2025 Nuno Dias
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

struct XMLStack {
  // MARK: Internal

  /// The number of `XMLNode` instances in the stack.
  var count: Int {
    stack.count
  }

  /// Pushes an `XMLNode` onto the stack.
  /// - Parameter node: The `XMLNode` to add to the stack.
  mutating func push(_ node: XMLNode) {
    stack.append(node)
  }

  /// Removes and returns the top `XMLNode` from the stack.
  /// - Returns: The top `XMLNode` if the stack is not empty, otherwise `nil`.
  @discardableResult
  mutating func pop() -> XMLNode? {
    stack.popLast()
  }

  /// Returns the top `XMLNode` without removing it from the stack.
  /// - Returns: The top `XMLNode` if the stack is not empty, otherwise `nil`.
  mutating func top() -> XMLNode? {
    stack.last
  }

  // MARK: Private

  /// The internal storage for the `XMLNode` stack.
  private var stack: [XMLNode] = []
}
