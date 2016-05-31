//
//  RSSFeed + Attributes Mapper.swift
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

extension RSSFeed {
    
    func map(attributes attributeDict: [String : String], forPath path: RSSPath) {
        
        switch path {
            
        case .RSSChannel:
            
            if  self.channel == nil {
                self.channel = RSSFeedChannel()
            }
            
        case .RSSChannelItem:
            
            if  self.channel?.items == nil {
                self.channel?.items = []
            }
            
            self.channel?.items?.append(RSSFeedChannelItem())
            
        case .RSSChannelImage:
            
            if  self.channel?.image == nil {
                self.channel?.image = RSSFeedChannelImage()
            }
            
        case .RSSChannelSkipDays:
            
            if  self.channel?.skipDays == nil {
                self.channel?.skipDays = []
            }
            
        case .RSSChannelSkipHours:
            
            if  self.channel?.skipHours == nil {
                self.channel?.skipHours = []
            }
            
        case .RSSChannelTextInput:
            
            if  self.channel?.textInput == nil {
                self.channel?.textInput = RSSFeedChannelTextInput()
            }
            
        case .RSSChannelCategory:
            
            if  self.channel?.categories == nil {
                self.channel?.categories = []
            }
            
            self.channel?.categories?.append(RSSFeedChannelCategory(attributes: attributeDict))
            
        case .RSSChannelCloud:
            
            if  self.channel?.cloud == nil {
                self.channel?.cloud = RSSFeedChannelCloud(attributes: attributeDict)
            }
            
        case .RSSChannelItemCategory:
            
            if  self.channel?.items?.last?.categories == nil {
                self.channel?.items?.last?.categories = []
            }
            
            self.channel?.items?.last?.categories?.append(RSSFeedChannelItemCategory(attributes: attributeDict))
            
        case .RSSChannelItemEnclosure:
            
            if  self.channel?.items?.last?.enclosure == nil {
                self.channel?.items?.last?.enclosure = RSSFeedChannelItemEnclosure(attributes: attributeDict)
            }
            
        case .RSSChannelItemGUID:
            
            if  self.channel?.items?.last?.guid == nil {
                self.channel?.items?.last?.guid = RSSFeedChannelItemGUID(attributes: attributeDict)
            }
            
        case .RSSChannelItemSource:
            
            if  self.channel?.items?.last?.source == nil {
                self.channel?.items?.last?.source = RSSFeedChannelItemSource(attributes: attributeDict)
            }
            
        default: break
            
            
        }
        
    }
    
}