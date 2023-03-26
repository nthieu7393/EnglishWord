//
//  UITableViewExtension.swift
//  EngWord
//
//  Created by hieu nguyen on 17/02/2023.
//

import UIKit

extension UITableView {

    func registerRow<T>(_ type: T.Type) where T: UITableViewCell {
        register(
            UINib(nibName: String(describing: type), bundle: nil),
            forCellReuseIdentifier: String(describing: type)
        )
    }

    func dequeueCell<T: UITableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: String(describing: type), for: indexPath) as? T
    }
}
