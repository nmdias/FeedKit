//
//  ViewController.swift
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

import Cocoa
import FeedKit

let feedURL = URL(string: "http://images.apple.com/main/rss/hotnews/hotnews.rss")!

class ViewController: NSViewController {

    @IBOutlet weak var feedTableView: NSTableView!
    @IBOutlet weak var feedItemsTableView: NSTableView!
    @IBOutlet var textView: NSTextView!
    
    var feed: RSSFeed?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let result = FeedParser(URL: feedURL)!.parse()
        self.feed = result.rssFeed
        self.feedItemsTableView.reloadData()
        
    }

    // MARK: - Text View Helper
    
    func updateTextView() {
        let selectedRow = self.feedItemsTableView.selectedRow
        if selectedRow > -1 {
            let item = self.feed!.items![selectedRow]
            self.textView.string = item.description!
        }
    }
    
}

// MARK: - Table View Delegate

extension ViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "Cell"), owner: nil) as? NSTableCellView else {
            return nil
        }
        
        switch tableView {
            
        case self.feedTableView:
            switch row {
            case 0: cell.textField?.stringValue = self.feed?.title ?? "[no title]"
            case 1: cell.textField?.stringValue = self.feed?.link ?? "[no link]"
            case 2: cell.textField?.stringValue = self.feed?.description ?? "[no description]"
            default: fatalError()
            }
            
        case self.feedItemsTableView:
            cell.textField?.stringValue = self.feed!.items![row].title ?? "[no title]"
            
        default: fatalError()
            
        }
        
        return cell
        
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        self.updateTextView()
    }
    
}

// MARK: - Table View Data Source

extension ViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        switch tableView {
        case self.feedTableView: return 3
        case self.feedItemsTableView: return self.feed?.items?.count ?? 0
        default: fatalError()
        }
    }
    
}
