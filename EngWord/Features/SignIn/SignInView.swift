//
//  SignInView.swift
//  Quizzie
//
//  Created by hieu nguyen on 31/01/2023.
//

import UIKit

protocol SignInView: BaseViewProtocol {

    func signinView(signinSuccess user: UserInfo)
}
