//
//  WordsAPIWordItem.swift
//  Quizzie
//
//  Created by hieu nguyen on 03/01/2023.
//

import Foundation

struct Result: Decodable {
    var definition: String?
    var partOfSpeech: String?
    var examples: [String]?
    var synonyms: [String]?
    var antonyms: [String]?

    enum CodingKeys: String, CodingKey {
        case definition
        case partOfSpeech
        case examples
        case synonyms
        case antonyms
    }
}

struct Pronunciation: Decodable {
    var phonetic: String?

    enum CodingKeys: String, CodingKey {
        case phonetic = "all"
    }
}

struct WordsApiWordItem: Card {

    private var id = UUID().uuidString
    private var word: String
    var results: [Result]?
    private var result: Result?
    private var pronunciation: Pronunciation?
    
    private var definition: String?
    private var lexicalCategory: PartOfSpeech?
    private var example: String?
    
    func encode(to encoder: Encoder) {}
    
    init(
        id: String = UUID().uuidString,
        word: String = "",
        results: [Result]? = nil,
        result: Result? = nil,
        pronunciation: Pronunciation? = nil,
        definition: String? = nil,
        lexicalCategory: PartOfSpeech? = nil,
        example: String? = nil) {
        self.id = id
        self.word = word
        self.results = results
        self.result = result
        self.pronunciation = pronunciation
        self.definition = definition
        self.lexicalCategory = lexicalCategory
        self.example = example
    }
    
    enum CodingKeys: String, CodingKey {
        case word
        case results
        case pronunciation
    }

    var idOfCard: String {
        get { return id }
        set { id = newValue }
    }

    var termDisplay: String {
        get { return word }
        set { word = newValue }
    }

    var phoneticDisplay: String? {
        get { return pronunciation?.phonetic }
        set { pronunciation?.phonetic = newValue }
    }

    var selectedDefinition: String? {
        get { return definition ?? listOfDefinition.first }
        set { self.definition = newValue }
    }

    var selectedExample: String? {
        get { return example ?? listOfExamples?.first }
        set { example = newValue }
    }

    var listOfDefinition: [String] {
        get {
            return results?.compactMap({ $0.definition }) ?? []
        }
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
//        return results?.first(where: { result in
//            result.definition == selectedDefinition
//        })?.examples ?? results?.first?.examples

        return results?.flatMap({
            $0.examples ?? []
        })

    }

    var partOfSpeech: PartOfSpeech?
    var partOfSpeechDisplay: String? {
        get { return partOfSpeech?.rawValue ?? results?.first?.partOfSpeech }

        set {
            partOfSpeech = PartOfSpeech(rawValue: newValue ?? "")
        }
    }
}
