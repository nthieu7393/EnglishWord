// 
//  PartOfSpeechMenuViewController.swift
//  EngWord
//
//  Created by hieu nguyen on 13/03/2023.
//

import UIKit

protocol PartOfSpeechMenuViewControllerDelegate: AnyObject {

    func partOfSpeechMenu(_ view: PartOfSpeechMenuViewController, didUpdatePartOfSpeech card: (any Card)?)
}

final class PartOfSpeechMenuViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var myPresenter: PartOfSpeechMenuPresenter? {
        return presenter as? PartOfSpeechMenuPresenter
    }

    weak var delegate: PartOfSpeechMenuViewControllerDelegate?

    override var forceHideDismissButton: Bool {
        return true
    }
    
    @IBAction func doneButtonOnTap(_ sender: TextButton) {
        dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = Colors.separatorLine
    }
}

extension PartOfSpeechMenuViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPresenter?.getAllPartOfSpeech().count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let current = myPresenter?.getItem(at: indexPath.row)
        guard let cell = tableView.dequeueCell(PartOfSpeechTableCell.self, for: indexPath) else { return UITableViewCell() }
        let attributeString = NSAttributedString(string: myPresenter?.getItem(at: indexPath.row).rawValue ?? "", attributes: [
            NSAttributedString.Key.font: current == myPresenter?.selectedPartOfSpeech ? Fonts.boldText : Fonts.mediumText,
            NSAttributedString.Key.foregroundColor: current == myPresenter?.selectedPartOfSpeech ? Colors.active : Colors.mainText
        ])
        cell.setTitle(attributeString: attributeString, indexpath: indexPath)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myPresenter?.changeSelectedPartOfSpeech(index: indexPath.row)
        delegate?.partOfSpeechMenu(self, didUpdatePartOfSpeech: myPresenter?.getCard())
    }
}

extension PartOfSpeechMenuViewController: PartOfSpeechMenuViewProtocol, Storyboarded {

    func reloadCell(at index: Int) {
        tableView.reloadData()
    }
}

extension PartOfSpeechMenuViewController: PartOfSpeechTableCellDelegate {

    func partOfSpeechCell(_ cell: PartOfSpeechTableCell, didSelectCellAt indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        myPresenter?.changeSelectedPartOfSpeech(index: indexPath.row)
        delegate?.partOfSpeechMenu(self, didUpdatePartOfSpeech: myPresenter?.getCard())
    }
}
