//
//  Copyright (c) 2016 - 2019 Nuno Manuel Dias
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

import XCTest
import FeedKit

class AmpersandTests: BaseTestCase {
    
    var document: Data?
    
    override func setUp() {
        let url = fileURL("Ampersand", type: "xml")
        document = try? Data(contentsOf: url)
    }
    
    func testUnquotedAmpersands() {
        if let document = document {
            let parser = FeedParser(data: document)
            let feed = try? parser.parse().get().rssFeed
            // Currently will fail because XMLParser strictly enforces the prohibition
            // against unquoted ampersands. Ideally, parsing would be more tolerant.
            XCTAssertNil(feed ?? nil)
        } else {
            XCTFail("Missing unquoted ampersand XML test document")
        }
    }
    
    func testQuotedAmpersands() {
        if let document = document, let groomed = document.groomXML() {
            let parser = FeedParser(data: groomed)
            let feed = try? parser.parse().get().rssFeed
            XCTAssertNotNil(feed ?? nil)
        }
    }

}

extension Data {
    
    // Proof of concept for ampersand fixup. Preserves original encoding. The wisdom of
    // actually attempting this grooming for the mainline parser is unclear. This regular
    // expression is just a quick hack and probably botches some edge cases. Performance
    // is likely terrible.
    
    func groomXML() -> Data? {
        var dataString: NSString?
        let encoding = NSString.stringEncoding(for: self, encodingOptions: nil, convertedString: &dataString, usedLossyConversion: nil)
        if let dataString = dataString as String? {
            // Escape ampersands
            let ampersands = #"&(?![\w#\d]{2,8};)"# // All ampersands not already part of an encoding
            let groomedString = dataString.replacingOccurrences(of: ampersands, with: "&amp;", options: .regularExpression) as NSString
            return groomedString.data(using: encoding)
        }
        return nil
    }
    
}
