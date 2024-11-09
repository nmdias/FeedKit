//
//  FeedKitTests + XMLParser.swift
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

@testable import FeedKit
import Testing

extension FeedKitTests {
  @Test
  func xmlParser() {
    // Given
    let data = data(resource: "XML", withExtension: "xml")
    
    let parser = XMLParser(data: data)

    let expected = XMLDocument(
      root: .init(
        name: "root",
        children: [
          .init(
            name: "metadata",
            children: [
              .init(
                name: "title",
                text: "Sample Document"
              ),
              .init(
                name: "description",
                text: "This is a sample document."
              ),
            ]
          ),
          .init(
            name: "data",
            children: [
              .init(
                name: "item",
                attributes: [
                  "id": "1",
                ],
                children: [
                  .init(
                    name: "name",
                    text: "Item 1"
                  ),
                  .init(
                    name: "description",
                    text: "This is a sample description for Item 1."
                  ),
                ]
              ),
              .init(
                name: "item",
                attributes: ["id": "2"],
                children: [
                  .init(
                    name: "name",
                    text: "Item 2"
                  ),
                  .init(
                    name: "description",
                    text: "This is a sample description for Item 2."
                  ),
                ]
              ),
            ]
          ),
        ]
      ))

    // When
    let actual = try? parser.parse().get()

    // Then
    #expect(expected == actual)
  }
}
