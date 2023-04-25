//
//  NetworkingVocabularyService.swift
//  Quizzie
//
//  Created by hieu nguyen on 03/01/2023.
//

import Foundation

protocol NetworkVocabularyProtocol {
    
    func getDefination<T: Decodable>(
        term: String,
        onComplete: @escaping (T?, Error?) -> Void)
}

class NetworkVocabularyService: NetworkVocabularyProtocol {
    
    let network = NetworkProvider<VocabularyRequest>()
    
    func getDefination<T>(term: String, onComplete: @escaping ((T?, Error?) -> Void)) where T: Decodable {
        network.load(
            request: VocabularyRequest.wordsAPI(term),
            decodeType: T.self) { result in
            switch result {
            case .success(let data):
                onComplete(data, nil)
            case .failure(let error):
                debugPrint("🤬: \(error.localizedDescription)")
                onComplete(nil, error)
            default:
                fatalError("🤬: Something went wrong")
            }
        }
    }
}

class OxfordDictionaryService: NetworkVocabularyProtocol {

    let network = NetworkProvider<VocabularyRequest>()
    
    func getDefination<T>(
        term: String,
        onComplete: @escaping (T?, Error?) -> Void) where T : Decodable {
            network.load(
                request: VocabularyRequest.oxford(term), decodeType: T.self) { result in
                    switch result {
                    case .success(let data):
                        onComplete(data, nil)
                    case .failure(let error):
                        onComplete(nil, error)
                    default:
                        onComplete(nil, GeneralError.notDefined)
                    }
                }
    }
}
