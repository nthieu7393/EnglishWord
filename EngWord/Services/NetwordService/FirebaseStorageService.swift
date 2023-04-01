//
//  FirebaseVocabularyService.swift
//  Quizzie
//
//  Created by hieu nguyen on 15/11/2022.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class FirebaseStorageService<T: Card>: StorageProtocol {
    
    private var authService: Authentication?
    private let firestore: Firestore!
    private let database = Firestore.firestore().collection("users")
    private var rootDocumentReference: DocumentReference? {
        guard let authUid = authService?.authUid else {
            debugPrint("‼️ not signin yet")
            return nil
        }
        return database.document(authUid)
    }
    
    private var folderCollectionRef: CollectionReference? {
        guard let reference = rootDocumentReference else { return nil }
        return reference.collection("folders")
    }

    private var deletedTopicCollection: CollectionReference? {
        guard let ref = rootDocumentReference else { return nil }
        return ref.collection("deleted_topics")
    }
    
    private func topicReference(setId: String, topicId: String) -> DocumentReference? {
        guard let reference = folderCollectionRef else { return nil }
        return reference.document(setId).collection("topics").document(topicId)
    }
    
    init(authService: Authentication?) {
        if let uwr = authService {
            self.authService = uwr
        }
        firestore = Firestore.firestore()
    }
    
    func getAllSets() async throws -> [SetTopicModel]? {
        do {
            guard let result = try await folderCollectionRef?.getDocuments() else { return nil }
            return result.documents.compactMap({
                return try? $0.data(as: SetTopicModel.self)
            })
        } catch {
            throw error
        }
    }
    
    func createNewFolder(folder: SetTopicModel) async throws -> SetTopicModel? {
        do {
            let ref = try await folderCollectionRef?.addDocument(data: folder.toDictionary())
            return SetTopicModel(id: ref?.documentID, name: folder.name)
        } catch {
            throw error
        }
    }
    
    func updateFolder(_ set: SetTopicModel) async throws -> SetTopicModel? {
        guard let id = set.id, set.name != nil else { return nil }
        do {
            try await folderCollectionRef?.document(id).setData(set.toDictionary())
            return set
        } catch {
            throw error
        }
    }
    
    func getTopicDetails<T: Decodable>(set: SetTopicModel, topic: TopicModel) async throws -> T? {
        guard let setId = set.id, let topicId = topic.topicId else { return nil }
        let result = topicReference(setId: setId, topicId: topicId)
        do {
            let topic = try await result!.getDocument(as: T.self)
            return topic
        } catch {
            throw error
        }
    }

    func saveCards(
        cards: [any Card],
        setId: String,
        topicId: String
    ) async throws {
        do {
            try await topicReference(
                setId: setId,
                topicId: topicId)?.setData(
                    ["terms": cards.toJson],
                    merge: true
                )
        } catch {
            throw error
        }
    }
    
    func createNewTopic(_ topic: TopicModel, folder: SetTopicModel) async throws -> TopicModel? {
        do {
            let documentRefOfFolder = folderCollectionRef?.document(folder.id ?? "")
            let documentRef = try await documentRefOfFolder?
                .collection("topics")
                .addDocument(data: topic.toDictionary())

            let topicId = documentRef?.documentID
            var mutatingFolder = folder
            let newTopic = TopicModel(id: topicId, name: topic.name)
            mutatingFolder.topics.append(newTopic)
            var dicData: [String: Any] = ["set_name": folder.name ?? ""]
            dicData["topics"] = mutatingFolder.topics.compactMap({
                var dicData = try? $0.toDictionary()
                dicData?.removeValue(forKey: "terms")
                return dicData
            })
            try await documentRefOfFolder?.setData(dicData, merge: false)
            return newTopic
        } catch {
            return nil
        }
    }

    func updateTopic(_ topic: TopicModel, folder: SetTopicModel) async throws -> TopicModel? {
        do {
            let documentRefOfSet = folderCollectionRef?.document(folder.id ?? "")
            try await documentRefOfSet?
                .collection("topics")
                .document(topic.topicId ?? "")
                .updateData(topic.toJson)
            try await documentRefOfSet?.updateData(folder.toDictionary())
        } catch {
            throw error
        }
        return nil
    }

    func deleteFolder(_ folder: SetTopicModel, completion: @escaping ((Error?) -> Void)) {
        guard let folderId = folder.id else { return }
        folderCollectionRef?.document(folderId).delete(completion: { error in
            completion(error)
        })
    }

    func deleteTopic(
        _ topic: TopicModel,
        in folder: SetTopicModel,
        completion: @escaping ((Error?) -> Void)) {
        moveTopicToDeletedCollection(topic: topic) { [weak self] error in
            guard error == nil,
                  let uwrSelf = self else { return }
            uwrSelf.deleteTopicFromFolder(topic, in: folder, completion: completion)
        }
    }

    func updatePracticeIntervalOfTopic(
        topic: TopicModel,
        folder: SetTopicModel,
        completion: @escaping (Error?) -> Void
    ) {
        let batch = firestore.batch()
        if let topicRef = topicReference(
            setId: folder.id!,
            topicId: topic.topicId!),
            let data = try? topic.toDictionary() {
            batch.updateData(data, forDocument: topicRef)
        }
        
        if let index = folder.topics.firstIndex(of: topic) {
            var mutatingFolder = folder
            mutatingFolder.topics[Int(index)] = topic
            
            if let folder = folderCollectionRef?.document(folder.id ?? ""),
                let data = try? mutatingFolder.toDictionary() {
                batch.updateData(data, forDocument: folder)
            }
        }
        
        batch.commit() { err in
            completion(err)
        }
    }

    private func moveTopicToDeletedCollection(
        topic: TopicModel,
        completion: @escaping ((Error?) -> Void)) {
        deletedTopicCollection?.addDocument(data: topic.toJson, completion: completion)
    }

    private func deleteTopicFromFolder(
        _ topic: TopicModel,
        in folder: SetTopicModel,
        completion: @escaping ((Error?) -> Void)) {
        let batch = firestore.batch()
        var mutatingTopics = folder.topics
        let deletedTopicIndex = mutatingTopics.firstIndex {
            $0.topicId == topic.topicId
        }
        guard let folderId = folder.id,
              let uwrIndex = deletedTopicIndex,
              let folderRef = folderCollectionRef?.document(folderId) else {
            debugPrint("🥵 folder id not found")
            completion(PathError.notFound)
            return
        }

        // field topics
        mutatingTopics.remove(at: uwrIndex)
        batch.updateData(["topics": mutatingTopics.map({
            $0.toJson
        })], forDocument: folderRef)

        // collection topics
        let folderTopicRef = folderRef.collection("topics").document(topic.topicId ?? "")
        batch.deleteDocument(folderTopicRef)

        batch.commit { error in
            completion(error)
        }
    }
}
