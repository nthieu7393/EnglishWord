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
    var pronunciations: [Pronunciation]?
    var language: String?
    
    enum CodingKeys: String, CodingKey {
        case word = "query"
        case language = "query"
        case pronunciations = "results.0.lexicalEntries.0.entries.0.pronunciations"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.word = try container.decodeIfPresent(String.self, forKey: .word) ?? ""
        self.language = try container.decode(String.self, forKey: .language)
        self.pronunciations = try container.decode([Pronunciation].self, forKey: .pronunciations)
    }
    
    struct Result: Decodable {
        var id: String?
        var language: String?
        var type: String?
        var word: String?
        var entries: Entry?
    }
    
    struct Entry: Decodable {
        var word: String?
        var pronunciations: [Pronunciation]?
        var senses: [Sense]?
        
        enum CodingKeys: String, CodingKey {
            case word = "id"
            case pronunciations
            case senses
        }
    }
    
    struct Pronunciation: Codable {
        var audioFile: String?
        var phoneticNotation: String?
        var phoneticSpelling: String?
        
        enum CodingKeys: String, CodingKey {
            case audioFile
            case phoneticNotation
            case phoneticSpelling
        }
    }
    
    struct Sense: Decodable {
        var definitions: [String]?
        var examples: [String]?
        var shortDefinitions: [String]?
        
        enum CodingKeys: String, CodingKey {
            
            case definitions
            case examples
            case shortDefinitions
        }
    }
}
