//
//  TermsView.swift
//  Quizzie
//
//  Created by hieu nguyen on 19/11/2022.
//

import UIKit

protocol TermsViewProtocol: BaseViewProtocol {

    func displayTerms(terms: [any Card])
    func deleteCard(at row: Int)
    func addNewCard()
    func displayTopicName(name: String)
    func showSaveButton()
    func hideSaveButton()
    func reviewCard(card: any Card)
    func updateCell(card: any Card, at index: Int, needUpdateCardView: Bool)
    func enablePracticeButton()
    func disablePracticeButton()
    func saveUpdatedTopicSuccess(topic: TopicModel, folder: SetTopicModel)
    func createNewTopicSuccess(topic: TopicModel, folder: SetTopicModel)
}
