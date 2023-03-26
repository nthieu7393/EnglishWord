//
//  TextFieldToolbar.swift
//  Quizzie
//
//  Created by hieu nguyen on 06/11/2022.
//

import UIKit

protocol SignInNoteViewProtocol: AnyObject {

    func signInNoteView(_ view: SignInNoteView, didTapSignInButton: ResponsiveButton)
    func signInNoteView(_ view: SignInNoteView, didTapSignUpButton: ResponsiveButton)
    func signInNoteView(_ view: SignInNoteView, didTapUserInfoView: UIView)
    func signInNoteView(_ view: SignInNoteView, didDeleteWarning: UIView)
}

class SignInNoteView: BaseView {

    @IBOutlet weak var signInSignupView: UIStackView!
    @IBOutlet weak var signinButton: ResponsiveButton!
    @IBOutlet weak var signupButton: ResponsiveButton!
    @IBOutlet weak var signinNoteLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userInfoView: UIStackView!
    @IBOutlet weak var warningView: UIView!

    weak var delegate: SignInNoteViewProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = Colors.mainBackground
        signinNoteLabel.text = Localizations.signinNote
        signinNoteLabel.font = Fonts.regularText
        signinNoteLabel.textColor = Colors.mainText

        usernameLabel.font = Fonts.mainTitle
        usernameLabel.textColor = Colors.mainText

        signinButton.title = Localizations.signin
        signupButton.title = Localizations.signup
        signupButton.color = UIColor.clear

        warningView.backgroundColor = Colors.cellBackground
        warningView.addCornerRadius()
    }

    func setUserInfo(userInfo: UserInfo?, shouldShowWarning: Bool = true) {
        warningView.isHidden = !shouldShowWarning
        if userInfo == nil {
            hideAvatarAndUsername()
            showSignInButton()
        } else {
            showAvatarAndUsername(
                avatarId: userInfo?.avatarId,
                email: userInfo?.email,
                userName: userInfo?.displayName
            )
            hideSignInButton()
        }
    }

    @IBAction func signInButtonDidTouch(_ sender: ResponsiveButton) {
        delegate?.signInNoteView(self, didTapSignInButton: sender)
    }

    @IBAction func signUpButtonDidTouch(_ sender: ResponsiveButton) {
        delegate?.signInNoteView(self, didTapSignUpButton: sender)
    }

    @IBAction func deleteWarningButtonDidTouch(_ sender: UIButton) {
        warningView.isHidden = true
        delegate?.signInNoteView(self, didDeleteWarning: sender)
    }

    private func hideSignInButton() {
        signInSignupView.isHidden = true
    }

    private func showSignInButton() {
        signinButton.isHidden = false
        signinNoteLabel.isHidden = signinButton.isHidden
    }

    private func showAvatarAndUsername(avatarId: String?, email: String?, userName: String?) {
        avatarImageView.image = UIImage(named: avatarId ?? "1")
        usernameLabel.text = (userName ?? "").isEmpty ? email : userName
        avatarImageView.isHidden = false
        usernameLabel.isHidden = false
    }

    private func hideAvatarAndUsername() {
        avatarImageView.isHidden = true
        usernameLabel.isHidden = true
    }

    @IBAction func userInfoOnTap(_ sender: UITapGestureRecognizer) {
        delegate?.signInNoteView(self, didTapUserInfoView: userInfoView)
    }
}

extension SignInNoteView: UITextFieldDelegate {

}
