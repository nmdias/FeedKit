//
//  AtomPath.swift
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

/**
 
 Describes the individual path for each XML DOM element of an Atom feed
 
 See https://tools.ietf.org/html/rfc4287
 
 */
enum AtomPath: String {
    
    case Feed                           = "/feed"
    case FeedTitle                      = "/feed/title"
    case FeedSubtitle                   = "/feed/subtitle"
    case FeedLink                       = "/feed/link"
    case FeedUpdated                    = "/feed/updated"
    case FeedCategory                   = "/feed/category"
    case FeedAuthor                     = "/feed/author"
    case FeedAuthorName                 = "/feed/author/name"
    case FeedAuthorEmail                = "/feed/author/email"
    case FeedAuthorUri                  = "/feed/author/uri"
    case FeedContributor                = "/feed/contributor"
    case FeedContributorName            = "/feed/contributor/name"
    case FeedContributorEmail           = "/feed/contributor/email"
    case FeedContributorUri             = "/feed/contributor/uri"
    case FeedID                         = "/feed/id"
    case FeedGenerator                  = "/feed/generator"
    case FeedIcon                       = "/feed/icon"
    case FeedLogo                       = "/feed/logo"
    case FeedRights                     = "/feed/rights"
    case FeedEntry                      = "/feed/entry"
    case FeedEntryTitle                 = "/feed/entry/title"
    case FeedEntrySummary               = "/feed/entry/summary"
    case FeedEntryLink                  = "/feed/entry/link"
    case FeedEntryUpdated               = "/feed/entry/updated"
    case FeedEntryCategory              = "/feed/entry/category"
    case FeedEntryID                    = "/feed/entry/id"
    case FeedEntryContent               = "/feed/entry/content"
    case FeedEntryPublished             = "/feed/entry/published"
    case FeedEntrySource                = "/feed/entry/source"
    case FeedEntrySourceID              = "/feed/entry/source/id"
    case FeedEntrySourceTitle           = "/feed/entry/source/title"
    case FeedEntrySourceUpdated         = "/feed/entry/source/updated"
    case FeedEntryRights                = "/feed/entry/rights"
    case FeedEntryAuthor                = "/feed/entry/author"
    case FeedEntryAuthorName            = "/feed/entry/author/name"
    case FeedEntryAuthorEmail           = "/feed/entry/author/email"
    case FeedEntryAuthorUri             = "/feed/entry/author/uri"
    case FeedEntryContributor           = "/feed/entry/contributor"
    case FeedEntryContributorName       = "/feed/entry/contributor/name"
    case FeedEntryContributorEmail      = "/feed/entry/contributor/email"
    case FeedEntryContributorUri        = "/feed/entry/contributor/uri"
    
}
