//
//  FeedView.swift
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

struct FeedView: View {
  let feed: RSSFeed
  @State private var selectedItem: RSSFeedItem? // Track the selected item
  @State private var showDetailView = false // Control the sheet presentation

  var body: some View {
    NavigationView {
      ScrollViewReader { proxy in
        List {
          Section {
            Text(feed.channel?.title ?? "-")
          } header: {
            Text("Title")
          }
          Section {
            Text(feed.channel?.description ?? "-")
          } header: {
            Text("Description")
          }
          Section {
            ForEach(feed.channel?.items ?? [], id: \.hashValue) { item in
              Button {
                selectedItem = item // Set the selected item
                showDetailView = true // Show the sheet
              } label: {
                Text(item.title ?? "-")
                  .frame(maxWidth: .infinity, alignment: .leading)
              }
              .id(item.hashValue) // Assign an ID for scrolling
            }
          } header: {
            Text("Items")
          }
        }
        .listStyle(.insetGrouped)
        .onAppear {

        }
      }
    }
    .sheet(isPresented: $showDetailView) {
      if let selectedItem = selectedItem {
        FeedDetailView(item: selectedItem) // Present the detail view
      }
    }
  }
}

#Preview {
  FeedView(feed: .init(
    channel: .init(
      title: "Feed Title",
      description: "Feed Description",
      items: [
        .init(title: "Item 1", description: "Description 1", pubDate: Date()),
        .init(title: "Item 2", description: "Description 2", pubDate: Date()),
        .init(title: "Item 3", description: "Description 3", pubDate: Date()),
      ]
    )
  ))
}
