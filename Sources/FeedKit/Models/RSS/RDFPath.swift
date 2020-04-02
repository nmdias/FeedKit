//
//  RDFPath.swift
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

/// Describes the individual path for each XML DOM element of an RDF feed
///
/// See http://www.rssboard.org/rss-0-9-0
enum RDFPath: String {
    
    case rdf                                            = "/rdf:RDF"
    case rdfChannel                                     = "/rdf:RDF/channel"
    case rdfChannelTitle                                = "/rdf:RDF/channel/title"
    case rdfChannelLink                                 = "/rdf:RDF/channel/link"
    case rdfChannelDescription                          = "/rdf:RDF/channel/description"
    case rdfChannelImage                                = "/rdf:RDF/channel/image"
    case rdfChannelItems                                = "/rdf:RDF/channel/items"
    case rdfChannelItemsRdfSeq                          = "/rdf:RDF/channel/items/rdf:Seq"
    case rdfChannelItemsRdfSeqRdfLi                     = "/rdf:RDF/channel/items/rdf:Seq/rdf:li"
    case rdfImage                                       = "/rdf:RDF/image"
    case rdfImageTitle                                  = "/rdf:RDF/image/title"
    case rdfImageURL                                    = "/rdf:RDF/image/url"
    case rdfImageLink                                   = "/rdf:RDF/image/link"
    case rdfItem                                        = "/rdf:RDF/item"
    case rdfItemTitle                                   = "/rdf:RDF/item/title"
    case rdfItemLink                                    = "/rdf:RDF/item/link"
    case rdfItemDescription                             = "/rdf:RDF/item/description"
    
    // Syndication
    
    case rdfChannelSyndicationUpdatePeriod              = "/rdf:RDF/channel/sy:updatePeriod"
    case rdfChannelSyndicationUpdateFrequency           = "/rdf:RDF/channel/sy:updateFrequency"
    case rdfChannelSyndicationUpdateBase                = "/rdf:RDF/channel/sy:updateBase"
    
    // Dublin Core
    
    case rdfChannelDublinCoreTitle                      = "/rdf:RDF/channel/dc:title"
    case rdfChannelDublinCoreCreator                    = "/rdf:RDF/channel/dc:creator"
    case rdfChannelDublinCoreSubject                    = "/rdf:RDF/channel/dc:subject"
    case rdfChannelDublinCoreDescription                = "/rdf:RDF/channel/dc:description"
    case rdfChannelDublinCorePublisher                  = "/rdf:RDF/channel/dc:publisher"
    case rdfChannelDublinCoreContributor                = "/rdf:RDF/channel/dc:contributor"
    case rdfChannelDublinCoreDate                       = "/rdf:RDF/channel/dc:date"
    case rdfChannelDublinCoreType                       = "/rdf:RDF/channel/dc:type"
    case rdfChannelDublinCoreFormat                     = "/rdf:RDF/channel/dc:format"
    case rdfChannelDublinCoreIdentifier                 = "/rdf:RDF/channel/dc:identifier"
    case rdfChannelDublinCoreSource                     = "/rdf:RDF/channel/dc:source"
    case rdfChannelDublinCoreLanguage                   = "/rdf:RDF/channel/dc:language"
    case rdfChannelDublinCoreRelation                   = "/rdf:RDF/channel/dc:relation"
    case rdfChannelDublinCoreCoverage                   = "/rdf:RDF/channel/dc:coverage"
    case rdfChannelDublinCoreRights                     = "/rdf:RDF/channel/dc:rights"
    case rdfItemDublinCoreTitle                         = "/rdf:RDF/item/dc:title"
    case rdfItemDublinCoreCreator                       = "/rdf:RDF/item/dc:creator"
    case rdfItemDublinCoreSubject                       = "/rdf:RDF/item/dc:subject"
    case rdfItemDublinCoreDescription                   = "/rdf:RDF/item/dc:description"
    case rdfItemDublinCorePublisher                     = "/rdf:RDF/item/dc:publisher"
    case rdfItemDublinCoreContributor                   = "/rdf:RDF/item/dc:contributor"
    case rdfItemDublinCoreDate                          = "/rdf:RDF/item/dc:date"
    case rdfItemDublinCoreType                          = "/rdf:RDF/item/dc:type"
    case rdfItemDublinCoreFormat                        = "/rdf:RDF/item/dc:format"
    case rdfItemDublinCoreIdentifier                    = "/rdf:RDF/item/dc:identifier"
    case rdfItemDublinCoreSource                        = "/rdf:RDF/item/dc:source"
    case rdfItemDublinCoreLanguage                      = "/rdf:RDF/item/dc:language"
    case rdfItemDublinCoreRelation                      = "/rdf:RDF/item/dc:relation"
    case rdfItemDublinCoreCoverage                      = "/rdf:RDF/item/dc:coverage"
    case rdfItemDublinCoreRights                        = "/rdf:RDF/item/dc:rights"
    
    // Content
    case rdfItemContentEncoded                          = "/rdf:RDF/item/content:encoded"
}
