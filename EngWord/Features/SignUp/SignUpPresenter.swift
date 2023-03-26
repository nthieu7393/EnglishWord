//
//  SignUpPresenter.swift
//  Quizzie
//
//  Created by hieu nguyen on 01/02/2023.
//

import Foundation

class SignUpPresenter: BasePresenter {

    private let authService: Authentication

    init(view: SignUpViewProtocol, auth: Authentication) {
        self.authService = auth
    }

    func signup() {

    }
}
