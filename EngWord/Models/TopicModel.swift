//
//  TopicModel.swift
//  Quizzie
//
//  Created by hieu nguyen on 16/11/2022.
//

import Foundation
import FirebaseFirestoreSwift

struct TopicModel: Codable {
    
    @DocumentID private var id: String?
    private let ID: String?
    var name: String
    var numberOfTerms: Int
    var createdDateTimeInterval: TimeInterval
    var intervalPractice: IntervalBetweenPractice?
    var numberOfPractice: Int?
    var lastDatePractice: TimeInterval?
    var terms: [TermModel]?

    var topicId: String? {
        return ID ?? id
    }

    var createdTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: Date(timeIntervalSince1970: createdDateTimeInterval))
    }

    enum CodingKeys: String, CodingKey {
        case ID = "id"
        case name = "topic_name"
        case numberOfTerms = "number_of_terms"
        case createdDateTimeInterval = "created_date"
        case intervalPractice = "interval_practice"
        case numberOfPractice = "number_of_practice"
        case lastDatePractice = "last_date_practice"
        case terms = "terms"
    }

    var toJson: [String: Any] {
        var dictionary: [String: Any] = [
            "topic_name": name,
            "number_of_terms": numberOfTerms,
            "created_date": createdDateTimeInterval
        ]
        
        if let intervalPractice = intervalPractice {
            dictionary["interval_practice"] = intervalPractice
        }
        
        if let numberOfPractice = numberOfPractice {
            dictionary["number_of_practice"] = numberOfPractice
        }
        
        if let lastDatePractice = lastDatePractice {
            dictionary["last_date_practice"] = lastDatePractice
        }
        
        if let topicId = topicId {
            dictionary["id"] = topicId
        }
        if let terms = terms {
            dictionary["terms"] = terms.compactMap({
                $0.toJson
            })
        }
        return dictionary
    }

    init(id: String? = nil, name: String) {
        self.ID = id
        self.name = name
        self.numberOfTerms = 0
        self.createdDateTimeInterval = Date().timeIntervalSince1970
        
        self.terms = nil
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.ID = try container.decodeIfPresent(String.self, forKey: .ID)
        self.name = try container.decode(String.self, forKey: .name)
        self.numberOfTerms = try container.decode(Int.self, forKey: .numberOfTerms)
        self.createdDateTimeInterval = try container.decode(TimeInterval.self, forKey: .createdDateTimeInterval)
        self.intervalPractice = try container.decodeIfPresent(IntervalBetweenPractice.self, forKey: .intervalPractice)
        self.numberOfPractice = try container.decodeIfPresent(Int.self, forKey: .numberOfPractice)
        self.lastDatePractice = try container.decodeIfPresent(TimeInterval.self, forKey: .lastDatePractice)
        self.terms = try container.decodeIfPresent([TermModel].self, forKey: .terms)
    }
}

extension TopicModel: Equatable {
    
    static func == (lhs: TopicModel, rhs: TopicModel) -> Bool {
        return lhs.topicId == rhs.topicId
    }
}
