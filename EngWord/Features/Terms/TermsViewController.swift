//
//  TermsViewController.swift
//  Quizzie
//
//  Created by hieu nguyen on 19/11/2022.
//

import UIKit

protocol TermsViewDelegate: AnyObject {

    func termsView(
        _ view: TermsViewController,
        updated topic: TopicModel,
        in folder: SetTopicModel)
    func termsView(
        _ view: TermsViewController,
        add topic: TopicModel,
        to folder: SetTopicModel)
}

class TermsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: ResponsiveButton!
    @IBOutlet weak var topicNameTextField: UnderlineTextField!
    @IBOutlet weak var practiceButton: IconTextButton!
    @IBOutlet weak var topicNameLabel: UILabel!

    weak var delegate: TermsViewDelegate?

    private var heightOfRowCache: [IndexPath: CGFloat] = [:]

    lazy var suggestionTableView: UITableView? = {
        let tableView = UITableView()
        return tableView
    }()

    lazy var sectionHeaderView: UIView = {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        header.backgroundColor = Colors.mainBackground
        return header
    }()

    lazy var newTermButton: TextButton = {
        let button = TextButton("+ New Term", frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 28))
        button.addTarget(self, action: #selector(newTermOnTap), for: .touchUpInside)
        return button
    }()

    private var termsPresenter: TermsPresenter! {
        return presenter as? TermsPresenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Localizations.term
        suggestionTableView?.dataSource = self
        suggestionTableView?.delegate = self
        doneButton.title = Localizations.done
        tableView.registerRow(TermActivitiesTableCell.self)
        termsPresenter.loadData()
        practiceButton.set(icon: R.image.bookOpenIcon()!, title: "Practice")
        practiceButton.isEnabled = false
        doneButton.title = Localizations.done
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }

    override func layoutIfKeyboardShow(keyboardSize: CGRect) {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 50, right: 0)
    }

    override func layoutIfKeyboardHide(keyboardSize: CGRect) {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }

    override func setupFontText() {
        topicNameLabel.attributedText = NSAttributedString(string: "Topic Name", attributes: [
            NSAttributedString.Key.foregroundColor: Colors.mainText,
            NSAttributedString.Key.font: Fonts.subtitle
        ])
        topicNameTextField.attributedPlaceholder = NSAttributedString(string: "What your topic name ?", attributes: [
            NSAttributedString.Key.foregroundColor: Colors.unFocused,
            NSAttributedString.Key.font: Fonts.regularText
        ])
    }

    @IBAction func doneButtonOnTap(_ sender: ResponsiveButton) {
        termsPresenter?.saveTopic()
        view.endEditing(true)
    }

    @IBAction func topicNameOnChange(_ sender: UnderlineTextField) {
        termsPresenter.topicNameChange(text: topicNameTextField.text ?? "")
    }

    @IBAction func practiceButtonOnTap(_ sender: IconTextButton) {
        coordinator?.presentPracticeTopicScreen(
            from: self,
            cards: termsPresenter.getAllCards(),
            topic: termsPresenter.getTopic(),
            folder: termsPresenter.getFolder()
        )
    }
}

extension TermsViewController: Storyboarded {}

extension TermsViewController: TermsViewProtocol {

    func reviewCard(card: Card) {
        coordinator?.goToReviewCardScreen(
            from: self,
            delegate: self,
            card: card,
            cards: termsPresenter.getAllCards()
        )
    }

    func showSaveButton() {
        doneButton.isHidden = false
    }

    func hideSaveButton() {
        doneButton.isHidden = true
    }

    func displayTerms(terms: [any Card]) {
        tableView.reloadData()
    }

    func deleteCard(at row: Int) {
        tableView.beginUpdates()
        tableView.deleteRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
        tableView.endUpdates()
    }

    func addNewCard() {
        let firstIndexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [firstIndexPath], with: .automatic)
        tableView.scrollToRow(at: firstIndexPath, at: .top, animated: true)
    }

    func displayTopicName(name: String) {
        topicNameTextField.text = name
    }

    func updateCell(card: any Card, at index: Int, needUpdateCardView: Bool) {
        guard let cell = tableView.cellForRow(
            at: IndexPath(row: index, section: 0)) as? TermTableCell else { return }
        cell.setCard(
            term: card,
            delegate: self,
            forceUpdateUI: needUpdateCardView)
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    func enablePracticeButton() {
        practiceButton.isEnabled = true
    }

    func disablePracticeButton() {
        practiceButton.isEnabled = false
    }

    func saveUpdatedTopicSuccess(topic: TopicModel, folder: SetTopicModel) {
        delegate?.termsView(self, updated: topic, in: folder)
    }
    func createNewTopicSuccess(topic: TopicModel, folder: SetTopicModel) {
        delegate?.termsView(self, add: topic, to: folder)
    }
}

extension TermsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if var height = heightOfRowCache[indexPath],
           let cell = tableView.cellForRow(at: indexPath) as? TermTableCell {
            if cell.visibleRecommendedDefinitions {
                height += cell.dynamicRecommendedDefinitionHeight
            }
            if cell.visibleRecommendedExamples {
                height  += cell.dynamicRecommendedExampleHeight
            }
            return height
        }
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return termsPresenter.numberOfCards()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(
            TermTableCell.self,
            for: indexPath) else {
            return UITableViewCell()
        }
        cell.setCard(
            term: termsPresenter.getCard(at: indexPath.row), delegate: self
        )
        heightOfRowCache[indexPath] = cell.bounds.height

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        sectionHeaderView.addSubview(newTermButton)
        newTermButton.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            newTermButton.topAnchor.constraint(equalTo: sectionHeaderView.topAnchor, constant: 10),
            newTermButton.leftAnchor.constraint(equalTo: sectionHeaderView.leftAnchor),
            sectionHeaderView.bottomAnchor.constraint(equalTo: newTermButton.bottomAnchor, constant: 8),
            newTermButton.rightAnchor.constraint(equalTo: sectionHeaderView.rightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        return sectionHeaderView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        heightOfRowCache[indexPath] = cell.bounds.height
    }

    @objc func newTermOnTap() {
        termsPresenter?.addNewCard()
    }
}

extension TermsViewController: UITableViewDelegate {

}

extension TermsViewController: TermActivitiesCellDelegate {

    func termActivitiesCell(_ cell: TermActivitiesTableCell, didSelect activity: TermActivitiesCellModel) {
        activity.handler()
    }
}

extension TermsViewController: TermTableCellDelegate {

    func cardTableCell(_ cell: TermTableCell, didUpdate card: Card) {
        heightOfRowCache.removeAll()
        tableView.beginUpdates()
        tableView.endUpdates()
        termsPresenter.updateCardList(card: card)
    }

    func cardTableCell(_ cell: TermTableCell, onDelete card: (any Card)?) {
        termsPresenter?.removeCard(card)
    }

    func updateHeightOfRow(_ cell: TermTableCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = tableView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
            //            if let indexPath = tableView.indexPath(for: cell) {
            //                tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            //            }
        }
    }

    func cardTableCell(
        _ cell: TermTableCell,
        didUpdate card: any Card,
        forceUpdateUI: Bool,
        loadRecommendation: Bool
    ) {
        if loadRecommendation {
            termsPresenter?.getWordMeaning(
                card: card,
                at: cell,
                forceUpdateCardView: forceUpdateUI
            )
        } else {
            heightOfRowCache.removeAll()
            tableView.beginUpdates()
            tableView.endUpdates()
            termsPresenter.updateCardList(card: card)
        }
    }

    func cardTableCell(_ cell: TermTableCell, onReview card: (any Card)) {
        termsPresenter.reviewCard(card: card)
    }

    func cardTableCell(_ cell: TermTableCell, didTapPartOfSpeech card: (Card)?) {
        guard let card = card else { return }
        coordinator?.presentPartOfSpeechMenuScreen(from: self, card: card, delegateScreen: self)
    }

    func cardTableCell(_ cell: TermTableCell) {
        heightOfRowCache.removeAll()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension TermsViewController: PartOfSpeechMenuViewControllerDelegate {

    func partOfSpeechMenu(
        _ view: PartOfSpeechMenuViewController,
        didUpdatePartOfSpeech card: (any Card)?) {
            guard let index = termsPresenter.updateCardList(card: card) else { return }
            let indexPath = IndexPath(row: index, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as? TermTableCell
            cell?.setCard(term: card, delegate: self)
            coordinator?.dismissScreen(self)
        }
}

extension TermsViewController: ReviewCardDelegate {

    func reviewCardScreen(_ screen: ReviewCardViewProtocol, onReview card: (Card)) {
        
    }
}
