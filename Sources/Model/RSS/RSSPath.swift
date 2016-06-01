//
//  RSSPath.swift
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
 
 Describes the individual path for each XML DOM element of an RSS feed
 
 See http://web.resource.org/rss/1.0/modules/content/
 
 */
enum RSSPath: String {

    case RSS                                = "/rss"
    case RSSChannel                         = "/rss/channel"
    case RSSChannelTitle                    = "/rss/channel/title"
    case RSSChannelLink                     = "/rss/channel/link"
    case RSSChannelDescription              = "/rss/channel/description"
    case RSSChannelLanguage                 = "/rss/channel/language"
    case RSSChannelCopyright                = "/rss/channel/copyright"
    case RSSChannelManagingEditor           = "/rss/channel/managingEditor"
    case RSSChannelWebMaster                = "/rss/channel/webMaster"
    case RSSChannelPubDate                  = "/rss/channel/pubDate"
    case RSSChannelLastBuildDate            = "/rss/channel/lastBuildDate"
    case RSSChannelCategory                 = "/rss/channel/category"
    case RSSChannelGenerator                = "/rss/channel/generator"
    case RSSChannelDocs                     = "/rss/channel/docs"
    case RSSChannelCloud                    = "/rss/channel/cloud"
    case RSSChannelRating                   = "/rss/channel/rating"
    case RSSChannelTTL                      = "/rss/channel/ttl"
    case RSSChannelImage                    = "/rss/channel/image"
    case RSSChannelImageURL                 = "/rss/channel/image/url"
    case RSSChannelImageTitle               = "/rss/channel/image/title"
    case RSSChannelImageLink                = "/rss/channel/image/link"
    case RSSChannelImageWidth               = "/rss/channel/image/width"
    case RSSChannelImageHeight              = "/rss/channel/image/height"
    case RSSChannelImageDescription         = "/rss/channel/image/description"
    case RSSChannelTextInput                = "/rss/channel/textInput"
    case RSSChannelTextInputTitle           = "/rss/channel/textInput/title"
    case RSSChannelTextInputDescription     = "/rss/channel/textInput/description"
    case RSSChannelTextInputName            = "/rss/channel/textInput/name"
    case RSSChannelTextInputLink            = "/rss/channel/textInput/link"
    case RSSChannelSkipHours                = "/rss/channel/skipHours"
    case RSSChannelSkipHoursHour            = "/rss/channel/skipHours/hour"
    case RSSChannelSkipDays                 = "/rss/channel/skipDays"
    case RSSChannelSkipDaysDay              = "/rss/channel/skipDays/day"
    case RSSChannelItem                     = "/rss/channel/item"
    case RSSChannelItemTitle                = "/rss/channel/item/title"
    case RSSChannelItemLink                 = "/rss/channel/item/link"
    case RSSChannelItemDescription          = "/rss/channel/item/description"
    case RSSChannelItemAuthor               = "/rss/channel/item/author"
    case RSSChannelItemCategory             = "/rss/channel/item/category"
    case RSSChannelItemComments             = "/rss/channel/item/comments"
    case RSSChannelItemEnclosure            = "/rss/channel/item/enclosure"
    case RSSChannelItemGUID                 = "/rss/channel/item/guid"
    case RSSChannelItemPubDate              = "/rss/channel/item/pubDate"
    case RSSChannelItemSource               = "/rss/channel/item/source"
    
    // Content
    
    case RSSChannelItemContentEncoded               = "/rss/channel/item/content:encoded"
    
    // Syndication
    
    case RSSChannelSyndicationUpdatePeriod         = "/rss/channel/sy:updatePeriod"
    case RSSChannelSyndicationUpdateFrequency      = "/rss/channel/sy:updateFrequency"
    case RSSChannelSyndicationUpdateBase           = "/rss/channel/sy:updateBase"
    
    // Dublin Core
    
    case RSSChannelDublinCoreTitle                = "/rss/channel/dc:title"
    case RSSChannelDublinCoreCreator              = "/rss/channel/dc:creator"
    case RSSChannelDublinCoreSubject              = "/rss/channel/dc:subject"
    case RSSChannelDublinCoreDescription          = "/rss/channel/dc:description"
    case RSSChannelDublinCorePublisher            = "/rss/channel/dc:publisher"
    case RSSChannelDublinCoreContributor          = "/rss/channel/dc:contributor"
    case RSSChannelDublinCoreDate                 = "/rss/channel/dc:date"
    case RSSChannelDublinCoreType                 = "/rss/channel/dc:type"
    case RSSChannelDublinCoreFormat               = "/rss/channel/dc:format"
    case RSSChannelDublinCoreIdentifier           = "/rss/channel/dc:identifier"
    case RSSChannelDublinCoreSource               = "/rss/channel/dc:source"
    case RSSChannelDublinCoreLanguage             = "/rss/channel/dc:language"
    case RSSChannelDublinCoreRelation             = "/rss/channel/dc:relation"
    case RSSChannelDublinCoreCoverage             = "/rss/channel/dc:coverage"
    case RSSChannelDublinCoreRights               = "/rss/channel/dc:rights"
    case RSSChannelItemDublinCoreTitle            = "/rss/channel/item/dc:title"
    case RSSChannelItemDublinCoreCreator          = "/rss/channel/item/dc:creator"
    case RSSChannelItemDublinCoreSubject          = "/rss/channel/item/dc:subject"
    case RSSChannelItemDublinCoreDescription      = "/rss/channel/item/dc:description"
    case RSSChannelItemDublinCorePublisher        = "/rss/channel/item/dc:publisher"
    case RSSChannelItemDublinCoreContributor      = "/rss/channel/item/dc:contributor"
    case RSSChannelItemDublinCoreDate             = "/rss/channel/item/dc:date"
    case RSSChannelItemDublinCoreType             = "/rss/channel/item/dc:type"
    case RSSChannelItemDublinCoreFormat           = "/rss/channel/item/dc:format"
    case RSSChannelItemDublinCoreIdentifier       = "/rss/channel/item/dc:identifier"
    case RSSChannelItemDublinCoreSource           = "/rss/channel/item/dc:source"
    case RSSChannelItemDublinCoreLanguage         = "/rss/channel/item/dc:language"
    case RSSChannelItemDublinCoreRelation         = "/rss/channel/item/dc:relation"
    case RSSChannelItemDublinCoreCoverage         = "/rss/channel/item/dc:coverage"
    case RSSChannelItemDublinCoreRights           = "/rss/channel/item/dc:rights"
    
}
