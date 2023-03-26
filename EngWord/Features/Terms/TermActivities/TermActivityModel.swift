//
//  TermActivityModel.swift
//  EngWord
//
//  Created by hieu nguyen on 22/02/2023.
//

import UIKit

protocol TermActivitiesCellModel {

    var icon: UIImage { get }
    var title: String { get }
    var handler: () -> Void { get }
}

class LearnTermActivity: TermActivitiesCellModel {

    var icon: UIImage {
        return R.image.bookOpenIcon()!
    }

    var title: String {
        return Localizations.study
    }

    var handler: () -> Void

    init(handler: @escaping () -> Void) {
        self.handler = handler
    }
}

class TestTermActivity: TermActivitiesCellModel {

    var icon: UIImage {
        return R.image.bookCheckIcon()!
    }

    var title: String {
        return Localizations.test
    }

    var handler: () -> Void

    init(handler: @escaping () -> Void) {
        self.handler = handler
    }
}
