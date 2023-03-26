 //
//  BaseView.swift
//  Quizzie
//
//  Created by hieu nguyen on 05/11/2022.
//

import UIKit

class BaseView: UIView {

    var borderRadius: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layoutView()
    }

    private func layoutView() {
        layer.masksToBounds = true
        layer.cornerRadius = borderRadius
    }
}
