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

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    private func setFonts() {
//        titleLabel.font = Fonts.
    }

    func setData(topic: TopicFolderWrapper) {
        titleLabel.text = topic.topic.name
    }
}
