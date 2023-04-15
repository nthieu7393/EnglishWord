//
//  CorrectAnswerPopup.swift
//  EngWord
//
//  Created by hieu nguyen on 08/03/2023.
//

import UIKit

class TurnResultPopup: UIViewController {

    @IBOutlet weak var dismissButton: ResponsiveButton!
    @IBOutlet weak var popupWrapper: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!

    var result: TurnResult = .incorrect
    var completionHandler: (() -> Void)?

    var message: NSAttributedString?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        popupWrapper.addCornerRadius()
        dismissButton.title = "Continue"
        
        let image = result == .correct ? R.image.checkRoundFillIcon() : R.image.closeRoundFillIcon()
        let color = result == .correct ? Colors.correct : Colors.incorrect
        iconView.image = image?.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = color
        messageLabel.attributedText = message
        dismissButton.color = color
    }

    @IBAction func dismissButtonOnTap(_ sender: TextButton) {
        dismiss(animated: true, completion: nil)
        completionHandler?()
    }
}

extension TurnResultPopup: UIViewControllerTransitioningDelegate {

    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController) -> UIPresentationController? {
            return DimmingPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
