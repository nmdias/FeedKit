//
//  RSSFeed + mapAttributes.swift
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

extension RSSFeed {

    /// Maps the attributes of the specified dictionary for a given `RSSPath`
    /// to the `RSSFeed` model,
    ///
    /// - Parameters:
    ///   - attributes: The attribute dictionary to map to the model.
    ///   - path: The path of feed's element.
    func map(_ attributes: [String : String], for path: RSSPath) {

        switch path {
            
        case .rssChannelItem:

            if  self.items == nil {
                self.items = []
            }

            self.items?.append(RSSFeedItem())

        case .rssChannelImage:

            if  self.image == nil {
                self.image = RSSFeedImage()
            }

        case .rssChannelSkipDays:

            if  self.skipDays == nil {
                self.skipDays = []
            }

        case .rssChannelSkipHours:

            if  self.skipHours == nil {
                self.skipHours = []
            }

        case .rssChannelTextInput:

            if  self.textInput == nil {
                self.textInput = RSSFeedTextInput()
            }

        case .rssChannelCategory:

            if  self.categories == nil {
                self.categories = []
            }

            self.categories?.append(RSSFeedCategory(attributes: attributes))

        case .rssChannelCloud:

            if  self.cloud == nil {
                self.cloud = RSSFeedCloud(attributes: attributes)
            }

        case .rssChannelItemCategory:

            if  self.items?.last?.categories == nil {
                self.items?.last?.categories = []
            }

            self.items?.last?.categories?.append(RSSFeedItemCategory(attributes: attributes))

        case .rssChannelItemEnclosure:

            if  self.items?.last?.enclosure == nil {
                self.items?.last?.enclosure = RSSFeedItemEnclosure(attributes: attributes)
            }

        case .rssChannelItemGUID:

            if  self.items?.last?.guid == nil {
                self.items?.last?.guid = RSSFeedItemGUID(attributes: attributes)
            }

        case .rssChannelItemSource:

            if  self.items?.last?.source == nil {
                self.items?.last?.source = RSSFeedItemSource(attributes: attributes)
            }

        case .rssChannelItemContentEncoded:

            if  self.items?.last?.content == nil {
                self.items?.last?.content = ContentNamespace()
            }


        case
        .rssChannelSyndicationUpdateBase,
        .rssChannelSyndicationUpdatePeriod,
        .rssChannelSyndicationUpdateFrequency:

            if  self.syndication == nil {
                self.syndication = SyndicationNamespace()
            }

        case
        .rssChannelDublinCoreTitle,
        .rssChannelDublinCoreCreator,
        .rssChannelDublinCoreSubject,
        .rssChannelDublinCoreDescription,
        .rssChannelDublinCorePublisher,
        .rssChannelDublinCoreContributor,
        .rssChannelDublinCoreDate,
        .rssChannelDublinCoreType,
        .rssChannelDublinCoreFormat,
        .rssChannelDublinCoreIdentifier,
        .rssChannelDublinCoreSource,
        .rssChannelDublinCoreLanguage,
        .rssChannelDublinCoreRelation,
        .rssChannelDublinCoreCoverage,
        .rssChannelDublinCoreRights:

            if  self.dublinCore == nil {
                self.dublinCore = DublinCoreNamespace()
            }

        case
        .rssChannelItemDublinCoreTitle,
        .rssChannelItemDublinCoreCreator,
        .rssChannelItemDublinCoreSubject,
        .rssChannelItemDublinCoreDescription,
        .rssChannelItemDublinCorePublisher,
        .rssChannelItemDublinCoreContributor,
        .rssChannelItemDublinCoreDate,
        .rssChannelItemDublinCoreType,
        .rssChannelItemDublinCoreFormat,
        .rssChannelItemDublinCoreIdentifier,
        .rssChannelItemDublinCoreSource,
        .rssChannelItemDublinCoreLanguage,
        .rssChannelItemDublinCoreRelation,
        .rssChannelItemDublinCoreCoverage,
        .rssChannelItemDublinCoreRights:

            if  self.items?.last?.dublinCore == nil {
                self.items?.last?.dublinCore = DublinCoreNamespace()
            }

        case
        .rssChannelItunesAuthor,
        .rssChannelItunesBlock,
        .rssChannelItunesCategory,
        .rssChannelItunesSubcategory,
        .rssChannelItunesImage,
        .rssChannelItunesExplicit,
        .rssChannelItunesComplete,
        .rssChannelItunesNewFeedURL,
        .rssChannelItunesOwner,
        .rssChannelItunesOwnerName,
        .rssChannelItunesOwnerEmail,
        .rssChannelItunesSubtitle,
        .rssChannelItunesSummary,
        .rssChannelItunesKeywords,
        .rssChannelItunesType:

            if  self.iTunes == nil {
                self.iTunes = ITunesNamespace()
            }

            switch path {
                
            case .rssChannelItunesCategory:
                
                if  self.iTunes?.iTunesCategories == nil {
                    self.iTunes?.iTunesCategories = []
                }
                
                self.iTunes?.iTunesCategories?.append(ITunesCategory(attributes: attributes))

            case .rssChannelItunesSubcategory:
                
                self.iTunes?.iTunesCategories?.last?.subcategory = ITunesSubCategory(attributes: attributes)

            case .rssChannelItunesImage:
                
                self.iTunes?.iTunesImage = ITunesImage(attributes: attributes)

            case .rssChannelItunesOwner:
                
                if  self.iTunes?.iTunesOwner == nil {
                    self.iTunes?.iTunesOwner = ITunesOwner()
                }
                
            default: break
                
            }

        case
        .rssChannelItemItunesAuthor,
        .rssChannelItemItunesBlock,
        .rssChannelItemItunesDuration,
        .rssChannelItemItunesImage,
        .rssChannelItemItunesExplicit,
        .rssChannelItemItunesIsClosedCaptioned,
        .rssChannelItemItunesOrder,
        .rssChannelItemItunesTitle,
        .rssChannelItemItunesSubtitle,
        .rssChannelItemItunesSummary,
        .rssChannelItemItunesKeywords:
            
            if  self.items?.last?.iTunes == nil {
                self.items?.last?.iTunes = ITunesNamespace()
            }

            switch path {
                
            case .rssChannelItemItunesImage:
                
                self.items?.last?.iTunes?.iTunesImage = ITunesImage(attributes: attributes)
                
            default: break
                
            }
            
            // MARK: Media
            
        case
        .rssChannelItemMediaThumbnail,
        .rssChannelItemMediaContent,
        .rssChannelItemMediaContentTitle,
        .rssChannelItemMediaContentDescription,
        .rssChannelItemMediaContentKeywords,
        .rssChannelItemMediaContentPlayer,
        .rssChannelItemMediaContentThumbnail,
        .rssChannelItemMediaContentCategory,
        .rssChannelItemMediaCommunity,
        .rssChannelItemMediaCommunityMediaStarRating,
        .rssChannelItemMediaCommunityMediaStatistics,
        .rssChannelItemMediaCommunityMediaTags,
        .rssChannelItemMediaComments,
        .rssChannelItemMediaCommentsMediaComment,
        .rssChannelItemMediaEmbed,
        .rssChannelItemMediaEmbedMediaParam,
        .rssChannelItemMediaResponses,
        .rssChannelItemMediaResponsesMediaResponse,
        .rssChannelItemMediaBackLinks,
        .rssChannelItemMediaBackLinksBackLink,
        .rssChannelItemMediaStatus,
        .rssChannelItemMediaPrice,
        .rssChannelItemMediaLicense,
        .rssChannelItemMediaSubTitle,
        .rssChannelItemMediaPeerLink,
        .rssChannelItemMediaLocation,
        .rssChannelItemMediaLocationPosition,
        .rssChannelItemMediaRestriction,
        .rssChannelItemMediaScenes,
        .rssChannelItemMediaScenesMediaScene,
        .rssChannelItemMediaGroup,
        .rssChannelItemMediaGroupMediaCategory,
        .rssChannelItemMediaGroupMediaCredit,
        .rssChannelItemMediaGroupMediaRating,
        .rssChannelItemMediaGroupMediaContent:
            
            if  self.items?.last?.media == nil {
                self.items?.last?.media = MediaNamespace()
            }
            
            switch path {
                
            case .rssChannelItemMediaThumbnail:
                
                if  self.items?.last?.media?.mediaThumbnails == nil {
                    self.items?.last?.media?.mediaThumbnails = []
                }
                
                self.items?.last?.media?.mediaThumbnails?.append(MediaThumbnail(attributes: attributes))
                
            case .rssChannelItemMediaContent:
                
                if  self.items?.last?.media?.mediaContents == nil {
                    self.items?.last?.media?.mediaContents = []
                }
                
                self.items?.last?.media?.mediaContents?.append(MediaContent(attributes: attributes))
                
            case .rssChannelItemMediaContentTitle:
                
                if  self.items?.last?.media?.mediaContents?.last?.mediaTitle == nil {
                    self.items?.last?.media?.mediaContents?.last?.mediaTitle = MediaTitle(attributes: attributes)
                }
                
            case .rssChannelItemMediaContentDescription:
                
                if  self.items?.last?.media?.mediaContents?.last?.mediaDescription == nil {
                    self.items?.last?.media?.mediaContents?.last?.mediaDescription = MediaDescription(attributes: attributes)
                }
                
            case .rssChannelItemMediaContentKeywords:
                
                if  self.items?.last?.media?.mediaContents?.last?.mediaKeywords == nil {
                    self.items?.last?.media?.mediaContents?.last?.mediaKeywords = []
                }
                
            case .rssChannelItemMediaContentCategory:
                
                if  self.items?.last?.media?.mediaContents?.last?.mediaCategory == nil {
                    self.items?.last?.media?.mediaContents?.last?.mediaCategory = MediaCategory(attributes: attributes)
                }
                
            case .rssChannelItemMediaContentPlayer:
                
                if  self.items?.last?.media?.mediaContents?.last?.mediaPlayer == nil {
                    self.items?.last?.media?.mediaContents?.last?.mediaPlayer = MediaPlayer(attributes: attributes)
                }
                
            case .rssChannelItemMediaContentThumbnail:
                
                if  self.items?.last?.media?.mediaContents?.last?.mediaThumbnails == nil {
                    self.items?.last?.media?.mediaContents?.last?.mediaThumbnails = []
                }
                
                self.items?.last?.media?.mediaContents?.last?.mediaThumbnails?.append(MediaThumbnail(attributes: attributes))
                
            case .rssChannelItemMediaCommunity:
                
                if  self.items?.last?.media?.mediaCommunity == nil {
                    self.items?.last?.media?.mediaCommunity = MediaCommunity()
                }
                
            case .rssChannelItemMediaCommunityMediaStarRating:
                
                if  self.items?.last?.media?.mediaCommunity?.mediaStarRating == nil {
                    self.items?.last?.media?.mediaCommunity?.mediaStarRating = MediaStarRating(attributes: attributes)
                }
                
            case .rssChannelItemMediaCommunityMediaStatistics:
                
                if  self.items?.last?.media?.mediaCommunity?.mediaStatistics == nil {
                    self.items?.last?.media?.mediaCommunity?.mediaStatistics = MediaStatistics(attributes: attributes)
                }
                
            case .rssChannelItemMediaCommunityMediaTags:
                
                if  self.items?.last?.media?.mediaCommunity?.mediaTags == nil {
                    self.items?.last?.media?.mediaCommunity?.mediaTags = []
                }
                
            case .rssChannelItemMediaComments:
                
                if  self.items?.last?.media?.mediaComments == nil {
                    self.items?.last?.media?.mediaComments = []
                }
                
            case .rssChannelItemMediaEmbed:
                
                if  self.items?.last?.media?.mediaEmbed == nil {
                    self.items?.last?.media?.mediaEmbed = MediaEmbed(attributes: attributes)
                }
                
            case .rssChannelItemMediaEmbedMediaParam:
                
                if  self.items?.last?.media?.mediaEmbed?.mediaParams == nil {
                    self.items?.last?.media?.mediaEmbed?.mediaParams = []
                }
                
                self.items?.last?.media?.mediaEmbed?.mediaParams?.append(MediaParam(attributes: attributes))
                
            case .rssChannelItemMediaResponses:
                
                if  self.items?.last?.media?.mediaResponses == nil {
                    self.items?.last?.media?.mediaResponses = []
                }
                
            case .rssChannelItemMediaBackLinks:
                
                if  self.items?.last?.media?.mediaBackLinks == nil {
                    self.items?.last?.media?.mediaBackLinks = []
                }
                
            case .rssChannelItemMediaStatus:
                
                if  self.items?.last?.media?.mediaStatus == nil {
                    self.items?.last?.media?.mediaStatus = MediaStatus(attributes: attributes)
                }
                
            case .rssChannelItemMediaPrice:
                
                if  self.items?.last?.media?.mediaPrices == nil {
                    self.items?.last?.media?.mediaPrices = []
                }
                
                self.items?.last?.media?.mediaPrices?.append(MediaPrice(attributes: attributes))
                
            case .rssChannelItemMediaLicense:
                
                if  self.items?.last?.media?.mediaLicense == nil {
                    self.items?.last?.media?.mediaLicense = MediaLicence(attributes: attributes)
                }
                
            case .rssChannelItemMediaSubTitle:
                
                if  self.items?.last?.media?.mediaSubTitle == nil {
                    self.items?.last?.media?.mediaSubTitle = MediaSubTitle(attributes: attributes)
                }
                
            case .rssChannelItemMediaPeerLink:
                
                if  self.items?.last?.media?.mediaPeerLink == nil {
                    self.items?.last?.media?.mediaPeerLink = MediaPeerLink(attributes: attributes)
                }
                
            case .rssChannelItemMediaLocation:
                
                if  self.items?.last?.media?.mediaLocation == nil {
                    self.items?.last?.media?.mediaLocation = MediaLocation(attributes: attributes)
                }
                
            case .rssChannelItemMediaRestriction:
                
                if  self.items?.last?.media?.mediaRestriction == nil {
                    self.items?.last?.media?.mediaRestriction = MediaRestriction(attributes: attributes)
                }
                
            case .rssChannelItemMediaScenes:
                
                if  self.items?.last?.media?.mediaScenes == nil {
                    self.items?.last?.media?.mediaScenes = []
                }
                
            case .rssChannelItemMediaScenesMediaScene:
                
                if  self.items?.last?.media?.mediaScenes == nil {
                    self.items?.last?.media?.mediaScenes = []
                }
                
                self.items?.last?.media?.mediaScenes?.append(MediaScene())
                
            case .rssChannelItemMediaGroup:
                
                if  self.items?.last?.media?.mediaGroup == nil {
                    self.items?.last?.media?.mediaGroup = MediaGroup()
                }
                
            case .rssChannelItemMediaGroupMediaCategory:
                
                if  self.items?.last?.media?.mediaGroup?.mediaCategory == nil {
                    self.items?.last?.media?.mediaGroup?.mediaCategory = MediaCategory(attributes: attributes)
                }
                
            case .rssChannelItemMediaGroupMediaCredit:
                
                if  self.items?.last?.media?.mediaGroup?.mediaCredits == nil {
                    self.items?.last?.media?.mediaGroup?.mediaCredits = []
                }
                
                self.items?.last?.media?.mediaGroup?.mediaCredits?.append(MediaCredit(attributes: attributes))
                
            case .rssChannelItemMediaGroupMediaRating:
                
                if  self.items?.last?.media?.mediaGroup?.mediaRating == nil {
                    self.items?.last?.media?.mediaGroup?.mediaRating = MediaRating(attributes: attributes)
                }
                
            case .rssChannelItemMediaGroupMediaContent:
                
                if  self.items?.last?.media?.mediaGroup?.mediaContents == nil {
                    self.items?.last?.media?.mediaGroup?.mediaContents = []
                }
                
                self.items?.last?.media?.mediaGroup?.mediaContents?.append(MediaContent(attributes: attributes))
                
            default: break
                
            }

            
        default: break
            
            
        }
        
        
    }
    
    /// Maps the attributes of the specified dictionary for a given `RSSPath`
    /// to the `RSSFeed` model,
    ///
    /// - Parameters:
    ///   - attributes: The attribute dictionary to map to the model.
    ///   - path: The path of feed's element.
    func map(_ attributes: [String : String], for path: RDFPath) {
    
        switch path {
        
        case .rdfItem:
            if  self.items == nil {
                self.items = []
            }
            
            self.items?.append(RSSFeedItem())
            
        case
        .rdfChannelSyndicationUpdateBase,
        .rdfChannelSyndicationUpdatePeriod,
        .rdfChannelSyndicationUpdateFrequency:
            
            if  self.syndication == nil {
                self.syndication = SyndicationNamespace()
            }
            
        case
        .rdfChannelDublinCoreTitle,
        .rdfChannelDublinCoreCreator,
        .rdfChannelDublinCoreSubject,
        .rdfChannelDublinCoreDescription,
        .rdfChannelDublinCorePublisher,
        .rdfChannelDublinCoreContributor,
        .rdfChannelDublinCoreDate,
        .rdfChannelDublinCoreType,
        .rdfChannelDublinCoreFormat,
        .rdfChannelDublinCoreIdentifier,
        .rdfChannelDublinCoreSource,
        .rdfChannelDublinCoreLanguage,
        .rdfChannelDublinCoreRelation,
        .rdfChannelDublinCoreCoverage,
        .rdfChannelDublinCoreRights:
            
            if  self.dublinCore == nil {
                self.dublinCore = DublinCoreNamespace()
            }
            
        case
        .rdfItemDublinCoreTitle,
        .rdfItemDublinCoreCreator,
        .rdfItemDublinCoreSubject,
        .rdfItemDublinCoreDescription,
        .rdfItemDublinCorePublisher,
        .rdfItemDublinCoreContributor,
        .rdfItemDublinCoreDate,
        .rdfItemDublinCoreType,
        .rdfItemDublinCoreFormat,
        .rdfItemDublinCoreIdentifier,
        .rdfItemDublinCoreSource,
        .rdfItemDublinCoreLanguage,
        .rdfItemDublinCoreRelation,
        .rdfItemDublinCoreCoverage,
        .rdfItemDublinCoreRights:
            
            if  self.items?.last?.dublinCore == nil {
                self.items?.last?.dublinCore = DublinCoreNamespace()
            }
            
        case .rdfItemContentEncoded:
            if  self.items?.last?.content == nil {
                self.items?.last?.content = ContentNamespace()
            }
            
        default: break
        }
        
    }
    
}
