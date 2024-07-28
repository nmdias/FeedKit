//
//  Feed.swift
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

/// An RSS and Atom feed parser. `FeedParser` uses `Foundation`'s `XMLParser`.
public protocol Feed {
    init(URL: URL) async throws
    init(data: Data) throws
    init(xmlStream: InputStream) throws
}

public enum FeedError: Error {
    case internalError(reason: String)
}

extension Feed {
    /// Initializes the parser with the JSON or XML content referenced by the given URL.
    ///
    /// - Parameter URL: URL whose contents are read to produce the feed data
    public init(URL: URL) async throws {
        var data: Data?
        
        if URL.isFileURL {
            data = try Data(contentsOf: URL)
        } else {
            let (result, response) = try await URLSession.shared.data(from: URL)
                
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    data = result
                } else {
                    throw FeedError.internalError(reason: "Unexpected HTTP Response: "+httpResponse.description)
                }
            }
        }

        if let data = data {
            try self.init(data: data)
        } else {
            throw FeedError.internalError(reason: "can't initialize")
        }
    }

    /// Initializes the parser with the XML contents encapsulated in a
    /// given InputStream.
    ///
    /// - Parameter xmlStream: An InputStream that yields XML data.
    public init(xmlStream: InputStream) throws {
        //let parser = XMLFeedParser(stream: xmlStream)
        throw FeedError.internalError(reason: "can't initialize")
    }
}
