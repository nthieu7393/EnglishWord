//
//  ServiceInjector.swift
//  Quizzie
//
//  Created by hieu nguyen on 03/01/2023.
//

import Foundation

let container = ServiceDIContainer.shared

func registerServices() {
    container.register(type: Authentication.self, service: FirebaseAuthentication())
    container.register(
        type: StorageProtocol.self,
        service: FirebaseStorageService<TermModel>(
            authService: container.resolve(type: Authentication.self)))
    container.register(type: NetworkVocabularyProtocol.self, service: NetworkVocabularyService())
    container.register(type: Authentication.self, service: FirebaseAuthentication())
}

var storage: StorageProtocol? = {
    return container.resolve(type: StorageProtocol.self)
}()

var vocabularyService: NetworkVocabularyProtocol? = {
    return container.resolve(type: NetworkVocabularyProtocol.self)
}()

class ServiceInjector {
    
    static var authenticationService: Authentication = {
        return container.resolve(type: Authentication.self)!
    }()
    
    static var storageService: StorageProtocol = {
        return container.resolve(type: StorageProtocol.self)!
    }()
}
