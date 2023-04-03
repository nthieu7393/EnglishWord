// 
//  LaunchViewController.swift
//  EngWord
//
//  Created by hieu nguyen on 04/04/2023.
//

import UIKit

final class LaunchViewController: BaseViewController {
    
    var myPresenter: LaunchPresenter? {
        return presenter as? LaunchPresenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myPresenter?.viewDidLoad()
    }
}

extension  LaunchViewController: LaunchViewProtocol, Storyboarded {

    func enterHomeScreen(folders: [SetTopicModel]) {
        coordinator?.gotoHomeScreen(folders: folders)
    }
}
