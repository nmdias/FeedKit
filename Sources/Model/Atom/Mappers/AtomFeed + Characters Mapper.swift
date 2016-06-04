//
//  AtomFeed + Characters Mapper.swift
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

extension AtomFeed {
    
    /**
     
     Maps the characters in the specified string to the `AtomFeed` model
     
     - parameter string:    The string to map to the model
     - parameter path:      The path of feed's element
     
     */
    func map(characters string: String, forPath path: AtomPath) {
        
        switch path {
        case .Feed:                             break
        case .FeedTitle:                        self.title                                      = self.title?.stringByAppendingString(string) ?? string
        case .FeedSubtitle:                     self.subtitle?.value                            = self.subtitle?.value?.stringByAppendingString(string) ?? string
        case .FeedLink:                         break
        case .FeedUpdated:                      self.updated                                    = self.updated?.stringByAppendingString(string) ?? string
        case .FeedCategory:                     break
        case .FeedAuthor:                       break
        case .FeedAuthorName:                   self.authors?.last?.name                        = self.authors?.last?.name?.stringByAppendingString(string) ?? string
        case .FeedAuthorEmail:                  self.authors?.last?.email                       = self.authors?.last?.email?.stringByAppendingString(string) ?? string
        case .FeedAuthorUri:                    self.authors?.last?.uri                         = self.authors?.last?.uri?.stringByAppendingString(string) ?? string
        case .FeedContributor:                  break
        case .FeedContributorName:              self.contributors?.last?.name                   = self.contributors?.last?.name?.stringByAppendingString(string) ?? string
        case .FeedContributorEmail:             self.contributors?.last?.email                  = self.contributors?.last?.email?.stringByAppendingString(string) ?? string
        case .FeedContributorUri:               self.contributors?.last?.uri                    = self.contributors?.last?.uri?.stringByAppendingString(string) ?? string
        case .FeedID:                           self.id                                         = self.id?.stringByAppendingString(string) ?? string
        case .FeedGenerator:                    self.generator?.value                           = self.generator?.value?.stringByAppendingString(string) ?? string
        case .FeedIcon:                         self.icon                                       = self.icon?.stringByAppendingString(string) ?? string
        case .FeedLogo:                         self.logo                                       = self.logo?.stringByAppendingString(string) ?? string
        case .FeedRights:                       self.rights                                     = self.rights?.stringByAppendingString(string) ?? string
        case .FeedEntry:                        break
        case .FeedEntryTitle:                   self.entries?.last?.title                       = self.entries?.last?.title?.stringByAppendingString(string) ?? string
        case .FeedEntrySummary:                 self.entries?.last?.summary?.value              = self.entries?.last?.summary?.value?.stringByAppendingString(string) ?? string
        case .FeedEntryLink:                    break
        case .FeedEntryUpdated:                 self.entries?.last?.updated                     = self.entries?.last?.updated?.stringByAppendingString(string) ?? string
        case .FeedEntryCategory:                break
        case .FeedEntryID:                      self.entries?.last?.id                          = self.entries?.last?.id?.stringByAppendingString(string) ?? string
        case .FeedEntryContent:                 self.entries?.last?.content?.value              = self.entries?.last?.content?.value?.stringByAppendingString(string) ?? string
        case .FeedEntryPublished:               self.entries?.last?.published                   = self.entries?.last?.published?.stringByAppendingString(string) ?? string
        case .FeedEntrySource:                  break
        case .FeedEntrySourceID:                self.entries?.last?.source?.id                  = self.entries?.last?.source?.id?.stringByAppendingString(string) ?? string
        case .FeedEntrySourceTitle:             self.entries?.last?.source?.title               = self.entries?.last?.source?.title?.stringByAppendingString(string) ?? string
        case .FeedEntrySourceUpdated:           self.entries?.last?.source?.updated             = self.entries?.last?.source?.updated?.stringByAppendingString(string) ?? string
        case .FeedEntryRights:                  self.entries?.last?.rights                      = self.entries?.last?.rights?.stringByAppendingString(string) ?? string
        case .FeedEntryAuthor:                  break
        case .FeedEntryAuthorName:              self.entries?.last?.authors?.last?.name         = self.entries?.last?.authors?.last?.name?.stringByAppendingString(string) ?? string
        case .FeedEntryAuthorEmail:             self.entries?.last?.authors?.last?.email        = self.entries?.last?.authors?.last?.email?.stringByAppendingString(string) ?? string
        case .FeedEntryAuthorUri:               self.entries?.last?.authors?.last?.uri          = self.entries?.last?.authors?.last?.uri?.stringByAppendingString(string) ?? string
        case .FeedEntryContributor:             break
        case .FeedEntryContributorName:         self.entries?.last?.contributors?.last?.name    = self.entries?.last?.contributors?.last?.name?.stringByAppendingString(string) ?? string
        case .FeedEntryContributorEmail:        self.entries?.last?.contributors?.last?.email   = self.entries?.last?.contributors?.last?.email?.stringByAppendingString(string) ?? string
        case .FeedEntryContributorUri:          self.entries?.last?.contributors?.last?.uri     = self.entries?.last?.contributors?.last?.uri?.stringByAppendingString(string) ?? string
        }
        
    }
    
}