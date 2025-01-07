@MainActor
class ConcurrencyViewModel: ObservableObject {
  @Published var feeds: [FeedModel] = []

  func loadFeeds() async {
    feeds = []
    await FeedParser().parse(from: urlStrings) { [weak self] result in
      Task { @MainActor in

        switch result {
        case let .success(feed):
          self?.feeds.append(.init(feed: feed))

        case let .failure(error):
          print("Failed to load feed: \(error)")
        }
      }
    }
  }

  let urlStrings = [
    "https://techcrunch.com/feed/atom/",
    "https://www.9to5mac.com/feed/",
    "https://www.anandtech.com/rss",
    "https://www.androidauthority.com/feed/",
    "https://www.androidcentral.com/feed",
    "https://www.bbc.com/news/technology/rss.xml",
    "https://www.bgr.com/feed/",
    "https://www.cio.com/feed/",
    "https://www.cnet.com/rss/all/",
    "https://www.datafloq.com/feed/",
    "https://www.datamation.com/feed/",
    "https://www.digitaltrends.com/feed/",
    "https://www.engadget.com/rss.xml",
    "https://www.eweek.com/rss.xml",
    "https://www.extremetech.com/feed",
    "https://www.fastcompany.com/rss",
    "https://www.forbes.com/technology/feed/",
    "https://www.futurism.com/feed",
    "https://www.gartner.com/en/newsroom/rss",
    "https://www.geekwire.com/feed/",
    "https://www.gizmodo.com/rss",
    "https://www.hackernews.com/rss",
    "https://www.hackernoon.com/feed",
    "https://www.huffpost.com/section/technology/feed",
    "https://www.infoq.com/feed/",
    "https://www.lifehacker.com/rss",
    "https://www.macworld.com/feed/",
    "https://www.makeuseof.com/feed/",
    "https://www.mashable.com/feed",
    "https://www.networkworld.com/rss",
    "https://www.readwrite.com/feed/",
    "https://www.siliconvalley.com/feed/",
    "https://www.softwaretestinghelp.com/feed/",
    "https://www.techcrunch.com/feed/",
    "https://www.techmeme.com/feed.xml",
    "https://www.technologyreview.com/feed/",
    "https://www.techradar.com/rss",
    "https://www.thedrum.com/rss.xml",
    "https://www.theguardian.com/technology/rss",
    "https://www.thenextweb.com/feed/",
    "https://www.tomshardware.com/feeds/all",
    "https://www.venturebeat.com/feed/",
    "https://www.wired.com/feed/rss",
    "https://www.zdnet.com/rss.xml",
  ]
}
