//
//  DublinCoreNamespace.swift
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

/// The Dublin Core Metadata Element Set is a standard for cross-domain
/// resource description.
/// 
/// See https://tools.ietf.org/html/rfc5013
public class DublinCoreNamespace {
    
    /// A name given to the resource.
    public var dcTitle: String?
    
    /// An entity primarily responsible for making the content of the resource 
    /// 
    /// Examples of a Creator include a person, an organization, or a service. 
    /// Typically, the name of a Creator should be used to indicate the entity.
    public var dcCreator: String?
    
    /// The topic of the content of the resource
    /// 
    /// Typically, the subject will be represented using keywords, key phrases, 
    /// or classification codes. Recommended best practice is to use a controlled 
    /// vocabulary.  To describe the spatial or temporal topic of the resource, 
    /// use the Coverage element.
    public var dcSubject: String?
    
    /// An account of the content of the resource
    /// 
    /// Description may include but is not limited to: an abstract, a table of 
    /// contents, a graphical representation, or a free-text account of the 
    /// resource.
    public var dcDescription: String?
    
    /// An entity responsible for making the resource available
    /// 
    /// Examples of a Publisher include a person, an organization, or a service. 
    /// Typically, the name of a Publisher should be used to indicate the entity.
    public var dcPublisher: String?
    
    /// An entity responsible for making contributions to the content of the
    /// resource 
    /// 
    /// Examples of a Contributor include a person, an organization, or a service.
    /// Typically, the name of a Contributor should be used to indicate the entity.
    public var dcContributor: String?
    
    /// A point or period of time associated with an event in the lifecycle of the
    /// resource.
    /// 
    /// Date may be used to express temporal information at any level of 
    /// granularity. Recommended best practice is to use an encoding scheme, such
    /// as the W3CDTF profile of ISO 8601 [W3CDTF].
    public var dcDate: Date?
    
    /// The nature or genre of the content of the resource
    /// 
    /// Recommended best practice is to use a controlled vocabulary such as the 
    /// DCMI Type Vocabulary [DCTYPE].  To describe the file format, physical 
    /// medium, or dimensions of the resource, use the Format element.
    public var dcType: String?
    
    /// The file format, physical medium, or dimensions of the resource.
    /// 
    /// Examples of dimensions include size and duration. Recommended best 
    /// practice is to use a controlled vocabulary such as the list of Internet 
    /// Media Types [MIME].
    public var dcFormat: String?
    
    /// An unambiguous reference to the resource within a given context.
    /// 
    /// Recommended best practice is to identify the resource by means of a string
    /// conforming to a formal identification system.
    public var dcIdentifier: String?
    
    /// A Reference to a resource from which the present resource is derived
    /// 
    /// The described resource may be derived from the related resource in whole
    /// or in part. Recommended best practice is to identify the related resource
    /// by means of a string conforming to a formal identification system.
    public var dcSource: String?
     
    /// A language of the resource.
    /// 
    /// Recommended best practice is to use a controlled vocabulary such as 
    /// RFC 4646 [RFC4646].
    public var dcLanguage: String?

    /// A related resource.
    /// 
    /// Recommended best practice is to identify the related resource by means of
    /// a string conforming to a formal identification system.
    public var dcRelation: String?
    
    /// The spatial or temporal topic of the resource, the spatial applicability
    /// of the resource, or the jurisdiction under which the resource is 
    /// relevant.
    /// 
    /// Spatial topic and spatial applicability may be a named place or a location
    /// specified by its geographic coordinates.  Temporal topic may be a named 
    /// period, date, or date range.  A jurisdiction may be a named administrative
    /// entity or a geographic place to which the resource applies.  Recommended 
    /// best practice is to use a controlled vocabulary such as the Thesaurus of 
    /// Geographic Names [TGN].  Where appropriate, named places or time periods 
    /// can be used in preference to numeric identifiers such as sets of 
    /// coordinates or date ranges.
    public var dcCoverage: String?
    
    /// Information about rights held in and over the resource.
    /// 
    /// Typically, rights information includes a statement about various property
    /// rights associated with the resource, including intellectual property
    /// rights.
    public var dcRights: String?
    
}

// MARK: - Equatable

extension DublinCoreNamespace: Equatable {
    
    public static func ==(lhs: DublinCoreNamespace, rhs: DublinCoreNamespace) -> Bool {
        return
            lhs.dcTitle == rhs.dcTitle &&
            lhs.dcCreator == rhs.dcCreator &&
            lhs.dcSubject == rhs.dcSubject &&
            lhs.dcDescription == rhs.dcDescription &&
            lhs.dcPublisher == rhs.dcPublisher &&
            lhs.dcContributor == rhs.dcContributor &&
            lhs.dcDate == rhs.dcDate &&
            lhs.dcType == rhs.dcType &&
            lhs.dcFormat == rhs.dcFormat &&
            lhs.dcIdentifier == rhs.dcIdentifier &&
            lhs.dcSource == rhs.dcSource &&
            lhs.dcLanguage == rhs.dcLanguage &&
            lhs.dcRelation == rhs.dcRelation &&
            lhs.dcCoverage == rhs.dcCoverage &&
            lhs.dcRights == rhs.dcRights
    }
    
}
