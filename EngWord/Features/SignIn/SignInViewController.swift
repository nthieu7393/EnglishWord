//
//  SignInViewController.swift
//  Quizzie
//
//  Created by hieu nguyen on 13/11/2022.
//

import UIKit

protocol SignInViewDelete: AnyObject {

    func signInView(_ view: SignInViewController, signInSuccess user: UserInfo)
}

class SignInViewController: BaseViewController {

    weak var delegate: SignInViewDelete?

    @IBOutlet weak var signInWithEmailLabel: UILabel!
    @IBOutlet weak var quicklySignInWithLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var inputFieldsContainer: UIView!

    @IBOutlet weak var forgotPasswordButton: ResponsiveButton!
    @IBOutlet weak var signInButton: ResponsiveButton!
    @IBOutlet weak var signInWithGmailButton: ResponsiveButton!
    @IBOutlet weak var signInWithFacebookButton: ResponsiveButton!
    @IBOutlet weak var signInWithPhoneNumber: ResponsiveButton!

    private var signInPresenter: SignInPresenter? {
        return presenter as? SignInPresenter
    }

    @IBAction func signInOnTap(_ sender: ResponsiveButton) {
        signInPresenter?.signIn(email: emailTextField.text, password: passwordTextField.text)
    }

    @IBAction func resetPassword(_ sender: ResponsiveButton) {
        signInPresenter?.resetPassword()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.mainBackground
        inputFieldsContainer.addLineBorder(
            Colors.mainText,
            cornerRadius: CGFloat(Constants.borderRadius)
        )
        inputFieldsContainer.backgroundColor = Colors.mainText

        signInWithEmailLabel.text = Localizations.signInWithEmail.uppercased()
        signInWithEmailLabel.font = Fonts.mainTitle
        signInWithEmailLabel.textColor = Colors.mainText

        quicklySignInWithLabel.font = Fonts.mainTitle
        quicklySignInWithLabel.text = Localizations.quicklySignInWith.uppercased()
        quicklySignInWithLabel.textColor = Colors.mainText

        emailTextField.font = Fonts.regularText
        emailTextField.textColor = Colors.mainText
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: Localizations.email,
            attributes: [
                NSAttributedString.Key.font: Fonts.regularText,
                NSAttributedString.Key.foregroundColor: Colors.placeholder
            ]
        )
        passwordTextField.textColor = Colors.mainText
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: Localizations.password,
            attributes: [
                NSAttributedString.Key.font: Fonts.regularText,
                NSAttributedString.Key.foregroundColor: Colors.placeholder
            ]
        )

        signInWithGmailButton.title = "Continue with Gmail"
        signInWithGmailButton.color = UIColor.orange
        signInWithFacebookButton.title = "Continue with Facebook"
        signInWithPhoneNumber.title = "Sign in with phone number"
        signInButton.title = Localizations.signin

        forgotPasswordButton.title = Localizations.signin
        forgotPasswordButton.color = UIColor.clear
        forgotPasswordButton.textColor = Colors.active
    }
}

extension SignInViewController: Storyboarded, SignInView {

    func signinView(signinSuccess user: UserInfo) {
        delegate?.signInView(self, signInSuccess: user)
        coordinator?.back(animated: true)
    }
}
