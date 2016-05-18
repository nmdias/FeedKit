//
//  RSS2ChannelTextInput.swift
//  FeedParser
//
//  Created by Nuno Dias on 01/07/15.
//  Copyright © 2015 FeedParser. All rights reserved.
//

import Foundation

/**
    A text input box that can be displayed with the channel. A channel may optionally contain a `<textInput>` sub-element, which contains four required sub-elements.
*/
public class RSS2FeedChannelTextInput {
    
    /// The label of the Submit button in the text input area.
    public var title: String?
    
    /// Explains the text input area.
    public var description: String?
    
    /// The name of the text object in the text input area.
    public var name: String?
    
    /// The URL of the CGI script that processes text input requests.
    public var link: String?
    
    public init() {}
    
}