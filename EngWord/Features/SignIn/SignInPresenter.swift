//
//  SignInPresenter.swift
//  Quizzie
//
//  Created by hieu nguyen on 13/11/2022.
//

import Foundation

class SignInPresenter: BasePresenter {
    let authService: Authentication
    private var view: SignInView?

    init(authService: Authentication, view: SignInView) {
        self.authService = authService
        self.view = view
    }

    func signIn(email: String?, password: String?) {
        guard let email = email,
                let password = password,
                email.isEmail else {
            view?.showErrorAlert(msg: "check input again")
            return
        }
        view?.showLoadingIndicator()
        authService.signInWithEmail(
            email: email,
            password: password
        ) { [weak self] userInfo, error in
            self?.view?.dismissLoadingIndicator()
            if let error = error {
                self?.view?.showErrorAlert(msg: error.localizedDescription)
            } else {
                guard let user = userInfo else { return }
                self?.view?.signinView(signinSuccess: user)
                self?.view?.showSuccessAlert(msg: Localizations.signinSuccess, completion: nil)
            }
        }
    }

    func resetPassword() {
    }
}
