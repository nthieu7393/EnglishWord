//
//  PracticeForm.swift
//  EngWord
//
//  Created by hieu nguyen on 25/02/2023.
//

import UIKit

enum PracticeTopicForm {

    case practiceTerm
    case practiceDescription
}

protocol PracticeFormView {

    associatedtype T: PracticeFormPresenter
    associatedtype U: UIView

    var contentView: U { get }
    var presenter: T? { get set }
    var delegate: PracticeFormDelegate? { get set }
    var description: String { get }

    func displayCard(card: (any Card)?)
    func updateRoundProgress(value: Float)
    func moveToNextCard()

    func showTurnResult(msg: NSAttributedString?, result: TurnResult)
}

extension PracticeFormView {
    func disableNextButton() {}
    func enableNextButton() {}
}

protocol PracticeFormPresenter {

    var endTestHandler: ((String) -> Void)? { get set }

    func getProcessingCard() -> (any Card)?
    func getPracticeCards() -> [any Card]
}

protocol PracticeFormControllerDelegate: AnyObject {

    func practiceFormController(_ controller: PracticeFormController, result: TurnResult)
}

class PracticeFormController: UIViewController {

    private var form: (any PracticeFormView)?
    weak var delegate: PracticeFormControllerDelegate?

    init(form: any PracticeFormView, delegatedController: PracticeFormControllerDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.form = form
        self.form?.delegate = self
        self.delegate = delegatedController
        view = form.contentView
    }

    func presentResultPopup(msg: NSAttributedString, result: TurnResult) {
        let popupStoryboard = UIStoryboard(name: R.storyboard.popupStoryboard.name, bundle: nil)
        guard let popupVC = popupStoryboard.instantiateViewController(
            withIdentifier: String(describing: TurnResultPopup.self)) as? TurnResultPopup else { return }
        popupVC.message = msg
        popupVC.result = result
        popupVC.completionHandler = { [weak self] in
            self?.form?.moveToNextCard()
        }
        present(popupVC, animated: true)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension PracticeFormController: PracticeFormDelegate {

    func practiceForm(_ form: any PracticeFormView, msg: NSAttributedString?, result: TurnResult) {
        if let msg = msg {
            presentResultPopup(msg: msg, result: result)
        }
        delegate?.practiceFormController(self, result: result)
    }
}
