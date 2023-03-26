//
//  UserInfoViewController.swift
//  Quizzie
//
//  Created by hieu nguyen on 30/01/2023.
//

import UIKit

protocol UserInfoViewDelegate: AnyObject {

    func userInfoViewSignOutSuccess(_ view: UserInfoView)
}

class UserInfoViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!

    weak var delegate: UserInfoViewDelegate?
    private var userInfoPresenter: UserInfoPresenter? {
        return presenter as? UserInfoPresenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension UserInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserAvatarAndUserNameCell.self), for: indexPath) as? UserAvatarAndUserNameCell else { return UITableViewCell() }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LogoutTableCell.self), for: indexPath) as? LogoutTableCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            return cell
        }
    }
}

extension UserInfoViewController: LogoutCellDelegate {

    func logoutCell(_ cell: LogoutTableCell, didTouch button: ResponsiveButton) {
        userInfoPresenter?.signout()
    }
}

extension UserInfoViewController: UITableViewDelegate {


}

extension UserInfoViewController: Storyboarded, UserInfoView {

    func signoutSuccess() {
        delegate?.userInfoViewSignOutSuccess(self)
        coordinator?.back(animated: true)
    }
}

protocol UserInfoView: BaseViewProtocol {

    func signoutSuccess()
}
