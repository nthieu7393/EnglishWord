//
//  TermActivitiesTableCell.swift
//  EngWord
//
//  Created by hieu nguyen on 21/02/2023.
//

import UIKit

protocol TermActivitiesCellDelegate: AnyObject {

    func termActivitiesCell(_ cell: TermActivitiesTableCell, didSelect activity: TermActivitiesCellModel)
}

class TermActivitiesTableCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!

    weak var delegate: TermActivitiesCellDelegate?
    var termActivities: [TermActivitiesCellModel]!

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerCellType(TermActivityCollectionCell.self)
        collectionView.isPagingEnabled = true
    }

    func setData(activities: [TermActivitiesCellModel], delegate: TermActivitiesCellDelegate) {
        self.termActivities = activities
        self.delegate = delegate
    }
}

extension TermActivitiesTableCell: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return termActivities.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueCell(TermActivityCollectionCell.self, for: indexPath)
        else { return UICollectionViewCell() }
        cell.setData(activity: termActivities[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.termActivitiesCell(self, didSelect: termActivities[indexPath.row])
    }
}

extension TermActivitiesTableCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bounds.width / 2, height: 200)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
