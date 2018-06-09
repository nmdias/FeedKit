//
//  ParserError.swift
//
//  Copyright (c) 2016 - 2018 Nuno Manuel Dias
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

import Foundation


/// Error types with `NSError` codes and user info providers
///
/// - feedNotFound: Couldn't parse any known feed.
/// - feedCDATABlockEncodingError: Unable to convert the bytes in `CDATABlock` 
///   to Unicode characters using the UTF-8 encoding.
/// - internalError: An internal error from which the user cannot recover.
public enum ParserError {
    
    case feedNotFound
    case feedCDATABlockEncodingError(path: String)
    case internalError(reason: String)
    
    /// An error's code for the specified case.
    var code: Int {
        switch self {
        case .feedNotFound: return -1000
        case .feedCDATABlockEncodingError: return -10001
        case .internalError(_): return -90000
        }
    }
    
    /// The error's userInfo dictionary for the specified case.
    var userInfo: [String: String] {
        switch self {
        case .feedNotFound:
            return [
                NSLocalizedDescriptionKey: "Feed not found",
                NSLocalizedFailureReasonErrorKey: "Couldn't parse any known feed",
                NSLocalizedRecoverySuggestionErrorKey: "Provide a valid Atom/RSS/JSON feed "
            ]
            
        case .feedCDATABlockEncodingError(let path):
            return [
                NSLocalizedDescriptionKey: "`CDATAblock` encoding error",
                NSLocalizedFailureReasonErrorKey: "Unable to convert the bytes in `CDATABlock` to Unicode characters using the UTF-8 encoding at current path: \(path)",
                NSLocalizedRecoverySuggestionErrorKey: "Make sure the encoding provided in a `CDATABlock` is encoded as UTF-8"
            ]
        
        case .internalError(let reason):
            return [
                NSLocalizedDescriptionKey: "Internal unresolved error: \(reason)",
                NSLocalizedFailureReasonErrorKey: "Unable to recover from an internal unresolved error: \(reason)",
                NSLocalizedRecoverySuggestionErrorKey: "If you're seeing this error you probably should open an issue on github"
            ]
            
        }
        
    }
    
    /// The `NSError` from the specified case.
    var value: NSError {
        return NSError(domain:"com.feedkit.error", code: self.code, userInfo: self.userInfo)
    }
    
}
