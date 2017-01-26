//
//  String + TimeInterval.swift
//  FeedKit
//
//  Created by Ben Murphy on 1/26/17.
//
//

import Foundation

// MARK: - Convert string in format like "HH:MM:SS" to TimeInterval
extension String {

    func toDuration() -> TimeInterval {
        guard !self.isEmpty else {
            return 0
        }

        return self.components(separatedBy: ":")
            .reversed()
            .enumerated()
            .map { i, e in
                (Double(e) ?? 0)
                    *
                    pow(Double(60), Double(i))
            }
            .reduce(0, +)
    }
}


