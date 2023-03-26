//
//  DimmingPresentationController.swift
//  EngWord
//
//  Created by hieu nguyen on 09/03/2023.
//

import UIKit

class DimmingPresentationController: UIPresentationController {

    lazy var dimmingView = GradientView(frame: CGRect.zero)

    override func presentationTransitionWillBegin() {
        dimmingView.frame = containerView!.bounds
        containerView?.insertSubview(dimmingView, at: 0)
    }

    override var shouldRemovePresentersView: Bool {
        return false
    }
}
