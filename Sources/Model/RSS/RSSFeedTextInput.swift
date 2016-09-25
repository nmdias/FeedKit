//
//  RSSFeedTextInput.swift
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
 
 Specifies a text input box that can be displayed with the channel.
 
 A channel may optionally contain a <textInput> sub-element, which contains
 four required sub-elements.
 
 <title> -- The label of the Submit button in the text input area.
 
 <description> -- Explains the text input area.
 
 <name> -- The name of the text object in the text input area.
 
 <link> -- The URL of the CGI script that processes text input requests.
 
 The purpose of the <textInput> element is something of a mystery. You can
 use it to specify a search engine box. Or to allow a reader to provide
 feedback. Most aggregators ignore it.
 
 */
open class RSSFeedTextInput {
    
    /** 
     
     The label of the Submit button in the text input area. 
     
     */
    open var title: String?
    
    /** 
     
     Explains the text input area. 
     
     */
    open var description: String?
    
    /** 
     
     The name of the text object in the text input area. 
     
     */
    open var name: String?
    
    /** 
     
     The URL of the CGI script that processes text input requests. 
     
     */
    open var link: String?
    
}
