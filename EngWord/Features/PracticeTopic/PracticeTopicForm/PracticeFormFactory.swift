//
//  PracticeFormInterface.swift
//  EngWord
//
//  Created by hieu nguyen on 24/02/2023.
//

import UIKit

class PracticalFormController {

    static func practiceFormView(
        for form: PracticeTopicForm,
        cards: [any Card],
        endTest handler: @escaping ((String) -> Void)
    ) -> any PracticeFormView {
        switch form {
        case .practiceTerm:
            let view = Bundle.main.loadNibNamed("PracticeTermForm", owner: nil)?.first as? PracticeTermForm
            var presenter = practiceFormPresenter(for: form, view: view!, cards: cards)
            presenter.endTestHandler = handler
            view!.presenter = presenter as? PracticeTermPresenter
            return view!
        case .practiceDescription:
            let view = Bundle.main.loadNibNamed("PracticeDescriptionForm", owner: nil)?.first as? PracticeDescriptionForm
            var presenter = practiceFormPresenter(for: form, view: view!, cards: cards)
            presenter.endTestHandler = handler
            view!.presenter = presenter as? PracticeDescriptionPresenter
            return view!
        }
    }

    static func practiceFormPresenter(
        for form: PracticeTopicForm,
        view: any PracticeFormView,
        cards: [any Card]
    ) -> PracticeFormPresenter {
        switch form {
        case .practiceTerm:
            return PracticeTermPresenter(view: view, cards: cards)
        case .practiceDescription:
            return PracticeDescriptionPresenter(view: view, cards: cards)
        }
    }
}
