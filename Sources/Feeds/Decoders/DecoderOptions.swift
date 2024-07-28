//
//  DecoderOptions.swift
//
//
//  Created by Axel Martinez on 2/7/24.
//

import Foundation

typealias Source = Foundation.JSONDecoder

struct DecoderOptions {
    var dateDecodingStrategy: Source.DateDecodingStrategy
    var dataDecodingStrategy: Source.DataDecodingStrategy
    var nonConformingFloatDecodingStrategy: Source.NonConformingFloatDecodingStrategy
    var keyDecodingStrategy: Source.KeyDecodingStrategy
    
    init(dateDecodingStrategy: Source.DateDecodingStrategy = .deferredToDate,
         dataDecodingStrategy: Source.DataDecodingStrategy = .base64,
         nonConformingFloatDecodingStrategy: Source.NonConformingFloatDecodingStrategy =  .throw,
         keyDecodingStrategy: Source.KeyDecodingStrategy = .useDefaultKeys
    ) {
        self.dateDecodingStrategy = dateDecodingStrategy
        self.dataDecodingStrategy = dataDecodingStrategy
        self.nonConformingFloatDecodingStrategy = nonConformingFloatDecodingStrategy
        self.keyDecodingStrategy = keyDecodingStrategy
    }
}
