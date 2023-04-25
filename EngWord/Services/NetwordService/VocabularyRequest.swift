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
    case oxford(String)
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
        case .oxford:
            return "https://od-api.oxforddictionaries.com"
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
        case .oxford:
            return "/api/v2/words/en-gb"
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .googleTranslate, .wordsAPI, .freeDic:
            return [:]
        case .oxford(let word):
            return ["q": word]
        }
    }
    
    var method: RequestMethod {
        return .get
    }
    
    var headers: [String : String]? {
        switch self {
        case .wordsAPI:
            return [
                "X-RapidAPI-Key": "687f879fd7mshc6f17304318d6b7p15771ajsnf6ef45c79755",
                "X-RapidAPI-Host": "wordsapiv1.p.rapidapi.com"]
        case .oxford:
            return [
                "app_id": "23d5c6e7",
                "app_key": "2cc7f4c4fdf686c440db103de02301d8"
            ]
        default:
            return [:]
        }
    }
}
