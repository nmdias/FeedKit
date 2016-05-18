//
//  RSS2ChannelImage.swift
//  FeedParser
//
//  Created by Nuno Dias on 01/07/15.
//  Copyright © 2015 FeedParser. All rights reserved.
//

import Foundation

/**
    Specifies a GIF, JPEG or PNG image that can be displayed with the channel. `Image` is an optional element of the `<channel>`.
*/
public class RSS2FeedChannelImage {
    
    /// The URL of a GIF, JPEG or PNG image that represents the channel.
    public var url: String?
    
    /// Describes the image, it's used in the ALT attribute of the HTML `<img>` tag when the channel is rendered in HTML.
    public var title: String?
    
    /// The URL of the site, when the channel is rendered, the image is a link to the site. (Note, in practice the image `<title>` and `<link>` should have the same value as the channel's `<title>` and `<link>`.
    public var link: String?
    
    /// Optional element `<width>` indicating the width of the image in pixels. Maximum value for width is 144, default value is 88.
    public var width: UInt?
    
    /// Optional element `<height>` indicating the height of the image in pixels. Maximum value for height is 400, default value is 31.
    public var height: UInt?
    
    /// Contains text that is included in the TITLE attribute of the link formed around the image in the HTML rendering.
    public var description: String?
    
    public init() {}
    
}