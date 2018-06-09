//
//  AtomFeed + mapAttributes.swift
//
//  Copyright (c) 2016 - 2018 Nuno Manuel Dias
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

    /// Maps the attributes of the specified dictionary for a given `AtomPath`
    /// to the `AtomFeed` model
    ///
    /// - Parameters:
    ///   - attributes: The attribute dictionary to map to the model.
    ///   - path: The path of feed's element.
    func map(_ attributes: [String : String], for path: AtomPath) {
        
        switch path {
            
        case .feedSubtitle:
            
            if  self.subtitle == nil {
                self.subtitle = AtomFeedSubtitle(attributes: attributes)
            }
            
        case .feedLink:
            
            if  self.links == nil {
                self.links = []
            }
            
            self.links?.append(AtomFeedLink(attributes: attributes))
                        
        case .feedCategory:
            
            if  self.categories == nil {
                self.categories = []
            }
            
            self.categories?.append(AtomFeedCategory(attributes: attributes))
            
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
                self.generator = AtomFeedGenerator(attributes: attributes)
            }

        case .feedEntry:
            
            if  self.entries == nil {
                self.entries = []
            }
            
            self.entries?.append(AtomFeedEntry())
            
        case .feedEntrySummary:
            
            if  self.entries?.last?.summary == nil {
                self.entries?.last?.summary = AtomFeedEntrySummary(attributes: attributes)
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
            
            self.entries?.last?.links?.append(AtomFeedEntryLink(attributes: attributes))
            
        case .feedEntryCategory:
            
            if  self.entries?.last?.categories == nil {
                self.entries?.last?.categories = []
            }
            
            self.entries?.last?.categories?.append(AtomFeedEntryCategory(attributes: attributes))
            
        case .feedEntryContent:
            
            if  self.entries?.last?.content == nil {
                self.entries?.last?.content = AtomFeedEntryContent(attributes: attributes)
            }
            
        case .feedEntrySource:
            
            if  self.entries?.last?.source == nil {
                self.entries?.last?.source = AtomFeedEntrySource()
            }

            // MARK: Media
            
        case
        .feedEntryMediaThumbnail,
        .feedEntryMediaContent,
        .feedEntryMediaCommunity,
        .feedEntryMediaCommunityMediaStarRating,
        .feedEntryMediaCommunityMediaStatistics,
        .feedEntryMediaCommunityMediaTags,
        .feedEntryMediaComments,
        .feedEntryMediaCommentsMediaComment,
        .feedEntryMediaEmbed,
        .feedEntryMediaEmbedMediaParam,
        .feedEntryMediaResponses,
        .feedEntryMediaResponsesMediaResponse,
        .feedEntryMediaBackLinks,
        .feedEntryMediaBackLinksBackLink,
        .feedEntryMediaStatus,
        .feedEntryMediaPrice,
        .feedEntryMediaLicense,
        .feedEntryMediaSubTitle,
        .feedEntryMediaPeerLink,
        .feedEntryMediaLocation,
        .feedEntryMediaLocationPosition,
        .feedEntryMediaRestriction,
        .feedEntryMediaScenes,
        .feedEntryMediaScenesMediaScene,
        .feedEntryMediaGroup,
        .feedEntryMediaGroupMediaCategory,
        .feedEntryMediaGroupMediaCredit,
        .feedEntryMediaGroupMediaRating,
        .feedEntryMediaGroupMediaContent:
            
            if  self.entries?.last?.media == nil {
                self.entries?.last?.media = MediaNamespace()
            }
            
            switch path {
                
            case .feedEntryMediaThumbnail:
                
                if  self.entries?.last?.media?.mediaThumbnails == nil {
                    self.entries?.last?.media?.mediaThumbnails = []
                }
                
                self.entries?.last?.media?.mediaThumbnails?.append(MediaThumbnail(attributes: attributes))
                
            case .feedEntryMediaContent:
                
                if  self.entries?.last?.media?.mediaContents == nil {
                    self.entries?.last?.media?.mediaContents = []
                }
                
                self.entries?.last?.media?.mediaContents?.append(MediaContent(attributes: attributes))
                
            case .feedEntryMediaCommunity:
                
                if  self.entries?.last?.media?.mediaCommunity == nil {
                    self.entries?.last?.media?.mediaCommunity = MediaCommunity()
                }
                
            case .feedEntryMediaCommunityMediaStarRating:
                
                if  self.entries?.last?.media?.mediaCommunity?.mediaStarRating == nil {
                    self.entries?.last?.media?.mediaCommunity?.mediaStarRating = MediaStarRating(attributes: attributes)
                }
                
            case .feedEntryMediaCommunityMediaStatistics:
                
                if  self.entries?.last?.media?.mediaCommunity?.mediaStatistics == nil {
                    self.entries?.last?.media?.mediaCommunity?.mediaStatistics = MediaStatistics(attributes: attributes)
                }
                
            case .feedEntryMediaCommunityMediaTags:
                
                if  self.entries?.last?.media?.mediaCommunity?.mediaTags == nil {
                    self.entries?.last?.media?.mediaCommunity?.mediaTags = []
                }
                
            case .feedEntryMediaComments:
                
                if  self.entries?.last?.media?.mediaComments == nil {
                    self.entries?.last?.media?.mediaComments = []
                }
                
            case .feedEntryMediaEmbed:
                
                if  self.entries?.last?.media?.mediaEmbed == nil {
                    self.entries?.last?.media?.mediaEmbed = MediaEmbed(attributes: attributes)
                }
                
            case .feedEntryMediaEmbedMediaParam:
                
                if  self.entries?.last?.media?.mediaEmbed?.mediaParams == nil {
                    self.entries?.last?.media?.mediaEmbed?.mediaParams = []
                }
                
                self.entries?.last?.media?.mediaEmbed?.mediaParams?.append(MediaParam(attributes: attributes))
                
            case .feedEntryMediaResponses:
                
                if  self.entries?.last?.media?.mediaResponses == nil {
                    self.entries?.last?.media?.mediaResponses = []
                }
                
            case .feedEntryMediaBackLinks:
                
                if  self.entries?.last?.media?.mediaBackLinks == nil {
                    self.entries?.last?.media?.mediaBackLinks = []
                }
                
            case .feedEntryMediaStatus:
                
                if  self.entries?.last?.media?.mediaStatus == nil {
                    self.entries?.last?.media?.mediaStatus = MediaStatus(attributes: attributes)
                }
                
            case .feedEntryMediaPrice:
                
                if  self.entries?.last?.media?.mediaPrices == nil {
                    self.entries?.last?.media?.mediaPrices = []
                }
                
                self.entries?.last?.media?.mediaPrices?.append(MediaPrice(attributes: attributes))
                
            case .feedEntryMediaLicense:
                
                if  self.entries?.last?.media?.mediaLicense == nil {
                    self.entries?.last?.media?.mediaLicense = MediaLicence(attributes: attributes)
                }
                
            case .feedEntryMediaSubTitle:
                
                if  self.entries?.last?.media?.mediaSubTitle == nil {
                    self.entries?.last?.media?.mediaSubTitle = MediaSubTitle(attributes: attributes)
                }
                
            case .feedEntryMediaPeerLink:
                
                if  self.entries?.last?.media?.mediaPeerLink == nil {
                    self.entries?.last?.media?.mediaPeerLink = MediaPeerLink(attributes: attributes)
                }
                
            case .feedEntryMediaLocation:
                
                if  self.entries?.last?.media?.mediaLocation == nil {
                    self.entries?.last?.media?.mediaLocation = MediaLocation(attributes: attributes)
                }
                
            case .feedEntryMediaRestriction:
                
                if  self.entries?.last?.media?.mediaRestriction == nil {
                    self.entries?.last?.media?.mediaRestriction = MediaRestriction(attributes: attributes)
                }
                
            case .feedEntryMediaScenes:
                
                if  self.entries?.last?.media?.mediaScenes == nil {
                    self.entries?.last?.media?.mediaScenes = []
                }
                
            case .feedEntryMediaScenesMediaScene:
                
                if  self.entries?.last?.media?.mediaScenes == nil {
                    self.entries?.last?.media?.mediaScenes = []
                }
                
                self.entries?.last?.media?.mediaScenes?.append(MediaScene())
                
            case .feedEntryMediaGroup:
                
                if  self.entries?.last?.media?.mediaGroup == nil {
                    self.entries?.last?.media?.mediaGroup = MediaGroup()
                }
                
            case .feedEntryMediaGroupMediaCategory:
                
                if  self.entries?.last?.media?.mediaGroup?.mediaCategory == nil {
                    self.entries?.last?.media?.mediaGroup?.mediaCategory = MediaCategory(attributes: attributes)
                }
                
            case .feedEntryMediaGroupMediaCredit:
                
                if  self.entries?.last?.media?.mediaGroup?.mediaCredits == nil {
                    self.entries?.last?.media?.mediaGroup?.mediaCredits = []
                }
                
                self.entries?.last?.media?.mediaGroup?.mediaCredits?.append(MediaCredit(attributes: attributes))
                
            case .feedEntryMediaGroupMediaRating:
                
                if  self.entries?.last?.media?.mediaGroup?.mediaRating == nil {
                    self.entries?.last?.media?.mediaGroup?.mediaRating = MediaRating(attributes: attributes)
                }
                
            case .feedEntryMediaGroupMediaContent:
                
                if  self.entries?.last?.media?.mediaGroup?.mediaContents == nil {
                    self.entries?.last?.media?.mediaGroup?.mediaContents = []
                }
                
                self.entries?.last?.media?.mediaGroup?.mediaContents?.append(MediaContent(attributes: attributes))
            
            default: break
                
            }
            
        default: break
            
        }
        
    }
    
}
