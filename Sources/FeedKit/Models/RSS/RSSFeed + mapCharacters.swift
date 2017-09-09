//
//  RSSFeed + mapCharacters.swift
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

extension RSSFeed {
    
    /// Maps the characters in the specified string to the `RSSFeed` model.
    ///
    /// - Parameters:
    ///   - string: The string to map to the model.
    ///   - path: The path of feed's element.
    func map(_ string: String, for path: RSSPath) {
        
        switch path {
        case .rssChannelTitle:                                      self.title                                                      = self.title?.appending(string) ?? string
        case .rssChannelLink:                                       self.link                                                       = self.link?.appending(string) ?? string
        case .rssChannelDescription:                                self.description                                                = self.description?.appending(string) ?? string
        case .rssChannelLanguage:                                   self.language                                                   = self.language?.appending(string) ?? string
        case .rssChannelCopyright:                                  self.copyright                                                  = self.copyright?.appending(string) ?? string
        case .rssChannelManagingEditor:                             self.managingEditor                                             = self.managingEditor?.appending(string) ?? string
        case .rssChannelWebMaster:                                  self.webMaster                                                  = self.webMaster?.appending(string) ?? string
        case .rssChannelPubDate:                                    self.pubDate                                                    = string.toDate(from: .rfc822)
        case .rssChannelLastBuildDate:                              self.lastBuildDate                                              = string.toDate(from: .rfc822)
        case .rssChannelCategory:                                   self.categories?.last?.value                                    = self.categories?.last?.value?.appending(string) ?? string
        case .rssChannelGenerator:                                  self.generator                                                  = self.generator?.appending(string) ?? string
        case .rssChannelDocs:                                       self.docs                                                       = self.docs?.appending(string) ?? string
        case .rssChannelRating:                                     self.rating                                                     = self.rating?.appending(string) ?? string
        case .rssChannelTTL:                                        self.ttl                                                        = Int(string)
        case .rssChannelImageURL:                                   self.image?.url                                                 = self.image?.url?.appending(string) ?? string
        case .rssChannelImageTitle:                                 self.image?.title                                               = self.image?.title?.appending(string) ?? string
        case .rssChannelImageLink:                                  self.image?.link                                                = self.image?.link?.appending(string) ?? string
        case .rssChannelImageWidth:                                 self.image?.width                                               = Int(string)
        case .rssChannelImageHeight:                                self.image?.height                                              = Int(string)
        case .rssChannelImageDescription:                           self.image?.description                                         = self.image?.description?.appending(string) ?? string
        case .rssChannelTextInputTitle:                             self.textInput?.title                                           = self.textInput?.title?.appending(string) ?? string
        case .rssChannelTextInputDescription:                       self.textInput?.description                                     = self.textInput?.description?.appending(string) ?? string
        case .rssChannelTextInputName:                              self.textInput?.name                                            = self.textInput?.name?.appending(string) ?? string
        case .rssChannelTextInputLink:                              self.textInput?.link                                            = self.textInput?.link?.appending(string) ?? string
        case .rssChannelSkipHoursHour:
            if let hour = RSSFeedSkipHour(string), 0...23 ~= hour {
                self.skipHours?.append(hour)
            }
        case .rssChannelSkipDaysDay:
            if let day = RSSFeedSkipDay(rawValue: string) {
                self.skipDays?.append(day)
            }
        case .rssChannelItemTitle:                                  self.items?.last?.title                                         = self.items?.last?.title?.appending(string) ?? string
        case .rssChannelItemLink:                                   self.items?.last?.link                                          = self.items?.last?.link?.appending(string) ?? string
        case .rssChannelItemDescription:                            self.items?.last?.description                                   = self.items?.last?.description?.appending(string) ?? string
        case .rssChannelItemAuthor:                                 self.items?.last?.author                                        = self.items?.last?.author?.appending(string) ?? string
        case .rssChannelItemCategory:                               self.items?.last?.categories?.last?.value                       = self.items?.last?.categories?.last?.value?.appending(string) ?? string
        case .rssChannelItemComments:                               self.items?.last?.comments                                      = self.items?.last?.comments?.appending(string) ?? string
        case .rssChannelItemGUID:                                   self.items?.last?.guid?.value                                   = self.items?.last?.guid?.value?.appending(string) ?? string
        case .rssChannelItemPubDate:                                self.items?.last?.pubDate                                       = string.toDate(from: .rfc822)
        case .rssChannelItemSource:                                 self.items?.last?.source?.value                                 = self.items?.last?.source?.value?.appending(string) ?? string
        case .rssChannelItemContentEncoded:                         self.items?.last?.content?.contentEncoded                       = self.items?.last?.content?.contentEncoded?.appending(string) ?? string
        case .rssChannelSyndicationUpdatePeriod:                    self.syndication?.syUpdatePeriod                                = SyndicationUpdatePeriod(rawValue: string)
        case .rssChannelSyndicationUpdateFrequency:                 self.syndication?.syUpdateFrequency                             = Int(string)
        case .rssChannelSyndicationUpdateBase:                      self.syndication?.syUpdateBase                                  = string.toDate(from: .iso8601)
        case .rssChannelDublinCoreTitle:                            self.dublinCore?.dcTitle                                        = self.dublinCore?.dcTitle?.appending(string) ?? string
        case .rssChannelDublinCoreCreator:                          self.dublinCore?.dcCreator                                      = self.dublinCore?.dcCreator?.appending(string) ?? string
        case .rssChannelDublinCoreSubject:                          self.dublinCore?.dcSubject                                      = self.dublinCore?.dcSubject?.appending(string) ?? string
        case .rssChannelDublinCoreDescription:                      self.dublinCore?.dcDescription                                  = self.dublinCore?.dcDescription?.appending(string) ?? string
        case .rssChannelDublinCorePublisher:                        self.dublinCore?.dcPublisher                                    = self.dublinCore?.dcPublisher?.appending(string) ?? string
        case .rssChannelDublinCoreContributor:                      self.dublinCore?.dcContributor                                  = self.dublinCore?.dcContributor?.appending(string) ?? string
        case .rssChannelDublinCoreDate:                             self.dublinCore?.dcDate                                         = string.toDate(from: .iso8601)
        case .rssChannelDublinCoreType:                             self.dublinCore?.dcType                                         = self.dublinCore?.dcType?.appending(string) ?? string
        case .rssChannelDublinCoreFormat:                           self.dublinCore?.dcFormat                                       = self.dublinCore?.dcFormat?.appending(string) ?? string
        case .rssChannelDublinCoreIdentifier:                       self.dublinCore?.dcIdentifier                                   = self.dublinCore?.dcIdentifier?.appending(string) ?? string
        case .rssChannelDublinCoreSource:                           self.dublinCore?.dcSource                                       = self.dublinCore?.dcSource?.appending(string) ?? string
        case .rssChannelDublinCoreLanguage:                         self.dublinCore?.dcLanguage                                     = self.dublinCore?.dcLanguage?.appending(string) ?? string
        case .rssChannelDublinCoreRelation:                         self.dublinCore?.dcRelation                                     = self.dublinCore?.dcRelation?.appending(string) ?? string
        case .rssChannelDublinCoreCoverage:                         self.dublinCore?.dcCoverage                                     = self.dublinCore?.dcCoverage?.appending(string) ?? string
        case .rssChannelDublinCoreRights:                           self.dublinCore?.dcRights                                       = self.dublinCore?.dcRights?.appending(string) ?? string
        case .rssChannelItemDublinCoreTitle:                        self.items?.last?.dublinCore?.dcTitle                           = self.items?.last?.dublinCore?.dcTitle?.appending(string) ?? string
        case .rssChannelItemDublinCoreCreator:                      self.items?.last?.dublinCore?.dcCreator                         = self.items?.last?.dublinCore?.dcCreator?.appending(string) ?? string
        case .rssChannelItemDublinCoreSubject:                      self.items?.last?.dublinCore?.dcSubject                         = self.items?.last?.dublinCore?.dcSubject?.appending(string) ?? string
        case .rssChannelItemDublinCoreDescription:                  self.items?.last?.dublinCore?.dcDescription                     = self.items?.last?.dublinCore?.dcDescription?.appending(string) ?? string
        case .rssChannelItemDublinCorePublisher:                    self.items?.last?.dublinCore?.dcPublisher                       = self.items?.last?.dublinCore?.dcPublisher?.appending(string) ?? string
        case .rssChannelItemDublinCoreContributor:                  self.items?.last?.dublinCore?.dcContributor                     = self.items?.last?.dublinCore?.dcContributor?.appending(string) ?? string
        case .rssChannelItemDublinCoreDate:                         self.items?.last?.dublinCore?.dcDate                            = string.toDate(from: .iso8601)
        case .rssChannelItemDublinCoreType:                         self.items?.last?.dublinCore?.dcType                            = self.items?.last?.dublinCore?.dcType?.appending(string) ?? string
        case .rssChannelItemDublinCoreFormat:                       self.items?.last?.dublinCore?.dcFormat                          = self.items?.last?.dublinCore?.dcFormat?.appending(string) ?? string
        case .rssChannelItemDublinCoreIdentifier:                   self.items?.last?.dublinCore?.dcIdentifier                      = self.items?.last?.dublinCore?.dcIdentifier?.appending(string) ?? string
        case .rssChannelItemDublinCoreSource:                       self.items?.last?.dublinCore?.dcSource                          = self.items?.last?.dublinCore?.dcSource?.appending(string) ?? string
        case .rssChannelItemDublinCoreLanguage:                     self.items?.last?.dublinCore?.dcLanguage                        = self.items?.last?.dublinCore?.dcLanguage?.appending(string) ?? string
        case .rssChannelItemDublinCoreRelation:                     self.items?.last?.dublinCore?.dcRelation                        = self.items?.last?.dublinCore?.dcRelation?.appending(string) ?? string
        case .rssChannelItemDublinCoreCoverage:                     self.items?.last?.dublinCore?.dcCoverage                        = self.items?.last?.dublinCore?.dcCoverage?.appending(string) ?? string
        case .rssChannelItemDublinCoreRights:                       self.items?.last?.dublinCore?.dcRights                          = self.items?.last?.dublinCore?.dcRights?.appending(string) ?? string
        case .rssChannelItunesAuthor:                               self.iTunes?.iTunesAuthor                                       = self.iTunes?.iTunesAuthor?.appending(string) ?? string
        case .rssChannelItunesBlock:                                self.iTunes?.iTunesBlock                                        = self.iTunes?.iTunesBlock?.appending(string) ?? string
        case .rssChannelItunesExplicit:                             self.iTunes?.iTunesExplicit                                     = self.iTunes?.iTunesExplicit?.appending(string) ?? string
        case .rssChannelItunesComplete:                             self.iTunes?.iTunesComplete                                     = self.iTunes?.iTunesComplete?.appending(string) ?? string
        case .rssChannelItunesNewFeedURL:                           self.iTunes?.iTunesNewFeedURL                                   = self.iTunes?.iTunesNewFeedURL?.appending(string) ?? string
        case .rssChannelItunesOwnerName:                            self.iTunes?.iTunesOwner?.name                                  = self.iTunes?.iTunesOwner?.name?.appending(string) ?? string
        case .rssChannelItunesOwnerEmail:                           self.iTunes?.iTunesOwner?.email                                 = self.iTunes?.iTunesOwner?.email?.appending(string) ?? string
        case .rssChannelItunesSubtitle:                             self.iTunes?.iTunesSubtitle                                     = self.iTunes?.iTunesSubtitle?.appending(string) ?? string
        case .rssChannelItunesSummary:                              self.iTunes?.iTunesSummary                                      = self.iTunes?.iTunesSummary?.appending(string) ?? string
        case .rssChannelItunesKeywords:                             self.iTunes?.iTunesKeywords                                     = self.iTunes?.iTunesKeywords?.appending(string) ?? string
        case .rssChannelItemItunesAuthor:                           self.items?.last?.iTunes?.iTunesAuthor                          = self.items?.last?.iTunes?.iTunesAuthor?.appending(string) ?? string
        case .rssChannelItemItunesBlock:                            self.items?.last?.iTunes?.iTunesBlock                           = self.items?.last?.iTunes?.iTunesBlock?.appending(string) ?? string
        case .rssChannelItemItunesDuration:                         self.items?.last?.iTunes?.iTunesDuration                        = string.toDuration()
        case .rssChannelItemItunesExplicit:                         self.items?.last?.iTunes?.iTunesExplicit                        = self.items?.last?.iTunes?.iTunesExplicit?.appending(string) ?? string
        case .rssChannelItemItunesIsClosedCaptioned:                self.items?.last?.iTunes?.isClosedCaptioned                     = self.items?.last?.iTunes?.isClosedCaptioned?.appending(string) ?? string
        case .rssChannelItemItunesOrder:                            self.items?.last?.iTunes?.iTunesOrder                           = Int(string)
        case .rssChannelItemItunesSubtitle:                         self.items?.last?.iTunes?.iTunesSubtitle                        = self.items?.last?.iTunes?.iTunesSubtitle?.appending(string) ?? string
        case .rssChannelItemItunesSummary:                          self.items?.last?.iTunes?.iTunesSummary                         = self.items?.last?.iTunes?.iTunesSummary?.appending(string) ?? string
        case .rssChannelItemItunesKeywords:                         self.items?.last?.iTunes?.iTunesKeywords                        = self.items?.last?.iTunes?.iTunesKeywords?.appending(string) ?? string
        case .rssChannelItemMediaThumbnail:                         self.items?.last?.media?.mediaThumbnails?.last?.value           = self.items?.last?.media?.mediaThumbnails?.last?.value?.appending(string) ?? string
        case .rssChannelItemMediaLicense:                           self.items?.last?.media?.mediaLicense?.value                    = self.items?.last?.media?.mediaLicense?.value?.appending(string) ?? string
        case .rssChannelItemMediaRestriction:                       self.items?.last?.media?.mediaRestriction?.value                = self.items?.last?.media?.mediaRestriction?.value?.appending(string) ?? string
        case .rssChannelItemMediaCommunityMediaTags:                self.items?.last?.media?.mediaCommunity?.mediaTags              = MediaTag.tagsFrom(string: string)
        case .rssChannelItemMediaCommentsMediaComment:              self.items?.last?.media?.mediaComments?.append(string)
        case .rssChannelItemMediaEmbedMediaParam:                   self.items?.last?.media?.mediaEmbed?.mediaParams?.last?.value   = self.items?.last?.media?.mediaEmbed?.mediaParams?.last?.value?.appending(string) ?? string
        case .rssChannelItemMediaGroupMediaCredit:                  self.items?.last?.media?.mediaGroup?.mediaCredits?.last?.value  = self.items?.last?.media?.mediaGroup?.mediaCredits?.last?.value?.appending(string) ?? string
        case .rssChannelItemMediaGroupMediaCategory:                self.items?.last?.media?.mediaGroup?.mediaCategory?.value       = self.items?.last?.media?.mediaGroup?.mediaCategory?.value?.appending(string) ?? string
        case .rssChannelItemMediaGroupMediaRating:                  self.items?.last?.media?.mediaGroup?.mediaRating?.value         = self.items?.last?.media?.mediaGroup?.mediaRating?.value?.appending(string) ?? string
        case .rssChannelItemMediaResponsesMediaResponse:            self.items?.last?.media?.mediaResponses?.append(string)
        case .rssChannelItemMediaBackLinksBackLink:                 self.items?.last?.media?.mediaBackLinks?.append(string)
        case .rssChannelItemMediaLocationPosition:                  self.items?.last?.media?.mediaLocation?.mapFrom(latLng: string)
        case .rssChannelItemMediaScenesMediaSceneSceneTitle:        self.items?.last?.media?.mediaScenes?.last?.sceneTitle          = self.items?.last?.media?.mediaScenes?.last?.sceneTitle?.appending(string) ?? string
        case .rssChannelItemMediaScenesMediaSceneSceneDescription:  self.items?.last?.media?.mediaScenes?.last?.sceneDescription    = self.items?.last?.media?.mediaScenes?.last?.sceneDescription?.appending(string) ?? string
        case .rssChannelItemMediaScenesMediaSceneSceneStartTime:    self.items?.last?.media?.mediaScenes?.last?.sceneStartTime      = string.toDuration()
        case .rssChannelItemMediaScenesMediaSceneSceneEndTime:      self.items?.last?.media?.mediaScenes?.last?.sceneEndTime        = string.toDuration()
        default: break
        }
        
    }
    
    /// Maps the characters in the specified string to the `RSSFeed` model.
    ///
    /// - Parameters:
    ///   - string: The string to map to the model.
    ///   - path: The path of feed's element.
    func map(_ string: String, for path: RDFPath) {
        
        switch path {
        case .rdfChannelTitle:                                      self.title                                                      = self.title?.appending(string) ?? string
        case .rdfChannelLink:                                       self.link                                                       = self.link?.appending(string) ?? string
        case .rdfChannelDescription:                                self.description                                                = self.description?.appending(string) ?? string
        case .rdfChannelImage:                                      self.image?.url                                                 = self.image?.url?.appending(string) ?? string
        case .rdfItemTitle:                                         self.items?.last?.title                                         = self.items?.last?.title?.appending(string) ?? string
        case .rdfItemLink:                                          self.items?.last?.link                                          = self.items?.last?.link?.appending(string) ?? string
        case .rdfItemDescription:                                   self.items?.last?.description                                   = self.items?.last?.description?.appending(string) ?? string
        case .rdfChannelSyndicationUpdatePeriod:                    self.syndication?.syUpdatePeriod                                = SyndicationUpdatePeriod(rawValue: string)
        case .rdfChannelSyndicationUpdateFrequency:                 self.syndication?.syUpdateFrequency                             = Int(string)
        case .rdfChannelSyndicationUpdateBase:                      self.syndication?.syUpdateBase                                  = string.toDate(from: .iso8601)
        case .rdfChannelDublinCoreTitle:                            self.dublinCore?.dcTitle                                        = self.dublinCore?.dcTitle?.appending(string) ?? string
        case .rdfChannelDublinCoreCreator:                          self.dublinCore?.dcCreator                                      = self.dublinCore?.dcCreator?.appending(string) ?? string
        case .rdfChannelDublinCoreSubject:                          self.dublinCore?.dcSubject                                      = self.dublinCore?.dcSubject?.appending(string) ?? string
        case .rdfChannelDublinCoreDescription:                      self.dublinCore?.dcDescription                                  = self.dublinCore?.dcDescription?.appending(string) ?? string
        case .rdfChannelDublinCorePublisher:                        self.dublinCore?.dcPublisher                                    = self.dublinCore?.dcPublisher?.appending(string) ?? string
        case .rdfChannelDublinCoreContributor:                      self.dublinCore?.dcContributor                                  = self.dublinCore?.dcContributor?.appending(string) ?? string
        case .rdfChannelDublinCoreDate:                             self.dublinCore?.dcDate                                         = string.toDate(from: .iso8601)
        case .rdfChannelDublinCoreType:                             self.dublinCore?.dcType                                         = self.dublinCore?.dcType?.appending(string) ?? string
        case .rdfChannelDublinCoreFormat:                           self.dublinCore?.dcFormat                                       = self.dublinCore?.dcFormat?.appending(string) ?? string
        case .rdfChannelDublinCoreIdentifier:                       self.dublinCore?.dcIdentifier                                   = self.dublinCore?.dcIdentifier?.appending(string) ?? string
        case .rdfChannelDublinCoreSource:                           self.dublinCore?.dcSource                                       = self.dublinCore?.dcSource?.appending(string) ?? string
        case .rdfChannelDublinCoreLanguage:                         self.dublinCore?.dcLanguage                                     = self.dublinCore?.dcLanguage?.appending(string) ?? string
        case .rdfChannelDublinCoreRelation:                         self.dublinCore?.dcRelation                                     = self.dublinCore?.dcRelation?.appending(string) ?? string
        case .rdfChannelDublinCoreCoverage:                         self.dublinCore?.dcCoverage                                     = self.dublinCore?.dcCoverage?.appending(string) ?? string
        case .rdfChannelDublinCoreRights:                           self.dublinCore?.dcRights                                       = self.dublinCore?.dcRights?.appending(string) ?? string
        case .rdfItemDublinCoreTitle:                               self.items?.last?.dublinCore?.dcTitle                           = self.items?.last?.dublinCore?.dcTitle?.appending(string) ?? string
        case .rdfItemDublinCoreCreator:                             self.items?.last?.dublinCore?.dcCreator                         = self.items?.last?.dublinCore?.dcCreator?.appending(string) ?? string
        case .rdfItemDublinCoreSubject:                             self.items?.last?.dublinCore?.dcSubject                         = self.items?.last?.dublinCore?.dcSubject?.appending(string) ?? string
        case .rdfItemDublinCoreDescription:                         self.items?.last?.dublinCore?.dcDescription                     = self.items?.last?.dublinCore?.dcDescription?.appending(string) ?? string
        case .rdfItemDublinCorePublisher:                           self.items?.last?.dublinCore?.dcPublisher                       = self.items?.last?.dublinCore?.dcPublisher?.appending(string) ?? string
        case .rdfItemDublinCoreContributor:                         self.items?.last?.dublinCore?.dcContributor                     = self.items?.last?.dublinCore?.dcContributor?.appending(string) ?? string
        case .rdfItemDublinCoreDate:                                self.items?.last?.dublinCore?.dcDate                            = string.toDate(from: .iso8601)
        case .rdfItemDublinCoreType:                                self.items?.last?.dublinCore?.dcType                            = self.items?.last?.dublinCore?.dcType?.appending(string) ?? string
        case .rdfItemDublinCoreFormat:                              self.items?.last?.dublinCore?.dcFormat                          = self.items?.last?.dublinCore?.dcFormat?.appending(string) ?? string
        case .rdfItemDublinCoreIdentifier:                          self.items?.last?.dublinCore?.dcIdentifier                      = self.items?.last?.dublinCore?.dcIdentifier?.appending(string) ?? string
        case .rdfItemDublinCoreSource:                              self.items?.last?.dublinCore?.dcSource                          = self.items?.last?.dublinCore?.dcSource?.appending(string) ?? string
        case .rdfItemDublinCoreLanguage:                            self.items?.last?.dublinCore?.dcLanguage                        = self.items?.last?.dublinCore?.dcLanguage?.appending(string) ?? string
        case .rdfItemDublinCoreRelation:                            self.items?.last?.dublinCore?.dcRelation                        = self.items?.last?.dublinCore?.dcRelation?.appending(string) ?? string
        case .rdfItemDublinCoreCoverage:                            self.items?.last?.dublinCore?.dcCoverage                        = self.items?.last?.dublinCore?.dcCoverage?.appending(string) ?? string
        case .rdfItemDublinCoreRights:                              self.items?.last?.dublinCore?.dcRights                          = self.items?.last?.dublinCore?.dcRights?.appending(string) ?? string
        default: break
        }
        
    }
    
}
