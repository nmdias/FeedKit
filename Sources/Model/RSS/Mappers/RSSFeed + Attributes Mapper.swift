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
    
    /**
     
     Maps the attributes of the specified dictionary for a given `RSSPath`
     to the `RSSFeed` model
     
     - parameter attributeDict:     The attribute dictionary to map to the model
     - parameter path:              The path of feed's element
     
     */
    func map(attributes attributeDict: [String : String], forPath path: RSSPath) {
        
        switch path {
            
        case .RSSChannelItem:
            
            if  self.items == nil {
                self.items = []
            }
            
            self.items?.append(RSSFeedItem())
            
        case .RSSChannelImage:
            
            if  self.image == nil {
                self.image = RSSFeedImage()
            }
            
        case .RSSChannelSkipDays:
            
            if  self.skipDays == nil {
                self.skipDays = []
            }
            
        case .RSSChannelSkipHours:
            
            if  self.skipHours == nil {
                self.skipHours = []
            }
            
        case .RSSChannelTextInput:
            
            if  self.textInput == nil {
                self.textInput = RSSFeedTextInput()
            }
            
        case .RSSChannelCategory:
            
            if  self.categories == nil {
                self.categories = []
            }
            
            self.categories?.append(RSSFeedCategory(attributes: attributeDict))
            
        case .RSSChannelCloud:
            
            if  self.cloud == nil {
                self.cloud = RSSFeedCloud(attributes: attributeDict)
            }
            
        case .RSSChannelItemCategory:
            
            if  self.items?.last?.categories == nil {
                self.items?.last?.categories = []
            }
            
            self.items?.last?.categories?.append(RSSFeedItemCategory(attributes: attributeDict))
            
        case .RSSChannelItemEnclosure:
            
            if  self.items?.last?.enclosure == nil {
                self.items?.last?.enclosure = RSSFeedItemEnclosure(attributes: attributeDict)
            }
            
        case .RSSChannelItemGUID:
            
            if  self.items?.last?.guid == nil {
                self.items?.last?.guid = RSSFeedItemGUID(attributes: attributeDict)
            }
            
        case .RSSChannelItemSource:
            
            if  self.items?.last?.source == nil {
                self.items?.last?.source = RSSFeedItemSource(attributes: attributeDict)
            }
            
        case .RSSChannelItemContentEncoded:
            
            if  self.items?.last?.content == nil {
                self.items?.last?.content = ContentNamespace()
            }
            
            
        case
        .RSSChannelSyndicationUpdateBase,
        .RSSChannelSyndicationUpdatePeriod,
        .RSSChannelSyndicationUpdateFrequency:
            
            /// If the syndication variable has not been initialized yet, do it before assiging any values
            if  self.syndication == nil {
                self.syndication = SyndicationNamespace()
            }
            
        case
        .RSSChannelDublinCoreTitle,
        .RSSChannelDublinCoreCreator,
        .RSSChannelDublinCoreSubject,
        .RSSChannelDublinCoreDescription,
        .RSSChannelDublinCorePublisher,
        .RSSChannelDublinCoreContributor,
        .RSSChannelDublinCoreDate,
        .RSSChannelDublinCoreType,
        .RSSChannelDublinCoreFormat,
        .RSSChannelDublinCoreIdentifier,
        .RSSChannelDublinCoreSource,
        .RSSChannelDublinCoreLanguage,
        .RSSChannelDublinCoreRelation,
        .RSSChannelDublinCoreCoverage,
        .RSSChannelDublinCoreRights:
            
            if  self.dublinCore == nil {
                self.dublinCore = DublinCoreNamespace()
            }
            
        case
        
        .RSSChannelItemDublinCoreTitle,
        .RSSChannelItemDublinCoreCreator,
        .RSSChannelItemDublinCoreSubject,
        .RSSChannelItemDublinCoreDescription,
        .RSSChannelItemDublinCorePublisher,
        .RSSChannelItemDublinCoreContributor,
        .RSSChannelItemDublinCoreDate,
        .RSSChannelItemDublinCoreType,
        .RSSChannelItemDublinCoreFormat,
        .RSSChannelItemDublinCoreIdentifier,
        .RSSChannelItemDublinCoreSource,
        .RSSChannelItemDublinCoreLanguage,
        .RSSChannelItemDublinCoreRelation,
        .RSSChannelItemDublinCoreCoverage,
        .RSSChannelItemDublinCoreRights:
            
            /// If the dublin core variable has not been initialized yet, do it before assiging any values
            if  self.items?.last?.dublinCore == nil {
                self.items?.last?.dublinCore = DublinCoreNamespace()
            }
            
        default: break
            
            
        }
        
    }
    
}