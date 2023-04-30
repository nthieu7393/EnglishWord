//
//  TermsPresenter.swift
//  Quizzie
//
//  Created by hieu nguyen on 19/11/2022.
//

import Foundation
import RealmSwift
import AVFAudio

enum AudioFolderDirectory: String {
    case main, remove, add

    func url(folder: SetTopicModel, topic: TopicModel) -> URL? {
        return try? Path.inLibrary("\(folder.id ?? "")/\(topic.topicId ?? "")").appendingPathComponent("\(self.rawValue)")
    }
}

class TermsPresenter: BasePresenter {
    private let storageService: StorageProtocol
    private let networkVocabularySerivce: NetworkVocabularyProtocol
//    private let realmVocabularyService: RealmVocabularyService<PhrasalVerbEntity>
    private var phrasalVerbsFileProvider: (any FileDataProvider)?
    private var dispathQueue = DispatchQueue(
        label: "concurrentQueue",
        attributes: .concurrent)
    var searchMeaningOfCarddDispatchWork: DispatchWorkItem!

    private var topic: TopicModel
    private var folder: SetTopicModel
    private var cards: [any Card]? = []
    private let view: TermsViewProtocol
    private let fileManager = FileManager.default
    private var pronunciationPlayer: AVAudioPlayer?

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
//        realmVocabularyService = RealmVocabularyService(realm: RealmProvider.phrasalVerbs.realm!)
        
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

    func backToPreviousScreen() {
        if let addUrl = AudioFolderDirectory.add.url(folder: folder, topic: topic) {
            removeFolder(url: addUrl)
        }

        if let removeUrl = AudioFolderDirectory.remove.url(folder: folder, topic: topic),
           let mainUrl = AudioFolderDirectory.main.url(folder: folder, topic: topic) {
            moveFilesToFolder(at: removeUrl, toUrl: mainUrl)
        }
    }

    func playAudio(card: Card) {
        if let url = card.audioFilePath(folder: folder, topic: topic),
           fileManager.fileExists(atPath: url.relativePath) {
            do {
                pronunciationPlayer = try AVAudioPlayer(contentsOf: url)
                pronunciationPlayer?.play()
            } catch {
                debugPrint(error.localizedDescription)
            }
        } else {
            if let url = AudioFolderDirectory.add.url(folder: folder, topic: topic)?.appendingPathComponent(card.audioFileName) {
                do {
                    pronunciationPlayer = try AVAudioPlayer(contentsOf: url)
                    pronunciationPlayer?.play()
                } catch {
                    debugPrint(error.localizedDescription)
                }
            }
        }
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
        view.disableNewTerm()
        searchMeaningOfCarddDispatchWork?.cancel()
        guard !card.termDisplay.isEmpty else { return }
        if let index = cards?.firstIndex(where: { $0.idOfCard == card.idOfCard }),
           card.hasRecommendedData,
           card.termDisplay == cards?[index].termDisplay {
            if card.isEqual(card: cards?[index]) {
                view.updateCell(card: card, at: index, needUpdateCardView: false)
                view.enableNewTerm()
            } else {
                updateCardList(card: card)
            }
            return
        }

        searchMeaningOfCarddDispatchWork = DispatchWorkItem(block: {
            if card.termDisplay.components(separatedBy: " ").count == 1 {
                self.getDataOfSingleWord(
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
            execute: searchMeaningOfCarddDispatchWork
        )
    }
    
    func getDataOfSingleWord(card: any Card, cell: TermTableCell, needUpdateCardView: Bool) {
        debugPrint("💩💩💩💩: get data of word: \(card.termDisplay)")
        networkVocabularySerivce.getDefination(
            term: card.termDisplay,
            onComplete: {[weak self] (wordItem: OxfordWordItem?, error: Error?) in
                guard let self = self else { return }
                if let error = error {
                    debugPrint("☠️: \(error.localizedDescription)")
                } else if var wordItem = wordItem {
                    wordItem.idOfCard = card.idOfCard
                    if card.termDisplay != wordItem.termDisplay {
                        removeAudioFileOfPreviousCard(card: card)
                    }
                    // Download Audio
                    if !wordItem.isAudioFileExists(folder: self.folder, topic: self.topic) {
                        self.downloadAudioPronunciation(
                            downloadUrl: URL(string: wordItem.pronunciation?.audioFile ?? "")!,
                            card: wordItem
                        ) {
                            self.updateItemOfListCards(
                                card: wordItem,
                                cell: cell,
                                updateCardView: needUpdateCardView
                            )
                        }
                    } else {
                        self.updateItemOfListCards(
                            card: wordItem,
                            cell: cell,
                            updateCardView: needUpdateCardView
                        )
                    }
                }
            })
    }

    // move all files of folder to new folder
    private func moveFilesToFolder(at url: URL, toUrl: URL) {
        do {
            let fileUrls = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            for url in fileUrls {
                try fileManager.moveItem(at: url, to: toUrl.appendingPathComponent(url.lastPathComponent))
            }
            removeFolder(url: url)
        } catch {
            debugPrint("😓: \(error.localizedDescription)")
        }
    }

    // remove folder
    private func removeFolder(url: URL) {
        do {
            if fileManager.fileExists(atPath: url.relativePath) {
                try fileManager.removeItem(at: url)
            }
        } catch {
            debugPrint("😓: \(error.localizedDescription)")
        }
    }

    // remove audio
    private func removeAudioFileOfPreviousCard(card: Card) {
        guard let currentPath = card.audioFilePath(folder: folder, topic: topic),
              let removeDirectory = directoryOfAudioPronunciation(audioDirectory: .remove) else {
            return
        }
        try? fileManager.moveItem(at: currentPath, to: removeDirectory.appendingPathComponent("\(card.audioFileName)"))
    }

    // new audio
    private func downloadAudioPronunciation(
        downloadUrl: URL,
        card: Card,
        completionHandler: @escaping (() -> Void)
    ) {
        let session = URLSession(configuration: .default)
        let request = URLRequest(url: downloadUrl)
        let downloadTask = session.downloadTask(with: request) { localUrl, _, error in
            guard let localUrl = localUrl else { return }
            guard error == nil else { return }
            do {
                guard let saveUrl = self.directoryOfAudioPronunciation(audioDirectory: .add) else { return }
                try self.fileManager.moveItem(at: localUrl, to: saveUrl.appendingPathComponent(card.audioFileName))
                completionHandler()
            } catch {
                print("Error saving file: \(error.localizedDescription)")
            }
        }
        downloadTask.resume()
    }

    private func directoryOfAudioPronunciation(audioDirectory: AudioFolderDirectory) -> URL? {
        if let url = try? Path.inLibrary("\(folder.id ?? "")/\(topic.topicId ?? "")/\(audioDirectory.rawValue)") {
            guard !fileManager.fileExists(atPath: url.relativePath) else { return url }
            do {
                try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
                return url
            } catch {
                print("😓: \(error.localizedDescription)")
                return nil
            }
        }
        return nil
    }

    private func updateItemOfListCards(card: Card, cell: TermTableCell, updateCardView: Bool) {
        let ordinalNumber = self.updateCardList(card: card)
        DispatchQueue.main.async {
            self.view.updateCell(
                card: card,
                at: ordinalNumber ?? 0,
                needUpdateCardView: updateCardView
            )
            self.view.enableNewTerm()
        }
    }

    func getDataOfPhrasalVerbs(card: any Card, cell: TermTableCell, needUpdateCardView: Bool) {
//        DispatchQueue.main.async {
//            let result = self.realmVocabularyService.object(
//                type: PhrasalVerbEntity.self,
//                predicateFormat: "term == %@",
//                args: card.termDisplay
//            )
//            guard let phrasalVerb = result?.first else { return }
//            let index = self.updateCardList(card: phrasalVerb)
//        }
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
            updateAudioFilesInFolder()
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

                updateAudioFilesInFolder()

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

    private func updateAudioFilesInFolder() {
        if let url = AudioFolderDirectory.remove.url(folder: folder, topic: topic) {
            removeFolder(url: url)
        }
        if let addUrl = AudioFolderDirectory.add.url(folder: folder, topic: topic),
           let mainUrl = directoryOfAudioPronunciation(audioDirectory: .main) {
            moveFilesToFolder(at: addUrl, toUrl: mainUrl)
        }
    }

    func removeCard(_ card: (any Card)?) {
        if let deleteIndex = cards?.firstIndex(where: { $0.isEqual(card: card) }) {
            if let removedCard = cards?.remove(at: deleteIndex) {
                if card?.isAudioFileExists(folder: folder, topic: topic) ?? false {
                    removeAudioFileOfPreviousCard(card: removedCard)
                } else {

                    if let audioName = card?.audioFileName,
                       let path = directoryOfAudioPronunciation(audioDirectory: .add) {
                        if fileManager.fileExists(atPath: path.appendingPathComponent(audioName).relativePath) {
                            try? fileManager.removeItem(atPath: path.appendingPathComponent(audioName).relativePath)
                        }
                    }
                }
            }
            view.deleteCard(at: deleteIndex)
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
