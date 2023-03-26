//
//  UserAvatarAndUsernameCell.swift
//  Quizzie
//
//  Created by hieu nguyen on 31/01/2023.
//

import UIKit

class UserAvatarAndUserNameCell: UITableViewCell {

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var joinDateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(userInfo: UserInfo) {
        
    }
}
