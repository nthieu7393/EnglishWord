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
                NotificationCenter.default.post(name: .practiceFinishNotification, object: updatedPracticeIntervalTopic)
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
        var mutatingTopic: TopicModel
        switch topic.intervalPractice {
        case .daily:
           mutatingTopic = updatePracticeIntervalDaily(topic: topic)
        case .weekly:
            mutatingTopic = updatePracticeIntervalWeekly(topic: topic)
        case .monthly:
            mutatingTopic = updatePracticeIntervalMonthly(topic: topic)
        case .none:
            mutatingTopic = topic
            mutatingTopic.intervalPractice = .daily
            mutatingTopic.numberOfPractice = 1
        }
        mutatingTopic.lastDatePractice = Date().timeIntervalSince1970
        return mutatingTopic
    }
    
    private func updatePracticeIntervalDaily(topic: TopicModel) -> TopicModel {
        let now = Date()
        let lastPracticeDate = topic.lastDatePractice != nil
            ? Date(timeIntervalSince1970: topic.lastDatePractice!)
            : now
        let intervalInHours = abs(now.timeIntervalSince(lastPracticeDate)) / 3600
        
        var mutatingTopic = topic
        if intervalInHours < 24 {
            if topic.numberOfPractice == IntervalBetweenPractice.daily.maxPracticeNumber {
                mutatingTopic.intervalPractice = .weekly
                mutatingTopic.numberOfPractice = 0
            } else {
                mutatingTopic.numberOfPractice = (mutatingTopic.numberOfPractice ?? 0) + 1
            }
        } else {
            mutatingTopic.numberOfPractice = (mutatingTopic.numberOfPractice ?? 0) - 1
        }
        return mutatingTopic
    }
    
    private func updatePracticeIntervalWeekly(topic: TopicModel) -> TopicModel {
        guard let lastPracticeDate = topic.lastDatePractice else {
            fatalError("‼️ there's no lastPracticeDate")
        }
        var mutatingTopic = topic
        let calendar = Calendar.current
        let fromDateComponents = calendar.dateComponents(
            [.weekOfYear],
            from: Date(timeIntervalSince1970: lastPracticeDate)
        )
        let toDateComponents = calendar.dateComponents(
            [.weekOfYear],
            from: Date()
        )
        if toDateComponents.weekOfYear == (fromDateComponents.weekOfYear ?? 0) + 1 {
            if topic.numberOfPractice == IntervalBetweenPractice.weekly.maxPracticeNumber {
                mutatingTopic.intervalPractice = .monthly
                mutatingTopic.numberOfPractice = 0
            } else {
                mutatingTopic.numberOfPractice = (mutatingTopic.numberOfPractice ?? 0) + 1
            }
        } else {
            mutatingTopic.numberOfPractice = (mutatingTopic.numberOfPractice ?? 0) - 1
        }
        return mutatingTopic
    }
    
    private func updatePracticeIntervalMonthly(topic: TopicModel) -> TopicModel {
        guard let lastPracticeDate = topic.lastDatePractice else {
            fatalError("‼️ there's no lastPracticeDate")
        }
        var mutatingTopic = topic
        let calendar = Calendar.current
        let fromDateComponents = calendar.dateComponents(
            [.month],
            from: Date(timeIntervalSince1970: lastPracticeDate)
        )
        let toDateComponents = calendar.dateComponents(
            [.month],
            from: Date()
        )
        mutatingTopic.numberOfPractice = (mutatingTopic.numberOfPractice ?? 0) + ((toDateComponents.month == (fromDateComponents.month ?? 0) + 1) ? 1 : -1)
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
