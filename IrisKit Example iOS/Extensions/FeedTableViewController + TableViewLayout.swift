//
//  FeedTableViewController + TableViewLayout.swift
//  Iris
//
//  Created by Nuno Dias on 14/05/16.
//
//

import Foundation

extension FeedTableViewController {
    enum TableViewLayout {
        case Title, Link, Description, Items
        init?(indexPath: NSIndexPath) {
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0: self = .Title
                case 1: self = .Link
                case 2: self = .Description
                default: return nil
                }
            case 1: self = .Items
            default: return nil
            }
        }
    }
}
