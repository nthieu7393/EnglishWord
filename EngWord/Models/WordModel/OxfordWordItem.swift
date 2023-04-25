//
//  OxfordWordItem.swift
//  EngWord
//
//  Created by hieu nguyen on 25/04/2023.
//

import Foundation

struct OxfordWordItem: Decodable {
    
    private var id = UUID().uuidString
    var word: String?
    var pronunciation: [Pronunciation] = []
    var examples: [Example] = []
    var definitions: [String] = []

    struct Example: Decodable {
        var text: String

        enum CodingKeys: String, CodingKey {
            case text
        }
    }

    struct Pronunciation: Decodable {
        var audioFile: String?
        var phoneticNotation: String?
        var phoneticSpelling: String?

        enum CodingKeys: String, CodingKey {
            case audioFile, phoneticNotation, phoneticSpelling
        }
    }
    
    enum RootKeys: String, CodingKey {
        case query
        case results
    }

    enum ResultsKeys: String, CodingKey {
        case id, language, lexicalEntries
    }

    enum LexicalEntriesKeys: String, CodingKey {
        case entries, lexicalCategory, text
    }

    enum EntriesKeys: String, CodingKey {
        case pronunciations, senses
    }

    enum PronunciationKeys: String, CodingKey {
        case audioFile, phoneticNotation, phoneticSpelling
    }

    enum SensesKeys: String, CodingKey {
        case definitions, examples, id, shortDefinitions
    }

    enum ExamplesKeys: String, CodingKey {
        case text
    }

    enum LexicalCategoryKeys: String, CodingKey {
        case id, text
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        self.word = try container.decodeIfPresent(String.self, forKey: .query) ?? ""
        var resultsContainer = try container.nestedUnkeyedContainer(forKey: .results)

        while !resultsContainer.isAtEnd {
            let resultContainer = try resultsContainer.nestedContainer(keyedBy: ResultsKeys.self)
            let language = try resultContainer.decode(String.self, forKey: .language)
            let id = try resultContainer.decode(String.self, forKey: .id)

            var lexicalEntriesContainer = try resultContainer.nestedUnkeyedContainer(forKey: .lexicalEntries)
            while !lexicalEntriesContainer.isAtEnd {
                var lexicalEntryContainer = try lexicalEntriesContainer.nestedContainer(keyedBy: LexicalEntriesKeys.self)
//                let text = try lexicalEntryContainer.decode(String.self, forKey: .text)
                let lexicalCategory = try lexicalEntryContainer.nestedContainer(keyedBy: LexicalCategoryKeys.self, forKey: .lexicalCategory)

                let lexicalCategoryId = try lexicalCategory.decode(String.self, forKey: .id)
                let lexicalCategoryText = try lexicalCategory.decode(String.self, forKey: .text)

                var entriesContainer = try lexicalEntryContainer.nestedUnkeyedContainer(forKey: .entries)
                while !entriesContainer.isAtEnd {
                    var entryContainer = try entriesContainer.nestedContainer(keyedBy: EntriesKeys.self)
                    var pronunciationsContainer = try entryContainer.nestedUnkeyedContainer(forKey: .pronunciations)
                    var pronunciationContainer = try pronunciationsContainer.nestedContainer(keyedBy: PronunciationKeys.self)
                    let audioFile = try pronunciationContainer.decode(String.self, forKey: .audioFile)

                    var sensesContainer = try entryContainer.nestedUnkeyedContainer(forKey: .senses)
                    if !sensesContainer.isAtEnd {
                        let senseContainer = try sensesContainer.nestedContainer(keyedBy: SensesKeys.self)
                        var definitions = try senseContainer.nestedUnkeyedContainer(forKey: .definitions)
                        let definition = try definitions.decode(String.self)

                        examples = try senseContainer.decode([Example].self, forKey: .examples)
                    }

                }
                print(text)
            }
        }
    }
}

//extension OxfordWordItem: Card {
//    var termDisplay: String {
//        get {
//            <#code#>
//        }
//        set {
//            <#code#>
//        }
//    }
//
//    var idOfCard: String {
//        get {
//            <#code#>
//        }
//        set {
//            <#code#>
//        }
//    }
//
//    var phoneticDisplay: String? {
//        get {
//            <#code#>
//        }
//        set {
//            <#code#>
//        }
//    }
//
//    var partOfSpeechDisplay: String? {
//        get {
//            <#code#>
//        }
//        set {
//            <#code#>
//        }
//    }
//
//    var listOfDefinition: [String] {
//        <#code#>
//    }
//
//    var listOfLexicalCategory: [PartOfSpeech]? {
//        <#code#>
//    }
//
//    var listOfExamples: [String]? {
//        <#code#>
//    }
//
//    var selectedDefinition: String? {
//        get {
//            <#code#>
//        }
//        set {
//            <#code#>
//        }
//    }
//
//    var selectedExample: String? {
//        get {
//            <#code#>
//        }
//        set {
//            <#code#>
//        }
//    }
//
//
//
//}
