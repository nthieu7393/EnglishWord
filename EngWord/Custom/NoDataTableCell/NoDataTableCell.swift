//
//  NoDataTableCell.swift
//  EngWord
//
//  Created by hieu nguyen on 09/04/2023.
//

import UIKit

class NoDataTableCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        label.text = "No Data"
        backgroundColor = UIColor.clear
        label.font = Fonts.title
        label.textColor = Colors.mainText
    }
}
