//
//  FeedTableViewController + ReusableCell.swift
//  FeedParser
//
//  Created by Nuno Dias on 14/05/16.
//
//

import UIKit

extension FeedTableViewController {
    func reusableCell() -> UITableViewCell {
        let reuseIdentifier = "Cell"
        if let cell = self.tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) { return cell }
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: reuseIdentifier)
        cell.accessoryType = .DisclosureIndicator
        return cell
    }
}
