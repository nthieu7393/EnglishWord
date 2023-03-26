//
//  UserInfoLogoutTableCell.swift
//  Quizzie
//
//  Created by hieu nguyen on 31/01/2023.
//

import UIKit

protocol LogoutCellDelegate: AnyObject {

    func logoutCell(_ cell: LogoutTableCell, didTouch button: ResponsiveButton)
}

class LogoutTableCell: UITableViewCell {

    @IBOutlet weak var signoutButton: ResponsiveButton!

    weak var delegate: LogoutCellDelegate?

    @IBAction func signoutButtonOnTouch(_ sender: ResponsiveButton) {
        delegate?.logoutCell(self, didTouch: sender)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        signoutButton.title = Localizations.logout
    }
}
