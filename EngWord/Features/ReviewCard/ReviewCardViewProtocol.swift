// 
//  ReviewCardViewProtocol.swift
//  EngWord
//
//  Created by hieu nguyen on 23/02/2023.
//

import UIKit

protocol ReviewCardDelegate: AnyObject {

    func reviewCardScreen(_ screen: ReviewCardViewProtocol, onReview card: (any Card))
}

protocol ReviewCardViewProtocol: BaseViewProtocol {

    func moveToCard(at index: Int)
    func displayIndicatorNumber(text: String)
}
