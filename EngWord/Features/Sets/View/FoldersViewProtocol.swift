//
//  SetsView.swift
//  Quizzie
//
//  Created by hieu nguyen on 06/11/2022.
//

import UIKit

protocol FoldersViewProtocol: BaseViewProtocol {

    func displayDataOfSets(sets: [SetTopicModel])
    func startInputNameOfSet(
        initialString: String,
        endEditing: @escaping (String?) -> Void
    )
    func dismissNewSetInputScreen()
    func removeTopic(at section: Int, row: Int)
    func removeFolder(at section: Int)
    func updateFolderTitle(at index: Int)
    func displayDataOfSet(at index: Int)
}
