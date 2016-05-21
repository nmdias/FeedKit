//
//  DublinCore.swift
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
 
    The Dublin Core namespace supports the Dublin Core Metadata Initiative, a 
    standard for describing resources on the Internet to identify their author, 
    date of publication, publisher and similar information.
 
    See: http://www.rssboard.org/rss-profile#namespace-elements-dublin
 
*/
protocol DublinCoreProtocol {
    
    /// A name given to the resource.
    var dcTitle: String? { get set }
    
    /// An entity primarily responsible for making the content of the resource.
    var dcCreator: String? { get set }
    
    /// The topic of the content of the resource.
    var dcSubject: String? { get set }
    
    /// An account of the content of the resource.
    var dcDescription: String? { get set }
    
    /// An entity responsible for making the resource available.
    var dcPublisher: String? { get set }
    
    /// An entity responsible for making contributions to the content of the resource.
    var dcContributor: String? { get set }
    
    /// A date associated with an event in the life cycle of the resource.
    var dcDate: String? { get set }
    
    /// The nature or genre of the content of the resource.
    var dcType: String? { get set }
    
    /// The physical or digital manifestation of the resource.
    var dcFormat: String? { get set }
    
    /// An unambiguous reference to the resource within a given context.
    var dcIdentifier: String? { get set }
    
    /// A Reference to a resource from which the present resource is derived.
    var dcSource: String? { get set }
    
    /// A language of the intellectual content of the resource.
    var dcLanguage: String? { get set }
    
    /// A reference to a related resource.
    var dcRelation: String? { get set }
    
    /// The extent or scope of the content of the resource.
    var dcCoverage: String? { get set }
    
    /// Information about rights held in and over the resource.
    var dcRights: String? { get set }
    
}

// http://web.resource.org/rss/1.0/modules/dc/

public enum DublinCoreElement: String {
    
    public static let namespace = [ "xmlns:dc" : "http://purl.org/dc/elements/1.1/" ]
    
    case RSSChannelTitle          		= "/rss/channel/dc:title"
    case RSSChannelCreator        		= "/rss/channel/dc:creator"
    case RSSChannelSubject        		= "/rss/channel/dc:subject"
    case RSSChannelDescription    		= "/rss/channel/dc:description"
    case RSSChannelPublisher      		= "/rss/channel/dc:publisher"
    case RSSChannelContributor    		= "/rss/channel/dc:contributor"
    case RSSChannelDate           		= "/rss/channel/dc:date"
    case RSSChannelType           		= "/rss/channel/dc:type"
    case RSSChannelFormat         		= "/rss/channel/dc:format"
    case RSSChannelIdentifier     		= "/rss/channel/dc:identifier"
    case RSSChannelSource         		= "/rss/channel/dc:source"
    case RSSChannelLanguage       		= "/rss/channel/dc:language"
    case RSSChannelRelation       		= "/rss/channel/dc:relation"
    case RSSChannelCoverage       		= "/rss/channel/dc:coverage"
    case RSSChannelRights         		= "/rss/channel/dc:rights"
    case RSSChannelItemTitle          	= "/rss/channel/item/dc:title"
    case RSSChannelItemCreator        	= "/rss/channel/item/dc:creator"
    case RSSChannelItemSubject        	= "/rss/channel/item/dc:subject"
    case RSSChannelItemDescription    	= "/rss/channel/item/dc:description"
    case RSSChannelItemPublisher      	= "/rss/channel/item/dc:publisher"
    case RSSChannelItemContributor    	= "/rss/channel/item/dc:contributor"
    case RSSChannelItemDate           	= "/rss/channel/item/dc:date"
    case RSSChannelItemType           	= "/rss/channel/item/dc:type"
    case RSSChannelItemFormat         	= "/rss/channel/item/dc:format"
    case RSSChannelItemIdentifier     	= "/rss/channel/item/dc:identifier"
    case RSSChannelItemSource         	= "/rss/channel/item/dc:source"
    case RSSChannelItemLanguage       	= "/rss/channel/item/dc:language"
    case RSSChannelItemRelation       	= "/rss/channel/item/dc:relation"
    case RSSChannelItemCoverage       	= "/rss/channel/item/dc:coverage"
    case RSSChannelItemRights         	= "/rss/channel/item/dc:rights"
    
    
}