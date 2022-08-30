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
    func navigateToWebView(type: DoriDoriWeb)
}

final class SettingCoordinator: SettingCoordinatable {
    let navigationController: UINavigationController
    let innerNavigationController: UINavigationController 
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.innerNavigationController = UINavigationController()
    }
    
    deinit { debugPrint("\(self) deinit") }
    
    func start() {
        let settingReactor = SettingReactor()
        let settingViewController = SettingViewController(
            settingReactor: settingReactor,
            coordinator: self
        )
        innerNavigationController.viewControllers = [settingViewController]
        innerNavigationController.modalPresentationStyle = .overFullScreen
        self.navigationController.present(innerNavigationController, animated: true)
    }
    
    func dismiss(_ completion: (() -> Void)?) {
        self.navigationController.topViewController?.dismiss(animated: true, completion: completion)
    }
    
    func navigateToWebView(type: DoriDoriWeb) {
        WebViewCoordinator(
            navigationController: self.innerNavigationController,
            type: type,
            navigateStyle: .push
        ).start()
    }
}
