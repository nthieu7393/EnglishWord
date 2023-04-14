//
//  TextButton.swift
//  Quizzie
//
//  Created by hieu nguyen on 28/01/2023.
//

import UIKit

@IBDesignable
class TextButton: UIControl {

    @IBInspectable
    var titleAlign: NSTextAlignment = .center {
        didSet {
            titleLabel?.textAlignment = titleAlign
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            super.isEnabled = isEnabled
            textColor = isEnabled ? Colors.active : Colors.unFocused
            layoutSubviews()
        }
    }

    var textColor: UIColor? {
        didSet {
            titleLabel?.textColor = textColor
        }
    }

    private lazy var titleLabel: UILabel? = {
        let label = UILabel()
        label.font = Fonts.button
        label.textColor = textColor
        label.textAlignment = titleAlign
        label.backgroundColor = UIColor.clear
        return label
    }()

    private lazy var viewsOriginalTransform: CGAffineTransform! = {
        return titleLabel!.transform
    }()

    var title: String? {

        didSet {
            guard let titles = title else { return }
            titleLabel?.text = titles
        }
    }

    var attributeString: NSAttributedString? {

        didSet {
            guard let attribute = attributeString else { return }
            titleLabel?.attributedText = attribute
        }
    }

    required init?(coder: NSCoder) {
        textColor = Colors.mainText
        super.init(coder: coder)
        initLayout()
    }

    override init(frame: CGRect) {
        textColor = Colors.mainText
        super.init(frame: frame)
        initLayout()
    }

    init(_ text: String, frame: CGRect) {
        super.init(frame: frame)
        title = text
        initLayout()
    }

    private func initLayout() {
        backgroundColor = UIColor.clear
        titleLabel?.text = title
        titleLabel?.textColor = Colors.active
        addSubview(titleLabel!)

        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            titleLabel!.topAnchor.constraint(equalTo: topAnchor),
            titleLabel!.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel!.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel!.rightAnchor.constraint(equalTo: rightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonOnTap(_:))))
    }

    @objc func buttonOnTap(_ gesture: Any) {
        titleLabel?.textColor = Colors.active
        let transAnimation = CABasicAnimation(keyPath: "transform.scale")
        transAnimation.fromValue = 1.1
        transAnimation.toValue = 0.9
        transAnimation.duration = 0.1
        transAnimation.delegate = self
        titleLabel?.layer.add(transAnimation, forKey: nil)
    }

    override var intrinsicContentSize: CGSize {
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: bounds.height)
        let textWidth = titleLabel!.sizeThatFits(size).width
        return CGSize(width: textWidth, height: size.height)
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
        titleLabel?.transform = CGAffineTransformScale(viewsOriginalTransform, 0.95, 0.95)
    }

    private func buttonOnTouchUp() {
        titleLabel?.transform = CGAffineTransformScale(viewsOriginalTransform, 1, 1)
    }
}

extension TextButton: CAAnimationDelegate {

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard flag else { return }
        sendActions(for: .allTouchEvents)
    }
}
