//
//  UICollectionViewExtension.swift
//  EngWord
//
//  Created by hieu nguyen on 21/02/2023.
//

import UIKit

extension UICollectionView {

    func registerCellType<T>(_ type: T.Type) where T: UICollectionViewCell {
        register(
            UINib(nibName: String(describing: type), bundle: nil),
            forCellWithReuseIdentifier: String(describing: type)
        )
    }

    func dequeueCell<T: UICollectionViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withReuseIdentifier: String(describing: type), for: indexPath) as? T
    }
}
