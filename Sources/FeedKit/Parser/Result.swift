//
//  Result.swift
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

/// Used to provide the result of a parsed feed, whether the parsing was
/// successfull or encountered an error.
///
/// - atom: The parsed `AtomFeed` model.
/// - rss: The parsed `RSSFeed` model.
/// - json: The parsed `JSONFeed` model.
/// - failure: The failure `NSError` generated from parsing errors.
public enum Result {
    
    case atom(AtomFeed)
    case rss(RSSFeed)
    case json(JSONFeed)
    case failure(NSError)
    
    /// Returns `true` if the result is a success, `false` otherwise.
    public var isSuccess: Bool {
        switch self {
        case .atom:     return true
        case .rss:      return true
        case .json:     return true
        case .failure:  return false
        }
    }
    
    /// Returns `true` if the result is a failure, `false` otherwise.
    public var isFailure: Bool {
        return !isSuccess
    }
    
    /// Returns the parsed rss feed value if the result is a success, `nil`
    /// otherwise.
    public var rssFeed: RSSFeed? {
        switch self {
        case .rss(let value): return value
        default: return nil
        }
    }
    
    /// Returns the parsed atom feed if the result is a success, `nil` 
    /// otherwise.
    public var atomFeed: AtomFeed? {
        switch self {
        case .atom(let value): return value
        default: return nil
        }
    }
    
    /// Returns the parsed json feed if the result is a success, `nil` 
    /// otherwise.
    public var jsonFeed: JSONFeed? {
        switch self {
        case .json(let value): return value
        default: return nil
        }
    }
    
    /// Returns the associated error value if the result is a failure, `nil`
    /// otherwise.
    public var error: NSError? {
        switch self {
        case .failure(let error): return error
        default: return nil
        }
    }
    
}
