//
// RSSTests + Mocks.swift
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

extension RSSTests {
  var mock: RSSFeed {
    .init(
      channel: .init(
        title: "Iris",
        link: "http://www.iris.news/",
        description: "The one place for you daily news.",
        language: "en-us",
        copyright: "Copyright 2015, Iris News",
        managingEditor: "john.appleseed.editor@iris.news (John Appleseed)",
        webMaster: "john.appleseed.master@iris.news (John Appleseed)",
        pubDate: FeedDateFormatter(spec: .rfc822).date(from: "Sun, 16 Aug 2015 05:00:00 GMT"),
        lastBuildDate: FeedDateFormatter(spec: .rfc822).date(from: "Sun, 16 Aug 2015 18:18:55 GMT"),
        categories: [
          .init(
            text: "Media"
          ),
          .init(
            text: "News/Media/Science",
            attributes: .init(
              domain: "dmoz"
            )
          )
        ],
        generator: "Iris Gen",
        docs: "http://blogs.law.harvard.edu/tech/rss",
        cloud: .init(
          attributes: .init(
            domain: "server.iris.com",
            port: 80,
            path: "/rpc",
            registerProcedure: "cloud.notify",
            protocol: "xml-rpc"
          )
        ),
        rating: "(PICS-1.1 \"http://www.rsac.org/ratingsv01.html\" l by \"webmaster@example.com\" on \"2007.01.29T10:09-0800\" r (n 0 s 0 v 0 l 0))",
        ttl: 60,
        image: .init(
          url: "http://www.iris.news/image.jpg",
          title: "Iris",
          link: "http://www.iris.news/",
          width: 64,
          height: 192,
          description: "Read the Iris news feed."
        ),
        textInput: .init(
          title: "TextInput Inquiry",
          description: "Your aggregator supports the textInput element. What software are you using?",
          name: "query",
          link: "http://www.iris.com/textinput.php"
        ),
        skipHours: .init(
          hours: [
            0,
            1,
            2,
            22,
            23
          ]
        ),
        skipDays: .init(
          days: [
            .saturday, .sunday
          ]
        ),
        items: [
          .init(
            title: "Seventh Heaven! Ryan Hurls Another No Hitter",
            link: "http://dallas.example.com/1991/05/02/nolan.htm",
            description: "I'm headed for France. I wasn't gonna go this year, but then last week \"Valley Girl\" came out and I said to myself, Joe Bob, you gotta get out of the country for a while.",
            markdown: "## Highlights\n\n- Traveled to France.\n- Talked about \"Valley Girl\".",
            author: "jbb@dallas.example.com (Joe Bob Briggs)",
            categories: [
              .init(
                text: "movies"
              ),
              .init(
                text: "1983/V",
                attributes: .init(
                  domain: "rec.arts.movies.reviews"
                )
              )
            ],
            comments: "http://dallas.example.com/feedback/1983/06/joebob.htm",
            enclosure: .init(
              attributes: .init(
                url: "http://dallas.example.com/joebob_050689.mp3",
                length: 24_986_239,
                type: "audio/mpeg"
              )
            ),
            guid: .init(
              text: "tag:dallas.example.com,4131:news",
              attributes: .init(
                isPermaLink: false
              )
            ),
            pubDate: FeedDateFormatter(spec: .rfc822).date(from: "Fri, 05 Oct 2007 09:00:00 CST"),
            source: .init(
              text: "Los Angeles Herald-Examiner",
              attributes: .init(
                url: "http://la.example.com/rss.xml"
              )
            )
          ),
          .init(
            title: "Seventh Heaven! Ryan Hurls Another No Hitter",
            link: "http://dallas.example.com/1991/05/02/nolan.htm",
            description: "I'm headed for France. I wasn't gonna go this year, but then last week <a href=\"http://www.imdb.com/title/tt0086525/\">Valley Girl</a> came out and I said to myself, Joe Bob, you gotta get out of the country for a while.",
            author: "jbb@dallas.example.com (Joe Bob Briggs)",
            categories: [
              .init(
                text: "movies"
              ),
              .init(
                text: "1983/V",
                attributes: .init(
                  domain: "rec.arts.movies.reviews"
                )
              )
            ],
            comments: "http://dallas.example.com/feedback/1983/06/joebob.htm",
            enclosure: .init(
              attributes: .init(
                url: "http://dallas.example.com/joebob_050689.mp3",
                length: 24_986_239,
                type: "audio/mpeg"
              )
            ),
            guid: .init(
              text: "http://dallas.example.com/item/1234",
              attributes: .init(
                isPermaLink: true
              )
            ),
            pubDate: FeedDateFormatter(spec: .rfc822).date(from: "Fri, 05 Oct 2007 09:00:00 CST"),
            source: .init(
              text: "Los Angeles Herald-Examiner",
              attributes: .init(
                url: "http://la.example.com/rss.xml"
              )
            )
          )
        ]
      )
    )
  }
}
