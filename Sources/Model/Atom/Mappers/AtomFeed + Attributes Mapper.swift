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
    
    /**
     
     Maps the attributes of the specified dictionary for a given `AtomPath` 
     to the `AtomFeed` model
     
     - parameter attributeDict:     The attribute dictionary to map to the model
     - parameter path:              The path of feed's element
     
     */
    func map(attributes attributeDict: [String : String], forPath path: AtomPath) {
        
        switch path {
            
        case .FeedSubtitle:
            
            if  self.subtitle == nil {
                self.subtitle = AtomFeedSubtitle(attributes: attributeDict)
            }
            
        case .FeedLink:
            
            if  self.links == nil {
                self.links = []
            }
            
            self.links?.append(AtomFeedLink(attributes: attributeDict))
                        
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

        case .FeedContributor:
            
            if  self.contributors == nil {
                self.contributors = []
            }
            
            self.contributors?.append(AtomFeedContributor())
            
        case .FeedGenerator:
            
            if  self.generator == nil {
                self.generator = AtomFeedGenerator(attributes: attributeDict)
            }

        case .FeedEntry:
            
            if  self.entries == nil {
                self.entries = []
            }
            
            self.entries?.append(AtomFeedEntry())
            
        case .FeedEntrySummary:
            
            if  self.entries?.last?.summary == nil {
                self.entries?.last?.summary = AtomFeedEntrySummary(attributes: attributeDict)
            }
            
        case .FeedEntryAuthor:
            
            if  self.entries?.last?.authors == nil {
                self.entries?.last?.authors = []
            }
            
            self.entries?.last?.authors?.append(AtomFeedEntryAuthor())
            
        case .FeedEntryContributor:
            
            if  self.entries?.last?.contributors == nil {
                self.entries?.last?.contributors = []
            }
            
            self.entries?.last?.contributors?.append(AtomFeedEntryContributor())
            
        case .FeedEntryLink:
            
            if  self.entries?.last?.links == nil {
                self.entries?.last?.links = []
            }
            
            self.entries?.last?.links?.append(AtomFeedEntryLink(attributes: attributeDict))
            
        case .FeedEntryCategory:
            
            if  self.entries?.last?.categories == nil {
                self.entries?.last?.categories = []
            }
            
            self.entries?.last?.categories?.append(AtomFeedEntryCategory(attributes: attributeDict))
            
        case .FeedEntryContent:
            
            if  self.entries?.last?.content == nil {
                self.entries?.last?.content = AtomFeedEntryContent(attributes: attributeDict)
            }
            
        case .FeedEntrySource:
            
            if  self.entries?.last?.source == nil {
                self.entries?.last?.source = AtomFeedEntrySource()
            }

        default: break
            
        }
        
    }
    
}