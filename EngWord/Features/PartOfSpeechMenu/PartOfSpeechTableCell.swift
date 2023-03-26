//
//  PartOfSpeechTableCell.swift
//  EngWord
//
//  Created by hieu nguyen on 14/03/2023.
//

import UIKit

protocol PartOfSpeechTableCellDelegate: AnyObject {

    func partOfSpeechCell(_ cell: PartOfSpeechTableCell, didSelectCellAt indexPath: IndexPath?)
}

class PartOfSpeechTableCell: UITableViewCell {

    @IBOutlet weak var titleButton: TextButton!

    weak var delegate: PartOfSpeechTableCellDelegate?
    private var title: String?
    private var indexPath: IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func buttonOnTap(_ sender: TextButton) {
        delegate?.partOfSpeechCell(self, didSelectCellAt: indexPath)
    }

    func setTitle(attributeString: NSAttributedString, indexpath: IndexPath) {
        titleButton.attributeString = attributeString
        title = attributeString.string
        self.indexPath = indexpath
    }
}
