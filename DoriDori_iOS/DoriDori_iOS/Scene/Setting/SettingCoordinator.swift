//
//  SettingCoordinator.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/14.
//

import Foundation
import UIKit

protocol SettingCoordinatable: Coordinator {
    func dismiss(_ completion: (() -> Void)?)
}

final class SettingCoordinator: SettingCoordinatable {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit { debugPrint("\(self) deinit") }
    
    func start() {
        let settingReactor = SettingReactor()
        let settingViewController = SettingViewController(
            settingReactor: settingReactor,
            coordinator: self
        )
        settingViewController.modalPresentationStyle = .fullScreen
        self.navigationController.topViewController?.present(settingViewController, animated: true)
    }
    
    func dismiss(_ completion: (() -> Void)?) {
        self.navigationController.topViewController?.dismiss(animated: true, completion: completion)
    }
}
