//
//  PracticeDescriptionPresenter.swift
//  EngWord
//
//  Created by hieu nguyen on 08/03/2023.
//

import Foundation

class PracticeDescriptionPresenter: PracticeFormPresenter {

    var view: (any PracticeFormView)!
    private var processingCardIndex: Int?
    private var allCards: [Card]!
    private var unseenCards: [any Card]!
    private let numberOfCardsEachTurn = 2
    private var numberOfAnswers = 0
    private var answeredCards: [TurnResult] = []

    var endTestHandler: ((String) -> Void)?

    init(view: (any PracticeFormView), cards: [Card]) {
        self.view = view
        self.allCards = []
        if !cards.isEmpty {
            processingCardIndex = 0
            self.allCards = cards.shuffled()
            self.unseenCards = self.allCards
        }
    }

    func getProcessingCard() -> (any Card)? {
        return nil
    }

    func getCard(at index: Int) -> (any Card)? {
        return unseenCards?[index]
    }

    func getUnseenCardsPerSession() -> [Card] {
        guard unseenCards.count >= numberOfCardsEachTurn else {
            return unseenCards
        }
        let cards = Array(unseenCards.prefix(numberOfCardsEachTurn))
        return Array(cards)
    }

    func getPracticeCards() -> [Card] {
        return getUnseenCardsPerSession()
    }

    func getAnswersOfCards() -> [String] {
        return getUnseenCardsPerSession().map {
            $0.termDisplay.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }

    func answer(_ card: Card?, answer: String) {
        guard let card = card else { return }
        answeredCards.append(card.termDisplay == answer ? .correct : .incorrect)
        let quizResult = QuizResult(
            round: 2,
            question: card.selectedDefinition ?? "",
            result: card.termDisplay,
            answer: answer)
        view.showTurnResult(
            msg: nil,
            result: card.termDisplay == answer ? .correct : .incorrect,
            quizResult: quizResult)
        numberOfAnswers += 1
        let numberOfCardsInProgress = min(unseenCards.count, numberOfCardsEachTurn)
        if numberOfAnswers == numberOfCardsInProgress {
            unseenCards.removeFirst(numberOfCardsInProgress)
            if unseenCards.isEmpty {
                endTestHandler?("")
            } else {
                let isPass = checkResultOfTurnIsPass(answeredCards)
                let text = isPass ? "Good" : "Not Good"
                let msg = NSAttributedString(string: text, attributes: [
                    NSAttributedString.Key.font: Fonts.boldText,
                    NSAttributedString.Key.foregroundColor: Colors.mainText
                ])
//                view.showTurnResult(msg: msg, result: checkResultOfTurnIsPass(answeredCards) ? TurnResult.correct : TurnResult.incorrect,
//                    quizResult: <#T##QuizResult#>)
                numberOfAnswers = 0
            }
        }
    }

    func checkResultOfTurnIsPass(_ answeredCards: [TurnResult]) -> Bool {
        let correctAnswers = answeredCards.filter {
            $0 == .correct
        }.count
        let inCorrectAnswers = answeredCards.count - correctAnswers
        return correctAnswers > inCorrectAnswers
    }
}
