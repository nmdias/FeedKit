//
//  RSSFeed + Characters Mapper.swift
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
     
     Maps a parsed string to the feed model.
     
     Discussion:
     Characters found while parsing any given feed element are assigned or
     appended to the corresponding `model` property. If the corresponding
     `model` property is `nil`, the string of characters is assigned,
     otherwise, appended.
     
     Note:
     Switch cases with a `break` statement mean there are no values
     associated with that element, or they might just be parents to an
     element, or contain only attributes. Attributes are handled in the
     `parser(_:didStartElement:namespaceURI:qualifiedName:attributes:)`
     delegate method.
     
     - parameter string:    The string to map to the model.
     - parameter feed:      The feed to map to.
     - parameter element:   The element that identifies the property that should be mapped in the feed model.
     
     */
    
    func map(string: String, forPath path: RSSPath) {
        
        switch path {
            
        case .RSS: break
            
            // Channel
            
        case .RSSChannel:                       break
        case .RSSChannelTitle:                  self.channel?.title                                   = self.channel?.title?.stringByAppendingString(string) ?? string
        case .RSSChannelLink:                   self.channel?.link                                    = self.channel?.link?.stringByAppendingString(string) ?? string
        case .RSSChannelDescription:            self.channel?.description                             = self.channel?.description?.stringByAppendingString(string) ?? string
        case .RSSChannelLanguage:               self.channel?.language                                = self.channel?.language?.stringByAppendingString(string) ?? string
        case .RSSChannelCopyright:              self.channel?.copyright                               = self.channel?.copyright?.stringByAppendingString(string) ?? string
        case .RSSChannelManagingEditor:         self.channel?.managingEditor                          = self.channel?.managingEditor?.stringByAppendingString(string) ?? string
        case .RSSChannelWebMaster:              self.channel?.webMaster                               = self.channel?.webMaster?.stringByAppendingString(string) ?? string
        case .RSSChannelPubDate:                self.channel?.pubDate                                 = self.channel?.pubDate?.stringByAppendingString(string) ?? string
        case .RSSChannelLastBuildDate:          self.channel?.lastBuildDate                           = self.channel?.lastBuildDate?.stringByAppendingString(string) ?? string
        case .RSSChannelCategory:               self.channel?.categories?.last?.value                 = self.channel?.categories?.last?.value?.stringByAppendingString(string) ?? string
        case .RSSChannelGenerator:              self.channel?.generator                               = self.channel?.generator?.stringByAppendingString(string) ?? string
        case .RSSChannelDocs:                   self.channel?.docs                                    = self.channel?.docs?.stringByAppendingString(string) ?? string
        case .RSSChannelRating:                 self.channel?.rating                                  = self.channel?.rating?.stringByAppendingString(string) ?? string
        case .RSSChannelTTL:                    self.channel?.ttl                                     = Int(string)
        case .RSSChannelCloud:                  break
            
            // Channel Image
            
        case .RSSChannelImage:                  break
        case .RSSChannelImageURL:               self.channel?.image?.url                              = self.channel?.image?.url?.stringByAppendingString(string) ?? string
        case .RSSChannelImageTitle:             self.channel?.image?.title                            = self.channel?.image?.title?.stringByAppendingString(string) ?? string
        case .RSSChannelImageLink:              self.channel?.image?.link                             = self.channel?.image?.link?.stringByAppendingString(string) ?? string
        case .RSSChannelImageWidth:             self.channel?.image?.width                            = Int(string)
        case .RSSChannelImageHeight:            self.channel?.image?.height                           = Int(string)
        case .RSSChannelImageDescription:       self.channel?.image?.description                      = self.channel?.image?.description?.stringByAppendingString(string) ?? string
            
            // Channel Text Input
            
        case .RSSChannelTextInput:              break
        case .RSSChannelTextInputTitle:         self.channel?.textInput?.title                        = self.channel?.textInput?.title?.stringByAppendingString(string) ?? string
        case .RSSChannelTextInputDescription:   self.channel?.textInput?.description                  = self.channel?.textInput?.description?.stringByAppendingString(string) ?? string
        case .RSSChannelTextInputName:          self.channel?.textInput?.name                         = self.channel?.textInput?.name?.stringByAppendingString(string) ?? string
        case .RSSChannelTextInputLink:          self.channel?.textInput?.link                         = self.channel?.textInput?.link?.stringByAppendingString(string) ?? string
            
            // Channel Skip Hours
            
        case .RSSChannelSkipHours:              break
        case .RSSChannelSkipHoursHour:
            
            if let hour = RSSFeedChannelSkipHour(string) where 0...23 ~= hour  {
                self.channel?.skipHours?.append(hour)
            }
            
            // Channel Skip Days
            
        case .RSSChannelSkipDays:               break
        case .RSSChannelSkipDaysDay:
            
            if let day = RSSFeedChannelSkipDay(rawValue: string) {
                self.channel?.skipDays?.append(day)
            }
            
            // Channel Item
            
        case .RSSChannelItem:                   break
        case .RSSChannelItemTitle:              self.channel?.items?.last?.title                      = self.channel?.items?.last?.title?.stringByAppendingString(string) ?? string
        case .RSSChannelItemLink:               self.channel?.items?.last?.link                       = self.channel?.items?.last?.link?.stringByAppendingString(string) ?? string
        case .RSSChannelItemDescription:        self.channel?.items?.last?.description                = self.channel?.items?.last?.description?.stringByAppendingString(string) ?? string
        case .RSSChannelItemAuthor:             self.channel?.items?.last?.author                     = self.channel?.items?.last?.author?.stringByAppendingString(string) ?? string
        case .RSSChannelItemCategory:           self.channel?.items?.last?.categories?.last?.value    = self.channel?.items?.last?.categories?.last?.value?.stringByAppendingString(string) ?? string
        case .RSSChannelItemComments:           self.channel?.items?.last?.comments                   = self.channel?.items?.last?.comments?.stringByAppendingString(string) ?? string
        case .RSSChannelItemEnclosure:          break
        case .RSSChannelItemGUID:               self.channel?.items?.last?.guid?.value                = self.channel?.items?.last?.guid?.value?.stringByAppendingString(string) ?? string
        case .RSSChannelItemPubDate:            self.channel?.items?.last?.pubDate                    = self.channel?.items?.last?.pubDate?.stringByAppendingString(string) ?? string
        case .RSSChannelItemSource:             self.channel?.items?.last?.source?.value              = self.channel?.items?.last?.source?.value?.stringByAppendingString(string) ?? string
            
            // Dublin Core
            
        case .RSSChannelDublinCoreTitle:                  self.channel?.dublinCore?.dcTitle                          = self.channel?.dublinCore?.dcTitle?.stringByAppendingString(string) ?? string
        case .RSSChannelDublinCoreCreator:                self.channel?.dublinCore?.dcCreator                        = self.channel?.dublinCore?.dcCreator?.stringByAppendingString(string) ?? string
        case .RSSChannelDublinCoreSubject:                self.channel?.dublinCore?.dcSubject                        = self.channel?.dublinCore?.dcSubject?.stringByAppendingString(string) ?? string
        case .RSSChannelDublinCoreDescription:            self.channel?.dublinCore?.dcDescription                    = self.channel?.dublinCore?.dcDescription?.stringByAppendingString(string) ?? string
        case .RSSChannelDublinCorePublisher:              self.channel?.dublinCore?.dcPublisher                      = self.channel?.dublinCore?.dcPublisher?.stringByAppendingString(string) ?? string
        case .RSSChannelDublinCoreContributor:            self.channel?.dublinCore?.dcContributor                    = self.channel?.dublinCore?.dcContributor?.stringByAppendingString(string) ?? string
        case .RSSChannelDublinCoreDate:                   self.channel?.dublinCore?.dcDate                           = self.channel?.dublinCore?.dcDate?.stringByAppendingString(string) ?? string
        case .RSSChannelDublinCoreType:                   self.channel?.dublinCore?.dcType                           = self.channel?.dublinCore?.dcType?.stringByAppendingString(string) ?? string
        case .RSSChannelDublinCoreFormat:                 self.channel?.dublinCore?.dcFormat                         = self.channel?.dublinCore?.dcFormat?.stringByAppendingString(string) ?? string
        case .RSSChannelDublinCoreIdentifier:             self.channel?.dublinCore?.dcIdentifier                     = self.channel?.dublinCore?.dcIdentifier?.stringByAppendingString(string) ?? string
        case .RSSChannelDublinCoreSource:                 self.channel?.dublinCore?.dcSource                         = self.channel?.dublinCore?.dcSource?.stringByAppendingString(string) ?? string
        case .RSSChannelDublinCoreLanguage:               self.channel?.dublinCore?.dcLanguage                       = self.channel?.dublinCore?.dcLanguage?.stringByAppendingString(string) ?? string
        case .RSSChannelDublinCoreRelation:               self.channel?.dublinCore?.dcRelation                       = self.channel?.dublinCore?.dcRelation?.stringByAppendingString(string) ?? string
        case .RSSChannelDublinCoreCoverage:               self.channel?.dublinCore?.dcCoverage                       = self.channel?.dublinCore?.dcCoverage?.stringByAppendingString(string) ?? string
        case .RSSChannelDublinCoreRights:                 self.channel?.dublinCore?.dcRights                         = self.channel?.dublinCore?.dcRights?.stringByAppendingString(string) ?? string
            
        case .RSSChannelItemDublinCoreTitle:              self.channel?.items?.last?.dublinCore?.dcTitle             = self.channel?.items?.last?.dublinCore?.dcTitle?.stringByAppendingString(string) ?? string
        case .RSSChannelItemDublinCoreCreator:            self.channel?.items?.last?.dublinCore?.dcCreator           = self.channel?.items?.last?.dublinCore?.dcCreator?.stringByAppendingString(string) ?? string
        case .RSSChannelItemDublinCoreSubject:            self.channel?.items?.last?.dublinCore?.dcSubject           = self.channel?.items?.last?.dublinCore?.dcSubject?.stringByAppendingString(string) ?? string
        case .RSSChannelItemDublinCoreDescription:        self.channel?.items?.last?.dublinCore?.dcDescription       = self.channel?.items?.last?.dublinCore?.dcDescription?.stringByAppendingString(string) ?? string
        case .RSSChannelItemDublinCorePublisher:          self.channel?.items?.last?.dublinCore?.dcPublisher         = self.channel?.items?.last?.dublinCore?.dcPublisher?.stringByAppendingString(string) ?? string
        case .RSSChannelItemDublinCoreContributor:        self.channel?.items?.last?.dublinCore?.dcContributor       = self.channel?.items?.last?.dublinCore?.dcContributor?.stringByAppendingString(string) ?? string
        case .RSSChannelItemDublinCoreDate:               self.channel?.items?.last?.dublinCore?.dcDate              = self.channel?.items?.last?.dublinCore?.dcDate?.stringByAppendingString(string) ?? string
        case .RSSChannelItemDublinCoreType:               self.channel?.items?.last?.dublinCore?.dcType              = self.channel?.items?.last?.dublinCore?.dcType?.stringByAppendingString(string) ?? string
        case .RSSChannelItemDublinCoreFormat:             self.channel?.items?.last?.dublinCore?.dcFormat            = self.channel?.items?.last?.dublinCore?.dcFormat?.stringByAppendingString(string) ?? string
        case .RSSChannelItemDublinCoreIdentifier:         self.channel?.items?.last?.dublinCore?.dcIdentifier        = self.channel?.items?.last?.dublinCore?.dcIdentifier?.stringByAppendingString(string) ?? string
        case .RSSChannelItemDublinCoreSource:             self.channel?.items?.last?.dublinCore?.dcSource            = self.channel?.items?.last?.dublinCore?.dcSource?.stringByAppendingString(string) ?? string
        case .RSSChannelItemDublinCoreLanguage:           self.channel?.items?.last?.dublinCore?.dcLanguage          = self.channel?.items?.last?.dublinCore?.dcLanguage?.stringByAppendingString(string) ?? string
        case .RSSChannelItemDublinCoreRelation:           self.channel?.items?.last?.dublinCore?.dcRelation          = self.channel?.items?.last?.dublinCore?.dcRelation?.stringByAppendingString(string) ?? string
        case .RSSChannelItemDublinCoreCoverage:           self.channel?.items?.last?.dublinCore?.dcCoverage          = self.channel?.items?.last?.dublinCore?.dcCoverage?.stringByAppendingString(string) ?? string
        case .RSSChannelItemDublinCoreRights:             self.channel?.items?.last?.dublinCore?.dcRights            = self.channel?.items?.last?.dublinCore?.dcRights?.stringByAppendingString(string) ?? string
            
            
        }
        
    }
    
    
}