//
//  PracticeResultTableViewCell.swift
//  EngWord
//
//  Created by hieu nguyen on 18/04/2023.
//

import UIKit

class PracticeResultTableViewCell: BaseTableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.backgroundColor = Colors.cellBackground
        containerView.addCornerRadius()
        questionLabel.font = Fonts.title
        questionLabel.textColor = Colors.mainText
        answerLabel.font = Fonts.regularText
        resultLabel.font = Fonts.regularText
        resultLabel.textColor = Colors.mainText

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(quizResult: QuizResult?) {
        guard let quizResult = quizResult else { return }
        answerLabel.textColor = quizResult.isCorrect ? Colors.correct : Colors.incorrect
        answerLabel.text = "Your answer: \(quizResult.answer)"
        resultLabel.text = quizResult.result
        questionLabel.text = quizResult.question
    }
}
