// 
//  LearnTopicPresenter.swift
//  EngWord
//
//  Created by hieu nguyen on 21/02/2023.
//

import Foundation

final class LearnTopicPresenter: BasePresenter {
    
    private var view: LearnTopicViewProtocol?

    private var cards: [Card]!
    
    init(view: LearnTopicViewProtocol, cards: [Card]) {
        self.view = view
        self.cards = cards
    }

    func loadData() {
        
    }

    func numberOfCards() -> Int {
        return cards.count
    }

    func cardAt(index: Int) -> Card {
        return cards[index]
    }
}
