//
//  RSSFeed + Dublin Core Characters Mapper.swift
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
    
    func map(string: String, forPath path: DublinCorePath) {
        
        /// If the dublin core variable has not been initialized yet, do it before assiging any values
        if self.channel?.dublinCore == nil {
            self.channel?.dublinCore = DublinCoreNamespace()
        }
        
        switch path {
            
        case .RSSChannelTitle:                  self.channel?.dublinCore?.dcTitle                          = self.channel?.dublinCore?.dcTitle?.stringByAppendingString(string) ?? string
        case .RSSChannelCreator:                self.channel?.dublinCore?.dcCreator                        = self.channel?.dublinCore?.dcCreator?.stringByAppendingString(string) ?? string
        case .RSSChannelSubject:                self.channel?.dublinCore?.dcSubject                        = self.channel?.dublinCore?.dcSubject?.stringByAppendingString(string) ?? string
        case .RSSChannelDescription:            self.channel?.dublinCore?.dcDescription                    = self.channel?.dublinCore?.dcDescription?.stringByAppendingString(string) ?? string
        case .RSSChannelPublisher:              self.channel?.dublinCore?.dcPublisher                      = self.channel?.dublinCore?.dcPublisher?.stringByAppendingString(string) ?? string
        case .RSSChannelContributor:            self.channel?.dublinCore?.dcContributor                    = self.channel?.dublinCore?.dcContributor?.stringByAppendingString(string) ?? string
        case .RSSChannelDate:                   self.channel?.dublinCore?.dcDate                           = self.channel?.dublinCore?.dcDate?.stringByAppendingString(string) ?? string
        case .RSSChannelType:                   self.channel?.dublinCore?.dcType                           = self.channel?.dublinCore?.dcType?.stringByAppendingString(string) ?? string
        case .RSSChannelFormat:                 self.channel?.dublinCore?.dcFormat                         = self.channel?.dublinCore?.dcFormat?.stringByAppendingString(string) ?? string
        case .RSSChannelIdentifier:             self.channel?.dublinCore?.dcIdentifier                     = self.channel?.dublinCore?.dcIdentifier?.stringByAppendingString(string) ?? string
        case .RSSChannelSource:                 self.channel?.dublinCore?.dcSource                         = self.channel?.dublinCore?.dcSource?.stringByAppendingString(string) ?? string
        case .RSSChannelLanguage:               self.channel?.dublinCore?.dcLanguage                       = self.channel?.dublinCore?.dcLanguage?.stringByAppendingString(string) ?? string
        case .RSSChannelRelation:               self.channel?.dublinCore?.dcRelation                       = self.channel?.dublinCore?.dcRelation?.stringByAppendingString(string) ?? string
        case .RSSChannelCoverage:               self.channel?.dublinCore?.dcCoverage                       = self.channel?.dublinCore?.dcCoverage?.stringByAppendingString(string) ?? string
        case .RSSChannelRights:                 self.channel?.dublinCore?.dcRights                         = self.channel?.dublinCore?.dcRights?.stringByAppendingString(string) ?? string

        case
        
        .RSSChannelItemTitle,
        .RSSChannelItemCreator,
        .RSSChannelItemSubject,
        .RSSChannelItemDescription,
        .RSSChannelItemPublisher,
        .RSSChannelItemContributor,
        .RSSChannelItemDate,
        .RSSChannelItemType,
        .RSSChannelItemFormat,
        .RSSChannelItemIdentifier,
        .RSSChannelItemSource,
        .RSSChannelItemLanguage,
        .RSSChannelItemRelation,
        .RSSChannelItemCoverage,
        .RSSChannelItemRights:
            
            /// If the dublin core variable has not been initialized yet, do it before assiging any values
            if  self.channel?.items?.last?.dublinCore == nil {
                self.channel?.items?.last?.dublinCore = DublinCoreNamespace()
            }
            
            switch path {
            case .RSSChannelItemTitle:              self.channel?.items?.last?.dublinCore?.dcTitle             = self.channel?.items?.last?.dublinCore?.dcTitle?.stringByAppendingString(string) ?? string
            case .RSSChannelItemCreator:            self.channel?.items?.last?.dublinCore?.dcCreator           = self.channel?.items?.last?.dublinCore?.dcCreator?.stringByAppendingString(string) ?? string
            case .RSSChannelItemSubject:            self.channel?.items?.last?.dublinCore?.dcSubject           = self.channel?.items?.last?.dublinCore?.dcSubject?.stringByAppendingString(string) ?? string
            case .RSSChannelItemDescription:        self.channel?.items?.last?.dublinCore?.dcDescription       = self.channel?.items?.last?.dublinCore?.dcDescription?.stringByAppendingString(string) ?? string
            case .RSSChannelItemPublisher:          self.channel?.items?.last?.dublinCore?.dcPublisher         = self.channel?.items?.last?.dublinCore?.dcPublisher?.stringByAppendingString(string) ?? string
            case .RSSChannelItemContributor:        self.channel?.items?.last?.dublinCore?.dcContributor       = self.channel?.items?.last?.dublinCore?.dcContributor?.stringByAppendingString(string) ?? string
            case .RSSChannelItemDate:               self.channel?.items?.last?.dublinCore?.dcDate              = self.channel?.items?.last?.dublinCore?.dcDate?.stringByAppendingString(string) ?? string
            case .RSSChannelItemType:               self.channel?.items?.last?.dublinCore?.dcType              = self.channel?.items?.last?.dublinCore?.dcType?.stringByAppendingString(string) ?? string
            case .RSSChannelItemFormat:             self.channel?.items?.last?.dublinCore?.dcFormat            = self.channel?.items?.last?.dublinCore?.dcFormat?.stringByAppendingString(string) ?? string
            case .RSSChannelItemIdentifier:         self.channel?.items?.last?.dublinCore?.dcIdentifier        = self.channel?.items?.last?.dublinCore?.dcIdentifier?.stringByAppendingString(string) ?? string
            case .RSSChannelItemSource:             self.channel?.items?.last?.dublinCore?.dcSource            = self.channel?.items?.last?.dublinCore?.dcSource?.stringByAppendingString(string) ?? string
            case .RSSChannelItemLanguage:           self.channel?.items?.last?.dublinCore?.dcLanguage          = self.channel?.items?.last?.dublinCore?.dcLanguage?.stringByAppendingString(string) ?? string
            case .RSSChannelItemRelation:           self.channel?.items?.last?.dublinCore?.dcRelation          = self.channel?.items?.last?.dublinCore?.dcRelation?.stringByAppendingString(string) ?? string
            case .RSSChannelItemCoverage:           self.channel?.items?.last?.dublinCore?.dcCoverage          = self.channel?.items?.last?.dublinCore?.dcCoverage?.stringByAppendingString(string) ?? string
            case .RSSChannelItemRights:             self.channel?.items?.last?.dublinCore?.dcRights            = self.channel?.items?.last?.dublinCore?.dcRights?.stringByAppendingString(string) ?? string
            default: break
            }
            
        }
     
    }
    
}