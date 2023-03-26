//
//  IconTextButton.swift
//  Quizzie
//
//  Created by hieu nguyen on 28/01/2023.
//

import UIKit

class IconTextButton: UIControl {

    var view = UIView()

    private var icon: UIImage?
    private var title: String?
    private var backgroundLayer = CALayer()
    var button: IconTextView?

    var visibleBorder = true
    private lazy var viewsOriginalTransform: CGAffineTransform! = {
        return view.transform
    }()

    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: IconTextButton.self)
        let nib = UINib(nibName: String(describing: IconTextButton.self), bundle: bundle)
        return nib.instantiate(withOwner: self).first as? UIView ?? UIView()
    }

    override var intrinsicContentSize: CGSize {
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: bounds.height)
        let textWidth = (button?.titleLabel.sizeThatFits(size).width ?? 0) + 24
        return CGSize(width: textWidth, height: size.height)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initLayout()
    }

    func set(icon: UIImage, title: String) {
        self.icon = icon
        self.title = title
        if button == nil {
            initLayout()
        } else {
            button?.iconView.image = icon.withRenderingMode(.alwaysTemplate)
            button?.titleLabel.text = title
        }
    }

    private func initLayout() {

        backgroundLayer.backgroundColor = backgroundColor?.cgColor
        backgroundLayer.cornerRadius = Constants.borderRadius
        backgroundLayer.masksToBounds = true
        view.layer.addSublayer(backgroundLayer)

        addSubview(view)

        button = Bundle.main.loadNibNamed(String(describing: IconTextView.self), owner: self, options: nil)![0] as? IconTextView
        guard let icon = icon, let title = title else { return }
        button?.setData(icon: icon, title: title)
        button?.backgroundColor = UIColor.clear // backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        let constraintss = [
            view.leftAnchor.constraint(equalTo: leftAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            rightAnchor.constraint(equalTo: view.rightAnchor)
        ]
        NSLayoutConstraint.activate(constraintss)
        button?.frame = view.bounds
        view.addSubview(button!)
        view.backgroundColor = UIColor.clear // backgroundColor

        backgroundColor = UIColor.clear
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonOnTap(_:))))
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        if visibleBorder {
            view.addLineBorder(cornerRadius: Constants.borderRadius)
        }
        backgroundLayer.frame = layer.bounds
    }

    @objc func buttonOnTap(_ gesture: Any) {
        let transAnimation = CABasicAnimation(keyPath: "transform.scale")
        transAnimation.fromValue = 1
        transAnimation.toValue = 0.95
        transAnimation.duration = 0.1
        view.layer.add(transAnimation, forKey: nil)
        sendActions(for: .allTouchEvents)
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
        view.transform = CGAffineTransformScale(viewsOriginalTransform, 0.95, 0.95)
    }

    private func buttonOnTouchUp() {
        view.transform = CGAffineTransformScale(viewsOriginalTransform, 1, 1)
    }
}
