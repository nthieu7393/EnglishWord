//
//  TopicInRoutineTableCell.swift
//  EngWord
//
//  Created by hieu nguyen on 05/04/2023.
//

import UIKit

class TopicInRoutineTableCell: BaseTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberOfTermsLabel: UILabel!
    @IBOutlet weak var lastDateOfPracticeLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var containerView: ResponsiveView!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var startTestingButton: ResponsiveButton!

    var onTap: (() -> Void)?

    @IBAction func startTestingOnTap(_ sender: ResponsiveButton) {
        onTap?()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        progressBar.tintColor = Colors.active
        containerView.addCornerRadius()
        containerView.backgroundColor = Colors.cellBackground
        startTestingButton.title = "Start"
        setFonts()
    }

    private func setFonts() {
        titleLabel.font = Fonts.mainTitle
        numberOfTermsLabel.font = Fonts.subtitle
        lastDateOfPracticeLabel.font = Fonts.regularText
        percentLabel.font = Fonts.subtitle
        percentLabel.textColor = Colors.unFocused
        titleLabel.textColor = Colors.mainText
        numberOfTermsLabel.textColor = Colors.unFocused
        lastDateOfPracticeLabel.textColor = Colors.unFocused
    }

    func setData(topic: TopicFolderWrapper) {
        titleLabel.text = topic.topic.name
        numberOfTermsLabel.text = "\(topic.topic.numberOfTerms) Terms"
        lastDateOfPracticeLabel.text = "Last Practice: \(topic.topic.lastPracticeDate ?? "")"
        progressBar.tintColor = Colors.active
        percentLabel.text = "\(topic.topic.percentCompletionString) %"
        progressBar.progress = topic.topic.percentCompletion
    }
}
