//
//  TopicInRoutineTableCell.swift
//  EngWord
//
//  Created by hieu nguyen on 05/04/2023.
//

import UIKit

class TopicInRoutineTableCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberOfTermsLabel: UILabel!
    @IBOutlet weak var lastDateOfPracticeLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        selectionStyle = .none
        progressBar.tintColor = Colors.active
        setFonts()
    }

    private func setFonts() {
        titleLabel.font = Fonts.mainTitle
        numberOfTermsLabel.font = Fonts.subtitle
        lastDateOfPracticeLabel.font = Fonts.regularText
        
        titleLabel.textColor = Colors.mainText
        numberOfTermsLabel.textColor = Colors.unFocused
        lastDateOfPracticeLabel.textColor = Colors.unFocused
    }

    func setData(topic: TopicFolderWrapper) {
        titleLabel.text = topic.topic.name
        numberOfTermsLabel.text = "\(topic.topic.numberOfTerms)"
        lastDateOfPracticeLabel.text = topic.topic.lastPracticeDate
        progressBar.progress = Float(topic.topic.numberOfPractice ?? 0) / Float((topic.topic.intervalPractice ?? .daily).maxPracticeNumber)
    }
}
