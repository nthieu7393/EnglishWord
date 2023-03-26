// 
//  TestTopicViewController.swift
//  EngWord
//
//  Created by hieu nguyen on 21/02/2023.
//

import UIKit

final class TestTopicViewController: BaseViewController {
    
    var myPresenter: TestTopicPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension  TestTopicViewController: TestTopicViewProtocol, Storyboarded {

}