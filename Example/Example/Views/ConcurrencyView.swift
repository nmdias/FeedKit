//
// ConcurrencyView.swift
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
import SwiftUI

struct ConcurrencyView: View {
  // MARK: Internal

  let feedURLs = [
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
    "https://www.techcrunch.com/feed/atom/",
    "https://www.techmeme.com/feed.xml",
    "https://www.technologyreview.com/feed/",
    "https://www.techradar.com/rss",
    "https://www.thedrum.com/rss.xml",
    "https://www.theguardian.com/technology/rss",
    "https://www.thenextweb.com/feed/",
    "https://www.tomshardware.com/feeds/all",
    "https://www.venturebeat.com/feed/",
    "https://www.wired.com/feed/rss",
    "https://www.zdnet.com/rss.xml"
  ]

  var body: some View {
    NavigationView {
      List {
        Section("Feeds") {
          ForEach(feeds, id: \.title) { feed in
            NavigationLink(destination: FeedView(feed: feed)) {
              Text(feed.title ?? "")
            }
          }
        }
      }
      .refreshable {
        Task {
          await loadFeeds()
        }
      }
      .onAppear {
        Task {
          if feeds.isEmpty {
            await loadFeeds()
          }
        }
      }
    }
    .navigationTitle("Concurrency")
    .animation(.default, value: feeds)
  }

  func loadFeeds() async {
    feeds = []
    await withTaskGroup(of: Result<Feed, Error>.self) { group in
      for urlString in feedURLs {
        group.addTask {
          do {
            let feed = try await Feed(urlString: urlString)
            return .success(feed)
          } catch {
            return .failure(error)
          }
        }
      }

      for await result in group {
        switch result {
        case let .success(feed):
          feeds.append(.init(feed: feed))
        case let .failure(error):
          print("Failed to load feed: \(error)")
        }
      }
    }
  }

  // MARK: Private

  @State private var feeds: [FeedModel] = []
}
