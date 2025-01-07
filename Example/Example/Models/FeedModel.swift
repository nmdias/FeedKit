//
//  FeedItemModel.swift
//  Example
//
//  Created by Nuno Dias on 07/01/2025.
//


struct FeedItemModel: Equatable {
  var title: String?
  var description: String?
  var date: Date?

  init() {
  }

  init(item: RSSFeedItem) {
    title = item.title
    description = item.description
    date = item.pubDate
  }

  init(item: AtomFeedEntry) {
    title = item.title
    description = item.summary?.text
    date = item.published
  }

  init(item: JSONFeedItem) {
    title = item.title
    description = item.summary
    date = item.datePublished
  }
}

struct FeedModel: Equatable {
  var title: String?
  var date: Date?
  var description: String?
  var items: [FeedItemModel]?

  init() {
  }

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
    default:
      self.init()
    }
  }
}
