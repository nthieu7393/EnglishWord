//
//  StorageProtocol.swift
//  Quizzie
//
//  Created by hieu nguyen on 15/11/2022.
//

import Foundation

protocol StorageProtocol {
    
    func updateFolder(_ set: SetTopicModel) async throws -> SetTopicModel?
    func createNewFolder(folder: SetTopicModel) async throws -> SetTopicModel?
    func getAllSets() async throws -> [SetTopicModel]?
    func getTopicDetails<T: Decodable>(
        set: SetTopicModel,
        topic: TopicModel) async throws -> T?
    func saveCards(
        cards: [any Card],
        setId: String,
        topicId: String
    ) async throws
    func createNewTopic(_ topic: TopicModel, folder: SetTopicModel) async throws -> TopicModel?
    func updateTopic(_ topic: TopicModel, folder: SetTopicModel) async throws -> TopicModel?
    func deleteFolder(_ folder: SetTopicModel, completion: @escaping ((Error?) -> Void))
    func deleteTopic(
        _ topic: TopicModel,
        in folder: SetTopicModel,
        completion: @escaping ((Error?) -> Void))
    func updatePracticeIntervalOfTopic(
        topic: TopicModel,
        folder: SetTopicModel,
        completion: @escaping (Error?) -> Void
    )
    func addMultipleTopics(
        _ topics: [TopicModel],
        to folder: SetTopicModel
    ) throws -> [TopicModel]
}
