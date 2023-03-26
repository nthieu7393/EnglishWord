//
//  LocalFileProvider.swift
//  Quizzie
//
//  Created by hieu nguyen on 06/01/2023.
//

import Foundation

protocol FileDataProvider {
    associatedtype T: Decodable

    func loadData() throws -> T?
}

class BundleFileDataProvider<U: Decodable>: FileDataProvider {
    typealias T = U

    let fileName: String
    let `extension`: String

    init(fileName: String, extension: String) {
        self.fileName = fileName
        self.extension = `extension`
    }

    func loadData() throws -> U? {
        guard let bundle = Bundle.main.url(forResource: fileName, withExtension: `extension`),
                let data = try? Data(contentsOf: bundle, options: .mappedIfSafe) else {
            return nil
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            return nil
        }
    }
}
