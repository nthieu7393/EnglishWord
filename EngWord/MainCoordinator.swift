//
//  MainCoordinator.swift
//  Quizzie
//
//  Created by hieu nguyen on 03/11/2022.
//

import UIKit

class MainCoordinator {

    lazy var popupStorybard: UIStoryboard = {
        return UIStoryboard(name: R.storyboard.popupStoryboard.name, bundle: nil)
    }()

    private var navigationController: UINavigationController

    var child: [UIViewController] {
        return navigationController.viewControllers
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
//        guard let viewController = ViewController.instantiate() else { return }
        guard let viewController = LaunchViewController.instantiate() else { return }
        let presenter = LaunchPresenter(view: viewController, storageService: ServiceInjector.storageService)
        viewController.presenter = presenter
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func back(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }

    func gotoHomeScreen(folders: [SetTopicModel]) {
        guard let viewController = ViewController.instantiate() else { return }
        let presenter = HomePresenter(
            view: viewController,
            authentication: ServiceInjector.authenticationService,
            folders: folders
        )
        viewController.presenter = presenter
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func goToSetsScreen(folders: [SetTopicModel]) {
        guard let viewController = FolderViewController.instantiate() else { return }
        let presenter = SetsPresenter(
            view: viewController,
            storageService: storage!,
            folders: folders
        )
        viewController.presenter = presenter
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }

    func goToSignInScreen(delegatedView: SignInViewDelete) {
        guard let viewController = SignInViewController.instantiate() else { return }
        let presenter = SignInPresenter(authService: FirebaseAuthentication(), view: viewController)
        viewController.presenter = presenter
        viewController.coordinator = self
        viewController.delegate = delegatedView
        navigationController.pushViewController(viewController, animated: true)
    }

    func presentTextMenuScreen(
            menuItems: [String],
            initialSelectedItemIndex: Int?,
            didSelectHandler: @escaping ((Int) -> Void)) {
//        let viewController = TextMenuViewController.instantiate()
//        viewController?.menuItems = menuItems
//        viewController?.selectedItemIndex = initialSelectedItemIndex
//        viewController?.didSelectHandler = didSelectHandler
//        guard let viewController = viewController else { return }
//        navigationController.topViewController?.present(viewController, animated: true)
    }

    func presentNewSetInputScreen(delegateView: NewFolderInputViewDelegate, initialSet: SetTopicModel? = nil) {
        let viewController = NewFolderInputViewController.instantiate()
        guard let viewController = viewController else { return }
        viewController.coordinator = self
        viewController.delegate = delegateView
        viewController.initialSet = initialSet
        navigationController.topViewController?.present(viewController, animated: true)
    }

    func presentAllTopicsScreen(
        delegateView: AllTopicsViewDelegate,
        allFolders: [SetTopicModel],
        selectedFolder: SetTopicModel
    ) {
        let viewController = AllTopicsViewController.instantiate()
        guard let viewController = viewController else { return }
        let presenter = AllTopicsPresenter(
            view: viewController,
            allFolders: allFolders,
            selectedFolder: selectedFolder)
        viewController.delegate = delegateView
        viewController.presenter = presenter
        viewController.modalPresentationStyle = .fullScreen
        navigationController.topViewController?.present(viewController, animated: true)
    }

    func presentTermsScreen(
        folder: SetTopicModel,
        topic: TopicModel,
        delegateView: TermsViewDelegate) {
        guard let viewController = TermsViewController.instantiate() else { return }
        let presenter = TermsPresenter(
            view: viewController,
            set: folder,
            topic: topic,
            storageService: FirebaseStorageService<TermModel>(
                authService: FirebaseAuthentication()
            ),
            networkVocabularyService: vocabularyService!
        )
        viewController.presenter = presenter
        viewController.coordinator = self
        viewController.delegate = delegateView
        navigationController.show(viewController, sender: nil)
    }

    func dismissScreen(_ screen: UIViewController) {
        screen.dismiss(animated: true)
    }

    func goToUserInfoScreen(delegatedView: UserInfoViewDelegate?) {
        guard let view = UserInfoViewController.instantiate() else { return }
        let presenter = UserInfoPresenter(
            authService: ServiceInjector.authenticationService,
            view: view
        )
        view.presenter = presenter
        view.coordinator = self
        view.delegate = delegatedView
        navigationController.pushViewController(view, animated: true)
    }

    func goToSignupScreen(delegateView: SignUpViewDelegate) {
        guard let view = SignUpViewController.instantiate() else { return }
        let presenter = SignUpPresenter(view: view, auth: ServiceInjector.authenticationService)
        view.presenter = presenter
        view.coordinator = self
        navigationController.show(view, sender: nil)
    }

    func presentLearnTopicScreen(from view: UIViewController, cards: [Card]) {
        guard let viewController = LearnTopicViewController.instantiate() else { return }
        let presenter = LearnTopicPresenter(view: viewController, cards: cards)
        viewController.presenter = presenter
        viewController.coordinator = self
        viewController.modalPresentationStyle = .fullScreen
        view.present(viewController, animated: true)
    }

    func presentTestTopicScreen(from view: UIViewController) {
        guard let view = TestTopicViewController.instantiate() else { return }
        let presenter = TestTopicPresenter(view: view)
        view.presenter = presenter
        view.coordinator = self
        view.modalPresentationStyle = .fullScreen
        view.present(view, animated: true)
    }

    func goToReviewCardScreen(
        from screen: UIViewController,
        delegate: ReviewCardDelegate,
        card: any Card,
        cards: [any Card]) {
        guard let view = ReviewCardViewController.instantiate() else { return }
        let presenter = ReviewCardPresenter(view: view, cards: cards, currentCard: card)
        view.presenter = presenter
        view.modalPresentationStyle = .fullScreen
        view.coordinator = self
        screen.present(view, animated: true)
    }

    func presentPracticeTopicScreen(
        from screen: UIViewController,
        cards: [any Card],
        topic: TopicModel,
        folder: SetTopicModel
    ) {
        guard let viewController = PracticeTopicViewController.instantiate() else {
            return
        }
        let presenter = PracticeTopicPresenter(
            view: viewController,
            storageService: ServiceInjector.storageService,
            cards: cards,
            topic: topic,
            folder: folder
        )
        viewController.presenter = presenter
//        viewController.modalPresentationStyle = .fullScreen
        viewController.coordinator = self
//        screen.present(viewController, animated: true)
        navigationController.show(viewController, sender: nil)
    }

    func presentPartOfSpeechMenuScreen(
        from screen: UIViewController,
        card: (any Card),
        delegateScreen: PartOfSpeechMenuViewControllerDelegate
    ) {
        guard let viewController = PartOfSpeechMenuViewController.instantiate() else {
            return
        }
        let presenter = PartOfSpeechMenuPresenter(
            view: viewController,
            card: card)
        viewController.modalPresentationStyle = .popover
        viewController.presenter = presenter
        viewController.coordinator = self
        viewController.delegate = delegateScreen
        screen.present(viewController, animated: true)
    }
}
