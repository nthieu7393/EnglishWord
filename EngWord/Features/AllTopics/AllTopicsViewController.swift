// 
//  AllTopicsViewController.swift
//  EngWord
//
//  Created by hieu nguyen on 17/02/2023.
//

import UIKit

final class AllTopicsViewController: BaseViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var newTopicButton: ResponsiveButton!
    @IBOutlet weak var topicIconImageView: UIImageView!
    @IBOutlet private weak var tableView: UITableView!

    weak var delegate: AllTopicsViewDelegate?
    private var selectedTopics: [TopicModel]?
    private var allTopics: [TopicModel]?

    var myPresenter: AllTopicsPresenter? {
        return presenter as? AllTopicsPresenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Colors.mainBackground
        titleLabel.text = Localizations.allTopics
        titleLabel.font = Fonts.title
        titleLabel.textColor = Colors.mainText
        tableView.registerRow(TopicTableViewCell.self)
        newTopicButton.title = "Create New"
        topicIconImageView.image = R.image.paperIcon()?.withRenderingMode(.alwaysTemplate)
        topicIconImageView.tintColor = Colors.mainText
    }

    @IBAction func createButtonOnTap(_ sender: ResponsiveButton) {
        guard let folder = myPresenter?.folder else { return }
        delegate?.allTopicsView(self, didTap: sender, folder: folder)
    }
}

extension  AllTopicsViewController: AllTopicsViewProtocol, Storyboarded {

    func displayTopics(topics: [TopicModel], highlightTopics: [TopicModel]) {

    }
}

extension AllTopicsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPresenter?.numberOfTopics() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(TopicTableViewCell.self, for: indexPath)
                else { return UITableViewCell() }
        cell.setData(topic: myPresenter!.topic(at: indexPath.row))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myPresenter?.didSelectTopic(index: indexPath.row)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        myPresenter?.didDeselectTopic(index: indexPath.row)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
