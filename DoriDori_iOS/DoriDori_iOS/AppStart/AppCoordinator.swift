//
//  AppCoordinator.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/07/09.
//

import UIKit

final class AppCoordinator: Coordinator {

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
            let firstViewController = ViewController()
            let navigationController = UINavigationController(rootViewController: firstViewController)
            viewController = navigationController
        case .home:
            let secondViewController = ViewController()
            let navigationController = UINavigationController(rootViewController: secondViewController)
            viewController = navigationController
        case .myPage:
            let navigationController: UINavigationController = .init()
            let myPageCoordinator = MyPageCoordinator(navigationController: navigationController)
            navigationController.viewControllers = [ MyPageViewController(myPageCoordinator: myPageCoordinator)]
            viewController = navigationController
        }

        viewController.tabBarItem.title = tab.tabTitle
        viewController.tabBarItem.image = tab.tabImage
        viewController.tabBarItem.selectedImage = tab.selectedImage
        return viewController
    }

    func start() {
        switch appStart {
        case .home:
            let homeTabbarController = HomeTabBarController()
            let viewControllers = tabbarItems.map(createTabBarViewControllers(tab:))
            homeTabbarController.setViewControllers(viewControllers, animated: false)
            window?.rootViewController = homeTabbarController
        }
    }
}

