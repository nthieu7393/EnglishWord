//
//  SetsView.swift
//  Quizzie
//
//  Created by hieu nguyen on 06/11/2022.
//

import UIKit

protocol SetsView: BaseViewProtocol {

    func displayDataOfSets(sets: [SetTopicModel])
    func startInputNameOfSet(
        initialString: String,
        endEditing: @escaping (String?) -> Void
    )
    func dismissNewSetInputScreen()
}
