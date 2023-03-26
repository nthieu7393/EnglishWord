//
//  LocalVocabularyService.swift
//  Quizzie
//
//  Created by hieu nguyen on 04/01/2023.
//

import Foundation
import RealmSwift

protocol LocalProtocol {
    associatedtype T
    
    func save(item: T)
    func saveMany(items: [T], onComplete: @escaping ((Int, Error?) -> Void))
    func saveManySync(items: [T]) throws
    func delete(id: String) throws
    func object(type: T.Type, primaryKey: String) -> T?
    func object(type: T.Type, predicateFormat: String, args: Any...) -> [T]?
    func objects(type: T.Type) -> [T]?
    func deleteAll() throws
}

class RealmVocabularyService<T: Object>: LocalProtocol {
    
    var realm: Realm?
    
    convenience init(realm: Realm) {
        self.init()
        self.realm = realm
    }
    
    func save(item: T) {
        try? self.realm?.write({
            self.realm?.add(item)
        })
    }
    
    func saveMany(items: [T], onComplete: @escaping ((Int, Error?) -> Void)) {
        self.realm?.writeAsync({
            items.forEach {
                self.realm?.add($0)
            }
        }, onComplete: { error in
            onComplete(items.count, error)
        })
    }

    func saveManySync(items: [T]) throws {
        do {
            try realm?.write({
                items.forEach {
                    self.realm?.add($0)
                }
            })
        } catch {
            throw error
        }
    }
    
    func delete(id: String) throws {
        let object = self.realm?.object(ofType: T.self, forPrimaryKey: id)
        guard let object = object else { return }
        do {
            try self.realm?.write({
                self.realm?.delete(object)
            })
        } catch {
            debugPrint("‼️ Error: \(error)")
            throw error
        }
    }
    
    func object(type: T.Type, primaryKey: String) -> T? {
        return realm?.object(ofType: type, forPrimaryKey: primaryKey)
    }

    func objects(type: T.Type) -> [T]? {
        return Array(realm!.objects(type))
    }

    func deleteAll() throws {
        do {
            try realm?.write({
                realm?.deleteAll()
            })
        } catch {
            throw error
        }
    }

    func object(type: T.Type, predicateFormat: String, args: Any...) -> [T]? {
        return Array(realm!.objects(type).filter(predicateFormat, args))
    }
}
