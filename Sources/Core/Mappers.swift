//
//  Mappers.swift
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

extension FeedParser {
    
    func map(attributes attributeDict: [String : String], toFeed feed: RSS2Feed, forElement element: RSS2FeedElement) {
        
        switch element {
            
        case .RSSChannel:
            
            if  feed.channel == nil {
                feed.channel = RSS2FeedChannel()
            }
            
        case .RSSChannelItem:
            
            if  feed.channel?.items == nil {
                feed.channel?.items = []
            }
            
            feed.channel?.items?.append(RSS2FeedChannelItem())
            
        case .RSSChannelImage:
            
            if  feed.channel?.image == nil {
                feed.channel?.image = RSS2FeedChannelImage()
            }
            
        case .RSSChannelSkipDays:
            
            if  feed.channel?.skipDays == nil {
                feed.channel?.skipDays = []
            }
            
        case .RSSChannelSkipHours:
            
            if  feed.channel?.skipHours == nil {
                feed.channel?.skipHours = []
            }
            
        case .RSSChannelTextInput:
            
            if  feed.channel?.textInput == nil {
                feed.channel?.textInput = RSS2FeedChannelTextInput()
            }
            
        case .RSSChannelCategory:
            
            if  feed.channel?.categories == nil {
                feed.channel?.categories = []
            }
            
            feed.channel?.categories?.append(RSS2FeedChannelCategory())
            
            let domain = attributeDict["domain"]
            
            /**
             Only initializes the `attributes` variable if the `<category>`s `domain` attribute is present.
             */
            if let domain = domain {
                feed.channel?.categories?.last?.attributes = RSS2FeedChannelCategory.Attributes()
                feed.channel?.categories?.last?.attributes?.domain = domain
            }
            
        case .RSSChannelCloud:
            
            if  feed.channel?.cloud == nil {
                feed.channel?.cloud = RSS2FeedChannelCloud()
            }
            
            let domain                  = attributeDict["domain"]
            let port                    = attributeDict["port"]
            let path                    = attributeDict["path"]
            let registerProcedure       = attributeDict["registerProcedure"]
            let protocolSpecification   = attributeDict["protocol"]
            
            /**
             Only initializes the `attributes` variable if at least one of the `<cloud>`s attribute is present.
             */
            if  domain                  != nil ||
                port                    != nil ||
                path                    != nil ||
                registerProcedure       != nil ||
                protocolSpecification   != nil {
                
                feed.channel?.cloud?.attributes = RSS2FeedChannelCloud.Attributes()
                feed.channel?.cloud?.attributes?.domain = domain
                feed.channel?.cloud?.attributes?.port = UInt(port ?? "")
                feed.channel?.cloud?.attributes?.path = path
                feed.channel?.cloud?.attributes?.registerProcedure = registerProcedure
                feed.channel?.cloud?.attributes?.protocolSpecification = protocolSpecification
                
            }
            
        case .RSSChannelItemCategory:
            
            if  feed.channel?.items?.last?.categories == nil {
                feed.channel?.items?.last?.categories = []
            }
            
            feed.channel?.items?.last?.categories?.append(RSS2FeedChannelItemCategory())
            
            let domain = attributeDict["domain"]
            
            /**
             Only initializes the `attributes` variable if the `<category>`s `domain` attribute is present.
             */
            if let domain = domain {
                feed.channel?.items?.last?.categories?.last?.attributes = RSS2FeedChannelItemCategory.Attributes()
                feed.channel?.items?.last?.categories?.last?.attributes?.domain = domain
            }
            
        case .RSSChannelItemEnclosure:
            
            if  feed.channel?.items?.last?.enclosure == nil {
                feed.channel?.items?.last?.enclosure = RSS2FeedChannelItemEnclosure()
            }
            
            let url     = attributeDict["url"]
            let type    = attributeDict["type"]
            let length  = attributeDict["length"]
            
            /**
             Only initializes the `attributes` variable if at least one of the `<enclosure>`s attribute is present.
             */
            if  url     != nil ||
                length  != nil {
                
                feed.channel?.items?.last?.enclosure?.attributes = RSS2FeedChannelItemEnclosure.Attributes()
                feed.channel?.items?.last?.enclosure?.attributes?.url = url
                feed.channel?.items?.last?.enclosure?.attributes?.type = type
                feed.channel?.items?.last?.enclosure?.attributes?.length = UInt64(length ?? "")
                
            }
            
            
        case .RSSChannelItemGUID:
            
            if  feed.channel?.items?.last?.guid == nil {
                feed.channel?.items?.last?.guid = RSS2FeedChannelItemGUID()
            }
            
            let isPermaLink = attributeDict["isPermaLink"]
            
            /**
             Only initializes the `attributes` variable if the `<guid>`s `isPermaLink` attribute is present.
             */
            if let isPermaLink = isPermaLink where isPermaLink.lowercaseString == "true" || isPermaLink.lowercaseString == "false" {
                feed.channel?.items?.last?.guid?.attributes = RSS2FeedChannelItemGUID.Attributes()
                feed.channel?.items?.last?.guid?.attributes?.isPermaLink = NSString(string: isPermaLink).boolValue
            }
            
        case .RSSChannelItemSource:
            
            if  feed.channel?.items?.last?.source == nil {
                feed.channel?.items?.last?.source = RSS2FeedChannelItemSource()
            }
            
            let url = attributeDict["url"]
            
            /**
             Only initializes the `attributes` variable if the `<source>` `url` attribute is present.
             */
            if let url = url {
                feed.channel?.items?.last?.source?.attributes = RSS2FeedChannelItemSource.Attributes()
                feed.channel?.items?.last?.source?.attributes?.url = url
            }
            
        default: break
            
            
        }
        
    }
    
    /**
     
     Maps a parsed string to the feed model.
     
     Discussion:
     Characters found while parsing any given feed element are assigned or appended to the
     corresponding `model` property. If the corresponding `model` property is `nil`, the string
     of characters is assigned, otherwise, appended.
     
     Note:
     Switch cases with a `break` statement mean there are no values associated with that element,
     or they might just be parents to an element, or contain only attributes. Attributes are handled
     in the `parser(_:didStartElement:namespaceURI:qualifiedName:attributes:)` delegate method.
     
     - parameter string: The string to map to the model.
     - parameter feed: The feed to map to.
     - parameter element: The element that identifies the property that should be mapped in the feed model.
     
     */
    
    func map(string: String, toFeed feed: RSS2Feed, forElement element: RSS2FeedElement) {
        
        switch element {
            
        case .RSS: break
            
            // Channel
            
        case .RSSChannel:                       break
        case .RSSChannelTitle:                  feed.channel?.title                                   = feed.channel?.title?.stringByAppendingString(string) ?? string
        case .RSSChannelLink:                   feed.channel?.link                                    = feed.channel?.link?.stringByAppendingString(string) ?? string
        case .RSSChannelDescription:            feed.channel?.description                             = feed.channel?.description?.stringByAppendingString(string) ?? string
        case .RSSChannelLanguage:               feed.channel?.language                                = feed.channel?.language?.stringByAppendingString(string) ?? string
        case .RSSChannelCopyright:              feed.channel?.copyright                               = feed.channel?.copyright?.stringByAppendingString(string) ?? string
        case .RSSChannelManagingEditor:         feed.channel?.managingEditor                          = feed.channel?.managingEditor?.stringByAppendingString(string) ?? string
        case .RSSChannelWebMaster:              feed.channel?.webMaster                               = feed.channel?.webMaster?.stringByAppendingString(string) ?? string
        case .RSSChannelPubDate:                feed.channel?.pubDate                                 = feed.channel?.pubDate?.stringByAppendingString(string) ?? string
        case .RSSChannelLastBuildDate:          feed.channel?.lastBuildDate                           = feed.channel?.lastBuildDate?.stringByAppendingString(string) ?? string
        case .RSSChannelCategory:               feed.channel?.categories?.last?.value                 = feed.channel?.categories?.last?.value?.stringByAppendingString(string) ?? string
        case .RSSChannelGenerator:              feed.channel?.generator                               = feed.channel?.generator?.stringByAppendingString(string) ?? string
        case .RSSChannelDocs:                   feed.channel?.docs                                    = feed.channel?.docs?.stringByAppendingString(string) ?? string
        case .RSSChannelRating:                 feed.channel?.rating                                  = feed.channel?.rating?.stringByAppendingString(string) ?? string
        case .RSSChannelTTL:                    feed.channel?.ttl                                     = UInt(string)
        case .RSSChannelCloud:                  break
            
            // Channel Image
            
        case .RSSChannelImage:                  break
        case .RSSChannelImageURL:               feed.channel?.image?.url                              = feed.channel?.image?.url?.stringByAppendingString(string) ?? string
        case .RSSChannelImageTitle:             feed.channel?.image?.title                            = feed.channel?.image?.title?.stringByAppendingString(string) ?? string
        case .RSSChannelImageLink:              feed.channel?.image?.link                             = feed.channel?.image?.link?.stringByAppendingString(string) ?? string
        case .RSSChannelImageWidth:             feed.channel?.image?.width                            = UInt(string)
        case .RSSChannelImageHeight:            feed.channel?.image?.height                           = UInt(string)
        case .RSSChannelImageDescription:       feed.channel?.image?.description                      = feed.channel?.image?.description?.stringByAppendingString(string) ?? string
            
            // Channel Text Input
            
        case .RSSChannelTextInput:              break
        case .RSSChannelTextInputTitle:         feed.channel?.textInput?.title                        = feed.channel?.textInput?.title?.stringByAppendingString(string) ?? string
        case .RSSChannelTextInputDescription:   feed.channel?.textInput?.description                  = feed.channel?.textInput?.description?.stringByAppendingString(string) ?? string
        case .RSSChannelTextInputName:          feed.channel?.textInput?.name                         = feed.channel?.textInput?.name?.stringByAppendingString(string) ?? string
        case .RSSChannelTextInputLink:          feed.channel?.textInput?.link                         = feed.channel?.textInput?.link?.stringByAppendingString(string) ?? string
            
            // Channel Skip Hours
            
        case .RSSChannelSkipHours:              break
        case .RSSChannelSkipHoursHour:
            
            guard let hour = RSS2FeedChannelSkipHour(string) where 0...23 ~= hour  else {
                assertionFailure("Unexpected characters: \(string) found in path: \(element.path)")
                return
            }
            
            feed.channel?.skipHours?.append(hour)
            
            // Channel Skip Days
            
        case .RSSChannelSkipDays:               break
        case .RSSChannelSkipDaysDay:
            
            guard let day = RSS2FeedChannelSkipDay(rawValue: string) else {
                assertionFailure("Unexpected characters: \(string) found in path: \(element.path)")
                return
            }
            
            feed.channel?.skipDays?.append(day)
            
            // Channel Item
            
        case .RSSChannelItem:                   break
        case .RSSChannelItemTitle:              feed.channel?.items?.last?.title                      = feed.channel?.items?.last?.title?.stringByAppendingString(string) ?? string
        case .RSSChannelItemLink:               feed.channel?.items?.last?.link                       = feed.channel?.items?.last?.link?.stringByAppendingString(string) ?? string
        case .RSSChannelItemDescription:        feed.channel?.items?.last?.description                = feed.channel?.items?.last?.description?.stringByAppendingString(string) ?? string
        case .RSSChannelItemAuthor:             feed.channel?.items?.last?.author                     = feed.channel?.items?.last?.author?.stringByAppendingString(string) ?? string
        case .RSSChannelItemCategory:           feed.channel?.items?.last?.categories?.last?.value    = feed.channel?.items?.last?.categories?.last?.value?.stringByAppendingString(string) ?? string
        case .RSSChannelItemComments:           feed.channel?.items?.last?.comments                   = feed.channel?.items?.last?.comments?.stringByAppendingString(string) ?? string
        case .RSSChannelItemEnclosure:          break
        case .RSSChannelItemGUID:               feed.channel?.items?.last?.guid?.value                = feed.channel?.items?.last?.guid?.value?.stringByAppendingString(string) ?? string
        case .RSSChannelItemPubDate:            feed.channel?.items?.last?.pubDate                    = feed.channel?.items?.last?.pubDate?.stringByAppendingString(string) ?? string
        case .RSSChannelItemSource:             feed.channel?.items?.last?.source?.value              = feed.channel?.items?.last?.source?.value?.stringByAppendingString(string) ?? string
            
        }
        
        
    }
    
    func map(string: String, toFeed feed: RSS2Feed, forElement element: SyndicationElement) {
        
        switch element {
            
        case .UpdatePeriod:
            
            guard let syUpdatePeriod = SyndicationUpdatePeriod(rawValue: string) else {
                assertionFailure("Unexpected characters: \(string) found in element: \(element.rawValue)")
                return
            }
            
            feed.channel?.syndication?.syUpdatePeriod = syUpdatePeriod
            
        case .UpdateFrequency:  feed.channel?.syndication?.syUpdateFrequency   = UInt(string)
        case .UpdateBase:       feed.channel?.syndication?.syUpdateBase        = feed.channel?.syndication?.syUpdateBase?.stringByAppendingString(string) ?? string
            
        }
        
    }
    
    func map(string: String, toFeed feed: RSS2Feed, forElement element: ContentElementPath) {
        
        switch element {
            
        case .RSSChannelItemContent: feed.channel?.items?.last?.content?.contentEncoded = feed.channel?.items?.last?.content?.contentEncoded?.stringByAppendingString(string) ?? string
            
        }
        
    }
    
    func map(string: String, toFeed feed: RSS2Feed, forElement element: DublinCoreElementPath) {
        
        switch element {
            
            // Channel
            
        case .RSSChannelTitle:                  feed.channel?.dublinCore?.dcTitle                          = feed.channel?.dublinCore?.dcTitle?.stringByAppendingString(string) ?? string
        case .RSSChannelCreator:                feed.channel?.dublinCore?.dcCreator                        = feed.channel?.dublinCore?.dcCreator?.stringByAppendingString(string) ?? string
        case .RSSChannelSubject:                feed.channel?.dublinCore?.dcSubject                        = feed.channel?.dublinCore?.dcSubject?.stringByAppendingString(string) ?? string
        case .RSSChannelDescription:            feed.channel?.dublinCore?.dcDescription                    = feed.channel?.dublinCore?.dcDescription?.stringByAppendingString(string) ?? string
        case .RSSChannelPublisher:              feed.channel?.dublinCore?.dcPublisher                      = feed.channel?.dublinCore?.dcPublisher?.stringByAppendingString(string) ?? string
        case .RSSChannelContributor:            feed.channel?.dublinCore?.dcContributor                    = feed.channel?.dublinCore?.dcContributor?.stringByAppendingString(string) ?? string
        case .RSSChannelDate:                   feed.channel?.dublinCore?.dcDate                           = feed.channel?.dublinCore?.dcDate?.stringByAppendingString(string) ?? string
        case .RSSChannelType:                   feed.channel?.dublinCore?.dcType                           = feed.channel?.dublinCore?.dcType?.stringByAppendingString(string) ?? string
        case .RSSChannelFormat:                 feed.channel?.dublinCore?.dcFormat                         = feed.channel?.dublinCore?.dcFormat?.stringByAppendingString(string) ?? string
        case .RSSChannelIdentifier:             feed.channel?.dublinCore?.dcIdentifier                     = feed.channel?.dublinCore?.dcIdentifier?.stringByAppendingString(string) ?? string
        case .RSSChannelSource:                 feed.channel?.dublinCore?.dcSource                         = feed.channel?.dublinCore?.dcSource?.stringByAppendingString(string) ?? string
        case .RSSChannelLanguage:               feed.channel?.dublinCore?.dcLanguage                       = feed.channel?.dublinCore?.dcLanguage?.stringByAppendingString(string) ?? string
        case .RSSChannelRelation:               feed.channel?.dublinCore?.dcRelation                       = feed.channel?.dublinCore?.dcRelation?.stringByAppendingString(string) ?? string
        case .RSSChannelCoverage:               feed.channel?.dublinCore?.dcCoverage                       = feed.channel?.dublinCore?.dcCoverage?.stringByAppendingString(string) ?? string
        case .RSSChannelRights:                 feed.channel?.dublinCore?.dcRights                         = feed.channel?.dublinCore?.dcRights?.stringByAppendingString(string) ?? string
            
            // Item.
            
        case .RSSChannelItemTitle:              feed.channel?.items?.last?.dublinCore?.dcTitle             = feed.channel?.items?.last?.dublinCore?.dcTitle?.stringByAppendingString(string) ?? string
        case .RSSChannelItemCreator:            feed.channel?.items?.last?.dublinCore?.dcCreator           = feed.channel?.items?.last?.dublinCore?.dcCreator?.stringByAppendingString(string) ?? string
        case .RSSChannelItemSubject:            feed.channel?.items?.last?.dublinCore?.dcSubject           = feed.channel?.items?.last?.dublinCore?.dcSubject?.stringByAppendingString(string) ?? string
        case .RSSChannelItemDescription:        feed.channel?.items?.last?.dublinCore?.dcDescription       = feed.channel?.items?.last?.dublinCore?.dcDescription?.stringByAppendingString(string) ?? string
        case .RSSChannelItemPublisher:          feed.channel?.items?.last?.dublinCore?.dcPublisher         = feed.channel?.items?.last?.dublinCore?.dcPublisher?.stringByAppendingString(string) ?? string
        case .RSSChannelItemContributor:        feed.channel?.items?.last?.dublinCore?.dcContributor       = feed.channel?.items?.last?.dublinCore?.dcContributor?.stringByAppendingString(string) ?? string
        case .RSSChannelItemDate:               feed.channel?.items?.last?.dublinCore?.dcDate              = feed.channel?.items?.last?.dublinCore?.dcDate?.stringByAppendingString(string) ?? string
        case .RSSChannelItemType:               feed.channel?.items?.last?.dublinCore?.dcType              = feed.channel?.items?.last?.dublinCore?.dcType?.stringByAppendingString(string) ?? string
        case .RSSChannelItemFormat:             feed.channel?.items?.last?.dublinCore?.dcFormat            = feed.channel?.items?.last?.dublinCore?.dcFormat?.stringByAppendingString(string) ?? string
        case .RSSChannelItemIdentifier:         feed.channel?.items?.last?.dublinCore?.dcIdentifier        = feed.channel?.items?.last?.dublinCore?.dcIdentifier?.stringByAppendingString(string) ?? string
        case .RSSChannelItemSource:             feed.channel?.items?.last?.dublinCore?.dcSource            = feed.channel?.items?.last?.dublinCore?.dcSource?.stringByAppendingString(string) ?? string
        case .RSSChannelItemLanguage:           feed.channel?.items?.last?.dublinCore?.dcLanguage          = feed.channel?.items?.last?.dublinCore?.dcLanguage?.stringByAppendingString(string) ?? string
        case .RSSChannelItemRelation:           feed.channel?.items?.last?.dublinCore?.dcRelation          = feed.channel?.items?.last?.dublinCore?.dcRelation?.stringByAppendingString(string) ?? string
        case .RSSChannelItemCoverage:           feed.channel?.items?.last?.dublinCore?.dcCoverage          = feed.channel?.items?.last?.dublinCore?.dcCoverage?.stringByAppendingString(string) ?? string
        case .RSSChannelItemRights:             feed.channel?.items?.last?.dublinCore?.dcRights            = feed.channel?.items?.last?.dublinCore?.dcRights?.stringByAppendingString(string) ?? string
            
        }
        
    }
    
}