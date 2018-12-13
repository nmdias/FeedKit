//
//  Date + codingStrategy.swift
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

extension Date {
    
    public static var encodingStrategy: JSONEncoder.DateEncodingStrategy {
        return JSONEncoder.DateEncodingStrategy.custom({ (date, encoder) in
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss"
            let stringData = formatter.string(from: date)
            var container = encoder.singleValueContainer()
            try container.encode(stringData)
        })
    }
    
    public static var decodingStrategy: JSONDecoder.DateDecodingStrategy {
        
        return JSONDecoder.DateDecodingStrategy.custom({ (decoder: Decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            func from(_ string: String) -> Date? {
                if string.isEmpty {
                    return nil
                }
                for dateFormat in [
                    "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
                    "yyyy-MM-dd'T'HH:mm:ss.SSZZZZZ",
                    "yyyy-MM-dd'T'HH:mm:ss-SS:ZZ"] {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = dateFormat
                        if let date = dateFormatter.date(from: string) {
                            return date
                        }
                }
                return nil
            }
            
            guard let date = from(dateString) else {
                fatalError("Date decoding strategy failed.")
            }
            return date
        })
    }
    
}
