//
//  ResizeTableView.swift
//  EngWord
//
//  Created by hieu nguyen on 27/02/2023.
//

import UIKit

class ResizeTableView: UITableView {

    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
