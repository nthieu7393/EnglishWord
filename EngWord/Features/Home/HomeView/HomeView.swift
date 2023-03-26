//
//  HomeView.swift
//  Quizzie
//
//  Created by hieu nguyen on 02/11/2022.
//

import Foundation

protocol HomeView: BaseViewProtocol {
    
    func navigateToSetsScreen()
    func navigateToStudyingScreen()
    func navigateToFavoriteScreen()
    func navigateToReviewScreen()
    func navigateToTrashScreen()
    func navigateToSignInScreen()
}
