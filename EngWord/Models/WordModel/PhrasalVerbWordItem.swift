//
//  PhrasalVerbWordItem.swift
//  Quizzie
//
//  Created by hieu nguyen on 05/01/2023.
//

import Foundation

struct PhrasalVerbList: Decodable {
    
    struct DynamicCodingKey: CodingKey {
        var stringValue: String
        var intValue: Int?
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        init?(intValue: Int) {
            return nil
        }
    }
    
    var id: Int?
    var word: String!
    var derivatives: [String]?
    var descriptions: [String]?
    var examples: [String]?
    var synonyms: [String]?
    
    enum CodingKeys: String, CodingKey {
        case derivatives
        case descriptions
        case examples
        case synonyms
    }
    
    var list: [PhrasalVerbWordItem]?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKey.self)
        list = []
        for key in container.allKeys.enumerated() {
            var decodedObject = try container.decode(
                PhrasalVerbWordItem.self,
                forKey: DynamicCodingKey(stringValue: key.element.stringValue)!)
            decodedObject.word = key.element.stringValue
//            decodedObject.id = key.offset
            list?.append(decodedObject)
        }
    }
}

struct PhrasalVerbWordItem: Decodable {
    
    var id = UUID().uuidString
    var word: String!
    var description: String!
    var example: String!
    var derivatives: [String]?
    var descriptions: [String]?
    var examples: [String]?
    var synonyms: [String]?
    
    enum CodingKeys: String, CodingKey {
        case derivatives
        case descriptions
        case examples
        case synonyms
    }
}

extension PhrasalVerbWordItem: Card {

    var partOfSpeechDisplay: String? {
        get { return nil }
        set {}
    }

    var selectedDefinition: String? {
        get { return description }
        set { description = newValue }
    }
    
    var selectedExample: String? {
        get { return example }
        set { example = newValue }
    }

    var idOfCard: String {
        get { return id }
        set { id = newValue }
    }
    
    var termDisplay: String {
        get { return word }
        set { word = newValue }
    }
    
    var listOfDefinition: [String] {
        get { return descriptions ?? [] }
        set { descriptions = newValue }
    }
    
    var listOfLexicalCategory: [PartOfSpeech]? {
        return nil
    }
    
    var listOfExamples: [String]? {
        get { return descriptions }
        set { descriptions = newValue }
    }
    
    var phoneticDisplay: String? {
        get { return nil }
        set { }
    }

    var audioFileName: String {
        return ""
    }
}
