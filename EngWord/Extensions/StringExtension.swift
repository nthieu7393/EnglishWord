//
//  StringExtension.swift
//  Quizzie
//
//  Created by hieu nguyen on 01/02/2023.
//

import UIKit

extension String {

    var isEmail: Bool {
        let emailPattern = #"^\S+@\S+\.\S+$"#
        let result = range(of: emailPattern, options: .regularExpression)
        return result != nil
    }

    var isValidPassword: Bool {
        let pattern = #"(?=.{8,})"#
        let result = range(of: pattern, options: .regularExpression)
        return result != nil
    }

    func getSize(font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [
            NSAttributedString.Key.font: font
        ])
    }

    func hightLight(
        text: String,
        font: UIFont? = nil,
        colorHighlight: UIColor) -> NSAttributedString? {
        let attributeString = NSMutableAttributedString(string: self, attributes: [
            NSAttributedString.Key.font: font ?? Fonts.boldText,
            NSAttributedString.Key.foregroundColor: Colors.mainText
        ])
        guard let range = (self as? NSString)?.range(of: text) else { return attributeString }
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: colorHighlight, range: range)
        return attributeString
    }
}
