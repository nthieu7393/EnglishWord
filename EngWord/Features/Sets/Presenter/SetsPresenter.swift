//
//  SetViewController.swift
//  Quizzie
//
//  Created by hieu nguyen on 03/11/2022.
//

import Foundation

class SetsPresenter: BasePresenter {

    private let storageService: StorageProtocol
    private let view: SetsView
    private var sets: [SetTopicModel]?

    init(
        view: SetsView,
        storageService: StorageProtocol,
        folders: [SetTopicModel]
    ) {
        self.view = view
        self.storageService = storageService
        self.sets = folders
    }

    func loadAllSets() {
        view.showLoadingIndicator()
        Task {
            do {
//                sets = try await storageService.getAllSets()
                DispatchQueue.main.async {
                    self.view.displayDataOfSets(sets: self.sets ?? [])
                    self.view.dismissLoadingIndicator()
                }
            } catch {
                self.view.dismissLoadingIndicator()
                self.view.showErrorAlert(msg: error.localizedDescription)
            }
        }
    }

    func saveFolder(folder: SetTopicModel) {
        if folder.id.isNotEmpty() {
            updateFolder(folder)
        } else {
            createNewFolder(folder: folder)
        }
    }

    private func createNewFolder(folder: SetTopicModel) {
        view.showLoadingIndicator()
        Task {
            do {
                view.dismissLoadingIndicator()
                let set = try await self.storageService.createNewFolder(folder: folder)
                if let set = set {
                    DispatchQueue.main.async {
                        self.sets?.insert(set, at: 0)
                        self.view.displayDataOfSets(sets: self.sets ?? [])
                        self.view.dismissLoadingIndicator()
                        self.view.dismissNewSetInputScreen()
                    }
                }
            } catch {
                view.showErrorAlert(msg: error.localizedDescription)
                view.dismissLoadingIndicator()
            }
        }
    }

    func updateFolder(_ set: SetTopicModel) {
        guard let indexOfMutatingSet = sets?.firstIndex(
            where: { $0.id == set.id }) else { return }
        view.showLoadingIndicator()
        Task {
            do {
                let set = try await storageService.updateFolder(set)
                self.view.dismissLoadingIndicator()
                if let set = set {
                    DispatchQueue.main.async {
                        self.sets?[indexOfMutatingSet] = set
                        self.view.displayDataOfSets(sets: self.sets ?? [])
                    }
                }
            } catch {
                view.dismissLoadingIndicator()
                view.showErrorAlert(msg: error.localizedDescription)
            }
        }
    }

    func createNewTopicToSet(set: SetTopicModel) {
        view.startInputNameOfSet(initialString: "") { [weak self] topicName in
            guard let self = self else { return }
            self.addNewTopicToSet(topicName ?? "", set: set)
        }
    }
    
    func addNewTopicToSet(_ topicName: String, set: SetTopicModel) {
        Task {
            do {
                try await self.storageService.createNewTopic(TopicModel(name: topicName), folder: set)
            } catch {
                view.showErrorAlert(msg: error.localizedDescription)
            }
        }
    }

    func deleteFolder(_ folder: SetTopicModel) {
        storageService.deleteFolder(folder) { [weak self] error in
            self?.view.showResultAlert(error: error, message: nil)
        }
    }

    func deleteTopic(_ topic: TopicModel?, from folder: SetTopicModel?) {
        guard let topic = topic, let folder = folder else { return }
        storageService.deleteTopic(topic, in: folder) { [weak self] error in
            if error == nil {
                guard let section = self?.sets?.firstIndex(where: { $0.id == folder.id }) else { return }
                guard let index = folder.topics.firstIndex(where: { $0.topicId == topic.topicId }) else { return }
                self?.sets?[section].topics.remove(at: index)
                self?.view.removeTopic(at: section, row: index)
                self?.view.updateFolderTitle(at: section)
            }
            self?.view.showResultAlert(error: error, message: nil)
        }
    }
    
//    func updateTopic(topic: TopicModel?) {
//        guard let topic = topic else { return }
//        guard var folder = sets?.first(where: {
//            $0.topics.map { topic in topic.topicId }.contains { id in
//                id == topic.topicId
//            }
//        }) else { return }
//        
//        guard let indexOfTopic = folder.topics.firstIndex(where: {
//            $0.topicId == topic.topicId
//        }) else { return }
//        
//        folder.topics[indexOfTopic] = topic
//        
//        guard let indexOfFolder = sets?.firstIndex(where: {
//            $0.id == folder.id
//        }) else { return }
//        
//        sets?[Int(indexOfFolder)] = folder
//        view.displayDataOfSets(sets: sets ?? [])
//    }

    func addTopic(topic: TopicModel, to folder: SetTopicModel) {
        guard let indexOfFolder = sets?.firstIndex(where: {
            $0.id == folder.id
        }) else { return }
        sets?[Int(indexOfFolder)].topics.append(topic)
        view.displayDataOfSets(sets: sets ?? [])
        view.updateFolderTitle(at: indexOfFolder)
    }

    func getAllFolders() -> [SetTopicModel] {
        return sets ?? []
    }

    func getFolder(at index: Int) -> SetTopicModel? {
        return sets?[index]
    }

    func getTopicsOfFolder(at index: Int) -> [TopicModel] {
        return sets?[index].topics ?? []
    }

    func getTopic(of folder: SetTopicModel?, at index: Int) -> TopicModel? {
        guard let folder = folder else { return nil }
        guard let indexOfFolder = sets?.firstIndex(where: {
            $0.id == folder.id
        }) else { return nil }
        return sets?[Int(indexOfFolder)].topics[index]
    }

    func updateTopic(topic: TopicModel, of folder: SetTopicModel) {
        guard let indexOfFolder = sets?.firstIndex(where: {
            $0.id == folder.id
        }) else { return }
        sets?[indexOfFolder].updateTopic(by: topic)
        sets?[indexOfFolder].name = folder.name
        view.displayDataOfSets(sets: sets ?? [])
    }
}
