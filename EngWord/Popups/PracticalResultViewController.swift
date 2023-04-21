//
//  PracticalResult.swift
//  EngWord
//
//  Created by hieu nguyen on 10/03/2023.
//

import UIKit
import Charts
import Lottie

protocol PracticalResultPopupDelegate: AnyObject {

    func practicalResultPopup(
        _ popup: PracticalResultViewController,
        onTap doneButton: TextButton
    )
}

class PracticalResultViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var chartContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var yourResultLabel: UILabel!

    @IBOutlet weak var sortedByButton: TextButton!
    var allResults: [QuizResult]? {
        didSet {

        }
    }
    weak var delegate: PracticalResultPopupDelegate?

//    @IBAction func doneButtonOnTap(_ sender: TextButton) {
//        delegate?.practicalResultPopup(self, onTap: sender)
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let correctCount = allResults?.filter({
            $0.isCorrect
        }).count

        yourResultLabel.font = Fonts.title
        yourResultLabel.textColor = Colors.mainText
        yourResultLabel.text = "Your result"

//        pieChartView.delegate = self

        let l = pieChartView.legend
        l.textColor = UIColor.white
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.xEntrySpace = 2
        l.yEntrySpace = 2
        l.yOffset = 2

        pieChartView.entryLabelColor = Colors.mainText
        pieChartView.entryLabelFont = Fonts.regularText
        pieChartView.holeColor = Colors.cellBackground
        pieChartView.animate(xAxisDuration: 0.3, easingOption: .easeOutBack)

        chartContainerView.backgroundColor = Colors.cellBackground
        chartContainerView.addCornerRadius()

        let corrects = allResults?.filter({
            $0.isCorrect
        }).count ?? 0

        let percent = Double(corrects) / Double(allResults?.count ?? 1)

        var entries: [PieChartDataEntry] = []

//        if corrects > 0 {
        entries.append(PieChartDataEntry(
            value: percent,
            label: "Correct",
            data: percent * 100)
        )
//        }
//        if incorrects > 0 {
        entries.append(PieChartDataEntry(
            value: 1-percent,
            label: "Incorrect",
            data: (1-percent)*100)
        )
//        }

        let set = PieChartDataSet(entries: entries, label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        set.colors = [Colors.correct]
        + [Colors.incorrect]

        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.percentSymbol = " %"
        pFormatter.multiplier = 1
        pFormatter.maximumFractionDigits = 1
        pieChartView.usePercentValuesEnabled = true

        let data = PieChartData(dataSet: set)
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        data.setValueFont(Fonts.subtitle)
        data.setValueTextColor(UIColor.white)

        pieChartView.data = data
        pieChartView.highlightValues(nil)
        sortedByButton.title = sortedBy.text

    }

    private var sortedBy: SortedBy = .alphabetDescending {
        didSet {
            switch sortedBy {
                case .alphabetAscending:
                    allResults?.sort(by: {
                        $0.answer > $1.answer
                    })
                case .alphabetDescending:
                    allResults?.sort(by: {
                        $0.answer < $1.answer
                    })
                case .roundAscending:
                    allResults?.sort(by: {
                        $0.round > $1.round
                    })
                case .roundDescending:
                    allResults?.sort(by: {
                        $0.round < $1.round
                    })
            }
            sortedByButton.title = sortedBy.text
            tableView.beginUpdates()
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            tableView.endUpdates()
        }
    }
    @IBAction func sortedByButtonOnTap(_ sender: TextButton) {
//        sortedBy = sortedBy == .alphabet ? .round : .alphabet
        guard let viewController = SortedByMenuViewController.instantiate() else {
            return
        }
        viewController.selectedSortedBy = sortedBy
        viewController.didSelectSortedByItem = { sortedBy in
            self.dismiss(animated: true)
            self.sortedBy = sortedBy
        }
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: true)
    }

}

extension PracticalResultViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension PracticalResultViewController: UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allResults?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(
            PracticeResultTableViewCell.self,
            for: indexPath) else {
            return UITableViewCell()
        }
        cell.setData(quizResult: allResults?[indexPath.row])
        return cell
    }
}
