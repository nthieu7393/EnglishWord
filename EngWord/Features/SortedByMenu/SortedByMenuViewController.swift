//
//  SortedByMenuViewController.swift
//  EngWord
//
//  Created by hieu nguyen on 22/04/2023.
//

import UIKit

class SortedByMenuViewController: UIViewController, Storyboarded {

    @IBOutlet weak var tableView: UITableView!
    
    var didSelectSortedByItem: ((any SelectionMenuItem) -> Void)?

    var allItems: [any SelectionMenuItem] = []
    var selectedItem: (any SelectionMenuItem)?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .clear
        view.backgroundColor = Colors.mainBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = Colors.separatorLine
    }
}

extension SortedByMenuViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(SortedByMenuCell.self, for: indexPath) else {
            return UITableViewCell()
        }
        let smt = allItems[indexPath.row]
        cell.tag = indexPath.row
        cell.setData(
            sortedBy: smt,
            highlight: selectedItem?.isEqual(to: smt) ?? false
        )
        cell.onTap = {
            self.didSelect(index: cell.tag)
        }
        cell.backgroundColor = UIColor.clear
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect(index: indexPath.row)
    }

    private func didSelect(index: Int) {
        selectedItem = allItems[index]
        tableView.reloadData()
        guard let item = selectedItem else { return }
        didSelectSortedByItem?(item)
    }
}

class SortedByMenuCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!

    var onTap: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .clear
    }
    
    func setData(sortedBy: any SelectionMenuItem, highlight: Bool) {
        label.text = sortedBy.text
        label.font = highlight ? Fonts.boldText : Fonts.mediumText
        label.textColor = highlight ? Colors.active : Colors.mainText
    }

    @IBAction func viewOnTap(_ sender: ResponsiveView) {
        onTap?()
    }
}
