//
//  UIButtonExtension.swift
//  EngWord
//
//  Created by hieu nguyen on 19/02/2023.
//

import UIKit

extension UIButton {

    func setTitle(_ text: String, font: UIFont, textColor: UIColor) {
        setAttributedTitle(NSAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: textColor
            ]), for: .normal)

        setAttributedTitle(NSAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: textColor.lighter(componentDelta: 1.5)
            ]), for: .highlighted)
    }
}
