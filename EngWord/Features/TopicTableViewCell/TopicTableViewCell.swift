//
//  TopicTableViewCell.swift
//  EngWord
//
//  Created by hieu nguyen on 17/02/2023.
//

import UIKit

class TopicTableViewCell: BaseTableViewCell {

    @IBOutlet weak var containerView: CheckView!
    @IBOutlet weak var createDateLabel: UILabel!
    @IBOutlet weak var calendarIcon: UIImageView!
    @IBOutlet weak var numberOfTermsLabel: UILabel!
    @IBOutlet weak var topicNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.backgroundColor = Colors.cellBackground
        containerView.addCornerRadius()
        topicNameLabel.font = Fonts.title
        topicNameLabel.textColor = Colors.mainText
        numberOfTermsLabel.font = Fonts.subtitle
        numberOfTermsLabel.textColor = Colors.mainText

        calendarIcon.image = R.image.calendarLineIcon()?.withRenderingMode(.alwaysTemplate)
        calendarIcon.tintColor = Colors.mainText
        createDateLabel.font = Fonts.regularText
        createDateLabel.textColor = Colors.mainText
    }

    func setData(topic: TopicModel) {
        topicNameLabel.text = topic.name
        numberOfTermsLabel.text = "\(topic.terms?.count ?? 0) Terms"
        createDateLabel.text = topic.createdTime
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
    }
}
