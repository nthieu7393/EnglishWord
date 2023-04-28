//
//  CardProtocol.swift
//  Quizzie
//
//  Created by hieu nguyen on 03/01/2023.
//

import Foundation

protocol Card: Decodable {
    var termDisplay: String { get set }
    var idOfCard: String { get set }
    var phoneticDisplay: String? { get }
    var partOfSpeechDisplay: String? { get set }
    var listOfDefinition: [String] { get }
    var listOfLexicalCategory: [PartOfSpeech]? { get }
    var listOfExamples: [String]? { get }
    var audioFilePath: String? { get }

    var selectedDefinition: String? { get set }
    var selectedExample: String? { get set }
    var isAudioFileExists: Bool { get }
    var audioFileName: String { get }
}

extension Card {
    
    var toJson: [String: Any] {
        return [
            "id": idOfCard,
            "definition": selectedDefinition ?? "",
            "part_of_speech": partOfSpeechDisplay ?? PartOfSpeech.none.rawValue,
            "phrases": selectedExample ?? "",
            "term": termDisplay,
            "pronunciation": phoneticDisplay ?? "",
            "audioPath": audioFilePath ?? ""
        ]
    }
    
    var isEmpty: Bool {
        return termDisplay.isEmpty
        && (selectedDefinition?.isEmpty ?? true)
    }

    var hasRecommendedData: Bool {
        return !(listOfExamples ?? []).isEmpty && !listOfDefinition.isEmpty
    }

    var audioFileName: String {
        return "\(termDisplay).mp3"
    }

    func removeAudioFile() {
        guard let path = audioFilePath,
                isAudioFileExists else { return }
        try? FileManager.default.removeItem(atPath: path)
    }

    func isEqual(card: (any Card)?) -> Bool {
        guard let card = card else { return false }
        return idOfCard == card.idOfCard
        && termDisplay == card.termDisplay
        && selectedExample == card.selectedExample
        && selectedDefinition == card.selectedDefinition
    }
}

extension Array<Card> {

    var toJson: [[String: Any]] {
        return self.compactMap {
            $0.toJson
        }
    }
}
