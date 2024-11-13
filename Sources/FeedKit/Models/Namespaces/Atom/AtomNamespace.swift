//
//  AtomNamespace.swift
//
//  Copyright (c) 2023 Naufal Fachrian
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

/// Atom namespace in an RSS feed helps WebSub subscribers discover the topic
/// and hub information.
/// See https://www.w3.org/TR/websub/#discovery
public class AtomNamespace {
    
    /// The "atom:link" element defines a reference from an entry or feed to
    /// a Web resource.
    public var links: [AtomFeedLink]?
    
    public init() { }
    
}

// MARK: - Equatable

extension AtomNamespace: Equatable {
    
    public static func ==(lhs: AtomNamespace, rhs: AtomNamespace) -> Bool {
        return lhs.links == rhs.links
    }
    
}
