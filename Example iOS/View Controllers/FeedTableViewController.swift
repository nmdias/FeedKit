//
//  FeedTableViewController.swift
//
//  Copyright (c) 2017 Nuno Manuel Dias
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

import UIKit
import FeedKit

let feedURL = URL(string: "http://images.apple.com/main/rss/hotnews/hotnews.rss")!

class FeedTableViewController: UITableViewController {
    
    var feed: RSSFeed?
    
    let parser = FeedParser(URL: feedURL)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Feed"
        
        // Parse asynchronously, not to block the UI.
        parser.parseAsync { [weak self] (result) in
            self?.feed = result.rssFeed
            
            // Then back to the Main thread to update the UI.
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            
        }
        
    }

}

// MARK: - Table View Data Source

extension FeedTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 3
        case 1: return self.feed?.items?.count ?? 0
        default: fatalError()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reusableCell()
        guard let layout = TableViewLayout(indexPath: indexPath) else { fatalError() }
        switch layout {
        case .title:        cell.textLabel?.text = self.feed?.title ?? "[no title]"
        case .link:         cell.textLabel?.text = self.feed?.link ?? "[no link]"
        case .description:  cell.textLabel?.text = self.feed?.description ?? "[no description]"
        case .items:        cell.textLabel?.text = self.feed?.items?[indexPath.row].title ?? "[no title]"
        }
        return cell
    }
    
}

// MARK: - Table View Delegate

extension FeedTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let layout = TableViewLayout(indexPath: indexPath) else { fatalError() }
        switch layout {
        case .title:        self.showDetailViewControllerWithText(self.feed?.title ?? "[no title]")
        case .link:         self.showDetailViewControllerWithText(self.feed?.link ?? "[no link]")
        case .description:  self.showDetailViewControllerWithText(self.feed?.description ?? "[no link]")
        case .items:        self.showDetailViewControllerWithText(self.feed?.items?[indexPath.row].description ?? "[no description]")
        }
    }
    
}

// MARK: - Navigation

extension FeedTableViewController {
    
    // MARK: - Navigation
    
    func showDetailViewControllerWithText(_ text: String) {
        let viewController = FeedDetailTableViewController(text: text)
        self.show(viewController, sender: self)
    }
    
}
