//
//  QuizResult.swift
//  EngWord
//
//  Created by hieu nguyen on 17/04/2023.
//

import Foundation

struct QuizResult {
    
    let round: Int
    let question: String
    let result: String
    let answer: String
    var isCorrect: Bool {
        return answer == result
    }
}
