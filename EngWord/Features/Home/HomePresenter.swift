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
//        ServiceInjector.dictionaryService.getDefination(term: "evening", onComplete: { (result: OxfordWordItem?, error: Error?) in
//            print(result)
//        })
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
        DispatchQueue.main.async {
            self.view.display()
        }
    }
    
    func updateFolder(topicFolder: TopicFolderWrapper) {
        guard let indexOfFolder = folders.firstIndex(where: {
            $0.id == topicFolder.folder.id
        }) else { return }
        guard let indexOfTopic = folders[indexOfFolder].topics.firstIndex(where: {
            $0.topicId == topicFolder.topic.topicId
        }) else { return }
        folders[indexOfFolder].name = topicFolder.folder.name
        folders[indexOfFolder].topics[indexOfTopic] = topicFolder.topic
        calculateMenus(folders: folders)
    }
    
    func updateFolder(folder: SetTopicModel) {
        guard let indexOfFolder = folders.firstIndex(where: {
            $0.id == folder.id
        }) else {
            folders.append(folder)
            calculateMenus(folders: folders)
            return
        }
        folders[indexOfFolder] = folder
        calculateMenus(folders: folders)
    }

    func removeFolder(folder: SetTopicModel) {
        guard let indexOfFolder = folders.firstIndex(where: {
            $0.id == folder.id
        }) else { return }
        folders.remove(at: indexOfFolder)
        calculateMenus(folders: folders)
    }
}
