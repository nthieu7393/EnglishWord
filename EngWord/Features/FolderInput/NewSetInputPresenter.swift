// 
//  NewSetInputPresenter.swift
//  EngWord
//
//  Created by hieu nguyen on 17/02/2023.
//

import Foundation

final class NewSetInputPresenter: BasePresenter {
    
    private weak var view: NewSetInputViewProtocol?
    
    init(view: NewSetInputViewProtocol) {
        self.view = view
    }
}
