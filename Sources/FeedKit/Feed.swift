public enum Feed: Equatable {
  case atom(AtomFeed)
  case rss(RSSFeed)
  case json(JSONFeed)
}