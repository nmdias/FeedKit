//
//  AtomSyndication.swift
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
 
    The Atom syndication format, which serves a similar purpose to RSS, offers 
    some elements closely comparable to RSS elements and others that provide new 
    capabilities. Any of these elements can be used in RSS by employing Atom 
    as a namespace.
    
    See: http://www.rssboard.org/rss-profile#namespace-elements-atom
 
*/
protocol AtomSyndication {
    
    
    
}

public enum AtomSyndicationElement {
    
    public static let namespace = [ "xmlns:atom" : "http://www.w3.org/2005/Atom" ]
    
}