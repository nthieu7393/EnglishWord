// 
//  AllTopicsViewProtocol.swift
//  EngWord
//
//  Created by hieu nguyen on 17/02/2023.
//

import UIKit

protocol AllTopicsViewDelegate: AnyObject {

    func allTopicsView(
        _ view: AllTopicsViewProtocol,
        didTap createTopicButton: ResponsiveButton,
        folder: SetTopicModel)
    func allTopicsView(
        _ view: AllTopicsViewController,
        didUpdate folder: SetTopicModel?)
}

protocol AllTopicsViewProtocol: BaseViewProtocol {

    func hideAddTopicsButton()
    func showAddTopicsButton()
    func updateTopicsInFolder()
}
