//
//  RSSFeedTextInput.swift
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

/// Specifies a text input box that can be displayed with the channel.
/// 
/// A channel may optionally contain a <textInput> sub-element, which contains
/// four required sub-elements.
/// 
/// <title> -- The label of the Submit button in the text input area.
/// 
/// <description> -- Explains the text input area.
/// 
/// <name> -- The name of the text object in the text input area.
/// 
/// <link> -- The URL of the CGI script that processes text input requests.
/// 
/// The purpose of the <textInput> element is something of a mystery. You can
/// use it to specify a search engine box. Or to allow a reader to provide
/// feedback. Most aggregators ignore it.
public class RSSFeedTextInput {
    
    /// The label of the Submit button in the text input area.
    public var title: String?
    
    /// Explains the text input area.
    public var description: String?
    
    /// The name of the text object in the text input area.
    public var name: String?
    
    /// The URL of the CGI script that processes text input requests.
    public var link: String?
    
}

// MARK: - Equatable

extension RSSFeedTextInput: Equatable {
    
    public static func ==(lhs: RSSFeedTextInput, rhs: RSSFeedTextInput) -> Bool {
        return
            lhs.title == rhs.title &&
            lhs.description == rhs.description &&
            lhs.name == rhs.name &&
            lhs.link == lhs.link
    }
    
}
