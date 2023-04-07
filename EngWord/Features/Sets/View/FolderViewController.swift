//
//  FolderViewController.swift
//  Quizzie
//
//  Created by hieu nguyen on 03/11/2022.
//

import UIKit

class FolderViewController: BaseViewController {
    
    @IBOutlet weak var newSetContainerView: UIView!
    @IBOutlet weak var newSetButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    private var headerViewsList: [Int: SetHeaderTableView] = [:]

    private lazy var newSetTextField: UITextField = {
        return UITextField()
    }()
    var setsPresenter: SetsPresenter? {
        return presenter as? SetsPresenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutInputNewSetToolbar()
//        setsPresenter?.loadAllSets()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(practiceNotificationReceived(_:)),
            name: .practiceFinishNotification,
            object: nil
        )
    }
    
    @objc func practiceNotificationReceived(_ notification: Notification) {
        guard let topicFolder = notification.object as? TopicFolderWrapper else { return }
        setsPresenter?.updateTopic(topic: topicFolder.topic, of: topicFolder.folder)
    }

    private func layoutInputNewSetToolbar() {
        view.addSubview(newSetTextField)
    }

    override func dismissKeyboard() {
        super.dismissKeyboard()
        newSetTextField.endEditing(true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        newSetButton.addDashline(cornerRadius: CGFloat(Constants.borderRadius))
        view.window?.makeKeyAndVisible()
    }
    
    override func setupFontText() {
        newSetButton.tintColor = Colors.active
        newSetButton.setAttributedTitle(NSAttributedString(
            string: "+ \(Localizations.createNewFolder)",
            attributes: [NSAttributedString.Key.font: Fonts.button]
        ), for: .normal)
    }
    
    override var title: String? {
        get { return Localizations.folder }
        set {}
    }
    
    override var rightBarButtonItems: [UIBarButtonItem]? {
        let backButton: UIButton = UIButton()
        backButton.setImage(Icons.sortIcon, for: UIControl.State())
        backButton.addTarget(self, action: #selector(sortButtonOnTap(_:)), for: UIControl.Event.touchUpInside)
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        return [leftBarButtonItem]
    }

    private func showMoreActionsBottomSheet(of set: SetTopicModel) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editAction = UIAlertAction(
            title: "Edit name",
            style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true)
                self.coordinator?.presentNewSetInputScreen(delegateView: self, initialSet: set)
            }
        let addTopicAction = UIAlertAction(
            title: "Add topic",
            style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.coordinator?.presentAllTopicsScreen(
                    delegateView: self,
                    allFolders: self.setsPresenter?.getAllFolders() ?? [],
                    selectedFolder: set
                )
            }

        let deleteFolderAction = UIAlertAction(
            title: "Delete Folder",
            style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                self.setsPresenter?.deleteFolder(set)
            }

        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel) { [weak self] _ in
                self?.dismiss(animated: true)
            }
        alert.addAction(editAction)
        alert.addAction(addTopicAction)
        alert.addAction(deleteFolderAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .practiceFinishNotification, object: nil)
    }
    
    @objc func sortButtonOnTap(_ sender: Any) {
        // TODO: handle sort button on tap
        print("show sort popup")
    }
    
    @IBAction func newSetButtonOnTap(_ sender: UIButton) {
        coordinator?.presentNewSetInputScreen(delegateView: self, initialSet: SetTopicModel())
    }
}

extension FolderViewController: AllTopicsViewDelegate {

    func allTopicsView(
        _ view: AllTopicsViewProtocol,
        didTap createTopicButton: ResponsiveButton,
        folder: SetTopicModel) {
        coordinator?.dismissScreen(self)
        coordinator?.presentTermsScreen(
            folder: folder,
            topic: TopicModel(name: ""),
            delegateView: self
        )
    }
}

extension FolderViewController: TermsViewDelegate {

    func termsView(
        _ view: TermsViewController,
        add topic: TopicModel,
        to folder: SetTopicModel) {
        setsPresenter?.addTopic(topic: topic, to: folder)
    }

    func termsView(
        _ view: TermsViewController,
        updated topic: TopicModel,
        in folder: SetTopicModel) {
        setsPresenter?.updateTopic(topic: topic, of: folder)
    }
}

extension FolderViewController: NewFolderInputViewDelegate {

    func newSetInputView(_ view: NewSetInputViewProtocol, endEditing set: SetTopicModel) {
        print("🥰:\(set.id)--\(set.name)")
        setsPresenter?.saveFolder(folder: set)
        dismiss(animated: false)
    }
}

extension FolderViewController: SetsView {

    func dismissNewSetInputScreen() {
        dismiss(animated: false)
    }

    func displayDataOfSets(sets: [SetTopicModel]) {
        headerViewsList.removeAll()
        tableView.reloadData()
    }

    func startInputNameOfSet(
        initialString: String,
        endEditing: @escaping (String?) -> Void
    ) {
//        newSetTextField.becomeFirstResponder()
////        newSetToolBar?.becomeFirstResponser(
//            initialString: initialString,
//            endEditing: { [weak self] string in
//                guard let self = self else { return }
//                self.dismissKeyboard()
//                endEditing(string)
//            }
//        )
    }

    func removeTopic(at section: Int, row: Int) {
        tableView.deleteRows(at: [IndexPath(row: row, section: section)], with: .fade)
    }

    func removeFolder(at section: Int) {
        tableView.deleteSections(IndexSet(integer: section), with: .fade)
    }

    func updateFolderTitle(at index: Int) {
        guard let view = headerViewsList[index],
        let folder = setsPresenter?.getFolder(at: index) else { return }
        view.setData(set: folder)
    }
}

extension FolderViewController: Storyboarded {}

extension FolderViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return setsPresenter?.getAllFolders().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setsPresenter?.getTopicsOfFolder(at: section).count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: SetTableViewCell.self),
            for: indexPath
        ) as? SetTableViewCell
        cell?.setData(topic: setsPresenter?.getTopic(of: setsPresenter!.getFolder(at: indexPath.section)!, at: indexPath.row))
        return cell ?? UITableViewCell()
    }
}

extension FolderViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let folder = setsPresenter?.getFolder(at: indexPath.section),
              let topic = setsPresenter?.getTopic(of: folder, at: indexPath.row) else { return }
        coordinator?.presentTermsScreen(
            folder: folder,
            topic: topic,
            delegateView: self)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = headerViewsList[section] {
            return headerView
        }
        guard let headerView: SetHeaderTableView = SetHeaderTableView.fromNib(),
              let folder = setsPresenter?.getFolder(at: section) else { return UIView() }
        headerView.setData(set: folder) { [weak self] in
            guard let self = self else { return }
            self.showMoreActionsBottomSheet(of: folder)
        }
        headerViewsList[section] = headerView
        return headerView
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let folder = setsPresenter?.getFolder(at: indexPath.section)
            setsPresenter?.deleteTopic(
                setsPresenter?.getTopic(of: folder, at: indexPath.row),
                from: folder)
        }
    }
}
