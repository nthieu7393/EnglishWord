// 
//  TopicsListViewController.swift
//  EngWord
//
//  Created by hieu nguyen on 04/04/2023.
//

import UIKit

final class TopicsListViewController: BaseViewController {

    var daily: TopicsInRoutineViewController!
    var weekly: TopicsInRoutineViewController!
    var monthly: TopicsInRoutineViewController!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    let pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )
    var controllers: [TopicsInRoutineViewController]!

    var myPresenter: TopicsListPresenter {
        return presenter as! TopicsListPresenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(pageViewController.view)
        setupPageView()
        titleLabel.text = IntervalBetweenPractice.daily.text
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(practiceNotificationReceived(_:)),
            name: .practiceFinishNotification,
            object: nil
        )
    }

    @objc func practiceNotificationReceived(_ notification: Notification) {
        myPresenter.updateTopicsList(by: (notification.object as? TopicFolderWrapper))
    }

    private func setupPageView() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 28).isActive = true
        pageViewController.view.leftAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leftAnchor,
            constant: 0).isActive = true
        pageViewController.view.rightAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.rightAnchor,
            constant: 0).isActive = true
        pageViewController.view.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: 0).isActive = true

        daily = TopicsInRoutineViewController()
        weekly = TopicsInRoutineViewController()
        monthly = TopicsInRoutineViewController()
        daily.topics = myPresenter.dailyTopics
        daily.delegate = self
        daily.title = "Daily"
        weekly.topics = myPresenter.weeklyTopics
        weekly.delegate = self
        weekly.title = "Weekly"
        monthly.topics = myPresenter.monthlyTopics
        monthly.delegate = self
        monthly.title = "Monthly"
        controllers = [daily, weekly, monthly]
        pageViewController.setViewControllers([controllers[0]], direction: .forward, animated: true)
    }
}

extension TopicsListViewController: TopicsInRoutineViewDelegate {
    
    func topicInRoutineView(
        _ view: TopicsInRoutineViewController,
        didSelect topic: TopicFolderWrapper,
        at index: Int) {
        coordinator?.presentTermsScreen(
            folder: topic.folder,
            topic: topic.topic,
            delegateView: self)
    }
}

extension TopicsListViewController: TermsViewDelegate {

    func termsView(_ view: TermsViewController, updated topic: TopicModel, in folder: SetTopicModel) {
        myPresenter.updateTopicsList(by: TopicFolderWrapper(folder: folder, topic: topic))
    }

    func termsView(_ view: TermsViewController, add topic: TopicModel, to folder: SetTopicModel) {
        
    }
}

extension TopicsListViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController) -> UIViewController? {
        titleLabel.text = viewController.title

        guard let currentIndex = controllers.firstIndex(
            of: viewController as! TopicsInRoutineViewController) else { return nil }
        if currentIndex == 0 {
            return controllers.last
        } else {
            return controllers![currentIndex - 1]
        }
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController) -> UIViewController? {
        titleLabel.text = viewController.title
        guard let currentIndex = controllers.firstIndex(
            of: viewController as! TopicsInRoutineViewController) else { return nil }
        if currentIndex < controllers.count - 1 {
            return controllers![currentIndex + 1]
        } else {
            return controllers.first
        }
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        willTransitionTo pendingViewControllers: [UIViewController]) {
//        titleLabel.text = (pageViewController as! TopicsInRoutineViewController).title
            titleLabel.text = pendingViewControllers.first?.title
    }
}

extension TopicsListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentInset.right / view.bounds.width)
    }
}

extension TopicsListViewController: TopicsListViewProtocol, Storyboarded {

    func displayTopics() {
        daily.topics = myPresenter.dailyTopics
        weekly.topics = myPresenter.weeklyTopics
        monthly.topics = myPresenter.monthlyTopics
    }
}
