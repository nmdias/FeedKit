//
//  FeedTableViewController.swift
//  Iris
//
//  Created by Nuno Dias on 15/05/16.
//
//

import UIKit
import FeedParser

let feedURL = NSURL(string: "http://images.apple.com/main/rss/hotnews/hotnews.rss")!

class FeedTableViewController: UITableViewController {
    
    var feed: RSS2Feed?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Feed"
        
        IrisFeedParser(URL: feedURL).parse { (feed) in
            self.feed = feed
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
