//
//  AppCoordinator.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/07/09.
//

import UIKit

final class AppCoordinator {

    private let appStart: AppStart
    private let window: UIWindow?
    private let tabbarItems: [HomeTabType] = HomeTabType.allCases

    init(appStart: AppStart, window: UIWindow) {
        self.appStart = appStart
        self.window = window
    }

    private func createTabBarViewControllers(tab: HomeTabType) -> UIViewController {
        let viewController: UINavigationController

        switch tab {
        // TODO: 각 VC에서 자신의 Coordinator 생성해서 주입해줘야 됨.
        case .notification:
            let firstViewController = ViewController(url: URL(string: "https://deploy-preview-46--dori-dori.netlify.app/question-detail")!)
            let navigationController = UINavigationController(rootViewController: firstViewController)
            viewController = navigationController
        case .home:
            let homeViewController = HomeViewController()
            let navigationController = UINavigationController(rootViewController: homeViewController)
            viewController = navigationController
        case .myPage:
            viewController = self.setupMyPageNavigationController()
        }

        self.setupTabItem(tab, at: viewController)
        return viewController
    }

    func start() {
        switch appStart {
        case .home:
            let mainTabbarController = MainTabBarController()
            let viewControllers = tabbarItems.map(createTabBarViewControllers(tab:))
            mainTabbarController.setViewControllers(viewControllers, animated: false)
            window?.rootViewController = mainTabbarController
        }
    }
}

// MARK: - Private functions

extension AppCoordinator {
    
    private func setupMyPageNavigationController() -> UINavigationController {
        let myPageCoordinator = MyPageCoordinator(navigationController: .init())
        myPageCoordinator.start()
        return myPageCoordinator.navigationController
    }
    
    private func setupTabItem(_ tab: HomeTabType, at viewController: UINavigationController) {
        viewController.tabBarItem.title = tab.tabTitle
        viewController.tabBarItem.image = tab.tabImage
        viewController.tabBarItem.selectedImage = tab.selectedImage
    }
}
