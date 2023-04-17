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
            PracticalFormController.practiceFormView(
                for: .practiceTerm,
                cards: cards,
                endTest: { _ in
                self.endPracticeRound()
            }),
            PracticalFormController.practiceFormView(
                for: .practiceDescription,
                cards: cards,
                endTest: { _ in
                self.endPracticeRound()
            })
        ]
    }
    
    private func updatePracticeValue(of topic: TopicModel) -> TopicModel {
        var mutatingTopic: TopicModel!
        
        if topic.lastDatePractice == nil || topic.lastDatePractice == 0 {
            mutatingTopic = topic
            mutatingTopic.intervalPractice = .daily
            mutatingTopic.lastDatePractice = Date().timeIntervalSince1970
            mutatingTopic.numberOfPractice = 1
            return mutatingTopic
        }
        
        let calendar = Calendar.current
        let fromDateComponents = calendar.dateComponents(
            [.day, .weekOfYear, .month],
            from: Date(timeIntervalSince1970: topic.lastDatePractice!)
        )
        let toDateComponents = calendar.dateComponents(
            [.day, .weekOfYear, .month],
            from: Date()
        )
        switch topic.intervalPractice {
        case .daily:
            mutatingTopic = updatePracticeIntervalDaily(
                topic: topic,
                fromDateComponents: fromDateComponents,
                toDateComponents: toDateComponents)
        case .weekly:
            mutatingTopic = updatePracticeIntervalWeekly(
                topic: topic,
                fromDateComponents: fromDateComponents,
                toDateComponents: toDateComponents)
        case .monthly:
            mutatingTopic = updatePracticeIntervalMonthly(
                topic: topic,
                fromDateComponents: fromDateComponents,
                toDateComponents: toDateComponents)
        case .none, .master:
            return topic
        }
        mutatingTopic.lastDatePractice = Date().timeIntervalSince1970
        return mutatingTopic
    }
    
    private let dayDelta = 0
    
    private func updatePracticeIntervalDaily(
        topic: TopicModel,
        fromDateComponents: DateComponents,
        toDateComponents: DateComponents) -> TopicModel {
            var mutatingTopic = topic
            if fromDateComponents.year == toDateComponents.year
                && fromDateComponents.month == toDateComponents.month
                && fromDateComponents.day == (toDateComponents.day ?? 0) + dayDelta {
                if topic.numberOfPractice == IntervalBetweenPractice.daily.maxPracticeNumber {
                    mutatingTopic.intervalPractice = .weekly
                    mutatingTopic.numberOfPractice = 0
                } else {
                    mutatingTopic.numberOfPractice = (mutatingTopic.numberOfPractice ?? 0) + 1
                }
            } else {
                let differenceInDays = calculateDifferenceBetween(components: [.day], topic: topic).day ?? 0
                mutatingTopic.numberOfPractice = max((mutatingTopic.numberOfPractice ?? 0) - differenceInDays, 0)
            }
            return mutatingTopic
        }
    
    private func calculateDifferenceBetween(
        components: Set<Calendar.Component>,
        topic: TopicModel) -> DateComponents {
            let calendar = Calendar.current
            let fromDate = Date(timeIntervalSince1970: topic.lastDatePractice!)
            let toDate = Date()
            let dateComponents = calendar.dateComponents(components, from: fromDate, to: toDate)
            return dateComponents
        }
    
    private func updatePracticeIntervalWeekly(
        topic: TopicModel,
        fromDateComponents: DateComponents,
        toDateComponents: DateComponents) -> TopicModel {
            var mutatingTopic = topic
            if toDateComponents.weekOfYear == (fromDateComponents.weekOfYear ?? 0) + dayDelta
                && toDateComponents.year == fromDateComponents.year {
                if topic.numberOfPractice == IntervalBetweenPractice.weekly.maxPracticeNumber {
                    mutatingTopic.intervalPractice = .monthly
                    mutatingTopic.numberOfPractice = 0
                } else {
                    mutatingTopic.numberOfPractice = (mutatingTopic.numberOfPractice ?? 0) + 1
                }
            } else {
                let differenceInWeeks = calculateDifferenceBetween(
                    components: [.weekOfYear],
                    topic: topic).weekOfYear ?? 0
                mutatingTopic.numberOfPractice = max((mutatingTopic.numberOfPractice ?? 0) - differenceInWeeks, 0)
            }
            return mutatingTopic
        }
    
    private func updatePracticeIntervalMonthly(
        topic: TopicModel,
        fromDateComponents: DateComponents,
        toDateComponents: DateComponents) -> TopicModel {
        var mutatingTopic = topic
        let isWithinMonth = ((toDateComponents.month ?? 0) + dayDelta) == (fromDateComponents.month ?? 0)
            && toDateComponents.year == fromDateComponents.year
        if isWithinMonth {
            mutatingTopic.numberOfPractice = (mutatingTopic.numberOfPractice ?? 0) + 1
            if (mutatingTopic.numberOfPractice ?? 0) >= (mutatingTopic.intervalPractice?.maxPracticeNumber ?? 0) {
                mutatingTopic.intervalPractice = .master
            }
        } else {
            mutatingTopic.numberOfPractice = max((mutatingTopic.numberOfPractice ?? 0) - (calculateDifferenceBetween(components: [.month], topic: topic).month ?? 0), 0)
        }
        return mutatingTopic
    }
    
    private func endPracticeRound() {
        practiceRound += 1
        if practiceRound >= practicalFormControllers.count {
            let updatedPracticeIntervalTopic = self.updatePracticeValue(of: self.topic)
            let topicFolder = TopicFolderWrapper(
                folder: self.folder,
                topic: updatedPracticeIntervalTopic
            )
            NotificationCenter.default.post(
                name: .practiceFinishNotification,
                object: topicFolder
            )
            self.storageService.updatePracticeIntervalOfTopic(
                topic: updatedPracticeIntervalTopic,
                folder: self.folder
            ) { err in
                if let err = err {
                    self.view?.showErrorAlert(msg: err.localizedDescription)
                } else {
                    self.checkResultPassOrFail() == .pass
                    ? self.view?.showPracticePass()
                    : self.view?.showPracticeFail()
                }
            }
        } else {
            view?.moveToNextRound(index: practiceRound)
        }
    }
    
    func getAllResults() -> [QuizResult] {
        return quizResults
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
    
    func turnPracticeDone(result: TurnResult, quizResult: QuizResult) {
        resultsOfAnswerCards.append(result)
        quizResults.append(quizResult)
    }
    var quizResults: [QuizResult] = []
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
