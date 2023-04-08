//
//  SetTableViewCell.swift
//  Quizzie
//
//  Created by hieu nguyen on 03/11/2022.
//

import UIKit

class SetTableViewCell: UITableViewCell {

    @IBOutlet weak var topicNameLbl: UILabel!
    @IBOutlet weak var numberOfTermsLbl: UILabel!
    @IBOutlet weak var createdOnLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dateIntervalLabel: UILabel!
    @IBOutlet weak var frequencyContainer: UIView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var masterLevelView: UIView!
    @IBOutlet weak var progressContainer: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib() 
        setTextFont()
        containerView.addCornerRadius()
        containerView.backgroundColor = Colors.cellBackground
        frequencyContainer.addCornerRadius()
    }
    
    private func setTextFont() {
        topicNameLbl.font = Fonts.title
        topicNameLbl.textColor = Colors.mainText
        numberOfTermsLbl.font = Fonts.subtitle
        numberOfTermsLbl.textColor = Colors.mainText
        createdOnLbl.font = Fonts.regularText
        createdOnLbl.textColor = Colors.mainText
        dateIntervalLabel.font = Fonts.subtitle
        dateIntervalLabel.textColor = Colors.mainText
        progressLabel.font = Fonts.subtitle
        progressLabel.textColor = Colors.mainText
    }

    func setData(topic: TopicModel?) {
        guard let topic = topic else { return }
        progressContainer.isHidden = topic.intervalPractice == .master
        masterLevelView.isHidden = topic.intervalPractice != .master
        topicNameLbl.text = topic.name
        numberOfTermsLbl.text = "\(topic.numberOfTerms) \(Localizations.words.lowercased())"
        createdOnLbl.text = topic.createdTime
        dateIntervalLabel.text = (topic.intervalPractice ?? .daily).text
        frequencyContainer.backgroundColor = (topic.intervalPractice?.color ?? IntervalBetweenPractice.daily.color)
        progressLabel.text = "\(topic.numberOfPractice ?? 0)/\(topic.intervalPractice?.maxPracticeNumber ?? IntervalBetweenPractice.daily.maxPracticeNumber)"
        progressBar.progress = topic.percentCompletion
    }
}
