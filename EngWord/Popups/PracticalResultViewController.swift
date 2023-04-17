//
//  PracticalResult.swift
//  EngWord
//
//  Created by hieu nguyen on 10/03/2023.
//

import UIKit

protocol PracticalResultPopupDelegate: AnyObject {

    func practicalResultPopup(
        _ popup: PracticalResultViewController,
        onTap doneButton: TextButton
    )
}

class PracticalResultViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var correctAnswerCountLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var yourResultLabel: UILabel!
    @IBOutlet weak var yourAnswerLabel: UILabel!
    var allResults: [QuizResult]? {
        didSet {

        }
    }
    weak var delegate: PracticalResultPopupDelegate?

//    @IBAction func doneButtonOnTap(_ sender: TextButton) {
//        delegate?.practicalResultPopup(self, onTap: sender)
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        correctAnswerCountLabel.font = Fonts.regularText
        correctAnswerCountLabel.textColor = Colors.mainText

        let correctCount = allResults?.filter({
            $0.isCorrect
        }).count
        correctAnswerCountLabel.text = "\(correctCount ?? 0)/\(allResults?.count ?? 0)"
        progressBar.progress = Float(correctCount ?? 0)/Float(allResults?.count ?? 1)

        yourResultLabel.font = Fonts.subtitle
        yourAnswerLabel.font = Fonts.subtitle
        yourResultLabel.text = "Your result"
        yourAnswerLabel.text = "Your sanswers"
    }
}

extension PracticalResultViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension PracticalResultViewController: UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allResults?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(
            PracticeResultTableViewCell.self,
            for: indexPath) else {
            return UITableViewCell()
        }
        cell.setData(quizResult: allResults?[indexPath.row])
        return cell
    }
}
