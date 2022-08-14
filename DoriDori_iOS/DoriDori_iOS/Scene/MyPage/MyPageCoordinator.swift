//
//  MyPageCoordinator.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/09.
//

import UIKit

protocol MyPageCoordinatable: Coordinator {
    func navigateToSetting()
}

final class MyPageCoordinator: MyPageCoordinatable {
    var childCoordinatos: [Coordinator]
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinatos = []
    }
    
    func start() {
        let myPageViewModel = MyPageReactor(
            myPageTabs: MyPageTab.allCases,
            initialSeletedTab: .answerComplete,
            myPageRepository: MyPageRepository()
        )
        let mypageViewController = MyPageViewController(myPageCoordinator: self, reactor: myPageViewModel)
        navigationController.pushViewController(mypageViewController, animated: true)
    }
    func navigateToSetting() {
        let settingCoordinator = SettingCoordinator(navigationController: self.navigationController)
        settingCoordinator.start()
    }
}
