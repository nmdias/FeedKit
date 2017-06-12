//
//  AtomFeed + Attributes Mapper.swift
//
//  Copyright (c) 2017 Nuno Manuel Dias
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
            
        case .feedSubtitle:
            
            if  self.subtitle == nil {
                self.subtitle = AtomFeedSubtitle(attributes: attributeDict)
            }
            
        case .feedLink:
            
            if  self.links == nil {
                self.links = []
            }
            
            self.links?.append(AtomFeedLink(attributes: attributeDict))
                        
        case .feedCategory:
            
            if  self.categories == nil {
                self.categories = []
            }
            
            self.categories?.append(AtomFeedCategory(attributes: attributeDict))
            
        case .feedAuthor:
            
            if  self.authors == nil {
                self.authors = []
            }
            
            self.authors?.append(AtomFeedAuthor())

        case .feedContributor:
            
            if  self.contributors == nil {
                self.contributors = []
            }
            
            self.contributors?.append(AtomFeedContributor())
            
        case .feedGenerator:
            
            if  self.generator == nil {
                self.generator = AtomFeedGenerator(attributes: attributeDict)
            }

        case .feedEntry:
            
            if  self.entries == nil {
                self.entries = []
            }
            
            self.entries?.append(AtomFeedEntry())
            
        case .feedEntrySummary:
            
            if  self.entries?.last?.summary == nil {
                self.entries?.last?.summary = AtomFeedEntrySummary(attributes: attributeDict)
            }
            
        case .feedEntryAuthor:
            
            if  self.entries?.last?.authors == nil {
                self.entries?.last?.authors = []
            }
            
            self.entries?.last?.authors?.append(AtomFeedEntryAuthor())
            
        case .feedEntryContributor:
            
            if  self.entries?.last?.contributors == nil {
                self.entries?.last?.contributors = []
            }
            
            self.entries?.last?.contributors?.append(AtomFeedEntryContributor())
            
        case .feedEntryLink:
            
            if  self.entries?.last?.links == nil {
                self.entries?.last?.links = []
            }
            
            self.entries?.last?.links?.append(AtomFeedEntryLink(attributes: attributeDict))
            
        case .feedEntryCategory:
            
            if  self.entries?.last?.categories == nil {
                self.entries?.last?.categories = []
            }
            
            self.entries?.last?.categories?.append(AtomFeedEntryCategory(attributes: attributeDict))
            
        case .feedEntryContent:
            
            if  self.entries?.last?.content == nil {
                self.entries?.last?.content = AtomFeedEntryContent(attributes: attributeDict)
            }
            
        case .feedEntrySource:
            
            if  self.entries?.last?.source == nil {
                self.entries?.last?.source = AtomFeedEntrySource()
            }

        default: break
            
        }
        
    }
    
}
