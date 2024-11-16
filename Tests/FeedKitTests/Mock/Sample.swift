//
//  Sample.swift
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

struct Sample: Codable, Equatable {
  struct Header: Codable, Equatable {
    struct Keywords: Codable, Equatable {
      let keyword: [String]
    }

    let title: String
    let description: String
    let version: String
    let keywords: Keywords
  }

  struct Content: Codable, Equatable {
    struct Item: Codable, Equatable {
      struct Details: Codable, Equatable {
        let detail: [String]
      }

      let id: String
      let value: String
      let name: String
      let description: String
      let details: Details
    }

    let item: [Item]
  }

  struct Footer: Codable, Equatable {
    let notes: String
    let created: String
  }

  let header: Header
  let content: Content
  let footer: Footer
}
