// 
//  PracticeTopicPresenter.swift
//  EngWord
//
//  Created by hieu nguyen on 24/02/2023.
//

import Foundation

final class PracticeTopicPresenter: BasePresenter {
    
    private var view: PracticeTopicViewProtocol?
    private let storageService: StorageProtocol
    private var practicalFormControllers: [any PracticeFormView]!
    private var practiceRound: Int = 0
    private let topic: TopicModel
    private let folder: SetTopicModel
    
    private let cards: [any Card]
    
    init(
        view: PracticeTopicViewProtocol,
        storageService: StorageProtocol,
        cards: [any Card],
        topic: TopicModel,
        folder: SetTopicModel
    ) {
        self.view = view
        self.storageService = storageService
        self.cards = cards
        self.topic = topic
        self.folder = folder
    }
    
    func viewDidLoad() {
        practicalFormControllers = [
            PracticalFormController.practiceFormView(for: .practiceTerm, cards: cards, endTest: { _ in
                self.endPracticeRound()
            }),
            PracticalFormController.practiceFormView(for: .practiceDescription, cards: cards, endTest: { _ in
                self.endPracticeRound()
                
                let updatedPracticeIntervalTopic = self.updatePracticeValue(of: self.topic)
                self.storageService.updatePracticeIntervalOfTopic(
                    topic: updatedPracticeIntervalTopic,
                    folder: self.folder) { err in
                        if let err = err {
                            self.view?.showErrorAlert(msg: err.localizedDescription)
                        }
                    }
            })
        ]
    }
    
    private func updatePracticeValue(of topic: TopicModel) -> TopicModel {
        let now = Date()
        let lastPracticeDate = topic.lastDatePractice != nil
            ? Date(timeIntervalSince1970: topic.lastDatePractice!)
            : now
        let intervalInHours = abs(now.timeIntervalSince(lastPracticeDate)) / 3600
        switch topic.intervalPractice {
        case .daily:
            if topic.numberOfPractice != nil {
                return updatePracticeIntervalDaily(topic: topic, withinDay: intervalInHours < 24)
            } else {
                var mutatingTopic = topic
                mutatingTopic.numberOfPractice = 1
                return mutatingTopic
            }
        case .weekly:
            if topic.numberOfPractice != nil {
                return updatePracticeIntervalDaily(topic: topic, withinDay: intervalInHours < 24)
            } else {
                var mutatingTopic = topic
                mutatingTopic.numberOfPractice = 1
                return mutatingTopic
            }
            break
        case .monthly:
            if topic.numberOfPractice != nil {
                return updatePracticeIntervalDaily(topic: topic, withinDay: intervalInHours < 24)
            } else {
                var mutatingTopic = topic
                mutatingTopic.numberOfPractice = 1
                return mutatingTopic
            }
            break
        case .none:
            var mutatingTopic = topic
            mutatingTopic.lastDatePractice = Date().timeIntervalSince1970
            mutatingTopic.intervalPractice = .daily
            mutatingTopic.numberOfPractice = 1
            return mutatingTopic
        }
        //        mutatingTopic.lastDatePractice = Date.now.timeIntervalSince1970
        //        mutatingTopic.intervalPractice = .weekly
        //        mutatingTopic.numberOfPractice = 3
    }
    
    private func updatePracticeIntervalDaily(topic: TopicModel, withinDay: Bool) -> TopicModel {
        var mutatingTopic = topic
        if withinDay {
            if topic.numberOfPractice == IntervalBetweenPractice.daily.maxPracticeNumber {
                mutatingTopic.intervalPractice = .weekly
                mutatingTopic.numberOfPractice = 0
                
            } else {
                mutatingTopic.numberOfPractice = (mutatingTopic.numberOfPractice ?? 0) + 1
            }
        } else {
            mutatingTopic.numberOfPractice = (mutatingTopic.numberOfPractice ?? 0) - 1
        }
        
        mutatingTopic.lastDatePractice = Date().timeIntervalSince1970
        return mutatingTopic
    }
    
    private func endPracticeRound() {
        self.practiceRound += 1
        if practiceRound >= practicalFormControllers.count {
            checkResultPassOrFail() == .pass ? view?.showPracticePass() : view?.showPracticeFail()
        } else {
            view?.moveToNextRound(index: practiceRound)
        }
    }
    
    func getPracticeForm() -> any PracticeFormView {
        return practicalFormControllers[practiceRound]
    }
    
    func getPracticeForm(at index: Int) -> any PracticeFormView {
        return practicalFormControllers[index]
    }
    
    func getNumberOfPracticeTopicViews() -> Int {
        return practicalFormControllers.count
    }
    
    var resultsOfAnswerCards: [TurnResult] = []
    
    func turnPracticeDone(result: TurnResult) {
        resultsOfAnswerCards.append(result)
    }
    
    func checkResultPassOrFail() -> PracticalResult {
        let correct = resultsOfAnswerCards.filter {
            $0 == .correct
        }.count
        let incorrect = resultsOfAnswerCards.filter {
            $0 == .incorrect
        }.count
        return correct > incorrect ? .pass : .fail
    }
}
