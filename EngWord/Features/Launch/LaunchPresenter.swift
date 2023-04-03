// 
//  LaunchPresenter.swift
//  EngWord
//
//  Created by hieu nguyen on 04/04/2023.
//

import Foundation

final class LaunchPresenter: BasePresenter {
    
    private var view: LaunchViewProtocol?
    private var storageService: StorageProtocol
    
    init(view: LaunchViewProtocol, storageService: StorageProtocol) {
        self.view = view
        self.storageService = storageService
    }

    func viewDidLoad() {
        Task {
            do {
                let folders = try await storageService.getAllSets()
                DispatchQueue.main.async {
                    self.view?.enterHomeScreen(folders: folders ?? [])
                }
            } catch {
                view?.showErrorAlert(msg: error.localizedDescription)
            }
        }
    }
}
