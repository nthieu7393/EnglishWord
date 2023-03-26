//
//  ReviewCardViewController.swift
//  EngWord
//
//  Created by hieu nguyen on 23/02/2023.
//

import UIKit

final class ReviewCardViewController: BaseViewController {
    
    @IBOutlet weak var indicatorLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    var myPresenter: ReviewCardPresenter? {
        return presenter as? ReviewCardPresenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor.clear
        myPresenter?.viewLoaded()
        indicatorLabel.font = Fonts.subtitle
        indicatorLabel.textColor = Colors.mainText
    }
}

extension ReviewCardViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myPresenter?.getNumberOfCards() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueCell(ReviewCardCollectionCell.self, for: indexPath),
              let card = myPresenter?.getCard(at: indexPath.item) else { return UICollectionViewCell() }
        cell.setCard(card: card)
        return cell
    }
}

extension ReviewCardViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

extension ReviewCardViewController: ReviewCardViewProtocol, Storyboarded {

    func moveToCard(at index: Int) {
        collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredVertically, animated: false)
    }

    func displayIndicatorNumber(text: String) {
        indicatorLabel.text = text
    }
}

extension ReviewCardViewController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.y / scrollView.bounds.height
        myPresenter?.udpateIndicatorNumber(number: index + 1)
    }
}

final class ReviewCardCollectionCell: UICollectionViewCell {

    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var pronunciationButton: IconTextButton!
    @IBOutlet weak var partOfSpeechLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var exampleLabel: UILabel!

    func setCard(card: any Card) {
        termLabel.text = card.termDisplay
        termLabel.font = Fonts.bigTitle
        termLabel.textColor = Colors.mainText

        partOfSpeechLabel.text = card.partOfSpeechDisplay
        partOfSpeechLabel.font = Fonts.regularText
        partOfSpeechLabel.textColor = Colors.mainText

        pronunciationButton.set(icon: R.image.speakerIcon()!, title: card.phoneticDisplay ?? "")
        pronunciationButton.visibleBorder = false

        descriptionLabel.text = card.selectedDefinition
        descriptionLabel.font = Fonts.mainTitle
        descriptionLabel.textColor = Colors.mainText

        if card.selectedExample.isNotEmpty() {
            let attributeString = NSMutableAttributedString(string: card.selectedExample ?? "", attributes: [
                NSAttributedString.Key.font: Fonts.mediumText,
                NSAttributedString.Key.foregroundColor: Colors.mainText
            ])
            let range = (card.selectedExample as? NSString)?.range(of: card.termDisplay)
            attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: Colors.active, range: range!)

            exampleLabel.attributedText = attributeString

//            let attributes = parapraph?.map({
//                NSAttributedString(string: $0, attributes: [
//
//                ])
//            })
//            exampleLabel.attributedText = NSAttributedString(
//                string: card.selectedExample,
//                attributes: [
//                    NSAttributedString.Key.font: Fonts.mediumText
//                ])
//            exampleLabel.text = card.selectedExample
//            exampleLabel.font = Fonts.mediumText
//            exampleLabel.textColor = Colors.mainText
        }

    }
}
