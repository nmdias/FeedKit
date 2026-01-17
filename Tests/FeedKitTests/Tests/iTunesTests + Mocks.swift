//
// iTunesTests + Mocks.swift
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

extension iTunesTests {
  var mock: RSSFeed {
    .init(
      channel: .init(
        items: [
          .init(
            iTunes: .init(
              author: "Dan Carlin",
              block: "No",
              image: .init(
                text: nil,
                attributes: .init(
                  href: "http://www.dancarlin.com/graphics/DC_HH_iTunes.jpg"
                )
              ),
              duration: 18030,
              explicit: "No",
              isClosedCaptioned: "Yes",
              order: 1,
              title: "Dan Carlin's Hardcore History",
              subtitle: "If this were a movie, the events and cameos would be too numerous and star-studded to mention. It includes Xerxes, Spartans, Immortals, Alexander the Great, scythed chariots, and several of the greatest battles in history.",
              summary: "If this were a movie, the events and cameos would be too numerous and star-studded to mention. It includes Xerxes, Spartans, Immortals, Alexander the Great, scythed chariots, and several of the greatest battles in history.",
              keywords: "Persia, Achaemenid, Xerxes, Darius, Artaxerxes, Greek, Macedonian, ancient history, military, Philip, Alexander, Spartan, Athens, Herodotus, Leonidas, podcast, Plataea, Issus, Salamis, Gaugamela",
              episodeType: "full",
              season: 3,
              episode: "2"
            )
          )
        ],
        iTunes: .init(
          author: "Dan Carlin",
          block: "No",
          categories: [
            .init(
              attributes: .init(
                text: "Society & Culture"
              ),
              subcategory: .init(
                attributes: .init(
                  text: "History"
                )
              )
            )
          ],
          image: .init(
            text: nil,
            attributes: .init(
              href: "http://www.dancarlin.com/graphics/DC_HH_iTunes.jpg"
            )
          ),
          explicit: "No",
          complete: "No",
          newFeedURL: "http://newlocation.com/example.rss",
          owner: .init(
            email: "dan@dancarlin.com",
            name: "Dan Carlin's Hardcore History"
          ),
          title: "Dan Carlin's Hardcore History",
          subtitle: "This isn't academic history (and Carlin isn't a historian) but the podcast's unique blend of high drama, masterful narration and Twilight Zone-style twists has entertained millions of listeners.",
          summary: "In \"Hardcore History\" journalist and broadcaster Dan Carlin takes his \"Martian\", unorthodox way of thinking and applies it to the past. Was Alexander the Great as bad a person as Adolf Hitler? What would Apaches with modern weapons be like? Will our modern civilization ever fall like civilizations from past eras? This isn't academic history (and Carlin isn't a historian) but the podcast's unique blend of high drama, masterful narration and Twilight Zone-style twists has entertained millions of listeners.",
          keywords: "History, Military, War, Ancient, Archaeology, Classics, Carlin",
          type: "episodic"
        )
      )
    )
  }
}
