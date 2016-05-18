//
//  RSS2FeedChannelCloud.swift
//  FeedParser
//
//  Created by Nuno Dias on 05/07/15.
//  Copyright © 2015 FeedParser. All rights reserved.
//

import Foundation

/**
    It specifies a web service that supports the rssCloud interface which can be implemented in HTTP-POST, XML-RPC or SOAP 1.1. 
*/
public class RSS2FeedChannelCloud {
    
    /**
        The attributes of the `<channel>`'s `<cloud>` element
    */
    public class Attributes {
        
        /// The domain to register notification to.
        public var domain: String?
        
        /// The port to connect to.
        public var port: UInt?
        
        /// The path to the RPC service. e.g. "/RPC2"
        public var path: String?
        
        /// The procedure to call. e.g. "myCloud.rssPleaseNotify"
        public var registerProcedure: String?
        
        /// The `protocol` specification. Can be HTTP-POST, XML-RPC or SOAP 1.1 - Note: "protocol" is a reserved keyword, so `protocolSpecification` is used instead and refers to the `protocol` attribute of the `cloud` element.
        public var protocolSpecification: String?
        
    }
    
    /// The element's attributes
    public var attributes: Attributes?
    
    public init() {}
    
}