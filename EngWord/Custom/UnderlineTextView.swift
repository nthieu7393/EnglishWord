//
//  UnderlineTextView.swift
//  Quizzie
//
//  Created by hieu nguyen on 24/01/2023.
//

import UIKit

class UnderlineTextView: UITextView {

    private var hairlineLayer: CALayer?
    private var hairlineHeight: CGFloat = 0
    var forwardDelegate: UITextViewDelegate?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        delegate = self
        layout()
    }

    private func layout() {
        backgroundColor = UIColor.clear
        font = Fonts.regularText
        textColor = Colors.mainText
        textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        textContainer.lineFragmentPadding = 0.0

        hairlineLayer = CALayer()
        hairlineLayer?.backgroundColor = UIColor.green.cgColor
        layer.addSublayer(hairlineLayer!)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        forwardDelegate?.textViewDidChange?(self)
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

extension UnderlineTextView: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        forwardDelegate?.textViewDidChange?(textView)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        forwardDelegate?.textViewDidBeginEditing?(textView)
        hairlineLayer?.backgroundColor = Colors.active.cgColor
        hairlineHeight = 2.5
        hairlineLayer?.frame = CGRect(
            x: 0,
            y: bounds.height - hairlineHeight,
            width: bounds.width,
            height: hairlineHeight)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        forwardDelegate?.textViewDidEndEditing?(textView)
        hairlineLayer?.backgroundColor = Colors.unFocused.cgColor
        hairlineHeight = 2
        hairlineLayer?.frame = CGRect(
            x: 0,
            y: bounds.height - hairlineHeight,
            width: bounds.width,
            height: hairlineHeight)
    }
}
