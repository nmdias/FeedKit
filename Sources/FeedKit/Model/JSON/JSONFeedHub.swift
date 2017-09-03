//
//  JSONFeedHub.swift
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

import Foundation

/// Describes an endpoints that can be used to subscribe to real-time notifications 
/// from the publisher of this feed. Each object has a type and url, both of which
/// are required.
public class JSONFeedHub {
    
    /// The protocol used to talk with the hub, such as "rssCloud" or "WebSub."
    public var type: String?
    
    /// The hub's url.
    public var url: String?
    
}

// MARK: - Initializers

extension JSONFeedHub {
    
    convenience init?(dictionary: [String : Any?]) {
        
        if dictionary.isEmpty {
            return nil
        }
        
        self.init()
        
        self.type = dictionary["type"] as? String
        self.url = dictionary["url"] as? String
        
    }
    
}

// MARK: - Equatable

extension JSONFeedHub: Equatable {
    
    public static func ==(lhs: JSONFeedHub, rhs: JSONFeedHub) -> Bool {
        return
            lhs.type == rhs.type &&
            lhs.url == rhs.url
    }
    
}
