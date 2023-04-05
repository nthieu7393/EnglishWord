// 
//  PracticeTopicViewController.swift
//  EngWord
//
//  Created by hieu nguyen on 24/02/2023.
//

import UIKit
import Lottie

final class PracticeTopicViewController: BaseViewController {
    var animationView: AnimationView?

    var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)

    override var ignoreDismissKeyboardWhenTap: Bool {
        return true
    }

    var myPresenter: PracticeTopicPresenter? {
        return presenter as? PracticeTopicPresenter
    }
    var controllers: [PracticeFormController]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myPresenter?.viewDidLoad()
        controllers = [
            PracticeFormController(form: myPresenter!.getPracticeForm(at: 0), delegatedController: self),
            PracticeFormController(form: myPresenter!.getPracticeForm(at: 1), delegatedController: self)
        ]

//        roundNumberLabel.text = "Round 1"
//        roundNumberLabel.font = Fonts.boldText
//        roundNumberLabel.textColor = Colors.mainText
        title = "Round 1"

        view.addSubview(pageViewController.view)
        pageViewController.dataSource = self
        pageViewController.setViewControllers([controllers[0]], direction: .forward, animated: false)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            pageViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension PracticeTopicViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
}

extension PracticeTopicViewController: PracticeTopicViewProtocol, Storyboarded {

    func reloadCollectionView() {
//        collectionView.reloadData()
    }

    func dismissScreen() {
        coordinator?.dismissScreen(self)
    }

    func moveToNextRound(index: Int) {
        view.endEditing(true)
        title = "Round \(index + 1)"
        pageViewController.setViewControllers([controllers[index]], direction: .forward, animated: true)
    }

    func showPracticePass() {
        let jsonName = "lf20_tiviyc3p"
        let animation = Animation.named(jsonName)

        // Load animation to AnimationView
        animationView = AnimationView(animation: animation)
        animationView?.frame = view.bounds

        // Add animationView as subview
        view.addSubview(animationView!)

        // Play the animation
        animationView?.play(completion: { isComplete in
            guard isComplete else { return }
            self.animationView?.removeFromSuperview()
            self.dismissScreen()
        })

        let storyboard = PracticalResultViewController.instantiatePopup()
        storyboard?.practicalResult = .pass
        storyboard?.delegate = self
        self.present(storyboard!, animated: true)
    }

    func showPracticeFail() {
        let storyboard = PracticalResultViewController.instantiatePopup()
        storyboard?.practicalResult = .fail
        self.present(storyboard!, animated: true)
    }
}

extension PracticeTopicViewController: PracticalResultPopupDelegate {

    func practicalResultPopup(_ popup: PracticalResultViewController, onTap doneButton: TextButton) {
        self.dismiss(animated: true)
        animationView?.stop()
        animationView?.removeFromSuperview()
        coordinator?.back(animated: true)
    }
}

extension PracticeTopicViewController: PracticeFormControllerDelegate {

    func practiceFormController(_ controller: PracticeFormController, result: TurnResult) {
        myPresenter?.turnPracticeDone(result: result)
    }
}

//class PracticeTopicCollectionCell: UICollectionViewCell {
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
//
//    func setForm(form: UIView?) {
//        guard let form = form else { return }
//        contentView.addSubview(form)
//        form.translatesAutoresizingMaskIntoConstraints = false
//        let constraints = [
//            form.topAnchor.constraint(equalTo: contentView.topAnchor),
//            form.leftAnchor.constraint(equalTo: contentView.leftAnchor),
//            form.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            form.widthAnchor.constraint(equalTo: contentView.widthAnchor)
//        ]
//        NSLayoutConstraint.activate(constraints)
//    }
//}
