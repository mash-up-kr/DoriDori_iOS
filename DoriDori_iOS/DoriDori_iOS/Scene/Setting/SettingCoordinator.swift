//
//  SettingCoordinator.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/14.
//

import Foundation
import UIKit

final class SettingCoordinator: Coordinator {
    var childCoordinatos: [Coordinator]
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinatos = []
    }
    
    func start() {
        let settingReactor = SettingReactor()
        let settingViewController = SettingViewController(settingReactor: settingReactor)
        settingViewController.modalPresentationStyle = .fullScreen
        self.navigationController.present(settingViewController, animated: true)
    }
}
