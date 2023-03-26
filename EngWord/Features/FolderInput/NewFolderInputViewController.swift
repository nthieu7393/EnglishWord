// 
//  NewFolderInputViewController.swift
//  EngWord
//
//  Created by hieu nguyen on 17/02/2023.
//

import UIKit

protocol NewFolderInputViewDelegate: AnyObject {

    func newSetInputView(_ view: NewSetInputViewProtocol, endEditing set: SetTopicModel)
}

final class NewFolderInputViewController: BaseViewController {
    
    @IBOutlet private weak var screenTitleLabel: UILabel!
    @IBOutlet private weak var setNameTextField: UnderlineTextField!
    @IBOutlet private weak var doneButton: ResponsiveButton!
    @IBOutlet private weak var folderNameLabel: UILabel!

    private var myPresenter: NewSetInputPresenter!
    var initialSet: SetTopicModel!
    weak var delegate: NewFolderInputViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setNameTextField.becomeFirstResponder()
        setNameTextField.text = initialSet.name
        setNameTextField.placeholder = Localizations.typeFolderName
        doneButton.title = Localizations.done

        screenTitleLabel.text = initialSet.id.isNotEmpty() ? Localizations.updateFolder : Localizations.createNewFolder
        screenTitleLabel.textAlignment = .center
        screenTitleLabel.font = Fonts.title
        screenTitleLabel.textColor = Colors.mainText

        folderNameLabel.text = Localizations.folderName
        folderNameLabel.textColor = Colors.mainText
        folderNameLabel.font = Fonts.subtitle
    }

    override func setupFontText() {
        setNameTextField.font = Fonts.regularText
    }

    @IBAction func doneButtonOnTap(_ sender: ResponsiveButton) {
        initialSet?.name = setNameTextField.text
        delegate?.newSetInputView(self, endEditing: initialSet)
    }
}

extension  NewFolderInputViewController: NewSetInputViewProtocol, Storyboarded {

}
