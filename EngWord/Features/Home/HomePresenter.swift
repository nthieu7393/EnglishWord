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
    private let folders: [SetTopicModel]
    
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
        let allTopics = folders.flatMap { $0.topics }
        let dailyTopics = allTopics.filter {
            $0.intervalPractice == .daily
        }
        let weeklyTopics = allTopics.filter {
            $0.intervalPractice == .weekly
        }
        let monthlyTopics = allTopics.filter {
            $0.intervalPractice == .monthly
        }

        self.homeMenuList = [
            HomeMenuSet(totalItems: folders.count, actionOnTap: {
                self.view.navigateToSetsScreen(folders: folders)
            }),
            HomeMenuStudying(totalItems: dailyTopics.count, actionOnTap: {
                print("HomeMenuStudying")
            }),
            HomeMenuFavorite(totalItems: weeklyTopics.count, actionOnTap: {
                print("HomeMenuFavorite")
            }),
            HomeMenuPlan(totalItems: monthlyTopics.count, actionOnTap: {
                print("HomeMenuPlan")
            }),
        ]

        view.display()
    }
}
