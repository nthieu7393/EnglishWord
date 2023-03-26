//
//  UserInfoPresenter.swift
//  Quizzie
//
//  Created by hieu nguyen on 31/01/2023.
//

import UIKit

class UserInfoPresenter: BasePresenter {

    private var authService: Authentication
    private var view: UserInfoView

    init(authService: Authentication, view: UserInfoView) {
        self.authService = authService
        self.view = view
    }

    func signout() {
        view.showLoadingIndicator()
        authService.signOut { error in
            view.dismissLoadingIndicator()
            if error == nil {
                view.signoutSuccess()
                return
            }
            view.showErrorAlert(msg: error?.localizedDescription ?? "")
        }
    }
}
