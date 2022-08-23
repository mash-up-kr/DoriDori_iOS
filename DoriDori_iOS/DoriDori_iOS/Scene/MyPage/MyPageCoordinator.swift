//
//  MyPageCoordinator.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/09.
//

import UIKit

protocol MyPageCoordinatable: Coordinator {
    func navigateToSetting()
    func navigateToShare()
}

final class MyPageCoordinator: MyPageCoordinatable {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit { debugPrint(" \(self) deinit") }
    
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
        SettingCoordinator(navigationController: self.navigationController).start()
    }
    
    func navigateToShare() {
        print(#function)
        self.navigationController.pushViewController(OtherPageViewController(nibName: nil, bundle: nil), animated: true)
    }
}
