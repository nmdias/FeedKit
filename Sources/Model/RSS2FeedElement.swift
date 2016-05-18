//
//  Nodes.swift
//  FeedParser
//
//  Created by Nuno Dias on 28/06/15.
//  Copyright © 2015 FeedParser. All rights reserved.
//

import Foundation


/**
    TODO: - Add description
*/
enum RSS2FeedElement: String {

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
    
    /// Describes the XML DOM path to the specified node.
    var path: String {
        return self.rawValue
    }
    
}
