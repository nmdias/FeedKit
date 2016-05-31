//
//  AtomFeed + Attributes Mapper.swift
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
    
    func map(attributes attributeDict: [String : String], forPath path: AtomPath) {
        
        switch path {
            
        case .Feed: break
        case .FeedTitle: break
        case .FeedSubtitle:
            
            if  self.subtitle == nil {
                self.subtitle = AtomFeedSubtitle(attributes: attributeDict)
            }
            
        case .FeedLink:
            
            if  self.links == nil {
                self.links = []
            }
            
            self.links?.append(AtomFeedLink(attributes: attributeDict))
            
        case .FeedUpdated: break
            
        case .FeedCategory:
            
            if  self.categories == nil {
                self.categories = []
            }
            
            self.categories?.append(AtomFeedCategory(attributes: attributeDict))
            
        case .FeedAuthor:
            
            if  self.authors == nil {
                self.authors = []
            }
            
            self.authors?.append(AtomFeedAuthor())
            
        case .FeedAuthorName: break
        case .FeedAuthorEmail: break
        case .FeedAuthorUri: break
            
        case .FeedContributor:
            
            if  self.contributors == nil {
                self.contributors = []
            }
            
            self.contributors?.append(AtomFeedContributor())
            
        case .FeedContributorName: break
        case .FeedContributorEmail: break
        case .FeedContributorUri: break
        case .FeedID: break
        case .FeedGenerator:
            
            if  self.generator == nil {
                self.generator = AtomFeedGenerator(attributes: attributeDict)
            }
            
        case .FeedIcon: break
        case .FeedLogo: break
        case .FeedRights: break
        case .FeedEntry:
            
            if  self.entries == nil {
                self.entries = []
            }
            
            self.entries?.append(AtomFeedEntry())
            
        case .FeedEntryTitle: break
        case .FeedEntrySummary:
            
            if  self.entries?.last?.summary == nil {
                self.entries?.last?.summary = AtomFeedEntrySummary(attributes: attributeDict)
            }
            
        case .FeedEntryLink:
            
            if  self.entries?.last?.links == nil {
                self.entries?.last?.links = []
            }
            
            self.entries?.last?.links?.append(AtomFeedEntryLink(attributes: attributeDict))
            
        case .FeedEntryUpdated: break
            
        case .FeedEntryCategory:
            
            if  self.entries?.last?.categories == nil {
                self.entries?.last?.categories = []
            }
            
            self.entries?.last?.categories?.append(AtomFeedEntryCategory(attributes: attributeDict))
            
            
        case .FeedEntryID: break
        case .FeedEntryContent:
            
            if  self.entries?.last?.content == nil {
                self.entries?.last?.content = AtomFeedEntryContent(attributes: attributeDict)
            }
            
        case .FeedEntryPublished: break
        case .FeedEntrySource: break
        case .FeedEntryRights: break
            
        case .FeedEntryAuthor:
            
            if  self.entries?.last?.authors == nil {
                self.entries?.last?.authors = []
            }
            
            self.entries?.last?.authors?.append(AtomFeedEntryAuthor())
            
        case .FeedEntryAuthorName: break
        case .FeedEntryAuthorEmail: break
        case .FeedEntryAuthorUri: break
            
        case .FeedEntryContributor:
            
            if  self.entries?.last?.contributors == nil {
                self.entries?.last?.contributors = []
            }
            
            self.entries?.last?.contributors?.append(AtomFeedEntryContributor())
            
        case .FeedEntryContributorName: break
        case .FeedEntryContributorEmail: break
        case .FeedEntryContributorUri: break
            
        }
        
    }
    
}