//
//  PracticalResult.swift
//  EngWord
//
//  Created by hieu nguyen on 10/03/2023.
//

import UIKit

protocol PracticalResultPopupDelegate: AnyObject {

    func practicalResultPopup(
        _ popup: PracticalResultViewController,
        onTap doneButton: TextButton
    )
}

class PracticalResultViewController: UIViewController, Storyboarded {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var continueButton: TextButton!

    var practicalResult: PracticalResult?
    weak var delegate: PracticalResultPopupDelegate?

    @IBAction func doneButtonOnTap(_ sender: TextButton) {
        delegate?.practicalResultPopup(self, onTap: sender)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let isPass = practicalResult == .pass

        wrapperView.addCornerRadius()

        resultLabel.font = Fonts.boldText
        resultLabel.textColor = isPass ? Colors.correct : Colors.incorrect

        messageLabel.font = Fonts.boldText
        messageLabel.textColor = Colors.mainText

        iconView.image = isPass ? R.image.trophyIcon() : R.image.sadFaceIcon()
        resultLabel.text = isPass ? "Congratulation" : "Fail"
        messageLabel.text = isPass ? "You have completed these cards" : "You have not familiar with these cards"
        continueButton.title = Localizations.done
    }
}
