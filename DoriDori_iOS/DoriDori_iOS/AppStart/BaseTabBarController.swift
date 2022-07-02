//
//  BaseTabBarController.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/06/25.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setTabbarAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTabbarAppearance() {
        self.tabBar.backgroundColor = .systemGray
        self.tabBar.tintColor = .blue
    }
}


