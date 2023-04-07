//
//  HomePresenter.swift
//  Quizzie
//
//  Created by hieu nguyen on 02/11/2022.
//

import Foundation

class HomePresenter: BasePresenter {
    
    private var homeMenuList: [HomeMenuModel] = []
    private let view: HomeView
    private let authService: Authentication
    private var folders: [SetTopicModel]
    
    var getHomeMenuList: [HomeMenuModel] { return homeMenuList }
    var userInfo: UserInfo? {
        return authService.user
    }
    
    init(
        view: HomeView,
        authentication: Authentication,
        folders: [SetTopicModel]) {
        self.view = view
        self.authService = authentication
        self.folders = folders
        super.init()

    }

    func viewDidLoad() {
        calculateMenus(folders: folders)
    }

    private func calculateMenus(folders: [SetTopicModel]) {
        var allTopics: [TopicFolderWrapper] = []
        for folder in folders {
            let topics = folder.topics.map {
                TopicFolderWrapper(folder: folder, topic: $0)
            }
            allTopics.append(contentsOf: topics)
        }

        self.homeMenuList = [
            HomeMenuAllFolders(totalItems: folders.count, actionOnTap: {
                self.view.navigateToSetsScreen(folders: folders)
            }),
            HomeMenuDailyTopics(totalItems: allTopics.count, actionOnTap: {
                self.view.gotoTopicsListScreen(allTopics: allTopics)
            })
        ]
        view.display()
    }
    
    func updateFolders(topic: TopicFolderWrapper) {
        guard let indexOfFolder = folders.firstIndex(where: {
            $0.id == topic.folder.id
        }) else { return }
        guard let indexOfTopic = folders[indexOfFolder].topics.firstIndex(where: {
            $0.topicId == topic.topic.topicId
        }) else { return }
        folders[indexOfFolder].name = topic.folder.name
        folders[indexOfFolder].topics[indexOfTopic] = topic.topic
    }
}
