// 
//  LearnTopicViewController.swift
//  EngWord
//
//  Created by hieu nguyen on 21/02/2023.
//

import UIKit

final class LearnTopicViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var myPresenter: LearnTopicPresenter? {
        return presenter as? LearnTopicPresenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension LearnTopicViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myPresenter?.numberOfCards() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueCell(TermCollectionCell.self, for: indexPath) else {
            return UICollectionViewCell()
        }
        return cell
    }
}

extension LearnTopicViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return view.bounds.size
    }
}

extension LearnTopicViewController: LearnTopicViewProtocol, Storyboarded {

}
