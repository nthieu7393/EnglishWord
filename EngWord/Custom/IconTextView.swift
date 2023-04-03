//
//  IconTextView.swift
//  EngWord
//
//  Created by hieu nguyen on 22/02/2023.
//

import UIKit

class IconTextView: UIView {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    var isEnabled: Bool = true {

        didSet {
            iconView.tintColor = isEnabled ? Colors.active : Colors.unFocused
            titleLabel.textColor = iconView.tintColor
        }
    }

    func setData(icon: UIImage, title: String) {
        iconView.image = icon.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = Colors.active
        titleLabel.text = title
        titleLabel.textColor = Colors.active
        titleLabel.font = Fonts.button
        backgroundColor = UIColor.clear
    }

    override var intrinsicContentSize: CGSize {
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: bounds.height)
        let textWidth = titleLabel.sizeThatFits(size).width + 24
        return CGSize(width: textWidth, height: size.height)
    }
}
