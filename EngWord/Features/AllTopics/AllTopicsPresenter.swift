// 
//  AllTopicsPresenter.swift
//  EngWord
//
//  Created by hieu nguyen on 17/02/2023.
//

import Foundation

final class AllTopicsPresenter: BasePresenter {

    private let storage: StorageProtocol
    private var view: AllTopicsViewProtocol?
    private var allFolders: [SetTopicModel]?
    private var selectedFolder: SetTopicModel?
    private var allTopics: [TopicModel] = []
    private var selectedTopics: [TopicModel] = [] {
        didSet {
            if selectedTopics.isEmpty {
                view?.hideAddTopicsButton()
            } else {
                view?.showAddTopicsButton()
            }
        }
    }

    var folder: SetTopicModel? {
        return selectedFolder
    }

    init(
        storage: StorageProtocol,
        view: AllTopicsViewProtocol,
        allFolders: [SetTopicModel],
        selectedFolder: SetTopicModel
    ) {
        self.storage = storage
        super.init()
        self.view = view
        self.allFolders = allFolders
        self.selectedFolder = selectedFolder
        allTopics = flattenTopics(folders: allFolders)
    }

    private func flattenTopics(folders: [SetTopicModel]) -> [TopicModel] {
        let allAvailableTopics = folders.map({
            $0.topics
        }).joined()
        return Array(allAvailableTopics)
    }

    func numberOfTopics() -> Int {
        return allTopics.count
    }

//    func shouldHighlight(row: Int) -> Bool {
//        let ids = selectedTopics.map { $0.topicId }
//        let highlight = ids.contains {
//            $0 == allTopics[row].topicId
//        }
//        return highlight
//    }

    func topic(at index: Int) -> TopicModel {
        return allTopics[index]
    }

    func didSelectTopic(index: Int) {
        let selectedTopic = allTopics[index]
        if let indexOfSelectedTopic = selectedTopics.firstIndex(where: {
            $0.topicId == selectedTopic.topicId
        }) {
            selectedTopics.remove(at: indexOfSelectedTopic)
        } else {
            selectedTopics.append(selectedTopic)
        }
    }

    func saveSelectedTopicsToFolder() {
        view?.showLoadingIndicator()
        Task {
            do {
                let topics = try storage.addMultipleTopics(selectedTopics, to: selectedFolder!)
                selectedFolder?.topics.append(contentsOf: topics)
                _ = try await storage.updateFolder(selectedFolder!)
                self.view?.dismissLoadingIndicator()
            } catch {
                self.view?.dismissLoadingIndicator()
                self.view?.showErrorAlert(msg: error.localizedDescription)
            }
        }
    }
}
