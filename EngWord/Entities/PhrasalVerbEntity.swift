//
//  PhrasalVerbEntity.swift
//  Quizzie
//
//  Created by hieu nguyen on 05/01/2023.
//

import Foundation
import RealmSwift

public class PhrasalVerbEntity: Object, Card {
    var audioFileName: String

    @Persisted(primaryKey: true) private var id = UUID().uuidString
    @Persisted(indexed: true) var term: String
    @Persisted var derivatives = List<String>()
    @Persisted var descriptions = List<String>()
    @Persisted var examples = List<String>()
    
    private var definition: String?
    private var example: String?
    
    convenience init(
        term: String,
        derivatives: [String] = [],
        descriptions: [String] = [],
        examples: [String] = []
    ) {
        self.init()
        self.term = term
        self.derivatives.append(objectsIn: derivatives)
        self.descriptions.append(objectsIn: descriptions)
        self.examples.append(objectsIn: examples)
    }

    var idOfCard: String {
        get { return id }
        set { id = newValue }
    }

    var termDisplay: String {
        get { return term }
        set { term = newValue }
    }

    var listOfDefinition: [String] {
        return Array(descriptions)
    }

    var listOfLexicalCategory: [PartOfSpeech]? {
        return nil
    }

    var listOfExamples: [String]? {
        return Array(examples)
    }

    var phoneticDisplay: String? {
        get { return nil }
        set {}
    }

    var selectedDefinition: String? {
        get { return definition ?? descriptions.first }
        set { definition = newValue }
    }

    var selectedExample: String? {
        get { return example ?? examples.first }
        set { example = newValue }
    }

    var partOfSpeechDisplay: String?
    
    static func ==(lhs: PhrasalVerbEntity, rhs: PhrasalVerbEntity) -> Bool {
        return lhs.id == rhs.id || lhs.term == rhs.term
    }
}
