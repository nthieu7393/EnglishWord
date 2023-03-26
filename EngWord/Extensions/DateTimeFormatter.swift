//
//  DateTimeFormatter.swift
//  Quizzie
//
//  Created by hieu nguyen on 17/11/2022.
//

import Foundation

extension Date {

    var formattedWithoutTime: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
}
