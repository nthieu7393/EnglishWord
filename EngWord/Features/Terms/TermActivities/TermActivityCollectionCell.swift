//
//  TermActivityCollectionCell.swift
//  EngWord
//
//  Created by hieu nguyen on 21/02/2023.
//

import UIKit

class TermActivityCollectionCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var button: IconTextButton!

    private var activity: TermActivitiesCellModel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        button.backgroundColor = Colors.unFocused
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
//        containerView.addCornerRadius()
//        containerView.backgroundColor = Colors.active
        layer.cornerRadius = 20
//        layer.clipsToBounds = true
        layer.masksToBounds = true
//        containerView.addLineBorder()
    }

    func setData(activity: TermActivitiesCellModel) {
        self.activity = activity
//        button.backgroundColor = UIColor.green
        button.set(icon: activity.icon, title: activity.title)
        button.addTarget(self, action: #selector(runActivity), for: .touchUpInside)
    }

    @objc func runActivity() {
        activity.handler()
    }

}
