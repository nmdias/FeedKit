//
//  RSSFeed + Attributes Mapper.swift
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

     Maps the attributes of the specified dictionary for a given `RSSPath`
     to the `RSSFeed` model

     - parameter attributeDict:     The attribute dictionary to map to the model
     - parameter path:              The path of feed's element

     */
    func map(attributes attributeDict: [String : String], forPath path: RSSPath) {

        switch path {
            
        case .RSSChannelItem:

            if  self.items == nil {
                self.items = []
            }

            self.items?.append(RSSFeedItem())

        case .RSSChannelImage:

            if  self.image == nil {
                self.image = RSSFeedImage()
            }

        case .RSSChannelSkipDays:

            if  self.skipDays == nil {
                self.skipDays = []
            }

        case .RSSChannelSkipHours:

            if  self.skipHours == nil {
                self.skipHours = []
            }

        case .RSSChannelTextInput:

            if  self.textInput == nil {
                self.textInput = RSSFeedTextInput()
            }

        case .RSSChannelCategory:

            if  self.categories == nil {
                self.categories = []
            }

            self.categories?.append(RSSFeedCategory(attributes: attributeDict))

        case .RSSChannelCloud:

            if  self.cloud == nil {
                self.cloud = RSSFeedCloud(attributes: attributeDict)
            }

        case .RSSChannelItemCategory:

            if  self.items?.last?.categories == nil {
                self.items?.last?.categories = []
            }

            self.items?.last?.categories?.append(RSSFeedItemCategory(attributes: attributeDict))

        case .RSSChannelItemEnclosure:

            if  self.items?.last?.enclosure == nil {
                self.items?.last?.enclosure = RSSFeedItemEnclosure(attributes: attributeDict)
            }

        case .RSSChannelItemGUID:

            if  self.items?.last?.guid == nil {
                self.items?.last?.guid = RSSFeedItemGUID(attributes: attributeDict)
            }

        case .RSSChannelItemSource:

            if  self.items?.last?.source == nil {
                self.items?.last?.source = RSSFeedItemSource(attributes: attributeDict)
            }

        case .RSSChannelItemContentEncoded:

            if  self.items?.last?.content == nil {
                self.items?.last?.content = ContentNamespace()
            }


        case
        .RSSChannelSyndicationUpdateBase,
        .RSSChannelSyndicationUpdatePeriod,
        .RSSChannelSyndicationUpdateFrequency:

            /// If the syndication variable has not been initialized yet, do it before assiging any values
            if  self.syndication == nil {
                self.syndication = SyndicationNamespace()
            }

        case
        .RSSChannelDublinCoreTitle,
        .RSSChannelDublinCoreCreator,
        .RSSChannelDublinCoreSubject,
        .RSSChannelDublinCoreDescription,
        .RSSChannelDublinCorePublisher,
        .RSSChannelDublinCoreContributor,
        .RSSChannelDublinCoreDate,
        .RSSChannelDublinCoreType,
        .RSSChannelDublinCoreFormat,
        .RSSChannelDublinCoreIdentifier,
        .RSSChannelDublinCoreSource,
        .RSSChannelDublinCoreLanguage,
        .RSSChannelDublinCoreRelation,
        .RSSChannelDublinCoreCoverage,
        .RSSChannelDublinCoreRights:

            if  self.dublinCore == nil {
                self.dublinCore = DublinCoreNamespace()
            }

        case
        .RSSChannelItemDublinCoreTitle,
        .RSSChannelItemDublinCoreCreator,
        .RSSChannelItemDublinCoreSubject,
        .RSSChannelItemDublinCoreDescription,
        .RSSChannelItemDublinCorePublisher,
        .RSSChannelItemDublinCoreContributor,
        .RSSChannelItemDublinCoreDate,
        .RSSChannelItemDublinCoreType,
        .RSSChannelItemDublinCoreFormat,
        .RSSChannelItemDublinCoreIdentifier,
        .RSSChannelItemDublinCoreSource,
        .RSSChannelItemDublinCoreLanguage,
        .RSSChannelItemDublinCoreRelation,
        .RSSChannelItemDublinCoreCoverage,
        .RSSChannelItemDublinCoreRights:

            /// If the dublin core variable has not been initialized yet, do it before assiging any values
            if  self.items?.last?.dublinCore == nil {
                self.items?.last?.dublinCore = DublinCoreNamespace()
            }

        case
        .RSSChannelItunesAuthor,
        .RSSChannelItunesBlock,
        .RSSChannelItunesCategory,
        .RSSChannelItunesSubcategory,
        .RSSChannelItunesImage,
        .RSSChannelItunesExplicit,
        .RSSChannelItunesComplete,
        .RSSChannelItunesNewFeedURL,
        .RSSChannelItunesOwner,
        .RSSChannelItunesOwnerName,
        .RSSChannelItunesOwnerEmail,
        .RSSChannelItunesSubtitle,
        .RSSChannelItunesSummary,
        .RSSChannelItunesKeywords:

            if self.iTunes == nil {
                self.iTunes = ITunesNamespace()
            }

            switch path {
            case .RSSChannelItunesCategory:
                if self.iTunes?.iTunesCategories == nil {
                    self.iTunes?.iTunesCategories = []
                }
                self.iTunes?.iTunesCategories?.append(ITunesCategory(attributes: attributeDict))

            case .RSSChannelItunesSubcategory:
                self.iTunes?.iTunesCategories?.last?.subcategory = attributeDict["text"]

            case .RSSChannelItunesImage:
                self.iTunes?.iTunesImage = attributeDict["href"]

            case .RSSChannelItunesOwner:
                if self.iTunes?.iTunesOwner == nil {
                    self.iTunes?.iTunesOwner = ITunesOwner()
                }
            default:
                break
            }

        case
        .RSSChannelItemItunesAuthor,
        .RSSChannelItemItunesBlock,
        .RSSChannelItemItunesDuration,
        .RSSChannelItemItunesImage,
        .RSSChannelItemItunesExplicit,
        .RSSChannelItemItunesIsClosedCaptioned,
        .RSSChannelItemItunesOrder,
        .RSSChannelItemItunesSubtitle,
        .RSSChannelItemItunesSummary,
        .RSSChannelItemItunesKeywords:
            
            if self.items?.last?.iTunes == nil {
                self.items?.last?.iTunes = ITunesNamespace()
            }

            switch path {
            case .RSSChannelItemItunesImage:
                self.items?.last?.iTunes?.iTunesImage = attributeDict["href"]
            default:
                break
            }
            
            // MARK: Media
            
        case
        .RSSChannelItemMediaThumbnail,
        .RSSChannelItemMediaContent,
        .RSSChannelItemMediaCommunity,
        .RSSChannelItemMediaCommunityMediaStarRating,
        .RSSChannelItemMediaCommunityMediaStatistics,
        .RSSChannelItemMediaCommunityMediaTags,
        .RSSChannelItemMediaComments,
        .RSSChannelItemMediaCommentsMediaComment,
        .RSSChannelItemMediaEmbed,
        .RSSChannelItemMediaEmbedMediaParam,
        .RSSChannelItemMediaResponses,
        .RSSChannelItemMediaResponsesMediaResponse,
        .RSSChannelItemMediaBackLinks,
        .RSSChannelItemMediaBackLinksBackLink,
        .RSSChannelItemMediaStatus,
        .RSSChannelItemMediaPrice,
        .RSSChannelItemMediaLicense,
        .RSSChannelItemMediaSubTitle,
        .RSSChannelItemMediaPeerLink,
        .RSSChannelItemMediaLocation,
        .RSSChannelItemMediaLocationPosition,
        .RSSChannelItemMediaRestriction,
        .RSSChannelItemMediaScenes,
        .RSSChannelItemMediaScenesMediaScene,
        
        .RSSChannelItemMediaGroup,
        .RSSChannelItemMediaGroupMediaCategory,
        .RSSChannelItemMediaGroupMediaCredit,
        .RSSChannelItemMediaGroupMediaRating,
        .RSSChannelItemMediaGroupMediaContent:
            
            if  self.items?.last?.media == nil {
                self.items?.last?.media = MediaNamespace()
            }
            
            switch path {
                
            case .RSSChannelItemMediaThumbnail:
                
                if  self.items?.last?.media?.mediaThumbnails == nil {
                    self.items?.last?.media?.mediaThumbnails = []
                }
                
                self.items?.last?.media?.mediaThumbnails?.append(MediaThumbnail(attributes: attributeDict))
                
            case .RSSChannelItemMediaContent:
                
                if  self.items?.last?.media?.mediaContents == nil {
                    self.items?.last?.media?.mediaContents = []
                }
                
                self.items?.last?.media?.mediaContents?.append(MediaContent(attributes: attributeDict))
                
            case .RSSChannelItemMediaCommunity:
                
                if  self.items?.last?.media?.mediaCommunity == nil {
                    self.items?.last?.media?.mediaCommunity = MediaCommunity()
                }
                
            case .RSSChannelItemMediaCommunityMediaStarRating:
                
                if  self.items?.last?.media?.mediaCommunity?.mediaStarRating == nil {
                    self.items?.last?.media?.mediaCommunity?.mediaStarRating = MediaStarRating(attributes: attributeDict)
                }
                
            case .RSSChannelItemMediaCommunityMediaStatistics:
                
                if  self.items?.last?.media?.mediaCommunity?.mediaStatistics == nil {
                    self.items?.last?.media?.mediaCommunity?.mediaStatistics = MediaStatistics(attributes: attributeDict)
                }
                
            case .RSSChannelItemMediaCommunityMediaTags:
                
                if  self.items?.last?.media?.mediaCommunity?.mediaTags == nil {
                    self.items?.last?.media?.mediaCommunity?.mediaTags = []
                }
                
            case .RSSChannelItemMediaComments:
                
                if  self.items?.last?.media?.mediaComments == nil {
                    self.items?.last?.media?.mediaComments = []
                }
                
            case .RSSChannelItemMediaEmbed:
                
                if  self.items?.last?.media?.mediaEmbed == nil {
                    self.items?.last?.media?.mediaEmbed = MediaEmbed(attributes: attributeDict)
                }
                
            case .RSSChannelItemMediaEmbedMediaParam:
                
                if  self.items?.last?.media?.mediaEmbed?.mediaParams == nil {
                    self.items?.last?.media?.mediaEmbed?.mediaParams = []
                }
                
                self.items?.last?.media?.mediaEmbed?.mediaParams?.append(MediaParam(attributes: attributeDict))
                
            case .RSSChannelItemMediaResponses:
                
                if  self.items?.last?.media?.mediaResponses == nil {
                    self.items?.last?.media?.mediaResponses = []
                }
                
            case .RSSChannelItemMediaBackLinks:
                
                if  self.items?.last?.media?.mediaBackLinks == nil {
                    self.items?.last?.media?.mediaBackLinks = []
                }
                
            case .RSSChannelItemMediaStatus:
                
                if  self.items?.last?.media?.mediaStatus == nil {
                    self.items?.last?.media?.mediaStatus = MediaStatus(attributes: attributeDict)
                }
                
            case .RSSChannelItemMediaPrice:
                
                if  self.items?.last?.media?.mediaPrices == nil {
                    self.items?.last?.media?.mediaPrices = []
                }
                
                self.items?.last?.media?.mediaPrices?.append(MediaPrice(attributes: attributeDict))
                
            case .RSSChannelItemMediaLicense:
                
                if  self.items?.last?.media?.mediaLicense == nil {
                    self.items?.last?.media?.mediaLicense = MediaLicence(attributes: attributeDict)
                }
                
            case .RSSChannelItemMediaSubTitle:
                
                if  self.items?.last?.media?.mediaSubTitle == nil {
                    self.items?.last?.media?.mediaSubTitle = MediaSubTitle(attributes: attributeDict)
                }
                
            case .RSSChannelItemMediaPeerLink:
                
                if  self.items?.last?.media?.mediaPeerLink == nil {
                    self.items?.last?.media?.mediaPeerLink = MediaPeerLink(attributes: attributeDict)
                }
                
            case .RSSChannelItemMediaLocation:
                
                if  self.items?.last?.media?.mediaLocation == nil {
                    self.items?.last?.media?.mediaLocation = MediaLocation(attributes: attributeDict)
                }
                
            case .RSSChannelItemMediaRestriction:
                
                if  self.items?.last?.media?.mediaRestriction == nil {
                    self.items?.last?.media?.mediaRestriction = MediaRestriction(attributes: attributeDict)
                }
                
            case .RSSChannelItemMediaScenes:
                
                if  self.items?.last?.media?.mediaScenes == nil {
                    self.items?.last?.media?.mediaScenes = []
                }
                
            case .RSSChannelItemMediaScenesMediaScene:
                
                if  self.items?.last?.media?.mediaScenes == nil {
                    self.items?.last?.media?.mediaScenes = []
                }
                
                self.items?.last?.media?.mediaScenes?.append(MediaScene())
                
            case .RSSChannelItemMediaGroup:
                
                if  self.items?.last?.media?.mediaGroup == nil {
                    self.items?.last?.media?.mediaGroup = MediaGroup()
                }
                
            case .RSSChannelItemMediaGroupMediaCategory:
                
                if  self.items?.last?.media?.mediaGroup?.mediaCategory == nil {
                    self.items?.last?.media?.mediaGroup?.mediaCategory = MediaCategory(attributes: attributeDict)
                }
                
            case .RSSChannelItemMediaGroupMediaCredit:
                
                if  self.items?.last?.media?.mediaGroup?.mediaCredits == nil {
                    self.items?.last?.media?.mediaGroup?.mediaCredits = []
                }
                
                self.items?.last?.media?.mediaGroup?.mediaCredits?.append(MediaCredit(attributes: attributeDict))
                
            case .RSSChannelItemMediaGroupMediaRating:
                
                if  self.items?.last?.media?.mediaGroup?.mediaRating == nil {
                    self.items?.last?.media?.mediaGroup?.mediaRating = MediaRating(attributes: attributeDict)
                }
                
            case .RSSChannelItemMediaGroupMediaContent:
                
                if  self.items?.last?.media?.mediaGroup?.mediaContents == nil {
                    self.items?.last?.media?.mediaGroup?.mediaContents = []
                }
                
                self.items?.last?.media?.mediaGroup?.mediaContents?.append(MediaContent(attributes: attributeDict))
                
            default: break
                
            }

            
        default: break
            
            
        }
        
        
    }
    
    
}
