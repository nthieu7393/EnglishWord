//
//  VocabularyRequest.swift
//  Quizzie
//
//  Created by hieu nguyen on 03/01/2023.
//

import Foundation

enum VocabularyRequest {
    
    case wordsAPI(String)
    case googleTranslate
    case freeDic
}

extension VocabularyRequest: NetworkRequest {
    
    var baseUrl: String {
        switch self {
        case .wordsAPI:
            return "https://wordsapiv1.p.rapidapi.com"
        case .googleTranslate:
            return ""
        case .freeDic:
            return ""
        }
    }
    
    var path: String {
        switch self {
        case .wordsAPI(let word):
            return "/words/\(word)"
        case .googleTranslate:
            return ""
        case .freeDic:
            return ""
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .googleTranslate, .wordsAPI, .freeDic:
            return [:]
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .wordsAPI, .googleTranslate, .freeDic: return .get
        }
    }
    
    var headers: [String : String]? {
        return [
            "X-RapidAPI-Key": "687f879fd7mshc6f17304318d6b7p15771ajsnf6ef45c79755",
            "X-RapidAPI-Host": "wordsapiv1.p.rapidapi.com"]
    }
}
