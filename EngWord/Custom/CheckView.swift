//
//  CustomButton.swift
//  Quizzie
//
//  Created by hieu nguyen on 28/01/2023.
//

import UIKit

class CheckView: UIView {

    private var cornerRadiusLayer: CALayer?
    private var shadowLayer: CALayer?
    private let shadowOffset: CGFloat = 4
    var onTap: (() -> Void)?

    private var isScaleDown = false

    var color: UIColor? {
        didSet {
            setBackgroundColor()
        }
    }

    var textColor: UIColor? {
        didSet {
            layoutIfNeeded()
        }
    }

    var isEnabled: Bool = false {
        didSet {
//            super.isEnabled = isEnabled
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initLayout()
    }

    private func setBackgroundColor() {
        cornerRadiusLayer?.backgroundColor = color?.cgColor ?? Colors.active.cgColor
        shadowLayer?.backgroundColor = (color ?? Colors.active)?.darker().cgColor
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        shadowLayer?.frame = CGRect(
            x: 0,
            y: shadowOffset,
            width: bounds.width,
            height: bounds.height - shadowOffset)
        shadowLayer?.shadowPath = UIBezierPath(rect: shadowLayer!.bounds).cgPath
        cornerRadiusLayer?.frame = CGRect(
            x: 0,
            y: 0,
            width: bounds.width,
            height: bounds.height - shadowOffset)
    }

    private lazy var viewsOriginalTransform: CGAffineTransform! = {
        return transform
    }()

    private func initLayout() {
        backgroundColor = Colors.cellBackground

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonOnTap(_:))))
    }

    @objc func buttonOnTap(_ gesture: Any) {
//        let transAnimation = CABasicAnimation(keyPath: "transform.translation")
//        transAnimation.toValue = NSValue(cgPoint: CGPoint(x: 0, y: shadowOffset))
//        let groupTransform = CAAnimationGroup()
//        groupTransform.duration = 0.08
//        groupTransform.beginTime = CACurrentMediaTime()
//        groupTransform.animations = [transAnimation]
//        groupTransform.isRemovedOnCompletion = false
//        cornerRadiusLayer?.add(groupTransform, forKey: "transform")

        transform = CGAffineTransformScale(viewsOriginalTransform, !isScaleDown ? 0.93 : 1, !isScaleDown ? 0.93 : 1)
        isScaleDown = !isScaleDown
        onTap?()
//        backgroundColor = isScaleDown ? Colors.active : Colors.cellBackground
    }
}
