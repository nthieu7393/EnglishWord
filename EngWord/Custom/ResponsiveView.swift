//
//  IconButton.swift
//  Quizzie
//
//  Created by hieu nguyen on 28/01/2023.
//

import UIKit

protocol ResponsiveViewDelegate: AnyObject {

}

@IBDesignable
class ResponsiveView: UIControl {

    private lazy var viewsOriginalTransform: CGAffineTransform! = {
        return self.transform
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initLayout()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initLayout()
    }

    private func initLayout() {
        backgroundColor = UIColor.clear
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(buttonOnTap(_:))
        )
        addGestureRecognizer(tapGesture)

    }

    @objc func buttonOnTap(_ gesture: Any) {
        let transAnimation = CABasicAnimation(keyPath: "transform.scale")
        transAnimation.fromValue = 1
        transAnimation.toValue = 0.95
        transAnimation.duration = 0.1
        transAnimation.delegate = self
        layer.add(transAnimation, forKey: nil)
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
        transform = CGAffineTransformScale(viewsOriginalTransform, 0.95, 0.95)
    }

    private func buttonOnTouchUp() {
        transform = CGAffineTransformScale(viewsOriginalTransform, 1, 1)
    }
}

extension ResponsiveView: CAAnimationDelegate {

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard flag else { return }
        sendActions(for: UIControl.Event.allTouchEvents)
    }
}
