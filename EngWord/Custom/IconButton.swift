//
//  IconButton.swift
//  Quizzie
//
//  Created by hieu nguyen on 28/01/2023.
//

import UIKit

@IBDesignable
class IconButton: UIControl {
    private lazy var viewsOriginalTransform: CGAffineTransform! = {
        return iconView!.transform
    }()

    @IBInspectable
    var icon: UIImage? {
        get { return iconView?.image }
        set {
            iconView?.image = newValue?.withRenderingMode(.alwaysTemplate)
            iconView?.tintColor = tintColor
        }
    }

    private var renderMode: UIImage.RenderingMode = .alwaysOriginal

    private lazy var iconView: UIImageView? = {
        let image = UIImageView()
        image.tintColor = Colors.active
        image.backgroundColor = UIColor.clear
        image.contentMode = .scaleAspectFit
        return image
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
        addSubview(iconView!)
        iconView?.frame = bounds
        iconView?.image = icon?.withRenderingMode(.alwaysTemplate)
        iconView?.contentMode = .scaleAspectFit
        iconView?.tintColor = tintColor

        iconView?.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            iconView!.topAnchor.constraint(equalTo: topAnchor),
            iconView!.leftAnchor.constraint(equalTo: leftAnchor),
            iconView!.bottomAnchor.constraint(equalTo: bottomAnchor),
            iconView!.rightAnchor.constraint(equalTo: rightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonOnTap(_:))))
    }

    @objc func buttonOnTap(_ gesture: Any) {
        let transAnimation = CABasicAnimation(keyPath: "transform.scale")
        transAnimation.fromValue = 1
        transAnimation.toValue = 0.95
        transAnimation.duration = 0.1
        iconView?.layer.add(transAnimation, forKey: nil)
        sendActions(for: UIControl.Event.allTouchEvents)
        sendActions(for: UIControl.Event.valueChanged)
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
        iconView?.transform = CGAffineTransformScale(viewsOriginalTransform, 0.95, 0.95)
    }

    private func buttonOnTouchUp() {
        iconView?.transform = CGAffineTransformScale(viewsOriginalTransform, 1, 1)
    }
}
