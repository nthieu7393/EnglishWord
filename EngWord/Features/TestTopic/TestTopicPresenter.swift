// 
//  TestTopicPresenter.swift
//  EngWord
//
//  Created by hieu nguyen on 21/02/2023.
//

import Foundation

final class TestTopicPresenter: BasePresenter {
    
    private var view: TestTopicViewProtocol?
    
    init(view: TestTopicViewProtocol) {
        self.view = view
    }
}
