//
//  ToMediaTag.swift
//
//
//  Created by Axel Martinez on 28/7/24.
//

import Foundation

extension String {
    
    /// Attempts to convert the textual representation of a date with
    /// the specified `DateSpec` to a `Date` object.
    ///
    /// - Parameter spec: The `DateSpec` to interpert the string.
    /// - Returns: A `Date` object, or nil if the conversion failed.
    func toMediaTags() -> [MediaTag]? {
        return self.components(separatedBy: ",").compactMap({ (value) -> MediaTag? in
            var mediaTag = MediaTag()
            let components = value.components(separatedBy: ":")
                    
            if components.count > 0 {
                mediaTag.tag = components.first?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }
                    
            if components.count > 1 {
                mediaTag.weight = Int(components.last?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? "")
            }
                    
            return mediaTag
        })
    }
}
