//
//  TermsPresenter.swift
//  Quizzie
//
//  Created by hieu nguyen on 19/11/2022.
//

import Foundation
import RealmSwift

class TermsPresenter: BasePresenter {
    private let storageService: StorageProtocol
    private let networkVocabularySerivce: NetworkVocabularyProtocol
    private let realmVocabularyService: RealmVocabularyService<PhrasalVerbEntity>
    private var phrasalVerbsFileProvider: (any FileDataProvider)?
    private var dispathQueue = DispatchQueue(
        label: "concurrentQueue",
        attributes: .concurrent)
    var searchDataOfCardDispatchWork: DispatchWorkItem!

    private var topic: TopicModel
    private var folder: SetTopicModel
    private var cards: [any Card]? = []
    private let view: TermsViewProtocol
    
    func getTopic() -> TopicModel {
        return topic
    }
    
    func getFolder() -> SetTopicModel {
        return folder
    }

    init(
        view: TermsViewProtocol,
        set: SetTopicModel,
        topic: TopicModel,
        storageService: StorageProtocol,
        networkVocabularyService: NetworkVocabularyProtocol
    ) {
        self.view = view
        self.topic = topic
        self.folder = set
        self.storageService = storageService
        self.networkVocabularySerivce = networkVocabularyService

        view.showLoadingIndicator()

        phrasalVerbsFileProvider = BundleFileDataProvider<PhrasalVerbList>(
            fileName: "phrasal-verbs",
            extension: "json")
        realmVocabularyService = RealmVocabularyService(realm: RealmProvider.phrasalVerbs.realm!)
        
//        let verbs: [PhrasalVerbWordItem]? = ((try? phrasalVerbsFileProvider?.loadData()) as? PhrasalVerbList)?.list
//        let verbEntities = verbs?.compactMap({
//            return PhrasalVerbEntity(
//                term: $0.word,
//                derivatives: $0.derivatives ?? [],
//                descriptions: $0.descriptions ?? [],
//                examples: $0.examples ?? []
//            )
//        })
//        self.realmVocabularyService.saveMany(items: verbEntities ?? []) { _, _ in
//        }
        cards = []
        view.dismissLoadingIndicator()
    }

    func loadData() {
        view.hideSaveButton()
        view.displayTopicName(name: topic.name)
        getAllTerms()
    }

    func getAllTerms() {
        view.showLoadingIndicator()
        Task {
            do {
                let topicDetails: TopicModel? = try await storageService.getTopicDetails(
                    set: folder,
                    topic: topic
                )
                self.cards = topicDetails?.terms ?? []
                self.topic.terms = topicDetails?.terms
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.view.displayTerms(terms: self.cards ?? [])
                    self.checkIfPracticeEnabled()
                    self.view.dismissLoadingIndicator()
                }
            } catch {
                self.view.dismissLoadingIndicator()
            }
        }
    }
    
    func getWordMeaning(
        card: any Card,
        at cell: TermTableCell,
        forceUpdateCardView: Bool
    ) {
        searchDataOfCardDispatchWork?.cancel()
        guard !card.termDisplay.isEmpty else { return }
        if let index = cards?.firstIndex(where: { $0.idOfCard == card.idOfCard }),
           card.hasRecommendedData,
           card.termDisplay == cards?[index].termDisplay {
            if card.isEqual(card: cards?[index]) {
                view.updateCell(card: card, at: index, needUpdateCardView: false)
            } else {
                updateCardList(card: card)
            }
            return
        }

        searchDataOfCardDispatchWork = DispatchWorkItem(block: {
            if card.termDisplay.components(separatedBy: " ").count == 1 {
                self.getDataOfWord(
                    card: card,
                    cell: cell,
                    needUpdateCardView: forceUpdateCardView
                )
            } else {
                self.getDataOfPhrasalVerbs(card: card, cell: cell, needUpdateCardView: forceUpdateCardView)
            }
        })

        dispathQueue.asyncAfter(
            deadline: .now() + 1,
            execute: searchDataOfCardDispatchWork
        )
    }
    
    func getDataOfPhrasalVerbs(card: any Card, cell: TermTableCell, needUpdateCardView: Bool) {
        DispatchQueue.main.async {
            let result = self.realmVocabularyService.object(
                type: PhrasalVerbEntity.self,
                predicateFormat: "term == %@",
                args: card.termDisplay
            )
            guard let phrasalVerb = result?.first else { return }
            let index = self.updateCardList(card: phrasalVerb)
        }
    }
    
    func getDataOfWord(card: any Card, cell: TermTableCell, needUpdateCardView: Bool) {
        print("😀: \(card.termDisplay)")
        networkVocabularySerivce.getDefination(
            term: card.termDisplay) { [weak self] (wordItem: WordsApiWordItem?, error: Error?) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if let error = error {
                        debugPrint("☠️: \(error.localizedDescription)")
                    } else if var wordItem = wordItem {
                        wordItem.idOfCard = card.idOfCard
//                        wordItem.selectedExample = card.selectedExample
//                        wordItem.selectedDefinition = card.selectedDefinition
                        let ordinalNumber = self.updateCardList(card: wordItem)
                        self.view.updateCell(
                            card: wordItem,
                            at: ordinalNumber ?? 0,
                            needUpdateCardView: needUpdateCardView)
                    }
                }
            }
    }
    
    func addNewCard() {
        cards?.insert(WordsApiWordItem(), at: 0)
        view.addNewCard()
        view.showSaveButton()
    }
    
    @discardableResult
    func updateCardList(card: (any Card)?) -> Int? {
        guard let card = card else { return nil }
        if (cards?.count ?? 0) == 1 && cards?.first?.isEmpty == true || cards == nil {
            cards = [card]
            return nil
        }
        guard let index = cards?.firstIndex(where: { $0.idOfCard == card.idOfCard })
        else {
            debugPrint("‼️ not found term")
            return nil
        }
        let oldCard = cards?[index]
        if card.termDisplay != oldCard?.termDisplay
            || card.selectedExample != oldCard?.selectedExample
            || card.selectedDefinition != oldCard?.selectedDefinition {
            view.showSaveButton()
        }
        cards?[index] = card
        return index
    }

    func topicNameChange(text: String) {
        topic.name = text
        view.showSaveButton()
    }

    func saveTopic() {
        if !topic.topicId.isNotEmpty() {
            Task {
                await createTopic()
            }
        } else {
            updateTopic()
        }

    }

    func createTopic() async {
        view.showLoadingIndicator()
        topic.terms = cards?.map({
            TermModel(
                id: $0.idOfCard,
                term: $0.termDisplay,
                definition: $0.selectedDefinition,
                partOfSpeech: $0.partOfSpeechDisplay,
                pronunciation: $0.phoneticDisplay,
                phrases: $0.selectedExample
            )
        })
        do {
            if let newTopic = try await storageService.createNewTopic(topic, folder: folder) {
                topic = newTopic
                DispatchQueue.main.async {
                    self.checkIfPracticeEnabled()
                }
                folder.topics.append(newTopic)
                NotificationCenter.default.post(name: .updateFolderNotification, object: folder)
            }
            DispatchQueue.main.async {
                self.view.dismissLoadingIndicator()
                self.view.hideSaveButton()
                self.view.createNewTopicSuccess(
                    topic: self.topic,
                    folder: self.folder
                )
            }
        } catch {
            view.dismissLoadingIndicator()
            view.showErrorAlert(msg: error.localizedDescription)
        }
    }

    private func checkIfPracticeEnabled() {
        if (topic.terms ?? []).isEmpty {
            view.disablePracticeButton()
        } else {
            view.enablePracticeButton()
        }
    }

    func updateTopic() {
        view.showLoadingIndicator()
        Task {
            do {
                topic.terms = cards?.map({
                    TermModel(
                        id: $0.idOfCard,
                        term: $0.termDisplay,
                        definition: $0.selectedDefinition,
                        partOfSpeech: $0.partOfSpeechDisplay,
                        pronunciation: $0.phoneticDisplay,
                        phrases: $0.selectedExample
                    )
                })
                _ = try await storageService.updateTopic(topic, folder: folder)

                DispatchQueue.main.async {
                    self.view.hideSaveButton()
                    self.view.saveUpdatedTopicSuccess(
                        topic: self.topic,
                        folder: self.folder
                    )
                    guard let indexOfTopic = self.folder.topics.firstIndex(where: {
                        $0.topicId == self.topic.topicId
                    }) else { return }
                    self.folder.topics[indexOfTopic] = self.topic
                    NotificationCenter.default.post(name: .updateFolderNotification, object: self.folder)
                }
                view.dismissLoadingIndicator()
            } catch {
                view.dismissLoadingIndicator()
                view.showErrorAlert(msg: error.localizedDescription)
            }
        }
    }

    func removeCard(_ card: (any Card)?) {
        if let deleteIndex = cards?.firstIndex(where: { $0.isEqual(card: card) }) {
            cards?.remove(at: deleteIndex)
            view.deleteCard(at: deleteIndex)
        } else {
            cards?.removeFirst()
            view.deleteCard(at: 0)
        }
        view.showSaveButton()
    }

    func numberOfCards() -> Int {
        return cards?.count ?? 0
    }

    func getCard(at index: Int) -> (any Card)? {
        guard !(cards ?? []).isEmpty else { return nil }
        return cards?[index]
    }

    func getAllCards() -> [any Card] {
        return cards ?? []
    }

    func reviewCard(card: any Card) {
        view.reviewCard(card: card)
    }
}
