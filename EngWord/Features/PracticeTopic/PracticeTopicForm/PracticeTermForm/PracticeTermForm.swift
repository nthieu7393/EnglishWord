//
//  PracticeTermForm.swift
//  EngWord
//
//  Created by hieu nguyen on 24/02/2023.
//

import UIKit

protocol PracticeFormDelegate: AnyObject {

    func practiceForm(
        _ form: any PracticeFormView,
        msg: NSAttributedString?,
        result: TurnResult
    )
}

class PracticeTermForm: UIView, PracticeFormView {

    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var answerTextfield: UnderlineTextField!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var answerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextButton: TextButton!

    weak var delegate: PracticeFormDelegate?
    var completionHandler: ((String) -> Void)?

    var presenter: PracticeTermPresenter? {
        didSet {
            displayCard(card: presenter?.getProcessingCard())
        }
    }

    var contentView: PracticeTermForm {
        return self
    }

    @IBAction func nextButtonOnTap(_ sender: TextButton) {
        presenter?.checkAnswer(answer: answerTextfield.text ?? "")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        progressBar.progress = 0.0
        answerTextfield.addTarget(self, action: #selector(answerEditingChanged(_:)), for: .editingChanged)
        nextButton.isEnabled = false
        answerLabel.font = Fonts.subtitle
        answerLabel.textColor = Colors.mainText
        answerLabel.text = "Your answer"
        descriptionLabel.font = Fonts.mainTitle
        descriptionLabel.textColor = Colors.mainText
        nextButton.title = "Next"
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc func answerEditingChanged(_ sender: UnderlineTextField) {
        presenter?.answerEditingChanged(sender.text ?? "")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            layoutIfKeyboardShow(keyboardSize: keyboardSize.cgRectValue)
        }
    }

    @objc
    func keyboardWillHide(_ notification: Notification) {
        if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            layoutIfKeyboardHide(keyboardSize: keyboardSize.cgRectValue)
        }
    }

    func layoutIfKeyboardShow(keyboardSize: CGRect) {
        answerBottomConstraint.constant = keyboardSize.height
    }

    func layoutIfKeyboardHide(keyboardSize: CGRect) {}

    func displayCard(card: (any Card)?) {
        UIView.transition(
            with: descriptionLabel,
            duration: 0.25,
            animations: {
                self.descriptionLabel.text = card?.selectedDefinition
                self.answerTextfield.text = ""
            },
            completion: { isFinish in
                guard isFinish else { return }
                self.answerTextfield.becomeFirstResponder()
                self.nextButton.isEnabled = false
            })
    }

    func showTurnResult(msg: NSAttributedString?, result: TurnResult) {
        delegate?.practiceForm(self, msg: msg, result: result)
    }

    func updateRoundProgress(value: Float) {
        progressBar.progress = value
    }

    func moveToNextCard() {
        let originFrame = descriptionLabel.center
        UIView.animate(withDuration: 0.3, delay: 0.1) {
            self.descriptionLabel.center.x -= self.bounds.width
        } completion: { isFinish in
            guard isFinish else { return }
            self.presenter?.goToNextCard()
        }
        UIView.animate(withDuration: 0.0, delay: 0.3) {
            self.descriptionLabel.center.x = originFrame.x + self.bounds.width
        }
        UIView.animate(withDuration: 0.3, delay: 0.7) {
            self.descriptionLabel.center = originFrame
        }
    }
    
    func disableNextButton() {
        nextButton.isEnabled = false
    }
    
    func enableNextButton() {
        nextButton.isEnabled = true
    }
}
