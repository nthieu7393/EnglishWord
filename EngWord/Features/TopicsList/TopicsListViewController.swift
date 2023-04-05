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
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        pageViewController.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        pageViewController.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        pageViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true

        daily = TopicsInRoutineViewController()
        weekly = TopicsInRoutineViewController()
        monthly = TopicsInRoutineViewController()
        daily.topics = myPresenter.dailyTopics ?? []
        daily.delegate = self
        weekly.topics = myPresenter.weeklyTopics ?? []
        weekly.delegate = self
        monthly.topics = myPresenter.monthlyTopics ?? []
        monthly.delegate = self
        controllers = [daily, weekly, monthly]
        pageViewController.setViewControllers([controllers[0]], direction: .forward, animated: true)
    }
}

extension TopicsListViewController: TopicsInRoutineViewDelegate {
    
    func topicInRoutineView(_ view: TopicsInRoutineViewController, didSelect topic: TopicFolderWrapper, at index: Int) {
        coordinator?.presentTermsScreen(folder: topic.folder, topic: topic.topic, delegateView: self)
    }
}

extension TopicsListViewController: TermsViewDelegate {

    func termsView(_ view: TermsViewController, updated topic: TopicModel, in folder: SetTopicModel) {

    }

    func termsView(_ view: TermsViewController, add topic: TopicModel, to folder: SetTopicModel) {

    }
}

extension TopicsListViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = controllers.firstIndex(
            of: viewController as! TopicsInRoutineViewController) else { return nil }
        if currentIndex == 0 {
            return controllers.last
        } else {
            return controllers![currentIndex - 1]
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = controllers.firstIndex(
            of: viewController as! TopicsInRoutineViewController) else { return nil }
        if currentIndex < controllers.count - 1 {
            return controllers![currentIndex + 1]
        } else {
            return controllers.first
        }
    }
}

extension  TopicsListViewController: TopicsListViewProtocol, Storyboarded {

    func displayTopics() {
        daily.topics = myPresenter.dailyTopics
        weekly.topics = myPresenter.weeklyTopics
        monthly.topics = myPresenter.monthlyTopics
    }
}
