// 
//  TopicsListPresenter.swift
//  EngWord
//
//  Created by hieu nguyen on 04/04/2023.
//

import Foundation

final class TopicsListPresenter: BasePresenter {
    
    private var view: TopicsListViewProtocol?
    private var allTopics: [TopicFolderWrapper]
    var dailyTopics: [TopicFolderWrapper] {
        return allTopics.filter {
            $0.topic.intervalPractice == .daily || $0.topic.intervalPractice == nil
        }
    }

    var weeklyTopics: [TopicFolderWrapper] {
        return allTopics.filter {
            $0.topic.intervalPractice == .weekly
        }
    }

    var monthlyTopics: [TopicFolderWrapper] {
        return allTopics.filter {
            $0.topic.intervalPractice == .monthly
        }
    }
    
    init(view: TopicsListViewProtocol, topics: [TopicFolderWrapper]) {
        self.view = view
        self.allTopics = topics
    }

    func updateTopicsList(by topic: TopicFolderWrapper?) {
        guard let topic = topic else { return }
        guard let index = allTopics.firstIndex(where: {
            $0.folder.id == topic.folder.id && $0.topic.topicId == topic.topic.topicId
        }) else { return }
        allTopics[Int(index)] = topic
        view?.displayTopics()
    }
}

struct TopicFolderWrapper {
    var folder: SetTopicModel
    var topic: TopicModel
}
