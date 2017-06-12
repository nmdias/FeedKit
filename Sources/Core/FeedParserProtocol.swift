//
//  FeedParserProtocol.swift
//  FeedKit
//
//  Created by Nuno Dias on 12/06/2017.
//
//

import Foundation

protocol FeedParserProtocol {
    init(data: Data)
    func parse() -> Result
}
