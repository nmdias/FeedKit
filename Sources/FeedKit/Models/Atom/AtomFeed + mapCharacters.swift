//
//  AtomFeed + mapCharacters.swift
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

    /// Maps the characters in the specified string to the `AtomFeed` model.
    ///
    /// - Parameters:
    ///   - string: The string to map to the model.
    ///   - path: The path of feed's element.
    func map(_ string: String, for path: AtomPath) {
        switch path {
        case .feedTitle:                                       self.title                                                        = self.title?.appending(string) ?? string
        case .feedSubtitle:                                    self.subtitle?.value                                              = self.subtitle?.value?.appending(string) ?? string
        case .feedUpdated:                                     self.updated                                                      = string.toDate(from: .rfc3999)
        case .feedAuthorName:                                  self.authors?.last?.name                                          = self.authors?.last?.name?.appending(string) ?? string
        case .feedAuthorEmail:                                 self.authors?.last?.email                                         = self.authors?.last?.email?.appending(string) ?? string
        case .feedAuthorUri:                                   self.authors?.last?.uri                                           = self.authors?.last?.uri?.appending(string) ?? string
        case .feedContributorName:                             self.contributors?.last?.name                                     = self.contributors?.last?.name?.appending(string) ?? string
        case .feedContributorEmail:                            self.contributors?.last?.email                                    = self.contributors?.last?.email?.appending(string) ?? string
        case .feedContributorUri:                              self.contributors?.last?.uri                                      = self.contributors?.last?.uri?.appending(string) ?? string
        case .feedID:                                          self.id                                                           = self.id?.appending(string) ?? string
        case .feedGenerator:                                   self.generator?.value                                             = self.generator?.value?.appending(string) ?? string
        case .feedIcon:                                        self.icon                                                         = self.icon?.appending(string) ?? string
        case .feedLogo:                                        self.logo                                                         = self.logo?.appending(string) ?? string
        case .feedRights:                                      self.rights                                                       = self.rights?.appending(string) ?? string
        case .feedEntryTitle:                                  self.entries?.last?.title                                         = self.entries?.last?.title?.appending(string) ?? string
        case .feedEntrySummary:                                self.entries?.last?.summary?.value                                = self.entries?.last?.summary?.value?.appending(string) ?? string
        case .feedEntryUpdated:                                self.entries?.last?.updated                                       = string.toDate(from: .rfc3999)
        case .feedEntryID:                                     self.entries?.last?.id                                            = self.entries?.last?.id?.appending(string) ?? string
        case .feedEntryContent:                                self.entries?.last?.content?.value                                = self.entries?.last?.content?.value?.appending(string) ?? string
        case .feedEntryPublished:                              self.entries?.last?.published                                     = string.toDate(from: .rfc3999)
        case .feedEntrySourceID:                               self.entries?.last?.source?.id                                    = self.entries?.last?.source?.id?.appending(string) ?? string
        case .feedEntrySourceTitle:                            self.entries?.last?.source?.title                                 = self.entries?.last?.source?.title?.appending(string) ?? string
        case .feedEntrySourceUpdated:                          self.entries?.last?.source?.updated                               = string.toDate(from: .rfc3999)
        case .feedEntryRights:                                 self.entries?.last?.rights                                        = self.entries?.last?.rights?.appending(string) ?? string
        case .feedEntryAuthorName:                             self.entries?.last?.authors?.last?.name                           = self.entries?.last?.authors?.last?.name?.appending(string) ?? string
        case .feedEntryAuthorEmail:                            self.entries?.last?.authors?.last?.email                          = self.entries?.last?.authors?.last?.email?.appending(string) ?? string
        case .feedEntryAuthorUri:                              self.entries?.last?.authors?.last?.uri                            = self.entries?.last?.authors?.last?.uri?.appending(string) ?? string
        case .feedEntryContributorName:                        self.entries?.last?.contributors?.last?.name                      = self.entries?.last?.contributors?.last?.name?.appending(string) ?? string
        case .feedEntryContributorEmail:                       self.entries?.last?.contributors?.last?.email                     = self.entries?.last?.contributors?.last?.email?.appending(string) ?? string
        case .feedEntryContributorUri:                         self.entries?.last?.contributors?.last?.uri                       = self.entries?.last?.contributors?.last?.uri?.appending(string) ?? string
        case .feedEntryMediaThumbnail:                         self.entries?.last?.media?.mediaThumbnails?.last?.value           = self.entries?.last?.media?.mediaThumbnails?.last?.value?.appending(string) ?? string
        case .feedEntryMediaLicense:                           self.entries?.last?.media?.mediaLicense?.value                    = self.entries?.last?.media?.mediaLicense?.value?.appending(string) ?? string
        case .feedEntryMediaRestriction:                       self.entries?.last?.media?.mediaRestriction?.value                = self.entries?.last?.media?.mediaRestriction?.value?.appending(string) ?? string
        case .feedEntryMediaCommunityMediaTags:                self.entries?.last?.media?.mediaCommunity?.mediaTags              = MediaTag.tagsFrom(string: string)
        case .feedEntryMediaCommentsMediaComment:              self.entries?.last?.media?.mediaComments?.append(string)
        case .feedEntryMediaEmbedMediaParam:                   self.entries?.last?.media?.mediaEmbed?.mediaParams?.last?.value   = self.entries?.last?.media?.mediaEmbed?.mediaParams?.last?.value?.appending(string) ?? string
        case .feedEntryMediaGroupMediaCredit:                  self.entries?.last?.media?.mediaGroup?.mediaCredits?.last?.value  = self.entries?.last?.media?.mediaGroup?.mediaCredits?.last?.value?.appending(string) ?? string
        case .feedEntryMediaGroupMediaCategory:                self.entries?.last?.media?.mediaGroup?.mediaCategory?.value       = self.entries?.last?.media?.mediaGroup?.mediaCategory?.value?.appending(string) ?? string
        case .feedEntryMediaGroupMediaRating:                  self.entries?.last?.media?.mediaGroup?.mediaRating?.value         = self.entries?.last?.media?.mediaGroup?.mediaRating?.value?.appending(string) ?? string
        case .feedEntryMediaResponsesMediaResponse:            self.entries?.last?.media?.mediaResponses?.append(string)
        case .feedEntryMediaBackLinksBackLink:                 self.entries?.last?.media?.mediaBackLinks?.append(string)
        case .feedEntryMediaLocationPosition:                  self.entries?.last?.media?.mediaLocation?.mapFrom(latLng: string)
        case .feedEntryMediaScenesMediaSceneSceneTitle:        self.entries?.last?.media?.mediaScenes?.last?.sceneTitle          = self.entries?.last?.media?.mediaScenes?.last?.sceneTitle?.appending(string) ?? string
        case .feedEntryMediaScenesMediaSceneSceneDescription:  self.entries?.last?.media?.mediaScenes?.last?.sceneDescription    = self.entries?.last?.media?.mediaScenes?.last?.sceneDescription?.appending(string) ?? string
        case .feedEntryMediaScenesMediaSceneSceneStartTime:    self.entries?.last?.media?.mediaScenes?.last?.sceneStartTime      = string.toDuration()
        case .feedEntryMediaScenesMediaSceneSceneEndTime:      self.entries?.last?.media?.mediaScenes?.last?.sceneEndTime        = string.toDuration()
        default: break
        }
    }
    
}
