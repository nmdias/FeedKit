//
// RDFTests + Mocks.swift
//
// Copyright (c) 2016 - 2026 Nuno Dias
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

@testable import FeedKit

extension RDFTests {
  /// The expected model for `RDF.xml`, which covers the elements of the RSS 1.0
  /// core: the channel, its sibling items, the image and the text input.
  var mock: RDFFeed {
    .init(
      channel: .init(
        title: "Iris",
        link: "https://www.iris.example/",
        description: "The one place for you daily news."
      ),
      items: [
        .init(
          title: "Seventh Heaven! Ryan Hurls Another No Hitter",
          link: "https://www.iris.example/1991/05/02/nolan.htm",
          description: "I'm headed for France."
        ),
        .init(
          title: "Seventh Heaven! Ryan Hurls Another No Hitter",
          link: "https://www.iris.example/1991/05/03/nolan.htm",
          description: "I'm headed for France."
        )
      ],
      image: .init(
        url: "https://www.iris.example/image.jpg",
        title: "Iris",
        link: "https://www.iris.example/"
      ),
      textInput: .init(
        title: "TextInput Inquiry",
        description: "Your aggregator supports the textinput element.",
        name: "query",
        link: "https://www.iris.example/textinput.php"
      )
    )
  }

  /// The expected model for `RDFDC.xml`, which combines RSS 1.0 with the Dublin
  /// Core and Syndication modules and an item that carries `content:encoded`.
  var dcMock: RDFFeed {
    .init(
      channel: .init(
        title: "Iris",
        link: "https://www.iris.example/",
        description: "The one place for you daily news.",
        dublinCore: .init(
          title: "title",
          creator: "creator",
          subject: "subject",
          description: "description",
          publisher: "publisher",
          contributor: "contributor",
          date: FeedDateFormatter(spec: .rfc822).date(from: "Sat, 1 Jan 2000 12:00:00 GMT"),
          type: "type",
          format: "format",
          identifier: "identifier",
          source: "source",
          language: "language",
          relation: "relation",
          coverage: "coverage",
          rights: "rights"
        ),
        syndication: .init(
          updatePeriod: .hourly,
          updateFrequency: 2,
          updateBase: FeedDateFormatter(spec: .iso8601).date(from: "2000-01-01T12:00+00:00")
        )
      ),
      items: [
        .init(
          title: "Seventh Heaven! Ryan Hurls Another No Hitter",
          link: "https://www.iris.example/1991/05/02/nolan.htm",
          description: "I'm headed for France.",
          dublinCore: .init(
            title: "title",
            creator: "creator",
            subject: "subject",
            description: "description",
            publisher: "publisher",
            contributor: "contributor",
            date: FeedDateFormatter(spec: .rfc822).date(from: "Sat, 1 Jan 2000 12:00:00 GMT"),
            type: "type",
            format: "format",
            identifier: "identifier",
            source: "source",
            language: "language",
            relation: "relation",
            coverage: "coverage",
            rights: "rights"
          ),
          content: .init(
            encoded: "<p>What a <em>beautiful</em> day!</p>"
          )
        )
      ]
    )
  }
}
