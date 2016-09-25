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
        case .FeedTitle:                        self.title                                      = self.title?.appending(string) ?? string
        case .FeedSubtitle:                     self.subtitle?.value                            = self.subtitle?.value?.appending(string) ?? string
        case .FeedLink:                         break
        case .FeedUpdated:                      self.updated                                    = string.dateFromSpec(.rfc3999)
        case .FeedCategory:                     break
        case .FeedAuthor:                       break
        case .FeedAuthorName:                   self.authors?.last?.name                        = self.authors?.last?.name?.appending(string) ?? string
        case .FeedAuthorEmail:                  self.authors?.last?.email                       = self.authors?.last?.email?.appending(string) ?? string
        case .FeedAuthorUri:                    self.authors?.last?.uri                         = self.authors?.last?.uri?.appending(string) ?? string
        case .FeedContributor:                  break
        case .FeedContributorName:              self.contributors?.last?.name                   = self.contributors?.last?.name?.appending(string) ?? string
        case .FeedContributorEmail:             self.contributors?.last?.email                  = self.contributors?.last?.email?.appending(string) ?? string
        case .FeedContributorUri:               self.contributors?.last?.uri                    = self.contributors?.last?.uri?.appending(string) ?? string
        case .FeedID:                           self.id                                         = self.id?.appending(string) ?? string
        case .FeedGenerator:                    self.generator?.value                           = self.generator?.value?.appending(string) ?? string
        case .FeedIcon:                         self.icon                                       = self.icon?.appending(string) ?? string
        case .FeedLogo:                         self.logo                                       = self.logo?.appending(string) ?? string
        case .FeedRights:                       self.rights                                     = self.rights?.appending(string) ?? string
        case .FeedEntry:                        break
        case .FeedEntryTitle:                   self.entries?.last?.title                       = self.entries?.last?.title?.appending(string) ?? string
        case .FeedEntrySummary:                 self.entries?.last?.summary?.value              = self.entries?.last?.summary?.value?.appending(string) ?? string
        case .FeedEntryLink:                    break
        case .FeedEntryUpdated:                 self.entries?.last?.updated                     = string.dateFromSpec(.rfc3999)
        case .FeedEntryCategory:                break
        case .FeedEntryID:                      self.entries?.last?.id                          = self.entries?.last?.id?.appending(string) ?? string
        case .FeedEntryContent:                 self.entries?.last?.content?.value              = self.entries?.last?.content?.value?.appending(string) ?? string
        case .FeedEntryPublished:               self.entries?.last?.published                   = string.dateFromSpec(.rfc3999)
        case .FeedEntrySource:                  break
        case .FeedEntrySourceID:                self.entries?.last?.source?.id                  = self.entries?.last?.source?.id?.appending(string) ?? string
        case .FeedEntrySourceTitle:             self.entries?.last?.source?.title               = self.entries?.last?.source?.title?.appending(string) ?? string
        case .FeedEntrySourceUpdated:           self.entries?.last?.source?.updated             = string.dateFromSpec(.rfc3999)
        case .FeedEntryRights:                  self.entries?.last?.rights                      = self.entries?.last?.rights?.appending(string) ?? string
        case .FeedEntryAuthor:                  break
        case .FeedEntryAuthorName:              self.entries?.last?.authors?.last?.name         = self.entries?.last?.authors?.last?.name?.appending(string) ?? string
        case .FeedEntryAuthorEmail:             self.entries?.last?.authors?.last?.email        = self.entries?.last?.authors?.last?.email?.appending(string) ?? string
        case .FeedEntryAuthorUri:               self.entries?.last?.authors?.last?.uri          = self.entries?.last?.authors?.last?.uri?.appending(string) ?? string
        case .FeedEntryContributor:             break
        case .FeedEntryContributorName:         self.entries?.last?.contributors?.last?.name    = self.entries?.last?.contributors?.last?.name?.appending(string) ?? string
        case .FeedEntryContributorEmail:        self.entries?.last?.contributors?.last?.email   = self.entries?.last?.contributors?.last?.email?.appending(string) ?? string
        case .FeedEntryContributorUri:          self.entries?.last?.contributors?.last?.uri     = self.entries?.last?.contributors?.last?.uri?.appending(string) ?? string
        }
        
    }
    
}
