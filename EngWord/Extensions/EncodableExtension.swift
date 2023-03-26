//
//  EncodableExtension.swift
//  EngWord
//
//  Created by hieu nguyen on 17/02/2023.
//

import Foundation

extension Encodable {

    func toDictionary() throws -> [String: Any] {
        do {
            let data = try JSONEncoder().encode(self)
            guard let dictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                else { throw GeneralError.dataFormatNotAvailable }
            return dictionary
        } catch {
            throw error
        }
    }
}
