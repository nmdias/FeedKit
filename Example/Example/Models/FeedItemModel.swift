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
