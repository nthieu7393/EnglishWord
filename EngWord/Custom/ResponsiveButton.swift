//
//  CustomButton.swift
//  Quizzie
//
//  Created by hieu nguyen on 28/01/2023.
//

import UIKit

class ResponsiveButton: UIControl {

    private var cornerRadiusLayer: CALayer?
    private var shadowLayer: CALayer?
    private let shadowOffset: CGFloat = 4

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

    override var isEnabled: Bool {
        didSet {
            super.isEnabled = isEnabled
        }
    }

    private var titleLabel: UILabel? = {
        let label = UILabel()
        label.font = Fonts.button
        label.textColor = Colors.mainText
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        return label
    }()

    var title: String? {
        didSet {
            guard let title = title else { return }
            titleLabel?.text = title
        }
    }

    required init?(coder: NSCoder) {
        textColor = Colors.mainText
        super.init(coder: coder)
        initLayout()
    }

    private func setBackgroundColor() {
        cornerRadiusLayer?.backgroundColor = color?.cgColor ?? Colors.active.cgColor
        shadowLayer?.backgroundColor = (color ?? Colors.active)?.darker().cgColor
    }

    override init(frame: CGRect) {
        textColor = Colors.mainText
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
        titleLabel?.frame = cornerRadiusLayer?.frame ?? CGRect.zero
    }

    private func initLayout() {
        backgroundColor = UIColor.clear
        shadowLayer = CALayer()
        shadowLayer?.cornerRadius = 12

        cornerRadiusLayer = CALayer()
        cornerRadiusLayer!.cornerRadius = 12
        
        layer.addSublayer(shadowLayer!)
        layer.addSublayer(cornerRadiusLayer!)

        titleLabel?.text = title
        addSubview(titleLabel!)
        setBackgroundColor()

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonOnTap(_:))))
    }

    @objc func buttonOnTap(_ gesture: Any) {
        let transAnimation = CABasicAnimation(keyPath: "transform.translation")
        transAnimation.toValue = NSValue(cgPoint: CGPoint(x: 0, y: shadowOffset))
        transAnimation.delegate = self
        let groupTransform = CAAnimationGroup()
        groupTransform.duration = 0.08
        groupTransform.beginTime = CACurrentMediaTime()
        groupTransform.animations = [transAnimation]
        groupTransform.isRemovedOnCompletion = false
        cornerRadiusLayer?.add(groupTransform, forKey: "transform")
        titleLabel?.layer.add(groupTransform, forKey: "transform")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: (title ?? "").count * 15, height: 40)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        buttonOnTouchDown()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        buttonOnTouchUp()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        buttonOnTouchUp()
    }

    private func buttonOnTouchDown() {
        self.cornerRadiusLayer?.frame.origin = CGPoint(x: 0, y: shadowOffset)
        self.titleLabel?.frame.origin = cornerRadiusLayer?.frame.origin ?? CGPoint.zero
        self.titleLabel?.layer.removeAllAnimations()
        self.cornerRadiusLayer?.removeAllAnimations()
    }

    private func buttonOnTouchUp() {
        self.cornerRadiusLayer?.frame.origin = CGPoint.zero
        self.titleLabel?.frame.origin = CGPoint.zero
        self.titleLabel?.layer.removeAllAnimations()
        self.cornerRadiusLayer?.removeAllAnimations()
    }
}

extension ResponsiveButton: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        sendActions(for: UIControl.Event.allTouchEvents)
        sendActions(for: UIControl.Event.valueChanged)
    }
}
