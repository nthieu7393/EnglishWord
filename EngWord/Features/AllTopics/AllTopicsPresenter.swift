// 
//  AllTopicsPresenter.swift
//  EngWord
//
//  Created by hieu nguyen on 17/02/2023.
//

import Foundation

final class AllTopicsPresenter: BasePresenter {
    
    private var view: AllTopicsViewProtocol?
    private var allFolders: [SetTopicModel]?
    private var selectedFolder: SetTopicModel?
    private var allTopics: [TopicModel] = []
    private var selectedTopics: [TopicModel] = []

    var folder: SetTopicModel? {
        return selectedFolder
    }

    init(
        view: AllTopicsViewProtocol,
        allFolders: [SetTopicModel],
        selectedFolder: SetTopicModel
    ) {
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

    func shouldHighlight(row: Int) -> Bool {
        let ids = selectedTopics.map { $0.topicId }
        let highlight = ids.contains {
            $0 == allTopics[row].topicId
        }
        return highlight
    }

    func topic(at index: Int) -> TopicModel {
        return allTopics[index]
    }

    func didSelectTopic(index: Int) {

    }

    func didDeselectTopic(index: Int) {

    }
}
