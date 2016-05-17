//
//  BaseTestCase.swift
//  IrisKit
//
//  Created by Nuno Dias on 17/05/16.
//
//

import XCTest

class BaseTestCase: XCTestCase {
    
    func fileURL(name: String, type: String) -> NSURL {
        let bundle = NSBundle(forClass: self.dynamicType)
        let filePath = bundle.pathForResource(name, ofType: type)!
        return NSURL(fileURLWithPath: filePath)
    }
    
}
