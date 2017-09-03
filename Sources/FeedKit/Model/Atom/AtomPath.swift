//
//  AtomPath.swift
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

/// Describes the individual path for each XML DOM element of an Atom feed.
///
/// See https://tools.ietf.org/html/rfc4287
enum AtomPath: String {
    
    case feed                                              = "/feed"
    case feedTitle                                         = "/feed/title"
    case feedSubtitle                                      = "/feed/subtitle"
    case feedLink                                          = "/feed/link"
    case feedUpdated                                       = "/feed/updated"
    case feedCategory                                      = "/feed/category"
    case feedAuthor                                        = "/feed/author"
    case feedAuthorName                                    = "/feed/author/name"
    case feedAuthorEmail                                   = "/feed/author/email"
    case feedAuthorUri                                     = "/feed/author/uri"
    case feedContributor                                   = "/feed/contributor"
    case feedContributorName                               = "/feed/contributor/name"
    case feedContributorEmail                              = "/feed/contributor/email"
    case feedContributorUri                                = "/feed/contributor/uri"
    case feedID                                            = "/feed/id"
    case feedGenerator                                     = "/feed/generator"
    case feedIcon                                          = "/feed/icon"
    case feedLogo                                          = "/feed/logo"
    case feedRights                                        = "/feed/rights"
    case feedEntry                                         = "/feed/entry"
    case feedEntryTitle                                    = "/feed/entry/title"
    case feedEntrySummary                                  = "/feed/entry/summary"
    case feedEntryLink                                     = "/feed/entry/link"
    case feedEntryUpdated                                  = "/feed/entry/updated"
    case feedEntryCategory                                 = "/feed/entry/category"
    case feedEntryID                                       = "/feed/entry/id"
    case feedEntryContent                                  = "/feed/entry/content"
    case feedEntryPublished                                = "/feed/entry/published"
    case feedEntrySource                                   = "/feed/entry/source"
    case feedEntrySourceID                                 = "/feed/entry/source/id"
    case feedEntrySourceTitle                              = "/feed/entry/source/title"
    case feedEntrySourceUpdated                            = "/feed/entry/source/updated"
    case feedEntryRights                                   = "/feed/entry/rights"
    case feedEntryAuthor                                   = "/feed/entry/author"
    case feedEntryAuthorName                               = "/feed/entry/author/name"
    case feedEntryAuthorEmail                              = "/feed/entry/author/email"
    case feedEntryAuthorUri                                = "/feed/entry/author/uri"
    case feedEntryContributor                              = "/feed/entry/contributor"
    case feedEntryContributorName                          = "/feed/entry/contributor/name"
    case feedEntryContributorEmail                         = "/feed/entry/contributor/email"
    case feedEntryContributorUri                           = "/feed/entry/contributor/uri"
    
    // MARK: Media
    
    case feedEntryMediaThumbnail                           = "/feed/entry/media:thumbnail"
    case feedEntryMediaContent                             = "/feed/entry/media:content"
    case feedEntryMediaCommunity                           = "/feed/entry/media:community"
    case feedEntryMediaCommunityMediaStarRating            = "/feed/entry/media:community/media:starRating"
    case feedEntryMediaCommunityMediaStatistics            = "/feed/entry/media:community/media:statistics"
    case feedEntryMediaCommunityMediaTags                  = "/feed/entry/media:community/media:tags"
    case feedEntryMediaComments                            = "/feed/entry/media:comments"
    case feedEntryMediaCommentsMediaComment                = "/feed/entry/media:comments/media:comment"
    case feedEntryMediaEmbed                               = "/feed/entry/media:embed"
    case feedEntryMediaEmbedMediaParam                     = "/feed/entry/media:embed/media:param"
    case feedEntryMediaResponses                           = "/feed/entry/media:responses"
    case feedEntryMediaResponsesMediaResponse              = "/feed/entry/media:responses/media:response"
    case feedEntryMediaBackLinks                           = "/feed/entry/media:backLinks"
    case feedEntryMediaBackLinksBackLink                   = "/feed/entry/media:backLinks/media:backLink"
    case feedEntryMediaStatus                              = "/feed/entry/media:status"
    case feedEntryMediaPrice                               = "/feed/entry/media:price"
    case feedEntryMediaLicense                             = "/feed/entry/media:license"
    case feedEntryMediaSubTitle                            = "/feed/entry/media:subTitle"
    case feedEntryMediaPeerLink                            = "/feed/entry/media:peerLink"
    case feedEntryMediaLocation                            = "/feed/entry/media:location"
    case feedEntryMediaLocationPosition                    = "/feed/entry/media:location/georss:where/gml:Point/gml:pos"
    case feedEntryMediaRestriction                         = "/feed/entry/media:restriction"
    case feedEntryMediaScenes                              = "/feed/entry/media:scenes"
    case feedEntryMediaScenesMediaScene                    = "/feed/entry/media:scenes/media:scene"
    case feedEntryMediaScenesMediaSceneSceneTitle          = "/feed/entry/media:scenes/media:scene/sceneTitle"
    case feedEntryMediaScenesMediaSceneSceneDescription    = "/feed/entry/media:scenes/media:scene/sceneDescription"
    case feedEntryMediaScenesMediaSceneSceneStartTime      = "/feed/entry/media:scenes/media:scene/sceneStartTime"
    case feedEntryMediaScenesMediaSceneSceneEndTime        = "/feed/entry/media:scenes/media:scene/sceneEndTime"
    case feedEntryMediaGroup                               = "/feed/entry/media:group"
    case feedEntryMediaGroupMediaCredit                    = "/feed/entry/media:group/media:credit"
    case feedEntryMediaGroupMediaCategory                  = "/feed/entry/media:group/media:category"
    case feedEntryMediaGroupMediaRating                    = "/feed/entry/media:group/media:rating"
    case feedEntryMediaGroupMediaContent                   = "/feed/entry/media:group/media:content"
    
}
