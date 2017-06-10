//
//  MediaTag.swift
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

open class MediaTag {
    
    /**
     
     */
    open var tag: String?
    
    /**
     
     */
    open var weight: Int? = 1
    
}

// MARK: - Initializers

extension MediaTag {
    
    convenience init(tag: String, weight: Int = 1) {
        
        self.init()
        
        self.tag = tag
        self.weight = weight
        
    }
    
    static func tagsFrom(string: String) -> [MediaTag]? {
        
        return string.components(separatedBy: ",").flatMap({ (value) -> MediaTag? in
            
            let mediaTag = MediaTag()
            let components = value.components(separatedBy: ":")
            
            if components.count > 0 {
                mediaTag.tag = components.first?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }
            
            if components.count > 1 {
                mediaTag.weight = Int(components.last?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? "")
            }
            
            return mediaTag
            
        })
        
    }
    
}

// MARK: - Equatable

extension MediaTag: Equatable {
    
    public static func ==(lhs: MediaTag, rhs: MediaTag) -> Bool {
        return
            lhs.tag == rhs.tag &&
            lhs.weight == rhs.weight
    }
    
}
