//
//  TermModel.swift
//  Quizzie
//
//  Created by hieu nguyen on 16/11/2022.
//

import Foundation
import FirebaseFirestoreSwift

struct TermModel: Codable, Card {

    var isAudioFileExists: Bool {
        return FileManager.default.fileExists(atPath: audioFilePath ?? "")
    }

    var audioFilePath: String? {
        return try? Path.inLibrary(audioFileName).relativePath
    }

    var idOfCard: String {
        get { return id ?? "" }
        set { id = newValue }
    }

    var termDisplay: String {
        get { return term ?? "" }
        set { term = newValue }
    }
    
    var phoneticDisplay: String? {
        get { return pronunciation }
        set { pronunciation = newValue }
    }
    
    var selectedDefinition: String? {
        get { return definition }
        set { definition = newValue }
    }
    
    var selectedExample: String? {
        get { return phrases }
        set { phrases = newValue }
    }
    
    var listOfDefinition: [String] {
        return []
    }
    
    var listOfLexicalCategory: [PartOfSpeech]? {
        return [
            PartOfSpeech.none,
            PartOfSpeech.verb,
            PartOfSpeech.adjective,
            PartOfSpeech.adverb
        ]
    }
    
    var listOfExamples: [String]? {
        return []
    }

    var partOfSpeechDisplay: String? {
        get { return partOfSpeech }
        set { partOfSpeech = newValue }
    }
    
    var id: String?
    var term: String?
    var definition: String?
    var partOfSpeech: String?
    var pronunciation: String?
    var phrases: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case term
        case definition
        case partOfSpeech = "part_of_speech"
        case pronunciation
        case phrases
    }

    //    var toJson: [String: Any] {
    //        return [
    //            "term": term ?? "",
    //            "definitions": definitions ?? "",
    //            "lexical_category": lexicalCategory ?? "",
    //            "phrases": phrases ?? ""
    //        ]
    //    }
    
    //    func encode(to encoder: Encoder) throws {
    //        var container = encoder.container(keyedBy: CodingKeys.self)
    //        try container.encode(term, forKey: .term)
    //        try container.encode(definition, forKey: .definition)
    //        try container.encode(lexicalCategory, forKey: .lexicalCategory)
    //        try container.encode(phrases, forKey: .phrases)
    //    }
}
