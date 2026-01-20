//
// AtomTests + Mocks.swift
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

extension AtomTests {
  var mock: AtomFeed {
    .init(
      title: .init(
        text: "dive into mark",
        attributes: .init(
          type: "text"
        )
      ),
      subtitle: .init(
        text: "A <em>lot</em> of effort went into making this effortless",
        attributes: .init(
          type: "html"
        )
      ),
      links: [
        .init(
          attributes: .init(
            href: "http://example.org/",
            rel: "alternate",
            type: "text/html",
            hreflang: "en",
            title: "Human-readable information about the link",
            length: 1234
          )
        ),
        .init(
          attributes: .init(
            href: "http://example.org/feed.atom",
            rel: "self",
            type: "application/atom+xml",
            hreflang: "pt",
            title: "Information about the link is Human-readable",
            length: 5678
          )
        )
      ],
      updated: RFC3339DateFormatter().date(from: "2005-07-31T12:29:29Z"),
      categories: [
        .init(
          attributes: .init(
            term: "music",
            scheme: nil,
            label: nil
          )
        ),
        .init(
          attributes: .init(
            term: "video",
            scheme: nil,
            label: nil
          )
        )
      ],
      authors: [
        .init(
          name: "Pilgrim Mark",
          email: "1234@example.com",
          uri: "http://example.org/"
        ),
        .init(
          name: "Mark the Pilgrim",
          email: "5678@example.com",
          uri: "http://example.org/"
        )
      ],
      contributors: [
        .init(
          name: "Jane Doe",
          email: "9101@example.com",
          uri: "http://example.org/"
        ),
        .init(
          name: "John Doe",
          email: "2345@example.com",
          uri: "http://example.org/"
        )
      ],
      id: "tag:example.org,2003:3",
      generator: .init(
        text: "Example Toolkit",
        attributes: .init(
          uri: "http://www.example.com/",
          version: "1.0"
        )
      ),
      icon: nil,
      logo: "http://www.example.uk/logo.png",
      rights: "Copyright (c) 2003, Mark Pilgrim",
      entries: [
        .init(
          title: "Atom draft-07 snapshot",
          summary: .init(
            text: "An overview of Atom 1.0",
            attributes: .init(
              type: "text"
            )
          ),
          authors: [
            .init(
              name: "Mark Pilgrim",
              email: "f8dy@example.com",
              uri: "http://example.org/"
            )
          ],
          contributors: [
            .init(
              name: "Sam Ruby",
              email: "2345@example.com",
              uri: "http://example.org/"
            ),
            .init(
              name: "Joe Gregorio",
              email: "2345@example.com",
              uri: "http://example.org/"
            )
          ],
          links: [
            .init(
              attributes: .init(
                href: "http://example.org/2005/04/02/atom",
                rel: "alternate",
                type: "text/html",
                hreflang: "en",
                title: "Human-readable information about the link",
                length: 1234
              )
            ),
            .init(
              attributes: .init(
                href: "http://example.org/audio/ph34r_my_podcast.mp3",
                rel: "enclosure",
                type: "audio/mpeg",
                hreflang: "pt",
                title: "Information about the link is Human-readable",
                length: 1337
              )
            )
          ],
          updated: RFC3339DateFormatter().date(from: "2005-07-31T12:29:29Z"),
          categories: [
            .init(
              attributes: .init(
                term: "music",
                scheme: nil,
                label: nil
              )
            ),
            .init(
              attributes: .init(
                term: "video",
                scheme: nil,
                label: nil
              )
            )
          ],
          id: "tag:example.org,2003:3.2397",
          content: .init(
            text: "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><i>[Update: The Atom draft is finished.]</i></p></div>",
            attributes: .init(
              type: "xhtml",
              src: "http://www.example.org/",
              base: "http://diveintomark.org/"
            )
          ),
          published: RFC3339DateFormatter().date(from: "2003-12-13T08:29:29-04:00"),
          source: nil,
          rights: "Copyright (c) 2003, Mark Pilgrim"
        )
      ]
    )
  }
}

extension AtomTests {
  var xhtmlMock: AtomFeed {
    .init(
      entries: [
        .init(
          summary: .init(
            text: """
            <div xmlns="http://www.w3.org/1999/xhtml"><p><strong>Some markings</strong><a href="http://www.example.org/">Example</a></p><div class="blockquote"><p>On a quote...</p></div></div>
            """,
            attributes: .init(
              type: "xhtml"
            )
          )
        )
      ]
    )
  }
}
