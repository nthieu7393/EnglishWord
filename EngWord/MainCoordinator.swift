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
        navigationController.setViewControllers([viewController], animated: true)
        //        navigationController.show(viewController, animated: false)
    }
    
    func goToSetsScreen(folders: [SetTopicModel]) {
        guard let viewController = FolderViewController.instantiate() else { return }
        let presenter = FoldersPresenter(
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
            storage: ServiceInjector.storageService, view: viewController,
            allFolders: allFolders,
            selectedFolder: selectedFolder
        )
        viewController.delegate = delegateView
        viewController.coordinator = self
        viewController.presenter = presenter
        viewController.modalPresentationStyle = .fullScreen
        navigationController.topViewController?.present(viewController, animated: true)
    }

    func presentTermsScreen(
        folder: SetTopicModel,
        topic: TopicModel,
        delegateView: TermsViewDelegate
    ) {
        guard let viewController = TermsViewController.instantiate() else { return }
        let presenter = TermsPresenter(
            view: viewController,
            set: folder,
            topic: topic,
            storageService: FirebaseStorageService<TermModel>(
                authService: FirebaseAuthentication()
            ),
            networkVocabularyService: ServiceInjector.dictionaryService
        )
        viewController.presenter = presenter
        viewController.coordinator = self
        viewController.delegate = delegateView
        navigationController.show(viewController, sender: nil)
    }

    func dismiss(by screen: UIViewController) {
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

    func gotoTopicsListScreen(allTopics: [TopicFolderWrapper]) {
        guard let viewController = TopicsListViewController.instantiate() else {
            return
        }
        let presenter = TopicsListPresenter(view: viewController, topics: allTopics)
        viewController.presenter = presenter
        viewController.coordinator = self
        navigationController.show(viewController, sender: nil)
    }

    func presentSelectionMenuScreen(
        by screen: UIViewController,
        items: [SelectionMenuItem],
        selectedItem: SelectionMenuItem,
        didSelect: ((SelectionMenuItem) -> Void)?,
        didClose: (() -> Void)? = nil
    ) {
        guard let viewController = SortedByMenuViewController.instantiate() else {
            return
        }
        viewController.modalPresentationStyle = .formSheet
        viewController.allItems = items
        viewController.selectedItem = selectedItem
        viewController.didSelectSortedByItem = didSelect
        viewController.didClose = didClose
        viewController.modalPresentationStyle = .overFullScreen
        if didClose == nil {
            viewController.didClose = {
                screen.dismiss(animated: true)
            }
        }
        screen.present(viewController, animated: true)
    }
}
