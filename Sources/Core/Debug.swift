//
//  Debug.swift
//  Iris
//
//  Created by Nuno Dias on 15/05/16.
//
//

import Foundation

/**
 A debug functions wrapper.
 */
internal class Debug {
    
    /**
     Logs the specified message when the build configuration is set to debug mode.
     
     - parameter message: The message to print
     */
    static func log(message: String, file: String = #file, line: Int = #line) {
        #if DEBUG
            print("\(file.lastPathComponent):\(line): \(message)")
        #endif
    }
    
}

