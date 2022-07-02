//
//  HomeTabBarController.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/06/25.
//

import UIKit

class HomeTabBarController: BaseTabBarController {
    
    let tabbarItems: [HomeTabType] = HomeTabType.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Methods
    private func setup() {
        let viewControllers = self.tabbarItems.map(createTabbarViewControllers(tab:))
        setViewControllers(viewControllers, animated: false)
    }
    
    private func createTabbarViewControllers(tab: HomeTabType) -> UIViewController {
        let viewController: UIViewController
        
        switch tab {
        case .first:
            viewController = ViewController()
        case .second:
            viewController = ViewController()
        case .third:
            viewController = ViewController()
        }
        
        viewController.tabBarItem.title = tab.tabTitle
        viewController.tabBarItem.image = tab.tabImage
        viewController.tabBarItem.selectedImage = tab.selectedImage
        return viewController
    }
    
}


