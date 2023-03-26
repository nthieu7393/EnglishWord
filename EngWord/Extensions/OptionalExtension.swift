//
//  OptionalExtension.swift
//  EngWord
//
//  Created by hieu nguyen on 17/02/2023.
//

import Foundation

extension Optional where Wrapped == String {

    func isNotEmpty() -> Bool {
        if self == nil || self!.isEmpty {
            return false
        }
        return true
    }
}
