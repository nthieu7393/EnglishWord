//
//  HomePresenter.swift
//  Quizzie
//
//  Created by hieu nguyen on 02/11/2022.
//

import Foundation

class HomePresenter: BasePresenter {
    
    private let homeMenuList: [HomeMenuModel]
    private let view: HomeView
    private let authService: Authentication
    
    var getHomeMenuList: [HomeMenuModel] { return homeMenuList }
    var userInfo: UserInfo? {
        return authService.user
    }
    
    init(view: HomeView, authentication: Authentication) {
        self.view = view
        self.authService = authentication
        self.homeMenuList = [
            HomeMenuSet(totalItems: 0, actionOnTap: {
                view.navigateToSetsScreen()
            })
//            HomeMenuStudying(totalItems: 5, actionOnTap: {
//                print("HomeMenuStudying")
//            }),
//            HomeMenuFavorite(totalItems: 3, actionOnTap: {
//                print("HomeMenuFavorite")
//            }),
//            HomeMenuPlan(totalItems: 10, actionOnTap: {
//                print("HomeMenuPlan")
//            }),
//            HomeMenuTrash(totalItems: 20, actionOnTap: {
//                print("HomeMenuTrash")
//            })
        ]
    }
}
