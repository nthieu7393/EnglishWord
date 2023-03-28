//
//  TermTableCell.swift
//  Quizzie
//
//  Created by hieu nguyen on 19/11/2022.
//

import UIKit

protocol TermTableCellDelegate: AnyObject {
    
    func updateHeightOfRow(_ cell: TermTableCell, _ textView: UITextView)
    func cardTableCell(_ cell: TermTableCell, onDelete card: (any Card)?)
    func cardTableCell(_ cell: TermTableCell, onReview card: (any Card))
    func cardTableCell(_ cell: TermTableCell, didTapPartOfSpeech card: (any Card)?)
    func cardTableCell(_ cell: TermTableCell, didUpdate card: any Card, forceUpdateUI: Bool)
    func cardTableCell(_ cell: TermTableCell)
}

class TermTableCell: UITableViewCell {

    @IBOutlet private weak var definitionTextView: UnderlineTextView!
    @IBOutlet private weak var exampleTextView: UnderlineTextView!
    @IBOutlet weak var termTextField: UnderlineTextField!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var termLabel: UILabel!
    @IBOutlet private weak var definitionLabel: UILabel!
    @IBOutlet private weak var exampleLabel: UILabel!
    @IBOutlet private weak var partOfSpeechButton: TextButton!
    @IBOutlet private weak var pronunciationButton: IconTextButton!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var recommendedDefinitionView: UIStackView!
    @IBOutlet weak var recommendedDefinitionHeightConstraintConstant: NSLayoutConstraint!
    @IBOutlet weak var recommendedExampleView: UIStackView!
    @IBOutlet weak var recommendedExampleHeightConstraintConstant: NSLayoutConstraint!

    private var tempHeightOfDefinition: CGFloat = 0
    private var tempHeightOfExample: CGFloat = 0
    private let numberOfItems = 5
    private var textViewInProcess: UITextView? {

        didSet {
            if textViewInProcess == nil {
                visibleRecommendedExamples = false
                visibleRecommendedDefinitions = false
            } else if textViewInProcess == definitionTextView {
                visibleRecommendedExamples = false
                visibleRecommendedDefinitions = !recommendedDefinitionView.arrangedSubviews.isEmpty
            } else if textViewInProcess == exampleTextView {
                visibleRecommendedDefinitions = false // !recommendedDefinitionView.arrangedSubviews.isEmpty
                visibleRecommendedExamples = !recommendedExampleView.arrangedSubviews.isEmpty
            }
            delegate?.cardTableCell(self)
//            delegate?.cardTableCell(self, didUpdate: card!, forceUpdateUI: false)
        }
    }
    private var card: (any Card)?
    weak var delegate: TermTableCellDelegate?
    private var isEditingTermOfCard = false

    var visibleRecommendedDefinitions: Bool = false {
        didSet {
            if visibleRecommendedDefinitions {
                visibleRecommendedExamples = false
            }
            self.heightOfRecommendedDefinitions = self.visibleRecommendedDefinitions ? self.tempHeightOfDefinition : 0.0
            self.recommendedDefinitionHeightConstraintConstant.constant = self.heightOfRecommendedDefinitions
            
            UIView.animate(withDuration: 0.297, delay: 0.0) {
                self.recommendedDefinitionView.alpha = self.visibleRecommendedDefinitions ? 1.0 : 0.0
                self.recommendedDefinitionView.layoutIfNeeded()
                self.layoutIfNeeded()
            }
        }
    }

    private var heightOfRecommendedDefinitions = 0.0

    var dynamicRecommendedDefinitionHeight: CGFloat {
        return heightOfRecommendedDefinitions
    }

    var visibleRecommendedExamples: Bool = false {
        didSet {
            if visibleRecommendedExamples {
                visibleRecommendedDefinitions = false
            }
            self.heightOfRecommendedExamples = self.visibleRecommendedExamples ? self.tempHeightOfExample : 0.0
            self.recommendedExampleHeightConstraintConstant.constant = self.heightOfRecommendedExamples
            
            UIView.animate(withDuration: 0.297, delay: 0.0) {
                self.recommendedExampleView.alpha = self.visibleRecommendedExamples ? 1.0 : 0.0
                self.recommendedExampleView.layoutIfNeeded()
                self.layoutIfNeeded()
            }
        }
    }

    private var heightOfRecommendedExamples = 0.0

    var dynamicRecommendedExampleHeight: CGFloat {
        return heightOfRecommendedExamples
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        recommendedDefinitionHeightConstraintConstant.constant = 0
        recommendedExampleHeightConstraintConstant.constant = 0

        termTextField.addTarget(
            self,
            action: #selector(termTfEditingChanged(_:)),
            for: .editingChanged)
        termTextField.addTarget(
            self,
            action: #selector(termTfEditingDidBegin(_:)),
            for: .editingDidBegin)
        recommendedExampleView.alpha = 0.0
        recommendedDefinitionView.alpha = 0.0
        setupLabels()
        containerView.backgroundColor = Colors.cellBackground
        containerView.addCornerRadius()
        partOfSpeechButton.isHidden = true
        partOfSpeechButton.titleAlign = .left
        pronunciationButton.visibleBorder = false
        pronunciationButton.backgroundColor = UIColor.clear
        pronunciationButton.isHidden = true
        definitionTextView.forwardDelegate = self
        exampleTextView.forwardDelegate = self
    }

    private func newRecommendedRow(text: String, function: Selector) -> UIView {
        let view2 = UIView()
        view2.backgroundColor = Colors.mainBackground
        let textButton2 = TextButton()
        textButton2.titleAlign = .left
        textButton2.title = text
        view2.addSubview(textButton2)
        textButton2.translatesAutoresizingMaskIntoConstraints = false
        textButton2.topAnchor.constraint(equalTo: view2.topAnchor, constant: 0).isActive = true
        textButton2.bottomAnchor.constraint(equalTo: view2.bottomAnchor, constant: 0).isActive = true
        textButton2.leftAnchor.constraint(equalTo: view2.leftAnchor, constant: 12).isActive = true
        textButton2.rightAnchor.constraint(equalTo: view2.rightAnchor, constant: -12).isActive = true
        textButton2.addTarget(self, action: function, for: .allTouchEvents)
        return view2
    }

    @objc private func recommendedDefinitionOnTap(_ sender: TextButton) {
        card?.selectedDefinition = sender.title
        definitionTextView.text = sender.title
        textViewInProcess = nil
    }

    @objc private func recommendedExampleOnTap(_ sender: TextButton) {
        card?.selectedExample = sender.title
        exampleTextView.text = sender.title
        textViewInProcess = nil
    }

    private func setupLabels() {
        termLabel.text = Localizations.term
        termLabel.font = Fonts.subtitle
        termLabel.textColor = Colors.unFocused
        definitionLabel.text = Localizations.definition
        definitionLabel.font = Fonts.subtitle
        definitionLabel.textColor = termLabel.textColor
        exampleLabel.text = Localizations.example
        exampleLabel.font = Fonts.subtitle
        exampleLabel.textColor = termLabel.textColor
    }

    @objc func termTfEditingChanged(_ sender: UITextField) {
        removeRecommendedDefinitionRowFromStack()
        removeRecommendedExamplesRowFromStack()
        guard sender.text != card?.termDisplay else { return }
        isEditingTermOfCard = true
        guard var uwrCard = card else { return }
        uwrCard.termDisplay = sender.text ?? ""
        startLoading()
        delegate?.cardTableCell(self, didUpdate: uwrCard, forceUpdateUI: true)
    }

    @objc func termTfEditingDidBegin(_ sender: UITextField) {
        textViewInProcess = nil
    }

    private func addRecommendedDefinitionRowToStack(recommendedDefinitions: [String]) {
        removeRecommendedDefinitionRowFromStack()
        recommendedDefinitions.prefix(numberOfItems).forEach({ text in
            let view = newRecommendedRow(text: text, function: #selector(recommendedDefinitionOnTap(_:)))
            tempHeightOfDefinition += 30
            recommendedDefinitionView.addArrangedSubview(view)
        })
    }

    private func removeRecommendedDefinitionRowFromStack() {
        tempHeightOfDefinition = 0
        recommendedDefinitionView.arrangedSubviews.forEach {
            recommendedDefinitionView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }

    private func addRecommendedExamplesRowToStack(recommendedExamples: [String]) {
        removeRecommendedExamplesRowFromStack()
        recommendedExamples.prefix(numberOfItems).forEach({ text in
            let view = newRecommendedRow(text: text, function: #selector(recommendedExampleOnTap(_:)))
            tempHeightOfExample += 30
            recommendedExampleView.addArrangedSubview(view)
        })
    }

    private func removeRecommendedExamplesRowFromStack() {
        tempHeightOfExample = 0
        recommendedExampleView.arrangedSubviews.forEach {
            recommendedExampleView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
    
    func setCard(term: (Card)?, delegate: TermTableCellDelegate, forceUpdateUI: Bool = true) {
        self.delegate = delegate
        finishLoading()
        guard let term = term else { return }
        self.card = term

        displayCard(card: term, needUpdateUI: forceUpdateUI)

        if !isEditingTermOfCard {
            termTextField.text = term.termDisplay
        }

        becomeFirstResponserIfNeed(card: term)
    }

    private func displayCard(card: any Card, needUpdateUI: Bool) {
        addRecommendedDefinitionRowToStack(recommendedDefinitions: card.listOfDefinition)
        addRecommendedExamplesRowToStack(recommendedExamples: card.listOfExamples ?? [])

        showRecommendListIfNeed()

        guard needUpdateUI else { return }
        partOfSpeechButton.isHidden = !card.partOfSpeechDisplay.isNotEmpty()
        partOfSpeechButton.title = PartOfSpeech(rawValue: (card.partOfSpeechDisplay ?? ""))?.shortText
        pronunciationButton.isHidden = (card.phoneticDisplay ?? "").isEmpty
        pronunciationButton.set(icon: R.image.speakerIcon()!, title: card.phoneticDisplay ?? "")
        definitionTextView.text = card.selectedDefinition
        exampleTextView.text = card.selectedExample
    }

    private func showRecommendListIfNeed() {
        if textViewInProcess == definitionTextView && !visibleRecommendedDefinitions {
            visibleRecommendedDefinitions = !recommendedDefinitionView.arrangedSubviews.isEmpty
        } else if textViewInProcess == exampleTextView && !visibleRecommendedExamples {
            visibleRecommendedExamples = !recommendedExampleView.arrangedSubviews.isEmpty
        }
    }

    private func becomeFirstResponserIfNeed(card: any Card) {
        if card.termDisplay.isEmpty {
            termTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func deleteButtonOnTap(_ sender: IconButton) {
        delegate?.cardTableCell(self, onDelete: card)
    }

    func startLoading() {
        loadingIndicator.startAnimating()
    }

    func finishLoading() {
        loadingIndicator.stopAnimating()
    }

    @IBAction func reviewCardButtonOnTap(_ sender: UIControl) {
        guard let term = card else { return }
        delegate?.cardTableCell(self, onReview: term)
    }

    @IBAction func partOfSpeechOnTap(_ sender: TextButton) {
        textViewInProcess = nil
        delegate?.cardTableCell(self, didTapPartOfSpeech: card)
    }

    fileprivate func hideAllRecommendList() {

    }
}

extension TermTableCell: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        guard var card = card else { return }
        
        if textView == definitionTextView {
            card.selectedDefinition = textView.text
        } else if textView == exampleTextView {
            card.selectedExample = textView.text
        }
        delegate?.cardTableCell(self)

//        delegate?.updateHeightOfRow(self, textView)
//        delegate?.cardEditingChanged(self, uwrCard)
//
//
//        guard let uwrCard = card,
//              uwrCard.listOfDefinition.isEmpty
//                || (uwrCard.listOfExamples?.isEmpty ?? true) else { return }
//        delegate?.cardEditingChanged(self, uwrCard)
//        delegate?.cardTableCell(self, didUpdate: uwrCard, needLoadData: false)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewInProcess = textView
        if let card = card, !card.termDisplay.isEmpty && !card.hasRecommendedData {
            startLoading()
            delegate?.cardTableCell(self, didUpdate: card, forceUpdateUI: false)
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        textViewInProcess = nil
        delegate?.cardTableCell(self)
    }
    
    func updateDataOfCard() {
        card?.selectedDefinition = definitionTextView.text
        //        card?.selectedExample = exampleTextView.text
        //        delegate?.updateHeightOfRow(self, definitionTextView)
        //        delegate?.updateHeightOfRow(self, exampleTextView)
        finishLoading()
    }
}
