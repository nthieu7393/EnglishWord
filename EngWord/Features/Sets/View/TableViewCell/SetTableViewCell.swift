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
        dateIntervalLabel.font = Fonts.regularText
        dateIntervalLabel.textColor = Colors.mainText
    }

    func setData(topic: TopicModel?) {
        topicNameLbl.text = topic?.name
        numberOfTermsLbl.text = "\(topic?.numberOfTerms ?? 0) \(Localizations.words.lowercased())"
        createdOnLbl.text = topic?.createdTime
        dateIntervalLabel.text = (topic?.intervalPractice ?? .daily).text
        frequencyContainer.backgroundColor = (topic?.intervalPractice?.color ?? IntervalBetweenPractice.daily.color).darker(componentDelta: 0.5)
    }
}
