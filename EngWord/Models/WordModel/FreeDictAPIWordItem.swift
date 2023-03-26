//
//  FreeDictAPIWordItem.swift
//  Quizzie
//
//  Created by hieu nguyen on 03/01/2023.
//

import Foundation

struct FreeDictAPIWordItem: Decodable {
    
    let word: String
}

//extension FreeDictAPIWordItem: Card {
//    
//    var termProtocol: String {
//        return ""
//    }
//    
//    var listOfDefinition: [String] {
//        return []
//    }
//    
//    var listOfLexicalCategory: PartOfSpeech? {
//        return .adjective
//    }
//    
//    var listOfExamples: [String]? {
//        return nil
//    }
//    
//    var phonetic: String? {
//        return nil
//    }
//}
