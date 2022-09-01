//
//  UIViewController+Extension.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/08/21.
//

import UIKit

extension UIViewController {
    func dismissOrPopupViewController(animated: Bool, completion: (()-> Void)?) {
        guard let navigationController = navigationController,
              navigationController.viewControllers.count != 1 else {
                  dismiss(animated: animated, completion: completion)
                  return
              }
        navigationController.popViewController(animated: animated)
    }
    static func topViewController() -> UIViewController? {
        var topViewController: UIViewController?

        let rootViewController = UIApplication.shared.keyWindow?.rootViewController

        if let viewController = rootViewController as? UINavigationController {
            topViewController = viewController.visibleViewController
        } else if let viewController = rootViewController?.presentedViewController {
            topViewController = viewController

            if let viewController = topViewController as? UINavigationController {
                topViewController = viewController.visibleViewController
            }
        } else if let viewController = rootViewController as? UITabBarController {
            topViewController = viewController.selectedViewController

            if let viewController = topViewController as? UINavigationController {
                topViewController = viewController.visibleViewController
            }
        } else {
            topViewController = rootViewController
        }

        return topViewController
    }
}
