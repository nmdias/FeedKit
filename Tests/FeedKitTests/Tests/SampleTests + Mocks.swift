//
//  SampleTests + Mocks.swift
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
    struct Item: Equatable {
      struct Attributes: Codable, Equatable {
        let id: Int
        let value: String
      }

      struct Details: Codable, Equatable {
        let detail: [String]
      }

      struct Xhtml: Codable, Equatable {
        struct Attributes: Codable, Equatable {
          let type: String
        }

        let attributes: Attributes
        let text: String

        init(attributes: Sample.Content.Item.Xhtml.Attributes, text: String) {
          self.attributes = attributes
          self.text = text
        }

        private enum CodingKeys: String, CodingKey {
          case attributes = "@attributes"
          case text = "@text"
        }

        init(from decoder: any Decoder) throws {
          let container: KeyedDecodingContainer<Sample.Content.Item.Xhtml.CodingKeys> = try decoder.container(keyedBy: Sample.Content.Item.Xhtml.CodingKeys.self)

          attributes = try container.decode(Sample.Content.Item.Xhtml.Attributes.self, forKey: Sample.Content.Item.Xhtml.CodingKeys.attributes)
          text = try container.decode(String.self, forKey: Sample.Content.Item.Xhtml.CodingKeys.text)
        }

        func encode(to encoder: any Encoder) throws {
          var container: KeyedEncodingContainer<Sample.Content.Item.Xhtml.CodingKeys> = encoder.container(keyedBy: Sample.Content.Item.Xhtml.CodingKeys.self)

          try container.encode(attributes, forKey: Sample.Content.Item.Xhtml.CodingKeys.attributes)
          try container.encode(text, forKey: Sample.Content.Item.Xhtml.CodingKeys.text)
        }
      }

      let attributes: Attributes
      let name: String
      let description: String
      let precision: Double
      let details: Details
      let xhtml: Xhtml
    }

    let item: [Item]
  }

  struct Footer: Codable, Equatable {
    let notes: String
    let created: String
    let revision: Int
  }

  let header: Header
  let content: Content
  let footer: Footer
}

extension Sample.Content.Item: Codable {
  private enum CodingKeys: String, CodingKey {
    case attributes = "@attributes"
    case name
    case description
    case precision
    case details
    case xhtml
  }

  init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<Sample.Content.Item.CodingKeys> = try decoder.container(keyedBy: Sample.Content.Item.CodingKeys.self)

    attributes = try container.decode(Sample.Content.Item.Attributes.self, forKey: Sample.Content.Item.CodingKeys.attributes)
    name = try container.decode(String.self, forKey: Sample.Content.Item.CodingKeys.name)
    description = try container.decode(String.self, forKey: Sample.Content.Item.CodingKeys.description)
    precision = try container.decode(Double.self, forKey: Sample.Content.Item.CodingKeys.precision)
    details = try container.decode(Sample.Content.Item.Details.self, forKey: Sample.Content.Item.CodingKeys.details)
    xhtml = try container.decode(Sample.Content.Item.Xhtml.self, forKey: Sample.Content.Item.CodingKeys.xhtml)
  }

  func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<Sample.Content.Item.CodingKeys> = encoder.container(keyedBy: Sample.Content.Item.CodingKeys.self)

    try container.encode(attributes, forKey: Sample.Content.Item.CodingKeys.attributes)
    try container.encode(name, forKey: Sample.Content.Item.CodingKeys.name)
    try container.encode(description, forKey: Sample.Content.Item.CodingKeys.description)
    try container.encode(precision, forKey: Sample.Content.Item.CodingKeys.precision)
    try container.encode(details, forKey: Sample.Content.Item.CodingKeys.details)
    try container.encode(xhtml, forKey: Sample.Content.Item.CodingKeys.xhtml)
  }
}

extension SampleTests {
  var mock: Sample {
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
            ),
            xhtml: .init(
              attributes: .init(
                type: "xhtml"
              ),
              text: """
              <div xmlns="http://www.w3.org/1999/xhtml"><p><strong>Some markings</strong><a href="http://www.example.org/">Example</a></p><div class="blockquote"><p>On a quote...</p></div></div>
              """
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
            ),
            xhtml: .init(
              attributes: .init(
                type: "xhtml"
              ),
              text: """
              <div xmlns="http://www.w3.org/1999/xhtml"><p><strong>Some markings</strong><a href="http://www.example.org/">Example</a></p><div class="blockquote"><p>On a quote...</p></div></div>
              """
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

extension SampleTests {
  var xmlNodeMock: XMLNode {
    .init(
      name: "sample",
      children: [
        .init(
          name: "header",
          children: [
            .init(
              name: "title",
              text: "Sample Document",
              children: [
                .init(
                  name: "@attributes",
                  children: [
                    .init(
                      name: "type",
                      text: "text"
                    ),
                  ]
                ),
              ]
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
                  name: "@attributes",
                  children: [
                    .init(
                      type: .attribute,
                      name: "id",
                      text: "1"
                    ),
                    .init(
                      type: .attribute,
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
                .init(
                  name: "xhtml",
                  text: """
                  <div xmlns="http://www.w3.org/1999/xhtml"><p><strong>Some markings</strong><a href="http://www.example.org/">Example</a></p><div class="blockquote"><p>On a quote...</p></div></div>
                  """,
                  children: [
                    .init(
                      name: "@attributes",
                      children: [
                        .init(
                          name: "type",
                          text: "xhtml"
                        ),
                      ]
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
                  name: "@attributes",
                  children: [
                    .init(
                      type: .attribute,
                      name: "id",
                      text: "2"
                    ),
                    .init(
                      type: .attribute,
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
                .init(
                  name: "xhtml",
                  text: """
                  <div xmlns="http://www.w3.org/1999/xhtml"><p><strong>Some markings</strong><a href="http://www.example.org/">Example</a></p><div class="blockquote"><p>On a quote...</p></div></div>
                  """,
                  children: [
                    .init(
                      name: "@attributes",
                      children: [
                        .init(
                          name: "type",
                          text: "xhtml"
                        ),
                      ]
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
