//
//  ConcurrencyView.swift
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

import FeedKit
import SwiftUI

struct ConcurrencyView: View {
  let feeds: [RSSFeed] = [
    .init(
      channel: .init(
        title: "Feed 1",
        description: "Feed Description 1",
        items: [
          .init(title: "Feed Item 1", description: "Feed Description 1", pubDate: Date()),
          .init(title: "Feed Item 2", description: "Feed Description 2", pubDate: Date()),
          .init(title: "Feed Item 3", description: "Feed Description 3", pubDate: Date()),
        ]
      )
    ),
    .init(
      channel: .init(
        title: "Feed 2",
        description: "Feed Description 2",
        items: [
          .init(title: "Feed Item 1", description: "Feed Description 1", pubDate: Date()),
          .init(title: "Feed Item 2", description: "Feed Description 2", pubDate: Date()),
          .init(title: "Feed Item 3", description: "Feed Description 3", pubDate: Date()),
        ]
      )
    ),
    .init(
      channel: .init(
        title: "Feed 3",
        description: "Feed Description 3",
        items: [
          .init(title: "Feed Item 1", description: "Feed Description 1", pubDate: Date()),
          .init(title: "Feed Item 2", description: "Feed Description 2", pubDate: Date()),
          .init(title: "Feed Item 3", description: "Feed Description 3", pubDate: Date()),
        ]
      )
    ),
  ]

  var body: some View {
    NavigationView {
      List {
        Section {
          ForEach(feeds, id: \.channel?.hashValue) { feed in
            NavigationLink(destination: FeedView(feed: feed)) {
              Text(feed.channel?.title ?? "")
            }
          }
        } header: {
          Text("Feeds")
        }
      }
    }
  }
}
