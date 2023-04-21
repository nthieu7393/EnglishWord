//
//  SortedByMenuViewController.swift
//  EngWord
//
//  Created by hieu nguyen on 22/04/2023.
//

import UIKit

class SortedByMenuViewController: UIViewController, Storyboarded {

    @IBOutlet weak var tableView: UITableView!
    
    var didSelectSortedByItem: ((SortedBy) -> Void)?
    
    var sortedByMenus: [SortedBy] = [
        .alphabetAscending,
        .alphabetDescending,
        .roundAscending,
        .roundDescending]
    var selectedSortedBy: SortedBy = .alphabetAscending {
        didSet {
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .clear
        view.backgroundColor = Colors.mainBackground
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension SortedByMenuViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedByMenus.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(SortedByMenuCell.self, for: indexPath) else {
            return UITableViewCell()
        }
        cell.setData(
            sortedBy: sortedByMenus[indexPath.row],
            highlight: sortedByMenus[indexPath.row] == selectedSortedBy)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSortedBy = sortedByMenus[indexPath.row]
        tableView.reloadData()
        didSelectSortedByItem?(selectedSortedBy)
    }
}

class SortedByMenuCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .clear
    }
    
    func setData(sortedBy: SortedBy, highlight: Bool) {
        label.text = sortedBy.text
        label.font = highlight ? Fonts.boldText : Fonts.mediumText
        label.textColor = highlight ? Colors.active : Colors.mainText
    }
}
