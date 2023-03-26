//
//  ServicesError.swift
//  Quizzie
//
//  Created by hieu nguyen on 14/11/2022.
//

import Foundation

enum GeneralError: Error {

    case noConnection
    case notDefined
    case undefinedFormat
    case dataFormatNotAvailable

    var description: String {
        switch self {
        case .noConnection:
            return Localizations.noConnection
        case .notDefined:
            return Localizations.notDefined
        case .dataFormatNotAvailable:
            return Localizations.dataFormatNotAvailable
        default: return ""
        }
    }
}

enum AuthError: Error {

    case wrongPassword
    case emailAlreadyInUse
    case invalidEmail
    case missingEmail
    case unverifiedEmail
    case tooManyRequests
}
