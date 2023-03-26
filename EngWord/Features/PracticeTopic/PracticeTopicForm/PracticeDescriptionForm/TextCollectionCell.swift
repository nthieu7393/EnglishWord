//
//  TextCollectionCell.swift
//  EngWord
//
//  Created by hieu nguyen on 28/02/2023.
//

import UIKit

protocol TextCollectionCellDelegate: AnyObject {

    func textCollectionCell(
        _ cell: TextCollectionCell,
        draging view: UIView,
        text: String,
        gesture: UIPanGestureRecognizer)
}

class TextCollectionCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var label: UILabel!

    var isPairedWithQuestion = false

    weak var delegate: TextCollectionCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        label.font = Fonts.regularText
        label.textColor = Colors.mainText
        label.textAlignment = .center

        containerView.frame.size = CGSize(width: contentView.bounds.width, height: 42)
        containerView.backgroundColor = Colors.cellBackground
        containerView.addCornerRadius()

        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(dragGestureBegan(_:)))
        addGestureRecognizer(dragGesture)
    }

    @objc func dragGestureBegan(_ gesture: UIPanGestureRecognizer) {
        guard !isPairedWithQuestion else { return }
        delegate?.textCollectionCell(self, draging: containerView, text: label.text ?? "", gesture: gesture)
    }

    func setTitle(text: String) {
        containerView.isHidden = false
        contentView.frame.size = containerView.bounds.size
        label.text = text
    }

    func hideContentView() {
        label.isHidden = true
    }

    func showContentView() {
        label.isHidden = false
    }

    func getTextOfCell() -> String {
        return label.text ?? ""
    }
}
