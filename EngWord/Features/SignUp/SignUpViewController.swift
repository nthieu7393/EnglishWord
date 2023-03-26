//
//  SignUpViewController.swift
//  Quizzie
//
//  Created by hieu nguyen on 01/02/2023.
//

import UIKit

protocol SignUpViewDelegate: AnyObject {

    func signupView(_ view: SignUpViewController, signupSuccess user: UserInfo?)
}

class SignUpViewController: BaseViewController {

    weak var delegate: SignUpViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SignUpViewController: Storyboarded, SignUpViewProtocol {

    
}
