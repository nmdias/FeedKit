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
  var attributes: Attributes?
  var header: Header?
  var content: Content?
  var footer: Footer?
  
  struct Attributes: Codable, Equatable {
    var xmlns: String?
  }

  struct Header: Codable, Equatable {
    var title: Title?
    var description: String?
    var version: String?
    var keywords: Keywords?
    var namespace: Namespace?

    init(
      title: Title? = nil,
      description: String? = nil,
      version: String? = nil,
      keywords: Keywords? = nil,
      namespace: Namespace? = nil) {
      self.title = title
      self.description = description
      self.version = version
      self.keywords = keywords
      self.namespace = namespace
    }

    private enum CodingKeys: String, CodingKey {
      case title
      case description
      case version
      case keywords
      case namespace = "ns"
    }

    struct Title: Codable, Equatable {
      var text: String?
      var attributes: Attributes?

      struct Attributes: Codable, Equatable {
        var type: String?
      }

      private enum CodingKeys: String, CodingKey {
        case text = "@text"
        case attributes = "@attributes"
      }
    }

    struct Keywords: Codable, Equatable {
      var keyword: [String]?
    }

    struct Namespace: Codable, Equatable, XMLNamespaceCodable {
      var title: String?
      var description: String?

      private enum CodingKeys: String, CodingKey {
        case title = "ns:title"
        case description = "ns:description"
      }
    }
  }

  struct Content: Codable, Equatable {
    var item: [Item]

    struct Item: Codable, Equatable {
      var name: String?
      var description: String?
      var precision: Double?
      var details: Details?
      var xhtml: Xhtml?

      private enum CodingKeys: String, CodingKey {
        case name
        case description
        case precision
        case details
        case xhtml
      }

      init(
        name: String? = nil,
        description: String? = nil,
        precision: Double? = nil,
        details: Details? = nil,
        xhtml: Xhtml? = nil) {
        self.name = name
        self.description = description
        self.precision = precision
        self.details = details
        self.xhtml = xhtml
      }

      struct Details: Codable, Equatable {
        var detail: [String]?
      }

      struct Xhtml: Codable, Equatable {
        var attributes: XhtmlAttributes?
        var text: String?

        init(attributes: XhtmlAttributes, text: String) {
          self.attributes = attributes
          self.text = text
        }

        private enum CodingKeys: String, CodingKey {
          case attributes = "@attributes"
          case text = "@text"
        }

        struct XhtmlAttributes: Codable, Equatable {
          var type: String?
        }
      }
    }
  }

  struct Footer: Codable, Equatable {
    var notes: String?
    var created: String?
    var revision: Int?
  }
}

extension Sample {
  private enum CodingKeys: String, CodingKey {
    case attributes = "@attributes"
    case header
    case content
    case footer
  }
  
  init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<Sample.CodingKeys> = try decoder.container(keyedBy: Sample.CodingKeys.self)
    
    self.attributes = try container.decodeIfPresent(Sample.Attributes.self, forKey: Sample.CodingKeys.attributes)
    self.header = try container.decodeIfPresent(Sample.Header.self, forKey: Sample.CodingKeys.header)
    self.content = try container.decodeIfPresent(Sample.Content.self, forKey: Sample.CodingKeys.content)
    self.footer = try container.decodeIfPresent(Sample.Footer.self, forKey: Sample.CodingKeys.footer)
    
  }
  
  func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<Sample.CodingKeys> = encoder.container(keyedBy: Sample.CodingKeys.self)
    
    try container.encodeIfPresent(self.attributes, forKey: Sample.CodingKeys.attributes)
    try container.encodeIfPresent(self.header, forKey: Sample.CodingKeys.header)
    try container.encodeIfPresent(self.content, forKey: Sample.CodingKeys.content)
    try container.encodeIfPresent(self.footer, forKey: Sample.CodingKeys.footer)
  }
}

extension Sample.Attributes {
  private enum CodingKeys: String, CodingKey {
    case xmlns = "xmlns:ns"
  }
  
  init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<Sample.Attributes.CodingKeys> = try decoder.container(keyedBy: Sample.Attributes.CodingKeys.self)
    
    self.xmlns = try container.decodeIfPresent(String.self, forKey: Sample.Attributes.CodingKeys.xmlns)
    
  }
  
  func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<Sample.Attributes.CodingKeys> = encoder.container(keyedBy: Sample.Attributes.CodingKeys.self)
    
    try container.encodeIfPresent(self.xmlns, forKey: Sample.Attributes.CodingKeys.xmlns)
  }
}

extension SampleTests {
  var sampleMock: Sample {
    .init(
      attributes: .init(
        xmlns: "http://example.ns/namespace"
      ),
      header: .init(
        title: .init(
          text: "Sample Document",
          attributes: .init(
            type: "text"
          )
        ),
        description: "This is a sample document.",
        version: "1.0",
        keywords: .init(
          keyword: [
            "Generic",
            "Placeholder",
          ]
        ),
        namespace: .init(
          title: "This title is a sample namespace element.",
          description: "This description is a sample namespace element."
        )
      ),
      content: .init(
        item: [
          .init(
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
  var nodeMock: XMLNode {
    .init(
      name: "sample",
      children: [
        .init(
          name: "@attributes",
          children: [
            .init(
              name: "xmlns:ns",
              text: "http://example.ns/namespace"
            )
          ]
        ),
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
            .init(
              prefix: "ns",
              name: "ns:title",
              text: "This title is a sample namespace element."
            ),
            .init(
              prefix: "ns",
              name: "ns:description",
              text: "This description is a sample namespace element."
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
                  isXhtml: true,
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
              children: [
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
                  isXhtml: true,
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
