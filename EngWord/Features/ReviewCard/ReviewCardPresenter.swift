// 
//  ReviewCardPresenter.swift
//  EngWord
//
//  Created by hieu nguyen on 23/02/2023.
//

import Foundation

final class ReviewCardPresenter: BasePresenter {
    
    private var view: ReviewCardViewProtocol?
    private var cards: [any Card]!
    private var currentCard: (any Card)!
    
    init(view: ReviewCardViewProtocol, cards: [any Card], currentCard: any Card) {
        self.view = view
        self.cards = cards
        self.currentCard = currentCard
    }

    func viewLoaded() {
        let indexOfCard = cards.firstIndex {
            $0.isEqual(card: currentCard)
        }
        view?.moveToCard(at: indexOfCard!)
        view?.displayIndicatorNumber(text: "\(indexOfCard! + 1)/\(cards.count)")
    }

    func getNumberOfCards() -> Int {
        return cards.count
    }

    func getCard(at index: Int) -> (any Card)? {
        guard !cards.isEmpty else { return nil }
        return cards[index]
    }

    func udpateIndicatorNumber(number: CGFloat) {
        view?.displayIndicatorNumber(text: "\(Int(number))/\(cards.count)")
    }
}
