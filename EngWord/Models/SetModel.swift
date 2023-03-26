//
//  SetModel.swift
//  Quizzie
//
//  Created by hieu nguyen on 15/11/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseCore
import FirebaseFirestoreSwift

struct SetTopicModel: Codable {

    @DocumentID var id: String?
    var name: String?
    var topics: [TopicModel] = []

    enum CodingKeys: String, CodingKey {
        case id
        case name = "set_name"
        case topics
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(self._id, forKey: .id)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encode(self.topics, forKey: .topics)
    }
}
