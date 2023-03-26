//
//  HomeMenuTableViewCell.swift
//  Quizzie
//
//  Created by hieu nguyen on 31/10/2022.
//

import UIKit

class HomeMenuTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLbl: UILabel!
    @IBOutlet private weak var iconImg: UIImageView!
    
    @IBOutlet weak var numberLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setFont()
    }
    
    private func setFont() {
        titleLbl.font = Fonts.mediumText
        numberLbl.font = Fonts.mediumText
        titleLbl.textColor = Colors.mainText
        numberLbl.textColor = Colors.mainText
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func display(data: HomeMenuModel?) {
        titleLbl.text = data?.title
        iconImg.image = data?.icon
        numberLbl.text = "\(data?.numberOfItems ?? 0)"
    }
}
