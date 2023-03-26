// 
//  PartOfSpeechMenuPresenter.swift
//  EngWord
//
//  Created by hieu nguyen on 13/03/2023.
//

import Foundation

final class PartOfSpeechMenuPresenter: BasePresenter {
    
    private var view: PartOfSpeechMenuViewProtocol?
    private var card: (any Card)?

    func getCard() -> (any Card)? {
        return card
    }

    var selectedPartOfSpeech: PartOfSpeech? {
        return PartOfSpeech(rawValue: card?.partOfSpeechDisplay ?? "")
    }

    private let allPartOfSpeech: [PartOfSpeech] = [
        .noun,
        .verb,
        .adjective,
        .adverb
    ]
    
    init(view: PartOfSpeechMenuViewProtocol, card: (any Card)?) {
        self.view = view
        self.card = card
    }

    func getAllPartOfSpeech() -> [PartOfSpeech] {
        return allPartOfSpeech
    }

    func getItem(at index: Int) -> PartOfSpeech {
        return allPartOfSpeech[index]
    }

    func changeSelectedPartOfSpeech(index: Int) {
        card?.partOfSpeechDisplay = allPartOfSpeech[index].rawValue
        print("\(card?.partOfSpeechDisplay)")
    }
}
