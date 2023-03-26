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
    var presenter: T? { get }
    var delegate: PracticeFormDelegate? { get set }
    var description: String { get }

    func displayCard(card: (any Card)?)
    func updateRoundProgress(value: Float)
    func moveToNextCard()

    func showTurnResult(msg: NSAttributedString?, result: TurnResult)
}

protocol PracticeFormPresenter {

    var endTestHandler: ((String) -> Void)? { get set }

    func getProcessingCard() -> (any Card)?
    func getPracticeCards() -> [any Card]
}

// ---
//class PracticeTermView: UIView, PracticeFormView {
//    typealias T = PracticeTermPresenter
//
//    var vvvv: PracticeTermForm!
//
//    var presenter: PracticeTermPresenter? {
//        didSet {
//
//        }
//    }
//
//    var contentView: PracticeTermForm {
//        if vvvv == nil {
//            vvvv = Bundle.main.loadNibNamed("PracticeTermForm", owner: nil)?.first as? PracticeTermForm
//        }
//        return vvvv
//    }
//
//    override var description: String {
//        return "PracticeTermView"
//    }
//}

//class PracticeDescriptionView: UIView, PracticeFormView {
//    typealias T = PracticeDescriptionPresenter
//
//    var presenter: PracticeDescriptionPresenter?
//    var contentView: PracticeDescriptionForm {
//        return Bundle.main.loadNibNamed("PracticeDescriptionForm", owner: nil)?.first as! PracticeDescriptionForm
//    }
//
//    override var description: String {
//        return "PracticeDescriptionForm"
//    }
//}

// ---

//struct AnsweredCard {
//
//    var card: (any Card)
//    var isCorrect: Bool
//
//    func checkIfAnswer(_ card: Card) -> Bool {
//        return card.isEqual(card: card)
//    }
//}

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
