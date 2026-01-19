//
// FeedModel.swift
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

import FeedKit
import Foundation

struct FeedModel: Equatable {
  // MARK: Lifecycle

  init() {}

  init(feed: AtomFeed) {
    title = feed.title?.text
    date = feed.updated
    description = feed.subtitle?.text
    items = feed.entries?.compactMap { .init(item: $0) }
  }

  init(feed: RSSFeed) {
    title = feed.channel?.title
    date = feed.channel?.pubDate
    description = feed.channel?.description
    items = feed.channel?.items?.compactMap { .init(item: $0) }
  }

  init(feed: JSONFeed) {
    title = feed.title
    description = feed.description
    items = feed.items?.compactMap { .init(item: $0) }
  }

  init(feed: Feed) {
    switch feed {
    case let .atom(atomFeed):
      self.init(feed: atomFeed)
    case let .rss(rssFeed):
      self.init(feed: rssFeed)
    case let .json(jsonFeed):
      self.init(feed: jsonFeed)
    }
  }

  // MARK: Internal

  var title: String?
  var date: Date?
  var description: String?
  var items: [FeedItemModel]?
}
