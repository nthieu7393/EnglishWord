//
//  SetHeaderTableView.swift
//  Quizzie
//
//  Created by hieu nguyen on 04/11/2022.
//

import UIKit

class SetHeaderTableView: BaseView {
    
    @IBOutlet private weak var setNameLbl: UILabel!
    @IBOutlet private weak var moreActionsBtn: UIButton!
    @IBOutlet private weak var numberOfTopicsLbl: UILabel!

    private var action: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }

    private func initView() {
        backgroundColor = Colors.mainBackground
        setNameLbl.font = Fonts.title
        setNameLbl.textColor = Colors.mainText
        numberOfTopicsLbl.font = Fonts.title
        numberOfTopicsLbl.textColor = Colors.mainText
    }

    func setData(set: SetTopicModel, buttonOnTap: @escaping () -> Void) {
        setNameLbl.text = set.name
        numberOfTopicsLbl.text = "(\(set.topics.count))"
        action = buttonOnTap
    }

    func setData(set: SetTopicModel) {
        setNameLbl.text = set.name
        numberOfTopicsLbl.text = "(\(set.topics.count))"
    }

    @IBAction func moreActionOnTap(_ sender: UIButton) {
        action?()
    }
}
