//
//  PracticalResult.swift
//  EngWord
//
//  Created by hieu nguyen on 10/03/2023.
//

import UIKit

protocol PracticalResultPopupDelegate: AnyObject {

    func practicalResultPopup(
        _ popup: PracticalResultViewController,
        onTap doneButton: TextButton
    )
}

class PracticalResultViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var tableView: UITableView!
    
    var allResults: [QuizResult]?
    weak var delegate: PracticalResultPopupDelegate?

    @IBAction func doneButtonOnTap(_ sender: TextButton) {
        delegate?.practicalResultPopup(self, onTap: sender)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension PracticalResultViewController: UITableViewDelegate {
    
}

extension PracticalResultViewController: UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allResults?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(PracticeResultTableCell.self, for: indexPath) else {
            return UITableViewCell()
        }
        cell.lasssssbel.text = allResults?[indexPath.row].question
        return cell
    }
}


class PracticeResultTableCell: UITableViewCell {
    
    
    @IBOutlet weak var lasssssbel: UILabel!
}
