//
//  UnderlineTextField.swift
//  Quizzie
//
//  Created by hieu nguyen on 24/01/2023.
//

import UIKit

class UnderlineTextField: UITextField {

    private var hairlineLayer: CALayer?

    override var placeholder: String? {
        didSet {
            attributedPlaceholder = NSAttributedString(
                string: placeholder!,
                attributes: [
                    NSAttributedString.Key.foregroundColor: Colors.placeholder,
                    NSAttributedString.Key.font: Fonts.regularText
                ])
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layout()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    private func layout() {
        autocorrectionType = .no
        backgroundColor = UIColor.clear
        font = Fonts.regularText
        textColor = Colors.mainText

        hairlineLayer = CALayer()
        hairlineLayer?.backgroundColor = UIColor.green.cgColor

        layer.addSublayer(hairlineLayer!)

    }

    let padding = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        var hairlineHeight: CGFloat = 0
        if isFirstResponder {
            hairlineLayer?.backgroundColor = Colors.active.cgColor
            hairlineHeight = 2.5
        } else {
            hairlineLayer?.backgroundColor = Colors.unFocused.cgColor
            hairlineHeight = 2
        }
        hairlineLayer?.frame = CGRect(
            x: 0,
            y: bounds.height - hairlineHeight,
            width: bounds.width,
            height: hairlineHeight
        )
    }
}
