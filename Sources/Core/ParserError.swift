//
//  ParserError.swift
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

/**
 
 Error types with `NSError` codes and user info providers
 
 */
public enum ParserError {
    
    /**
     
     Couldn't parse any known feed from the provided DOM structure
     
     */
    case feedNotFound
    
    /**
     
     Unable to convert the bytes in `CDATABlock` to Unicode characters using
     the UTF-8 encoding
     
     */
    case feedCDATABlockEncodingError(path: String)
    
    /**
     
     The error's code for the specified case.
     
     */
    var code: Int {
        
        switch self {
        case .feedNotFound: return -1000
        case .feedCDATABlockEncodingError: return -10001
        }
        
    }
    
    /**
     
     The error's userInfo dictionary for the specified case.
     
     */
    var userInfo: [String: String] {
        
        switch self {
            
        case .feedNotFound:
            return [
                NSLocalizedDescriptionKey: "Feed not found",
                NSLocalizedFailureReasonErrorKey: "Couldn't parse any known feed from the provided DOM structure",
                NSLocalizedRecoverySuggestionErrorKey: "Provide a valid Atom/RSS DOM structure "
            ]
            
        case .feedCDATABlockEncodingError(let path):
            return [
                NSLocalizedDescriptionKey: "`CDATAblock` encoding error",
                NSLocalizedFailureReasonErrorKey: "Unable to convert the bytes in `CDATABlock` to Unicode characters using the UTF-8 encoding at current path: \(path)",
                NSLocalizedRecoverySuggestionErrorKey: "Make sure the encoding provided in a `CDATABlock` is encoded as UTF-8"
            ]
            
        }
        
    }
    
    /**
     
     The `NSError` from the specified case
     
     */
    var value: NSError {
        return NSError(domain:"com.feedkit.error", code: self.code, userInfo: self.userInfo)
    }
    
}
