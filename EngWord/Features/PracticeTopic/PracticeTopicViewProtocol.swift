// 
//  PracticeTopicViewProtocol.swift
//  EngWord
//
//  Created by hieu nguyen on 24/02/2023.
//

import UIKit

protocol PracticeTopicViewProtocol: BaseViewProtocol {

    func reloadCollectionView()
    func dismissScreen()
    func moveToNextRound(index: Int)
    func showPracticePass()
    func showPracticeFail()
}
