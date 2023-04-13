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

        tableView.registerRow(NoDataTableCell.self)
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
        cell.setData(topic: topics[indexPath.row])
        cell.onTap = {
            self.delegate?.topicInRoutineView(self, didSelect: self.topics[indexPath.row], at: indexPath.row)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < topics.count else { return }
        delegate?.topicInRoutineView(self, didSelect: topics[indexPath.row], at: indexPath.row)
    }
}
