//
//  ArrayExtension.swift
//  EngWord
//
//  Created by hieu nguyen on 28/02/2023.
//

import Foundation

enum SortOrder {
    case descending
    case ascending
}

extension Array where Element == String {

    func sort(_ order: SortOrder? = .ascending) -> [Element] {
        let rs = self.sorted { lhs, rhs in
            return lhs.count < rhs.count
        }
        return rs
    }
}
