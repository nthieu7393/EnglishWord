//
//  HomeMenuModel.swift
//  Quizzie
//
//  Created by hieu nguyen on 02/11/2022.
//

import UIKit

protocol HomeMenuModel {
    var icon: UIImage { get }
    var title: String { get }
    var numberOfItems: Int { get }
    func updateNumberOfItems(number: Int)
    func runOnTap()
}

class HomeMenuAllFolders: HomeMenuModel {
    private var totalItems: Int
    
    var title: String {
        return Localizations.folder
    }
    
    var numberOfItems: Int {
        return totalItems
    }
    
    var icon: UIImage {
        return R.image.setIcon()!
    }
    
    var onTap: () -> Void
    
    init(totalItems: Int, actionOnTap: @escaping () -> Void) {
        self.totalItems = totalItems
        self.onTap = actionOnTap
    }
    
    func runOnTap() {
        self.onTap()
    }
    
    func updateNumberOfItems(number: Int) {
        totalItems = number
    }
}

class HomeMenuDailyTopics: HomeMenuModel {
    private var totalItems: Int
    var onTap: () -> Void
    
    var title: String {
        return "Daily Topics"
    }
    
    var numberOfItems: Int {
        return totalItems
    }
    
    func runOnTap() {
        onTap()
    }
    
    var icon: UIImage {
        return R.image.bookIcon()!
    }
    
    init(totalItems: Int, actionOnTap: @escaping () -> Void) {
        self.totalItems = totalItems
        self.onTap = actionOnTap
    }
    
    func updateNumberOfItems(number: Int) {
        self.totalItems = number
    }
}

class HomeMenuWeeklyTopics: HomeMenuModel {
    private var totalItems: Int
    var onTap: () -> Void
    
    var title: String {
        return "Weekly Topics"
    }
    
    var numberOfItems: Int {
        return totalItems
    }
    
    func runOnTap() {
        onTap()
    }
    
    var icon: UIImage {
        return R.image.folderIcon()!
    }
    
    init(totalItems: Int, actionOnTap: @escaping () -> Void) {
        self.totalItems = totalItems
        self.onTap = actionOnTap
    }
    
    func updateNumberOfItems(number: Int) {
        self.totalItems = number
    }
}

class HomeMenuMonthlyTopics: HomeMenuModel {
    private var totalItems: Int
    var onTap: () -> Void

    var title: String {
        return "Monthly Topics"
    }
    
    var numberOfItems: Int {
        return totalItems
    }
    
    func runOnTap() {
        onTap()
    }
    
    var icon: UIImage {
        return R.image.folderIcon()!
    }
    
    init(totalItems: Int, actionOnTap: @escaping () -> Void) {
        self.totalItems = totalItems
        self.onTap = actionOnTap
    }
    
    func updateNumberOfItems(number: Int) {
        self.totalItems = number
    }
}
