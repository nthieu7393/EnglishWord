//
//  ResultPopupViewController.swift
//  EngWord
//
//  Created by hieu nguyen on 19/04/2023.
//

import UIKit
import Lottie

protocol ResultPopupViewDelegate: AnyObject {
    
    func resultView(_ view: ResultPopupViewController, didTap detailsButton: ResponsiveButton)
}

class ResultPopupViewController: UIViewController, Storyboarded {

    @IBOutlet weak var animationContainerView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var resultDetailButton: ResponsiveButton!
    @IBOutlet weak var effectContainerView: UIView!
    
    weak var delegate: ResultPopupViewDelegate?
    var animationView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animationContainerView.backgroundColor = Colors.cellBackground
        animationContainerView.addCornerRadius()
        
        
        let animation = Animation.named(Animations.congratulation.name)
        animationView = AnimationView(animation: animation)
        animationView.frame.size = CGSize(width: effectContainerView.bounds.height, height: effectContainerView.bounds.height)
        animationView.center = CGPoint(x: effectContainerView.bounds.width/2, y: effectContainerView.bounds.height/2)
        effectContainerView.backgroundColor = Colors.cellBackground
        effectContainerView.addSubview(animationView)
      
        
        titleLabel.textAlignment = .center
        titleLabel.font = Fonts.title
        titleLabel.textColor = Colors.mainText
        titleLabel.text = "Congratulations!"
        
        messageLabel.textAlignment = .center
        messageLabel.font = Fonts.regularText
        messageLabel.textColor = Colors.mainText
        messageLabel.numberOfLines = 0
        messageLabel.text = "You have passed\nthe test"
        resultDetailButton.title = "Check details"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animationView.play()
    }
    
    @IBAction func detailsButtonOnTap(_ sender: ResponsiveButton) {
        delegate?.resultView(self, didTap: sender)
    }
    
}
