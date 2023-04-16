//
//  PracticeTermPresenter.swift
//  EngWord
//
//  Created by hieu nguyen on 08/03/2023.
//

import Foundation

class PracticeTermPresenter: PracticeFormPresenter {

    var view: PracticeTermForm
    private var processingCardIndex: Int?
    private var cards: [any Card]!

    var endTestHandler: ((String) -> Void)?

    init(view: (any PracticeFormView), cards: [any Card]) {
        self.cards = cards.shuffled()
        self.view = view as! PracticeTermForm
        if !cards.isEmpty {
            processingCardIndex = 0
        }
    }

    func getProcessingCard() -> (any Card)? {
        guard let index = processingCardIndex, index < cards.count else { return nil }
        return cards[index]
    }

    func getPracticeCards() -> [Card] {
        return cards
    }

    func goToNextCard() {
        processingCardIndex! += 1
        guard let card = getProcessingCard() else {
            if processingCardIndex == cards.count {
                endTestHandler?("")
            }
            return
        }
        updateProgressOfRound()
        view.displayCard(card: card)

    }

    private func updateProgressOfRound() {
        guard let index = processingCardIndex else { return }
        view.updateRoundProgress(value: Float(index) / Float(cards.count))
    }

//    lazy var showCorrectMessage: DispatchWorkItem = {
//        return DispatchWorkItem {
//            self.goToNextCard()
//            self.view.hideResultMessage()
//        }
//    }()

    func checkAnswer(answer: String) {
        guard let card = getProcessingCard() else { return }
        let isAnswerCorrect = answer == card.termDisplay
        let textColor = isAnswerCorrect ? Colors.correct : Colors.incorrect
//        let message = "\(answer) is a \(isAnswerCorrect ? "correct" : "incorrect") answer"
        
        let message = isAnswerCorrect ? "Well done. Hurrayb" : "Oh no. Please try later"
        guard let attributeString = message.hightLight(text: message, colorHighlight: textColor) else { return }

        let msgAttributeString = NSAttributedString(string: "Well Done", attributes: [
            NSAttributedString.Key.foregroundColor: isAnswerCorrect ? Colors.correct : Colors.incorrect,
            NSAttributedString.Key.font: Fonts.bigTitle
        ])
        view.showTurnResult(msg: attributeString, result: isAnswerCorrect ? .correct : .incorrect)
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1700), execute: showCorrectMessage)
    }

    func answerEditingChanged(_ answer: String) {
        if answer.isEhmpty {
            view.disableNextButton()
        } else {
            view.enableNextButton()
        }
    }
}
