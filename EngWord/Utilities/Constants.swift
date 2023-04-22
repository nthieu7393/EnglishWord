//
//  Constants.swift
//  Quizzie
//
//  Created by hieu nguyen on 05/11/2022.
//

import UIKit

struct Constants {
    
    static let borderRadius = 10.0
    static let horizontalPadding = 24
}

enum PracticalResult {
    
    case pass, fail
}

enum TurnResult {
    
    case correct, incorrect
}

enum PartOfSpeech: String, Codable, SelectionMenuItem {

    case none
    case noun
    case adjective
    case adverb
    case verb
    
    var shortText: String {
        switch self {
            case .noun: return "n."
            case .adjective: return "adj."
            case .adverb: return "adv."
            case .verb: return "v."
            default: return ""
        }
    }

    var text: String {
        switch self {
            case .noun: return "noun"
            case .adjective: return "adjective"
            case .adverb: return "adverb"
            case .verb: return "verb"
            default: return ""
        }
    }

    func isEqual(to other: SelectionMenuItem) -> Bool {
        return self.text == other.text && type(of: self) == type(of: other)
    }
}

// MARK: ----
enum IntervalBetweenPractice: Int, Codable {

    case daily = 0, weekly, monthly, master

    var text: String {
        switch self {
            case .daily: return "Daily"
            case .weekly: return "Weekly"
            case .monthly: return "Monthly"
            case .master: return "Master"
        }
    }

    var color: UIColor {
        switch self {
            case .daily: return Colors.daily
            case .weekly: return Colors.weekly
            case .monthly: return Colors.monthly
            case .master: return UIColor.blue
        }
    }
    
    var maxPracticeNumber: Int {
        switch self {
            case .daily: return 7
            case .weekly: return 4
            case .monthly: return 12
            case .master: return 0
        }
    }
}

protocol SelectionMenuItem {

    var text: String { get }

    func isEqual(to other: SelectionMenuItem) -> Bool
}

enum SortedBy: SelectionMenuItem {

    case roundDescending, roundAscending, alphabetDescending, alphabetAscending

    var text: String {
        switch self {
            case .alphabetAscending:
                return "Alphabet Ascending"
            case .alphabetDescending:
                return "Alphabet Descending"
            case .roundAscending:
                return "Round Ascending"
            case .roundDescending:
                return "Round Descending"
        }
    }

    func isEqual(to other: SelectionMenuItem) -> Bool {
        return self.text == other.text && type(of: self) == type(of: other)
    }
}

extension Notification.Name {

    static let practiceFinishNotification = Notification.Name("PracticeFinishNotification")
    static let updateFolderNotification = Notification.Name("PracticeFinishNotification")
    static let deleteFolderNotification = Notification.Name("deleteFolderNotification")
}
