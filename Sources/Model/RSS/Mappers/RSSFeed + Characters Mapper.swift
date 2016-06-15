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
     
     Maps the characters in the specified string to the `RSSFeed` model
     
     - parameter string:    The string to map to the model
     - parameter path:      The path of feed's element
     
     */
    func map(string: String, forPath path: RSSPath) {
        
        switch path {
            
        case .RSS:                                        break
            
            // Channel
            
        case .RSSChannel:                                 break
        case .RSSChannelTitle:                            self.title                                   = self.title?.stringByAppendingString(string) ?? string
        case .RSSChannelLink:                             self.link                                    = self.link?.stringByAppendingString(string) ?? string
        case .RSSChannelDescription:                      self.description                             = self.description?.stringByAppendingString(string) ?? string
        case .RSSChannelLanguage:                         self.language                                = self.language?.stringByAppendingString(string) ?? string
        case .RSSChannelCopyright:                        self.copyright                               = self.copyright?.stringByAppendingString(string) ?? string
        case .RSSChannelManagingEditor:                   self.managingEditor                          = self.managingEditor?.stringByAppendingString(string) ?? string
        case .RSSChannelWebMaster:                        self.webMaster                               = self.webMaster?.stringByAppendingString(string) ?? string
        case .RSSChannelPubDate:                          self.pubDate                                 = string.dateFromSpec(.RFC822)
        case .RSSChannelLastBuildDate:                    self.lastBuildDate                           = string.dateFromSpec(.RFC822)
        case .RSSChannelCategory:                         self.categories?.last?.value                 = self.categories?.last?.value?.stringByAppendingString(string) ?? string
        case .RSSChannelGenerator:                        self.generator                               = self.generator?.stringByAppendingString(string) ?? string
        case .RSSChannelDocs:                             self.docs                                    = self.docs?.stringByAppendingString(string) ?? string
        case .RSSChannelRating:                           self.rating                                  = self.rating?.stringByAppendingString(string) ?? string
        case .RSSChannelTTL:                              self.ttl                                     = Int(string)
        case .RSSChannelCloud:                            break
            
            // Channel Image
            
        case .RSSChannelImage:                            break
        case .RSSChannelImageURL:                         self.image?.url                              = self.image?.url?.stringByAppendingString(string) ?? string
        case .RSSChannelImageTitle:                       self.image?.title                            = self.image?.title?.stringByAppendingString(string) ?? string
        case .RSSChannelImageLink:                        self.image?.link                             = self.image?.link?.stringByAppendingString(string) ?? string
        case .RSSChannelImageWidth:                       self.image?.width                            = Int(string)
        case .RSSChannelImageHeight:                      self.image?.height                           = Int(string)
        case .RSSChannelImageDescription:                 self.image?.description                      = self.image?.description?.stringByAppendingString(string) ?? string
            
            // Channel Text Input
            
        case .RSSChannelTextInput:                        break
        case .RSSChannelTextInputTitle:                   self.textInput?.title                        = self.textInput?.title?.stringByAppendingString(string) ?? string
        case .RSSChannelTextInputDescription:             self.textInput?.description                  = self.textInput?.description?.stringByAppendingString(string) ?? string
        case .RSSChannelTextInputName:                    self.textInput?.name                         = self.textInput?.name?.stringByAppendingString(string) ?? string
        case .RSSChannelTextInputLink:                    self.textInput?.link                         = self.textInput?.link?.stringByAppendingString(string) ?? string
            
            // Channel Skip Hours
            
        case .RSSChannelSkipHours:                        break
        case .RSSChannelSkipHoursHour:
            
            if let hour = RSSFeedSkipHour(string) where 0...23 ~= hour  {
                self.skipHours?.append(hour)
            }
            
            // Channel Skip Days
            
        case .RSSChannelSkipDays:                         break
        case .RSSChannelSkipDaysDay:
            
            if let day = RSSFeedSkipDay(rawValue: string) {
                self.skipDays?.append(day)
            }
            
            // Channel Item
            
        case .RSSChannelItem:                             break
        case .RSSChannelItemTitle:                        self.items?.last?.title                           = self.items?.last?.title?.stringByAppendingString(string) ?? string
        case .RSSChannelItemLink:                         self.items?.last?.link                            = self.items?.last?.link?.stringByAppendingString(string) ?? string
        case .RSSChannelItemDescription:                  self.items?.last?.description                     = self.items?.last?.description?.stringByAppendingString(string) ?? string
        case .RSSChannelItemAuthor:                       self.items?.last?.author                          = self.items?.last?.author?.stringByAppendingString(string) ?? string
        case .RSSChannelItemCategory:                     self.items?.last?.categories?.last?.value         = self.items?.last?.categories?.last?.value?.stringByAppendingString(string) ?? string
        case .RSSChannelItemComments:                     self.items?.last?.comments                        = self.items?.last?.comments?.stringByAppendingString(string) ?? string
        case .RSSChannelItemEnclosure:                    break
        case .RSSChannelItemGUID:                         self.items?.last?.guid?.value                     = self.items?.last?.guid?.value?.stringByAppendingString(string) ?? string
        case .RSSChannelItemPubDate:                      self.items?.last?.pubDate                         = string.dateFromSpec(.RFC822)
        case .RSSChannelItemSource:                       self.items?.last?.source?.value                   = self.items?.last?.source?.value?.stringByAppendingString(string) ?? string
            
            // Namespace - Content
            
        case .RSSChannelItemContentEncoded:               self.items?.last?.content?.contentEncoded         = self.items?.last?.content?.contentEncoded?.stringByAppendingString(string) ?? string

            // Namespace - Syndication
            
        case .RSSChannelSyndicationUpdatePeriod:          self.syndication?.syUpdatePeriod                  = SyndicationUpdatePeriod(rawValue: string)
        case .RSSChannelSyndicationUpdateFrequency:       self.syndication?.syUpdateFrequency               = Int(string)
        case .RSSChannelSyndicationUpdateBase:            self.syndication?.syUpdateBase                    = self.syndication?.syUpdateBase?.stringByAppendingString(string) ?? string
            
            // Namespace - Dublin Core
            
        case .RSSChannelDublinCoreTitle:                  self.dublinCore?.dcTitle                          = self.dublinCore?.dcTitle?.stringByAppendingString(string) ?? string
        case .RSSChannelDublinCoreCreator:                self.dublinCore?.dcCreator                        = self.dublinCore?.dcCreator?.stringByAppendingString(string) ?? string
        case .RSSChannelDublinCoreSubject:                self.dublinCore?.dcSubject                        = self.dublinCore?.dcSubject?.stringByAppendingString(string) ?? string
        case .RSSChannelDublinCoreDescription:            self.dublinCore?.dcDescription                    = self.dublinCore?.dcDescription?.stringByAppendingString(string) ?? string
        case .RSSChannelDublinCorePublisher:              self.dublinCore?.dcPublisher                      = self.dublinCore?.dcPublisher?.stringByAppendingString(string) ?? string
        case .RSSChannelDublinCoreContributor:            self.dublinCore?.dcContributor                    = self.dublinCore?.dcContributor?.stringByAppendingString(string) ?? string
        case .RSSChannelDublinCoreDate:                   self.dublinCore?.dcDate                           = string.dateFromSpec(.ISO8601)
        case .RSSChannelDublinCoreType:                   self.dublinCore?.dcType                           = self.dublinCore?.dcType?.stringByAppendingString(string) ?? string
        case .RSSChannelDublinCoreFormat:                 self.dublinCore?.dcFormat                         = self.dublinCore?.dcFormat?.stringByAppendingString(string) ?? string
        case .RSSChannelDublinCoreIdentifier:             self.dublinCore?.dcIdentifier                     = self.dublinCore?.dcIdentifier?.stringByAppendingString(string) ?? string
        case .RSSChannelDublinCoreSource:                 self.dublinCore?.dcSource                         = self.dublinCore?.dcSource?.stringByAppendingString(string) ?? string
        case .RSSChannelDublinCoreLanguage:               self.dublinCore?.dcLanguage                       = self.dublinCore?.dcLanguage?.stringByAppendingString(string) ?? string
        case .RSSChannelDublinCoreRelation:               self.dublinCore?.dcRelation                       = self.dublinCore?.dcRelation?.stringByAppendingString(string) ?? string
        case .RSSChannelDublinCoreCoverage:               self.dublinCore?.dcCoverage                       = self.dublinCore?.dcCoverage?.stringByAppendingString(string) ?? string
        case .RSSChannelDublinCoreRights:                 self.dublinCore?.dcRights                         = self.dublinCore?.dcRights?.stringByAppendingString(string) ?? string
            
        case .RSSChannelItemDublinCoreTitle:              self.items?.last?.dublinCore?.dcTitle             = self.items?.last?.dublinCore?.dcTitle?.stringByAppendingString(string) ?? string
        case .RSSChannelItemDublinCoreCreator:            self.items?.last?.dublinCore?.dcCreator           = self.items?.last?.dublinCore?.dcCreator?.stringByAppendingString(string) ?? string
        case .RSSChannelItemDublinCoreSubject:            self.items?.last?.dublinCore?.dcSubject           = self.items?.last?.dublinCore?.dcSubject?.stringByAppendingString(string) ?? string
        case .RSSChannelItemDublinCoreDescription:        self.items?.last?.dublinCore?.dcDescription       = self.items?.last?.dublinCore?.dcDescription?.stringByAppendingString(string) ?? string
        case .RSSChannelItemDublinCorePublisher:          self.items?.last?.dublinCore?.dcPublisher         = self.items?.last?.dublinCore?.dcPublisher?.stringByAppendingString(string) ?? string
        case .RSSChannelItemDublinCoreContributor:        self.items?.last?.dublinCore?.dcContributor       = self.items?.last?.dublinCore?.dcContributor?.stringByAppendingString(string) ?? string
        case .RSSChannelItemDublinCoreDate:               self.items?.last?.dublinCore?.dcDate              = string.dateFromSpec(.ISO8601)
        case .RSSChannelItemDublinCoreType:               self.items?.last?.dublinCore?.dcType              = self.items?.last?.dublinCore?.dcType?.stringByAppendingString(string) ?? string
        case .RSSChannelItemDublinCoreFormat:             self.items?.last?.dublinCore?.dcFormat            = self.items?.last?.dublinCore?.dcFormat?.stringByAppendingString(string) ?? string
        case .RSSChannelItemDublinCoreIdentifier:         self.items?.last?.dublinCore?.dcIdentifier        = self.items?.last?.dublinCore?.dcIdentifier?.stringByAppendingString(string) ?? string
        case .RSSChannelItemDublinCoreSource:             self.items?.last?.dublinCore?.dcSource            = self.items?.last?.dublinCore?.dcSource?.stringByAppendingString(string) ?? string
        case .RSSChannelItemDublinCoreLanguage:           self.items?.last?.dublinCore?.dcLanguage          = self.items?.last?.dublinCore?.dcLanguage?.stringByAppendingString(string) ?? string
        case .RSSChannelItemDublinCoreRelation:           self.items?.last?.dublinCore?.dcRelation          = self.items?.last?.dublinCore?.dcRelation?.stringByAppendingString(string) ?? string
        case .RSSChannelItemDublinCoreCoverage:           self.items?.last?.dublinCore?.dcCoverage          = self.items?.last?.dublinCore?.dcCoverage?.stringByAppendingString(string) ?? string
        case .RSSChannelItemDublinCoreRights:             self.items?.last?.dublinCore?.dcRights            = self.items?.last?.dublinCore?.dcRights?.stringByAppendingString(string) ?? string
           
            
        }
        
        
    }
    
    
}