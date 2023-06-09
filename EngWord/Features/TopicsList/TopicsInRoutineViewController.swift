//
//  TopicsInRoutineViewController.swift
//  EngWord
//
//  Created by hieu nguyen on 04/04/2023.
//

import UIKit

protocol TopicsInRoutineViewDelegate: AnyObject {

    func topicInRoutineView(
        _ view: TopicsInRoutineViewController,
        didSelect topic: TopicFolderWrapper,
        at index: Int)
}

class TopicsInRoutineViewController: UIViewController {

    var titleString: String?
    weak var delegate: TopicsInRoutineViewDelegate?
    lazy var tableView: UITableView = {
        let tbv = UITableView()
        return tbv
    }()

    var topics: [TopicFolderWrapper] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.mainBackground
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none

        tableView.registerRow(TopicInRoutineTableCell.self)

        tableView.dataSource = self
        tableView.delegate = self

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(practiceNotificationReceived(_:)),
            name: .practiceFinishNotification,
            object: nil
        )
        
        tableView.registerRow(NoDataTableCell.self)
    }
    
    @objc
    func practiceNotificationReceived(_ notification: Notification) {
        guard let topicFolder = notification.object as? TopicFolderWrapper else {
            return
        }
        guard let index = topics.firstIndex(where: {
            $0.topic == topicFolder.topic
        }) else { return }
        topics[index] = topicFolder
        tableView.reloadData()
    }
}

extension TopicsInRoutineViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(topics.count, 1)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if topics.isEmpty {
            guard let cell = tableView.dequeueCell(NoDataTableCell.self, for: indexPath) else { return UITableViewCell() }
            return cell
        }
        guard let cell = tableView.dequeueCell(TopicInRoutineTableCell.self, for: indexPath) else {
            return UITableViewCell()
        }

        cell.delegate = self
        cell.setData(topic: topics[indexPath.row])
        cell.tag = indexPath.row
        return cell
    }
}

extension TopicsInRoutineViewController: TopicInRoutineTableCellDelegate {

    func topicInRoutineCell(_ view: TopicInRoutineTableCell, didTap startButton: ResponsiveButton) {
        self.delegate?.topicInRoutineView(
            self,
            didSelect: self.topics[view.tag],
            at: view.tag
        )
    }
}
