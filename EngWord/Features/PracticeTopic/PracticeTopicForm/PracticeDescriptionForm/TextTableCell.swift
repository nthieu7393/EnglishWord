//
//  TextTableCell.swift
//  EngWord
//
//  Created by hieu nguyen on 28/02/2023.
//

import UIKit

class TextTableCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var answerWrapper: UIView!
    @IBOutlet weak var termView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var termLabel: UILabel!

    private var indexPath: IndexPath?
    var index: Int {
        return indexPath?.row ?? 0
    }

    var alreadyAnswered: Bool {
        return !(termLabel.text ?? "").isEmpty
    }
    var isHover = false {
        didSet {
            if isHover {
                zoomOutView()
            } else {
                zoomInView()
            }
        }
    }
    var card: Card?

    private func zoomOutView() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 5) {
                self.containerView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }
    }

    private func zoomInView() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 2) {
                self.containerView.transform = .identity
            }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        answerWrapper.backgroundColor = UIColor.clear
        answerWrapper.addCornerRadius()
        termView.isHidden = true
        descriptionLabel.font = Fonts.regularText
        descriptionLabel.textColor = Colors.mainText
        containerView.addCornerRadius()
        containerView.backgroundColor = Colors.cellBackground
        termLabel.font = Fonts.boldText
        termLabel.textColor = Colors.mainText
    }

    func setCard(card: Card?, indexPath: IndexPath) {
        guard let card = card else { return }
        self.card = card
        self.indexPath = indexPath
        descriptionLabel.text = card.selectedDefinition
        termLabel.text = ""
        termView.isHidden = true
    }

    func answer(_ text: String) {
        termLabel.text = text
        termView.isHidden = false
        zoomInView()
        let resultColor = text == card?.termDisplay ? Colors.correct : Colors.incorrect
        termLabel.textColor = resultColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
