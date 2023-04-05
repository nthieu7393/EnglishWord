//
//  BaseViewController.swift
//  Quizzie
//
//  Created by hieu nguyen on 03/11/2022.
//

import UIKit
import SVProgressHUD

class BaseViewController: UIViewController {
    weak var coordinator: MainCoordinator?
    var presenter: BasePresenter?
    var rightBarButtonItems: [UIBarButtonItem]? {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        displayDismissButtonIfNeed()
        displayBackBarItemIfNeed()
        displayRightBarItems()
        setupFontText()
        view.backgroundColor = Colors.mainBackground
        navigationController?.navigationBar.barTintColor = Colors.mainBackground
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Colors.mainText
        ]
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)

        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(screenOnTouch(_:))
        )
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    var ignoreDismissKeyboardWhenTap: Bool {
        return false
    }

    var showBackBtnIfNeed: Bool {
        return true
    }

    @objc func screenOnTouch(_ gesture: UITapGestureRecognizer) {
        if !ignoreDismissKeyboardWhenTap {
            dismissKeyboard()
        }
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            layoutIfKeyboardShow(keyboardSize: keyboardSize.cgRectValue)
        }
    }

    func layoutIfKeyboardShow(keyboardSize: CGRect) {}

    @objc
    func keyboardWillHide(_ notification: Notification) {
        if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            layoutIfKeyboardHide(keyboardSize: keyboardSize.cgRectValue)
        }
    }

    func layoutIfKeyboardHide(keyboardSize: CGRect) {}

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = !isPush
    }

    private lazy var dismissButton: IconButton = {
        let iconButton = IconButton()
        iconButton.tintColor = Colors.active
        iconButton.icon = R.image.closeRoundIcon()?.withRenderingMode(.alwaysTemplate)
        iconButton.addTarget(self, action: #selector(dismissScreen), for: .touchUpInside)
        return iconButton
    }()

    @objc private func dismissScreen() {
        coordinator?.dismissScreen(self)
    }

    var forceHideDismissButton: Bool {
        return false
    }

    private func displayDismissButtonIfNeed() {
        guard isModal && !forceHideDismissButton else { return }
        view.addSubview(dismissButton)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            dismissButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 12),
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            dismissButton.heightAnchor.constraint(equalToConstant: 24),
            dismissButton.widthAnchor.constraint(equalToConstant: 24)
        ]

        NSLayoutConstraint.activate(constraints)
    }
    
    private func displayBackBarItemIfNeed() {
        guard isPush, showBackBtnIfNeed else { return }
        let backButton: UIButton = UIButton()
        backButton.setImage(Icons.backIcon, for: UIControl.State())
        backButton.addTarget(
            self,
            action: #selector(backBarItemOnTap(_:)),
            for: UIControl.Event.touchUpInside
        )
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    private func displayRightBarItems() {
        navigationItem.rightBarButtonItems = rightBarButtonItems
    }
    
    @objc private func backBarItemOnTap(_ sender: Any) {
        backToPreviousScreen()
    }
    
    func backToPreviousScreen() {
        coordinator?.back(animated: true)
    }
    
    func setupFontText() {}

    private var isPush: Bool {
        if let index = coordinator?.child.firstIndex(of: self), index > 0 {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        }
        return false
    }

    var isModal: Bool {
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
}

extension BaseViewController: BaseViewProtocol {

    func showSuccessAlert(msg: String, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Success", message: msg, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Close", style: .destructive)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: completion)
        }
    }

    func showErrorAlert(msg: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Failed", message: msg, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Close", style: .destructive)
            alert.addAction(alertAction)
            self.present(alert, animated: true)
        }
    }

    func showLoadingIndicator() {
        SVProgressHUD.show()
    }

    func dismissLoadingIndicator() {
        SVProgressHUD.dismiss()
    }

    func showResultAlert(error: Error?, message: String? = nil) {
        if let uwrError = error {
            showErrorAlert(msg: uwrError.localizedDescription)
        } else {
            showSuccessAlert(msg: message ?? "")
        }
    }
}
