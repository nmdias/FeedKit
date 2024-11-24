//
//  Sample + Mocks.swift
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

extension Sample {
  static var mock: Sample {
    .init(
      header: .init(
        title: "Sample Document",
        description: "This is a sample document.",
        version: "1.0",
        keywords: .init(
          keyword: [
            "Generic",
            "Placeholder",
          ]
        )
      ),
      content: .init(
        item: [
          .init(
            attributes: .init(
              id: 1,
              value: "01"
            ),
            name: "Item 1",
            description: "This is a sample description for Item 1.",
            precision: 1.11,
            details: .init(
              detail: [
                "Detail 1A",
                "Detail 1B",
              ]
            )
          ),
          .init(
            attributes: .init(
              id: 2,
              value: "02"
            ),
            name: "Item 2",
            description: "This is a sample description for Item 2.",
            precision: 2.22,
            details: .init(
              detail: [
                "Detail 2A",
                "Detail 2B",
              ]
            )
          ),
        ]
      ),
      footer: .init(
        notes: "These are additional notes for the document.",
        created: "2024-11-16",
        revision: 1
      )
    )
  }
}

extension Sample {
  static var xmlElementMock: XMLElement {
    .init(
      name: "sample",
      children: [
        .init(
          name: "header",
          children: [
            .init(
              name: "title",
              text: "Sample Document"
            ),
            .init(
              name: "description",
              text: "This is a sample document."
            ),
            .init(
              name: "version",
              text: "1.0"
            ),
            .init(
              name: "keywords",
              children: [
                .init(
                  name: "keyword",
                  text: "Generic"
                ),
                .init(
                  name: "keyword",
                  text: "Placeholder"
                ),
              ]
            ),
          ]
        ),
        .init(
          name: "content",
          children: [
            .init(
              name: "item",
              children: [
                .init(
                  name: "attributes",
                  children: [
                    .init(
                      name: "id",
                      text: "1"
                    ),
                    .init(
                      name: "value",
                      text: "01"
                    ),
                  ]
                ),
                .init(
                  name: "name",
                  text: "Item 1"
                ),
                .init(
                  name: "description",
                  text: "This is a sample description for Item 1."
                ),
                .init(
                  name: "precision",
                  text: "1.11"
                ),
                .init(
                  name: "details",
                  children: [
                    .init(
                      name: "detail",
                      text: "Detail 1A"
                    ),
                    .init(
                      name: "detail",
                      text: "Detail 1B"
                    ),
                  ]
                ),
              ]
            ),
            .init(
              name: "item",
              attributes: [
                "id": "2",
                "value": "02",
              ],
              children: [
                .init(
                  name: "attributes",
                  children: [
                    .init(
                      name: "id",
                      text: "2"
                    ),
                    .init(
                      name: "value",
                      text: "02"
                    ),
                  ]
                ),
                .init(
                  name: "name",
                  text: "Item 2"
                ),
                .init(
                  name: "description",
                  text: "This is a sample description for Item 2."
                ),
                .init(
                  name: "precision",
                  text: "2.22"
                ),
                .init(
                  name: "details",
                  children: [
                    .init(
                      name: "detail",
                      text: "Detail 2A"
                    ),
                    .init(
                      name: "detail",
                      text: "Detail 2B"
                    ),
                  ]
                ),
              ]
            ),
          ]
        ),
        .init(
          name: "footer",
          children: [
            .init(
              name: "notes",
              text: "These are additional notes for the document."
            ),
            .init(
              name: "created",
              text: "2024-11-16"
            ),
            .init(
              name: "revision",
              text: "1"
            ),
          ]
        ),
      ]
    )
  }
}
