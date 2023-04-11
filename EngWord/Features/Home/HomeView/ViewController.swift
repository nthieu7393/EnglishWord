//
//  ViewController.swift
//  Quizzie
//
//  Created by hieu nguyen on 31/10/2022.
//

import UIKit

class ViewController: BaseViewController, Storyboarded {

    @IBOutlet weak var tableView: UITableView!

    private var signInNoteView: SignInNoteView?
    private var shouldShowWarning = true

    private var homePresenter: HomePresenter? {
        return presenter as? HomePresenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        presenter = HomePresenter(view: self, authentication: ServiceInjector.authenticationService)
//        signinButton.title = Localizations.signin
//        signinNoteLabel.text = Localizations.signinNote
        homePresenter?.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(practiceNotificationReceived(_:)),
            name: .practiceFinishNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(addTopicsToFolderNotificationReceived(_:)),
            name: .addTopicsToFolderNotification,
            object: nil
        )
    }
    
    @objc func practiceNotificationReceived(_ notification: Notification) {
        homePresenter?.updateFolder(topicFolder: (notification.object as! TopicFolderWrapper))
    }

    @objc func addTopicsToFolderNotificationReceived(_ notification: Notification) {
        homePresenter?.updateFolder(folder: (notification.object as! SetTopicModel))
    }
    
    override var showBackBtnIfNeed: Bool {
        return false
    }

    override func setupFontText() {
//        usernameLbl.text = "Hasam"
//        usernameLbl.font = Fonts.mainTitle
//        usernameLbl.textColor = Colors.active
//        logoutLbl.font = Fonts.button
//        logoutLbl.textColor = Colors.active
//        logoutLbl.text = Localizations.logout
//        signinNoteLabel.font = Fonts.regularText
//        signinNoteLabel.textColor = Colors.mainText
    }
}

extension ViewController: HomeView {
    
    func navigateToSetsScreen(folders: [SetTopicModel]) {
        coordinator?.goToSetsScreen(folders: folders)
    }
    
    func gotoTopicsListScreen(allTopics: [TopicFolderWrapper]) {
        coordinator?.gotoTopicsListScreen(allTopics: allTopics)
    }

    func display() {
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return homePresenter?.getHomeMenuList.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: HomeMenuTableViewCell.self),
            for: indexPath
        ) as? HomeMenuTableViewCell
        cell?.display(data: homePresenter?.getHomeMenuList[indexPath.row])
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        signInNoteView = SignInNoteView.fromNib()
        guard let signInNoteView = signInNoteView else { return nil }
        signInNoteView.setUserInfo(userInfo: homePresenter?.userInfo, shouldShowWarning: shouldShowWarning)
        signInNoteView.delegate = self
        return signInNoteView
    }
}

extension ViewController: SignInNoteViewProtocol {

    func signInNoteView(_ view: SignInNoteView, didTapSignInButton: ResponsiveButton) {
        coordinator?.goToSignInScreen(delegatedView: self)
    }

    func signInNoteView(_ view: SignInNoteView, didTapUserInfoView: UIView) {
        coordinator?.goToUserInfoScreen(delegatedView: self)
    }

    func signInNoteView(_ view: SignInNoteView, didTapSignUpButton: ResponsiveButton) {
        coordinator?.goToSignupScreen(delegateView: self)
    }

    func signInNoteView(_ view: SignInNoteView, didDeleteWarning: UIView) {
        shouldShowWarning = false
        tableView.reloadData()
    }
}

extension ViewController: UserInfoViewDelegate {

    func userInfoViewSignOutSuccess(_ view: UserInfoView) {
        signInNoteView?.setUserInfo(userInfo: nil, shouldShowWarning: shouldShowWarning)
        tableView.reloadData()
    }
}

extension ViewController: SignUpViewDelegate {

    func signupView(_ view: SignUpViewController, signupSuccess user: UserInfo?) {

    }
}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        homePresenter?.getHomeMenuList[indexPath.row].runOnTap()
    }
}

extension ViewController: SignInViewDelete {

    func signInView(_ view: SignInViewController, signInSuccess user: UserInfo) {
        signInNoteView?.setUserInfo(userInfo: user, shouldShowWarning: shouldShowWarning)
        tableView.reloadData()
    }
}
