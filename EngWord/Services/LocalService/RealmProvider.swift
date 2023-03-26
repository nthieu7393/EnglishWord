//
//  RealmProvider.swift
//  Quizzie
//
//  Created by hieu nguyen on 05/01/2023.
//

import Foundation
import RealmSwift

struct RealmProvider {
    
    var config: Realm.Configuration
    
    var realm: Realm? {
        debugPrint("😆 realm path: \(config.fileURL?.absoluteString ?? "")")
//        if !FileManager.default.fileExists(atPath: config.fileURL?.absoluteString ?? "") {
//            Realm.Configuration.defaultConfiguration = config
//        }
        return try? Realm(configuration: config)
    }
    
    private static let phrasalVerbsConfig = Realm.Configuration(
//        fileURL: try? Path.inDocuments("phrasal-verbs.realm"),
        objectTypes: [PhrasalVerbEntity.self]
    )
    
    init(config: Realm.Configuration) {
        self.config = config
    }
    
    static var phrasalVerbs: RealmProvider = {
        return RealmProvider(config: phrasalVerbsConfig)
    }()
    
}
