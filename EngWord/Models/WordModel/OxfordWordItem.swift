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
    var pronunciation: Pronunciation?
    var examples: [Example] = []
    var definitions: [String] = []
    var lexicalCategory: LexicalCategory?
    private var audioPath: String?

    private var definition: String?
    private var example: String?

    struct Example: Decodable {
        var text: String

        enum CodingKeys: String, CodingKey {
            case text
        }
    }

    struct LexicalCategory: Decodable {
        var id: String
        var text: String
        
        enum CodingKeys: String, CodingKey {
            case id, text
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

    func encode(to encoder: Encoder) {}

    init(from decoder: Decoder) throws {
        
            let container = try decoder.container(keyedBy: RootKeys.self)
            word = try container.decodeIfPresent(String.self, forKey: .query) ?? ""
            var resultsContainer = try container.nestedUnkeyedContainer(forKey: .results)

            while !resultsContainer.isAtEnd {
                let resultContainer = try resultsContainer.nestedContainer(keyedBy: ResultsKeys.self)
    //            let language = try resultContainer.decode(String.self, forKey: .language)
    //            let id = try resultContainer.decode(String.self, forKey: .id)

                var lexicalEntriesContainer = try resultContainer.nestedUnkeyedContainer(forKey: .lexicalEntries)
                while !lexicalEntriesContainer.isAtEnd {
                    let lexicalEntryContainer = try lexicalEntriesContainer.nestedContainer(keyedBy: LexicalEntriesKeys.self)

                    if lexicalCategory == nil {
                        lexicalCategory = try lexicalEntryContainer.decode(LexicalCategory.self, forKey: .lexicalCategory)
                    }

                    var entriesContainer = try lexicalEntryContainer.nestedUnkeyedContainer(forKey: .entries)
                    while !entriesContainer.isAtEnd {
                        let entryContainer = try entriesContainer.nestedContainer(keyedBy: EntriesKeys.self)
                        if entryContainer.contains(.pronunciations) {
                            var pronunciationsContainer = try entryContainer.nestedUnkeyedContainer(forKey: .pronunciations)
                            let pronunciationContainer = try pronunciationsContainer.nestedContainer(keyedBy: PronunciationKeys.self)
                            let audioFile = try pronunciationContainer.decode(String.self, forKey: .audioFile)
                            let phoneticNotation = try pronunciationContainer.decode(String.self, forKey: .phoneticNotation)
                            let phoneticSpelling = try pronunciationContainer.decode(String.self, forKey: .phoneticSpelling)

                            pronunciation = Pronunciation(
                                audioFile: audioFile,
                                phoneticNotation: phoneticNotation,
                                phoneticSpelling: phoneticSpelling)
                        }

                        if entryContainer.contains(.senses) {
                            var sensesContainer = try entryContainer.nestedUnkeyedContainer(forKey: .senses)
                            if !sensesContainer.isAtEnd {
                                let senseContainer = try sensesContainer.nestedContainer(keyedBy: SensesKeys.self)

                                if senseContainer.contains(.definitions) {
                                    var definitionsContainer = try senseContainer.nestedUnkeyedContainer(forKey: .definitions)

                                    let definition = try definitionsContainer.decode(String.self)
                                    definitions.append(definition)
                                }

                                if senseContainer.contains(.examples) {
                                    examples.append(contentsOf: try senseContainer.decode([Example].self, forKey: .examples))
                                }

                            }
                        }
                    }
                }
            }

    }
}

extension OxfordWordItem: Card {

    var audioFilePath: String? {
        get {
            return audioPath
        }
        set {
            audioPath = newValue
        }
    }


    var termDisplay: String {
        get { return word ?? "" }
        set { word = newValue }
    }

    var idOfCard: String {
        get { return id }
        set { id = newValue }
    }

    var phoneticDisplay: String? {
        get { return pronunciation?.phoneticSpelling }
        set {
            
        }
    }

    var partOfSpeechDisplay: String? {
        get {
            return lexicalCategory?.id.lowercased()
        }
        set {
            lexicalCategory = LexicalCategory(
                id: newValue?.lowercased() ?? "",
                text: newValue ?? "")
        }
    }

    var listOfDefinition: [String] {
        return definitions
    }

    var listOfLexicalCategory: [PartOfSpeech]? {
        return [.noun, .verb, .adjective, .adverb]
    }

    var listOfExamples: [String]? {
        return examples.map { $0.text }
    }

    var selectedDefinition: String? {
        get { return definition ?? listOfDefinition.first }
        set { definition = newValue }
    }

    var selectedExample: String? {
        get { return example ?? listOfExamples?.first }
        set { example = newValue }
    }
}
