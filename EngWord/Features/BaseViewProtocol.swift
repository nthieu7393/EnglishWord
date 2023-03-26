//
//  BaseViewProtocol.swift
//  Quizzie
//
//  Created by hieu nguyen on 12/01/2023.
//

import Foundation

protocol BaseViewProtocol: AnyObject {

    func showErrorAlert(msg: String)
    func showSuccessAlert(msg: String, completion: (() -> Void)?)
    func showResultAlert(error: Error?, message: String?)
    func showLoadingIndicator()
    func dismissLoadingIndicator()
}
