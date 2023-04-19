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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var yourResultLabel: UILabel!
    @IBOutlet weak var yourAnswerLabel: UILabel!
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
        yourAnswerLabel.font = Fonts.title
        yourAnswerLabel.textColor = Colors.mainText
        yourResultLabel.textColor = Colors.mainText
        yourResultLabel.text = "Your result"
        yourAnswerLabel.text = "Your practice"

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

        pieChartView.animate(xAxisDuration: 0.3, easingOption: .easeOutBack)
        pieChartView.holeColor = Colors.mainText

        pieChartView.backgroundColor = Colors.cellBackground
        pieChartView.addCornerRadius()

        let corrects = allResults?.filter({
            $0.isCorrect
        }).count ?? 0
        let incorrects = (allResults?.count ?? 0) - corrects

        let percent = Double(corrects) / Double(allResults?.count ?? 1)
        pieChartView.centerText = percent * 10 < 0.9 * 10 ? "Fail" : "Pass"

        var entries: [PieChartDataEntry] = []

        if corrects > 0 {
            entries.append(PieChartDataEntry(value: Double(corrects),
                                             label: "Correct",
                                             icon: R.image.addRoundIcon()))
        }
        if incorrects > 0 {
            entries.append(PieChartDataEntry(value: Double(corrects),
                               label: "Incorrect",
                               icon: R.image.addRoundIcon()))
        }

        let set = PieChartDataSet(entries: entries, label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 2

        set.colors = [Colors.correct]
        + [Colors.incorrect]

        let data = PieChartData(dataSet: set)

        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.multiplier = 1
        pFormatter.maximumFractionDigits = 1
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))

        data.setValueFont(Fonts.subtitle)
        data.setValueTextColor(UIColor.white)

        pieChartView.data = data
        pieChartView.highlightValues(nil)



        let jsonName = R.file.lf20_tiviyc3pJson.name
        let animation = Animation.named(jsonName)

        // Load animation to AnimationView
        let animationView = AnimationView(animation: animation)
        animationView.frame = view.bounds

        // Add animationView as subview
        view.addSubview(animationView)

        // Play the animation
        animationView.play(completion: { isComplete in
            guard isComplete else { return }
            animationView.removeFromSuperview()
//            self.dismissScreen()
        })
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
