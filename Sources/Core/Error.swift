//
//  Error.swift
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

import Foundation

public struct Error {
    
    /** 
     
     The domain used for creating all Alamofire errors. 
     
     */
    public static let domain = "com.feedparser.error"
    
    /**
     
     Error Codes and `NSError` user info provider
     
     */
    public enum Code: Int {
        
        case FeedNotFound = -1000
        
        var userInfo: [String: String] {
            switch self {
            case .FeedNotFound:
                return [
                    NSLocalizedDescriptionKey: "Feed not found",
                    NSLocalizedFailureReasonErrorKey: "Couldn't parse any known feed from the provided DOM structure",
                    NSLocalizedRecoverySuggestionErrorKey: "Provide a valid Atom/RSS DOM structure "
                ]
            }
            
        }
        
    }
    
    /**
     
     Creates an `NSError` from the specified Code
     
     - parameter code: The error code.
     
     - returns: An `NSError` with the given error code
     
     */
    static func error(code: Code) -> NSError {
        return NSError(domain: Error.domain, code: code.rawValue, userInfo: code.userInfo)
    }
    
}

