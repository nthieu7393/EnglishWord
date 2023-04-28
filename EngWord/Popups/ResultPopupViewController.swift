//
//  ResultPopupViewController.swift
//  EngWord
//
//  Created by hieu nguyen on 19/04/2023.
//

import UIKit
import Lottie

protocol ResultPopupViewDelegate: AnyObject {
    
    func resultPopup(_ view: ResultPopupViewController, didTap detailsButton: ResponsiveButton)
    func resultPopup(_ view: ResultPopupViewController, onTap dismissButton: TextButton)
}

class ResultPopupViewController: UIViewController, Storyboarded {

    @IBOutlet weak var animationContainerView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var resultDetailButton: ResponsiveButton!
    @IBOutlet weak var effectContainerView: UIView!
    @IBOutlet weak var closeButton: TextButton!

    weak var delegate: ResultPopupViewDelegate?
    var medalAnimationView: AnimationView!
    var fireworkAnimationView: AnimationView!
    var isPass = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animationContainerView.backgroundColor = Colors.cellBackground
        animationContainerView.addCornerRadius()

       animationViews()
        
        titleLabel.textAlignment = .center
        titleLabel.font = Fonts.title
        titleLabel.textColor = isPass ? Colors.correct : Colors.incorrect
        titleLabel.text = isPass ? "Congratulations!" : "Opps..."
        
        messageLabel.textAlignment = .center
        messageLabel.font = Fonts.regularText
        messageLabel.textColor = Colors.mainText
        messageLabel.numberOfLines = 0
        messageLabel.text = isPass ? "You have passed\nthe test" : "You have failed\nthe test"
        
        resultDetailButton.title = "Check details"

        closeButton.title = "Dismiss"
    }
    
    @IBAction func closeButtonOnTap(_ sender: TextButton) {
        delegate?.resultPopup(self, onTap: sender)
    }

    private func animationViews() {

        if isPass {
            let fireworkAnimation = Animation.named(Animations.confettiWithFireworks.name)
            fireworkAnimationView = AnimationView(animation: fireworkAnimation)
            fireworkAnimationView.frame = animationContainerView.bounds
            animationContainerView.insertSubview(fireworkAnimationView, at: 0)

            fireworkAnimationView.play()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let medalAnimation = Animation.named(isPass ? Animations.congratulation.name : Animations.crying.name)
        medalAnimationView = AnimationView(animation: medalAnimation)
        effectContainerView.backgroundColor = UIColor.clear
        medalAnimationView.frame.size = CGSize(
            width: effectContainerView.bounds.height,
            height: effectContainerView.bounds.height)
        medalAnimationView.center = CGPoint(
            x: effectContainerView.bounds.width/2,
            y: effectContainerView.bounds.height/2)
        effectContainerView.addSubview(medalAnimationView)
        medalAnimationView.play()

    }
    
    @IBAction func detailsButtonOnTap(_ sender: ResponsiveButton) {
        delegate?.resultPopup(self, didTap: sender)
    }
}
