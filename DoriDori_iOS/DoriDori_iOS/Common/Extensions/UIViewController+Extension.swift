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
}
