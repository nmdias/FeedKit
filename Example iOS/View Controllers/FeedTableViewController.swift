//
//  FeedTableViewController.swift
//
//  Copyright (c) 2016 Nuno Manuel Dias
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
import FeedParser

let feedURL = NSURL(string: "http://images.apple.com/main/rss/hotnews/hotnews.rss")!

class FeedTableViewController: UITableViewController {
    
    var feed: RSSFeed?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Feed"
        
        FeedParser(URL: feedURL).parse { (result) in
            self.feed = result.rssFeed
            self.tableView.reloadData()
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 3
        case 1: return self.feed?.channel?.items?.count ?? 0
        default: fatalError()
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = reusableCell()
        guard let layout = TableViewLayout(indexPath: indexPath) else { fatalError() }
        switch layout {
        case .Title:        cell.textLabel?.text = self.feed?.channel?.title ?? "[no title]"
        case .Link:         cell.textLabel?.text = self.feed?.channel?.link ?? "[no link]"
        case .Description:  cell.textLabel?.text = self.feed?.channel?.description ?? "[no description]"
        case .Items:        cell.textLabel?.text = self.feed?.channel?.items?[indexPath.row].title ?? "[no title]"
        }
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let layout = TableViewLayout(indexPath: indexPath) else { fatalError() }
        switch layout {
        case .Title:        self.showDetailViewControllerWithText(self.feed?.channel?.title ?? "[no title]")
        case .Link:         self.showDetailViewControllerWithText(self.feed?.channel?.link ?? "[no link]")
        case .Description:  self.showDetailViewControllerWithText(self.feed?.channel?.description ?? "[no link]")
        case .Items:        self.showDetailViewControllerWithText(self.feed?.channel?.items?[indexPath.row].description ?? "[no description]")
        }
    }
    
    // MARK: - Navigation
    
    func showDetailViewControllerWithText(text: String) {
        let viewController = FeedDetailTableViewController(text: text)
        self.showViewController(viewController, sender: self)
    }

}
